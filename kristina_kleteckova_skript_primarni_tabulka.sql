-- =====================================================
-- PRIMÁRNÍ TABULKA
-- obsahuje mzdy a ceny potravin pro ČR
-- =====================================================

CREATE TABLE t_kristina_kleteckova_project_SQL_primary_final AS 
SELECT
    czechia_payroll.payroll_year AS rok,
    czechia_payroll_industry_branch.name AS odvetvi,
    AVG(czechia_payroll.value) AS prumerna_mzda,
    czechia_price_category.name AS potravina,
    AVG(czechia_price.value) AS prumerna_cena
FROM czechia_payroll
JOIN czechia_payroll_industry_branch
    ON czechia_payroll.industry_branch_code = czechia_payroll_industry_branch.code
JOIN czechia_price
    ON czechia_payroll.payroll_year = date_part('year', czechia_price.date_from)
JOIN czechia_price_category
    ON czechia_price.category_code = czechia_price_category.code
WHERE czechia_payroll.value_type_code = 5958
  AND czechia_payroll.calculation_code = 200
  AND czechia_payroll.industry_branch_code IS NOT NULL
GROUP BY
    czechia_payroll.payroll_year,
    czechia_payroll_industry_branch.name,
    czechia_price_category.name;