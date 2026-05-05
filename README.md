# project_4

# SQL projekt – analýza mezd a cen potravin

## Popis projektu

Cílem projektu je analyzovat vývoj mezd a cen potravin v České republice 
a porovnat tyto změny s vybranými ekonomickými ukazateli.

---

## Použitá data

- czechia_payroll – informace o mzdách  
- czechia_price – ceny potravin  
- czechia_price_category – kategorie potravin  
- czechia_payroll_industry_branch – odvětví  
- economies – ekonomická data (HDP, GINI)  
- countries – informace o státech  

---

## Výzkumné otázky

Projekt se zaměřuje na následující otázky:

1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

---

## Struktura projektu

Součástí projektu jsou následující soubory:

- `kristina_kleteckova_skript_tabulky.sql`  
  obsahuje SQL skript pro vytvoření primární a sekundární tabulky  

- `kristina_kleteckova_skript_otazky.sql`  
  obsahuje SQL dotazy, které slouží jako podklad pro zodpovězení jednotlivých výzkumných otázek  

- `kristina_kleteckova_pruvodni_listina.md`  
  obsahuje průvodní dokumentaci, kde je popsán postup řešení, výpočty a interpretace výsledků  

---

## Autor

Kristina Kletečková

