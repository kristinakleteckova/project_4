-- OTÁZKA 4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd 
-- (větší než 10 %)?

WITH prumery_rok AS (
    SELECT
        rok,
        AVG(prumerna_mzda) AS mzda,
        AVG(prumerna_cena) AS cena
    FROM t_kristina_kleteckova_project_sql_primary_final
    GROUP BY rok
),
trendy AS (
    SELECT
        rok,
        mzda,
        cena,
        LAG(mzda) OVER (ORDER BY rok) AS mzda_predchozi_rok,
        LAG(cena) OVER (ORDER BY rok) AS cena_predchozi_rok
    FROM prumery_rok
)
SELECT
    rok,
    ROUND(((mzda - mzda_predchozi_rok) / mzda_predchozi_rok * 100)::numeric, 2) AS rust_mezd,
    ROUND(((cena - cena_predchozi_rok) / cena_predchozi_rok * 100)::numeric, 2) AS rust_cen,
    ROUND((
        ((cena - cena_predchozi_rok) / cena_predchozi_rok * 100)
        -
        ((mzda - mzda_predchozi_rok) / mzda_predchozi_rok * 100))::numeric,
        2
    ) AS rozdil
FROM trendy
WHERE mzda_predchozi_rok IS NOT NULL
  AND cena_predchozi_rok IS NOT NULL
  AND (
        ((cena - cena_predchozi_rok) / cena_predchozi_rok * 100)
        -
        ((mzda - mzda_predchozi_rok) / mzda_predchozi_rok * 100)
      ) > 10
ORDER BY rok;