-- OTÁZKA 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první 
-- a poslední srovnatelné období v dostupných datech cen a mezd?

SELECT
    rok,
    potravina,
    ROUND(AVG(prumerna_mzda)::numeric, 2) AS prumerna_mzda,
    ROUND(AVG(prumerna_cena)::numeric, 2) AS prumerna_cena,
    ROUND((AVG(prumerna_mzda) / AVG(prumerna_cena))::numeric, 2) AS mnozstvi
FROM t_kristina_kleteckova_project_SQL_primary_final
WHERE potravina IN (
    'Mléko polotučné pasterované',
    'Chléb konzumní kmínový'
)
AND rok IN (2006, 2018)
GROUP BY rok, potravina
ORDER BY potravina, rok;