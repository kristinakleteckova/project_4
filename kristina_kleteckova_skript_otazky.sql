-- OTÁZKA 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

SELECT
    t1.odvetvi,
    t1.rok,
    t1.prumerna_mzda,
    t2.prumerna_mzda AS mzda_predchozi_rok,
    t1.prumerna_mzda - t2.prumerna_mzda AS rozdil,
    CASE 
        WHEN t2.prumerna_mzda IS NULL THEN 'nema data'
        WHEN t1.prumerna_mzda > t2.prumerna_mzda THEN 'roste'
        WHEN t1.prumerna_mzda < t2.prumerna_mzda THEN 'klesa'
        ELSE 'stejne'
    END AS trend
FROM t_kristina_kleteckova_project_sql_primary_final t1
LEFT JOIN t_kristina_kleteckova_project_sql_primary_final t2
    ON t1.odvetvi = t2.odvetvi
    AND t1.rok = t2.rok + 1
GROUP BY
    t1.odvetvi,
    t1.rok,
    t1.prumerna_mzda,
    t2.prumerna_mzda
ORDER BY t1.odvetvi, t1.rok;

-- OTÁZKA 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první 
-- a poslední srovnatelné období v dostupných datech cen a mezd?

SELECT DISTINCT potravina
FROM t_kristina_kleteckova_project_SQL_primary_final;

SELECT
    rok,
    potravina,
    AVG(prumerna_mzda) AS prumerna_mzda,
    AVG(prumerna_cena) AS prumerna_cena,
    AVG(prumerna_mzda) / AVG(prumerna_cena) AS mnozstvi
FROM t_kristina_kleteckova_project_SQL_primary_final
WHERE potravina IN (
    'Mléko polotučné pasterované',
    'Chléb konzumní kmínový'
)
AND rok IN (2006, 2018)
GROUP BY rok, potravina
ORDER BY potravina, rok;

-- OTÁZKA 3: Která kategorie potravin zdražuje nejpomaleji 
--(je u ní nejnižší percentuální meziroční nárůst)? 

CREATE VIEW v_ceny_potravin AS
SELECT
    rok,
    potravina,
    AVG(prumerna_cena) AS prumerna_cena
FROM t_kristina_kleteckova_project_sql_primary_final
GROUP BY
    rok,
    potravina;

SELECT
    t1.potravina,
    AVG((t1.prumerna_cena - t2.prumerna_cena) / t2.prumerna_cena * 100) AS prumerny_rust
FROM v_ceny_potravin t1
JOIN v_ceny_potravin t2
    ON t1.potravina = t2.potravina
    AND t1.rok = t2.rok + 1
GROUP BY
    t1.potravina
ORDER BY
    prumerny_rust;

-- OTÁZKA 4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd 
-- (větší než 10 %)?

CREATE VIEW v_prumery_rok AS
SELECT
    rok,
    AVG(prumerna_mzda) AS mzda,
    AVG(prumerna_cena) AS cena
FROM t_kristina_kleteckova_project_SQL_primary_final
GROUP BY rok;

SELECT
    t1.rok,
    (t1.mzda - t2.mzda) / t2.mzda * 100 AS rust_mezd,
    (t1.cena - t2.cena) / t2.cena * 100 AS rust_cen,
    ((t1.cena - t2.cena) / t2.cena * 100)
    -
    ((t1.mzda - t2.mzda) / t2.mzda * 100) AS rozdil
FROM v_prumery_rok t1
JOIN v_prumery_rok t2
    ON t1.rok = t2.rok + 1
ORDER BY t1.rok;

-- OTÁZKA 3: Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste 
-- výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím 
-- roce výraznějším růstem?

SELECT
    p.rok,
    AVG(p.prumerna_mzda) AS mzda,
    AVG(p.prumerna_cena) AS cena,
    s.hdp
FROM t_kristina_kleteckova_project_SQL_primary_final p
JOIN t_kristina_kleteckova_project_SQL_secondary_final s
    ON p.rok = s.rok
    AND s.stat = 'Czech Republic'
GROUP BY
    p.rok, s.hdp
ORDER BY
    p.rok;