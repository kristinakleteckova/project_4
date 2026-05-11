## Otázka 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

### Postup

Pro analýzu byla použita primární tabulka obsahující informace o mzdách podle jednotlivých odvětví a let.

Pro porovnání mezd s předchozím rokem byla využita okenní funkce `LAG`, která umožňuje získat hodnotu z předchozího řádku v rámci stejného odvětví.

```sql
LAG(prumerna_mzda) OVER (
    PARTITION BY odvetvi
    ORDER BY rok
)
```

Data byla rozdělena podle odvětví (`PARTITION BY odvetvi`) a následně seřazena podle roku (`ORDER BY rok`).

### Výpočty

Pro každý rok a odvětví byly vypočítány:
- průměrná mzda v aktuálním roce,
- průměrná mzda v předchozím roce,
- rozdíl mezi těmito hodnotami.

Následně byly vyfiltrovány pouze případy, kdy došlo k meziročnímu poklesu mezd.

### Výsledek

Z výsledků vyplývá, že:
- ve většině odvětví mají mzdy dlouhodobě rostoucí trend,
- v některých letech však došlo ke krátkodobému poklesu mezd,
- nejvíce poklesů bylo zaznamenáno v roce 2013,
- tento pokles se ale neprojevil jako dlouhodobý trend, spíše šlo o krátkodobé kolísání, po kterém mzdy opět rostly.

Celkově lze říci, že mzdy v jednotlivých odvětvích v dlouhodobém horizontu převážně rostou.

---

## Otázka 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

### Postup

Z primární tabulky byly vyfiltrovány pouze dvě sledované potraviny:

```sql
WHERE potravina IN (
    'Mléko polotučné pasterované',
    'Chléb konzumní kmínový'
)
```

Data byla zároveň omezena pouze na první a poslední srovnatelné období:

```sql
AND rok IN (2006, 2018)
```

Pro jednotlivé kombinace roku a potraviny byly následně vypočítány:
- průměrná mzda,
- průměrná cena potraviny.

Kupní síla byla určena jako podíl průměrné mzdy a průměrné ceny:

```sql
AVG(prumerna_mzda) / AVG(prumerna_cena)
```

### Výsledek

Z výsledků vyplývá, že:

- u chleba bylo možné koupit:
  - v roce 2006 přibližně 1313 kg,
  - v roce 2018 přibližně 1365 kg,

- u mléka bylo možné koupit:
  - v roce 2006 přibližně 1466 litrů,
  - v roce 2018 přibližně 1669 litrů.

Ve sledovaném období tedy vzrostla kupní síla obyvatel, protože růst mezd převýšil růst cen těchto potravin.

---

## Otázka 3: Která kategorie potravin zdražuje nejpomaleji (má nejnižší průměrný meziroční nárůst)?

### Postup

Nejprve byla pomocí CTE připravena agregovaná data s průměrnou cenou jednotlivých potravin podle roku:

```sql
WITH ceny_potravin AS (
    SELECT
        rok,
        potravina,
        AVG(prumerna_cena) AS prumerna_cena
    FROM ...
)
```

Následně byla pomocí funkce `LAG` získána cena stejné potraviny z předchozího roku:

```sql
LAG(prumerna_cena) OVER (
    PARTITION BY potravina
    ORDER BY rok
)
```

### Výpočet

Meziroční procentuální změna byla vypočítána podle vzorce:

```sql
(nova_cena - puvodni_cena)
/ puvodni_cena * 100
```

Nakonec byl spočítán průměrný meziroční růst cen pro každou potravinu.

### Výsledek

Z výsledků vyplývá, že nejnižší průměrný meziroční růst mají cukr krystal a rajská jablka, u kterých je hodnota dokonce záporná, což znamená, že jejich cena v průměru klesá.

Pokud uvažujeme pouze potraviny, které skutečně zdražují, pak nejpomaleji zdražují banány, které mají nejnižší kladný meziroční růst.

---

## Otázka 4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

### Postup

Pomocí CTE byly nejprve připraveny průměrné hodnoty mezd a cen potravin pro jednotlivé roky.

Následně byla pomocí funkce `LAG` získána data z předchozího roku:

```sql
LAG(mzda) OVER (ORDER BY rok)
LAG(cena) OVER (ORDER BY rok)
```

### Výpočet

Pro každý rok byly vypočítány:
- meziroční růst mezd,
- meziroční růst cen potravin,
- rozdíl mezi těmito hodnotami.

### Výsledek

Z výsledků vyplývá, že v žádném ze sledovaných let nebyl meziroční růst cen potravin vyšší než růst mezd o více než 10 %.

Největší rozdíl byl zaznamenán v roce 2013, kdy ceny potravin rostly rychleji než mzdy, rozdíl však nepřekročil stanovenou hranici.

Výsledek zároveň souvisí s otázkou č. 1, kde byl právě v roce 2013 zaznamenán pokles mezd v řadě odvětví. V kombinaci s růstem cen potravin tak došlo ke krátkodobému zhoršení kupní síly obyvatel.

---

## Otázka 5: Má výška HDP vliv na změny ve mzdách a cenách potravin?

### Postup

Pro tuto analýzu byla primární tabulka obsahující mzdy a ceny potravin propojena se sekundární tabulkou obsahující ekonomická data včetně HDP.

Spojení probíhalo podle roku:

```sql
ON p.rok = s.rok
```

Následně byly pomocí funkce `LAG` vypočítány meziroční změny jednotlivých veličin:

```sql
LAG(hdp) OVER (ORDER BY rok)
LAG(mzda) OVER (ORDER BY rok)
LAG(cena) OVER (ORDER BY rok)
```

### Výsledek

Z výsledků je patrné, že HDP má dlouhodobě rostoucí trend a ve většině případů s ním rostou také mzdy.

Nelze však potvrdit přímou závislost mezi růstem HDP a růstem mezd nebo cen potravin, protože v některých letech se jejich vývoj lišil.

Například v roce 2013 došlo k poklesu mezd, přestože HDP výrazně neklesalo.

U cen potravin je vztah k HDP ještě méně jednoznačný, protože jejich vývoj více kolísá a neodpovídá vždy změnám HDP.

Celkově tedy nelze potvrdit, že by růst HDP automaticky vedl k růstu mezd nebo cen potravin.

# Závěr

Cílem projektu bylo analyzovat vývoj mezd, cen potravin a HDP v České republice a zjistit, zda mezi těmito veličinami existují souvislosti.

Z analýzy vyplynulo, že mzdy mají ve většině odvětví dlouhodobě rostoucí trend, i když v některých letech došlo ke krátkodobým poklesům. Nejvýraznější pokles byl zaznamenán v roce 2013, kdy zároveň rostly ceny potravin rychleji než mzdy, což vedlo ke krátkodobému zhoršení kupní síly obyvatel.

V rámci kupní síly bylo zjištěno, že za průměrnou mzdu bylo v roce 2018 možné koupit větší množství chleba i mléka než v roce 2006. To naznačuje, že růst mezd v dlouhodobém horizontu převyšoval růst cen sledovaných potravin.

Analýza cen potravin ukázala, že jednotlivé kategorie zdražují rozdílným tempem. Některé potraviny dokonce v průměru zlevňovaly. Naopak nejpomalejší kladný růst cen byl zaznamenán u banánů.

V poslední části projektu byl sledován vztah mezi HDP, mzdami a cenami potravin. Přestože HDP i mzdy vykazují dlouhodobě rostoucí trend, nepodařilo se potvrdit jednoznačnou přímou závislost mezi růstem HDP a růstem mezd nebo cen potravin. Vývoj jednotlivých veličin se v některých letech lišil a vztahy mezi nimi jsou komplexnější.

Projekt zároveň ukázal praktické využití SQL při práci s daty, agregacemi, okenními funkcemi, CTE a meziročními porovnáními.
