-- OTÁZKA 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

WITH mzdy_trend AS (
    SELECT
        odvetvi,
        rok,
        prumerna_mzda,
        LAG(prumerna_mzda) OVER (
            PARTITION BY odvetvi
            ORDER BY rok
        ) AS mzda_predchozi_rok
    FROM t_kristina_kleteckova_project_sql_primary_final
)
SELECT
    odvetvi,
    rok,
    ROUND(prumerna_mzda::numeric, 2) AS prumerna_mzda,
    ROUND(mzda_predchozi_rok::numeric, 2) AS mzda_predchozi_rok,
    ROUND(prumerna_mzda - mzda_predchozi_rok::numeric, 2) AS rozdil,
    'klesa' AS trend
FROM mzdy_trend
WHERE mzda_predchozi_rok IS NOT NULL
  AND prumerna_mzda < mzda_predchozi_rok
ORDER BY odvetvi, rok;