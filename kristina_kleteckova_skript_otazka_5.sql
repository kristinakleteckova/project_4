-- OTÁZKA 5: Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste 
-- výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím 
-- roce výraznějším růstem?

WITH rocni_data AS (
    SELECT
        p.rok,
        AVG(p.prumerna_mzda) AS mzda,
        AVG(p.prumerna_cena) AS cena,
        s.hdp
    FROM t_kristina_kleteckova_project_sql_primary_final p
    JOIN t_kristina_kleteckova_project_sql_secondary_final s
        ON p.rok = s.rok
        AND s.stat = 'Czech Republic'
    GROUP BY p.rok, s.hdp
),
trendy AS (
    SELECT
        rok,
        mzda,
        cena,
        hdp,
        LAG(mzda) OVER (ORDER BY rok) AS mzda_predchozi_rok,
        LAG(cena) OVER (ORDER BY rok) AS cena_predchozi_rok,
        LAG(hdp) OVER (ORDER BY rok) AS hdp_predchozi_rok
    FROM rocni_data
)
SELECT
    rok,
    ROUND(((hdp - hdp_predchozi_rok) / hdp_predchozi_rok * 100)::numeric, 2) AS rust_hdp,
    ROUND(((mzda - mzda_predchozi_rok) / mzda_predchozi_rok * 100)::numeric, 2) AS rust_mezd,
    ROUND(((cena - cena_predchozi_rok) / cena_predchozi_rok * 100)::numeric, 2) AS rust_cen
FROM trendy
WHERE hdp_predchozi_rok IS NOT NULL
  AND mzda_predchozi_rok IS NOT NULL
  AND cena_predchozi_rok IS NOT NULL
ORDER BY rok;