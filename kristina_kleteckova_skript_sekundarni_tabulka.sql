-- =====================================================
-- SEKUNDÁRNÍ TABULKA
-- obsahuje ekonomická data evropských států
-- =====================================================

CREATE TABLE t_kristina_kleteckova_project_SQL_secondary_final AS
SELECT
    economies.year AS rok,
    economies.country AS stat,
    economies.gdp AS hdp,
    economies.gini AS gini,
    countries.continent AS kontinent
FROM economies
JOIN countries
    ON economies.country = countries.country
WHERE countries.continent = 'Europe'
  AND economies.year BETWEEN 2006 AND 2018;