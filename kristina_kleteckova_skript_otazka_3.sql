-- OTÁZKA 3: Která kategorie potravin zdražuje nejpomaleji 
--(je u ní nejnižší percentuální meziroční nárůst)? 

WITH ceny_potravin AS (
    SELECT
        rok,
        potravina,
        AVG(prumerna_cena) AS prumerna_cena
    FROM t_kristina_kleteckova_project_sql_primary_final
    GROUP BY rok, potravina
),
ceny_trend AS (
    SELECT
        rok,
        potravina,
        prumerna_cena,
        LAG(prumerna_cena) OVER (
            PARTITION BY potravina
            ORDER BY rok
        ) AS cena_predchozi_rok
    FROM ceny_potravin
)
SELECT
    potravina,
    ROUND(AVG((prumerna_cena - cena_predchozi_rok) / cena_predchozi_rok * 100)::numeric, 2) AS prumerny_rust
FROM ceny_trend
WHERE cena_predchozi_rok IS NOT NULL
GROUP BY potravina
ORDER BY prumerny_rust;