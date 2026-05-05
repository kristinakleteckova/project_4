## Otázka 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

### Postup

Použila jsem primární tabulku, která obsahuje mzdy podle roku, odvětví a potravin. 

Tabulku jsem napojila sama na sebe pomocí `LEFT JOIN`, abych byla schopná porovnávat data s předešlým rokem:
- `t1` představuje aktuální rok
- `t2` představuje předchozí rok

Spojení jsem provedla pomocí:
- stejného odvětví (`odvetvi`)
- a roku posunutého o 1 (`t1.rok = t2.rok + 1`)

### Výpočty

Pro každý řádek jsem vypočítala:
- mzdu v aktuálním roce
- mzdu v předchozím roce
- rozdíl mezi těmito hodnotami

Pomocí podmínky `CASE` jsem určila trend:
- `roste` – pokud je mzda vyšší než v předchozím roce
- `klesa` – pokud je nižší
- `stejne` – pokud je stejná
- `nema data` – pokud není k dispozici předchozí rok 

### Výsledek

Z výsledků je patrné, že:
- ve většině odvětví mzdy v průběhu let rostly,
- v některých případech došlo ke krátkodobému poklesu,
- zajímavým zjištěním je, že k většině meziročních poklesů mezd v jednotlivých odvětvích 
došlo v roce 2013, tento pokles se neprojevil jako dlouhodobý trend, ale spíše jako krátkodobé kolísání, 
po kterém mzdy opět rostly, tento vývoj mohl souviset s ekonomickou situací v daném období
- celkový trend je tedy rostoucí.

---

## Otázka 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první 
a poslední srovnatelné období v dostupných datech cen a mezd?

### Postup

Z primární tabulky jsem vyfiltrovala pouze dvě požadované potraviny
a zároveň jsem omezila data na první a poslední rok sledovaného období (2006 a 2018).

Následně jsem pro každý rok spočítala:
- průměrnou mzdu
- průměrnou cenu potraviny

Kupní sílu jsem vypočítala jako podíl průměrné mzdy a ceny potraviny.

### Výsledek

Z výsledků vyplývá, že:

- u chleba bylo možné koupit:
  - v roce 2006 přibližně 1313 kg
  - v roce 2018 přibližně 1365 kg

- u mléka bylo možné koupit:
  - v roce 2006 přibližně 1466 litrů
  - v roce 2018 přibližně 1669 litrů

 Z výsledků vyplývá, že v roce 2018 je možné koupit větší množství chleba i mléka než v roce 2006, 
 lze tedy říci, že ve sledovaných letech vzrostly mzdy více než ceny těchto potravin.
 
 ---

## Otázka 3: Která kategorie potravin zdražuje nejpomaleji(je u ní nejnižší percentuální meziroční nárůst)? 


### Postup

Z primární tabulky jsem vytvořila pomocné view `v_ceny_potravin`, kde jsou data seskupena
podle roku a potraviny. Tím jsem odstranila duplicity způsobené různými odvětvími.

Následně jsem toto view napojila samo na sebe (obdobně jako při otázce 1):
- `t1` představuje aktuální rok
- `t2` představuje předchozí rok

Spojení probíhá podle:
- stejné potraviny
- a roku posunutého o 1 (`t1.rok = t2.rok + 1`)

### Výpočet

Pro každou potravinu jsem vypočítala meziroční procentuální změnu ceny podle vzorce:

(nová cena − původní cena) / původní cena × 100

Nakonec jsem spočítala průměrnou hodnotu tohoto růstu pro každou potravinu a výsledky 
seřadila od nejnižší hodnoty.

### Závěr

Z výsledků vyplývá, že nejnižší průměrný meziroční růst mají rajská jablka, 
u kterých je hodnota dokonce záporná, což znamená, že jejich cena v průměru klesá.
Pokud však uvažujeme pouze potraviny, které skutečně zdražují, pak nejpomaleji zdražují banány, 
které mají nejnižší kladný růst.

---

## Otázka 4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd 
(větší než 10 %)?

### Postup

Nejprve jsem si vytvořila pomocné view, ve kterém jsou pro každý rok vypočítány průměrné hodnoty:
- průměrná mzda
- průměrná cena potravin

Tím jsem získala přehled o celkovém vývoji mezd a cen v jednotlivých letech.

Následně jsem toto view napojila samo na sebe:
- `t1` představuje aktuální rok
- `t2` představuje předchozí rok

Spojení probíhá podle roku posunutého o 1 (`t1.rok = t2.rok + 1`).

### Výpočet

Pro každý rok jsem vypočítala:
- meziroční růst mezd v procentech
- meziroční růst cen v procentech
- rozdíl mezi těmito hodnotami


### Závěr

Z výsledků vyplývá, že v žádném ze sledovaných let nebyl meziroční růst cen potravin vyšší 
než růst mezd o více než 10 %. Největší rozdíl (9,49 %) byl zaznamenán v roce 2013, 
kdy ceny rostly rychleji než mzdy, ale rozdíl nedosáhl stanovené hranice.
Tento výsledek zároveň koresponduje s otázkou č. 1, ve které byl v roce 2013 zaznamenán pokles mezd 
v řadě odvětví. V kombinaci s růstem cen potravin to vedlo k dočasnému zhoršení kupní síly obyvatel.

---

## Otázka 5: Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste 
výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím 
roce výraznějším růstem?

### Postup

Pro tuto analýzu jsem propojila primární tabulku (mzdy a ceny potravin) se sekundární tabulkou, 
která obsahuje ekonomická data včetně HDP.

Data jsem spojila podle roku, aby bylo možné porovnat vývoj všech tří veličin ve stejném časovém období.

Následně jsem pro každý rok vypočítala:
- průměrnou mzdu
- průměrnou cenu potravin
- hodnotu HDP

Tyto hodnoty jsem poté porovnala v čase a sledovala, zda při růstu HDP dochází zároveň k růstu mezd 
a cen potravin, případně zda se změny projeví i v následujícím roce.

Z výsledků je vidět, že HDP má celkově rostoucí trend a ve většině případů s ním rostou i mzdy.
Neznamená to ale, že by mezi nimi byla přímá závislost, protože v některých letech se jejich vývoj liší.
Například v roce 2013 mzdy klesly, i když HDP nijak výrazně neklesalo.
U cen potravin je vztah k HDP ještě méně zřejmý, protože jejich vývoj kolísá a neodpovídá vždy změnám HDP.
Celkově tedy nelze potvrdit, že by růst HDP automaticky vedl k růstu mezd nebo cen potravin.
