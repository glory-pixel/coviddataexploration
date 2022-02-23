SELECT * FROM ['covid death data] 
ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM ['covid death data] 
ORDER BY 1,2

--TOTAL CASES VS TOTAL DEATH
SELECT location, date, total_deaths, total_cases, (total_deaths/total_cases)*100 AS Deathpercentage
FROM ['covid death data]
WHERE location LIKE '%Nigeria%'


--TOTAL CASES VS POPULATION
--SHOWS WHAT NUMBER OF POPULATION GOT COVID
SELECT location, date, population, total_cases, (total_cases/population)*100 AS Populationpercentage
FROM ['covid death data]
WHERE location LIKE '%states%'

--WHAT COUNTRY HAS THE HIGHEST PERCENTAGE OF INFECTION REATE COMPARED TO POPULATION

SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 AS percentPopulationInfected
FROM ['covid death data]
GROUP BY location, population
ORDER BY percentPopulationInfected desc

--COUNTRIES WITH HIGHEST DEATH COUNT 
SELECT location, MAX (CAST(total_deaths as bigint)) as TotaldeathCount
FROM ['covid death data]
WHERE continent is NOT null
GROUP BY location
ORDER BY TotaldeathCount desc


--CONTINENT WITH HIGHEST DEATH COUNT 
SELECT continent, MAX (CAST(total_deaths as bigint)) as TotaldeathCount
FROM ['covid death data]
WHERE continent is NOT null
GROUP BY continent
ORDER BY TotaldeathCount desc

--GLOBAL NUMBER
SELECT   SUM (new_cases) AS Total_cases,SUM(CAST(new_deaths as bigint)) as Total_death, SUM(CAST(new_deaths as bigint))/ SUM (new_cases)*100 AS Deathpercentage
FROM ['covid death data]
WHERE continent is NOT null
--GROUP BY date
ORDER BY 1,2

-- JIONING  COVID VACCINATION DATA TO COVID DEATH DATA  
SELECT * FROM  ['covid death data] dea
JOIN [covid vaccination data] vacc
ON  dea.date = vacc.date
and dea.location = vacc. location


--  VACCINATIONS VS TOTAL POPULATION
SELECT  dea. continent, dea.location, dea.date, dea.population, vacc.new_vaccinations,
SUM (CONVERT ( bigint, vacc.new_vaccinations )) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM  ['covid death data] dea
JOIN [covid vaccination data] vacc
ON  dea.date = vacc.date
and dea.location = vacc. location
WHERE dea. continent IS NOT NULL
ORDER BY 2, 3


--CREATING CTE

WITH povvsvacc ( continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT  dea. continent, dea.location, dea.date, dea.population, vacc.new_vaccinations,
SUM (CONVERT ( bigint, vacc.new_vaccinations )) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM  ['covid death data] dea
JOIN [covid vaccination data] vacc
ON  dea.date = vacc.date
and dea.location = vacc. location
WHERE dea. continent IS NOT NULL
--ORDER BY 2, 3 
)
SELECT *, (RollingPeopleVaccinated / population)*100  as perofrollingpeoplevaccinated FROM povvsvacc


--CREATING VIEWS
CREATE VIEW  RollingPeopleVaccinated AS
SELECT  dea. continent, dea.location, dea.date, dea.population, vacc.new_vaccinations,
SUM (CONVERT ( bigint, vacc.new_vaccinations )) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM  ['covid death data] dea
JOIN [covid vaccination data] vacc
ON  dea.date = vacc.date
and dea.location = vacc. location
WHERE dea. continent IS NOT NULL
--ORDER BY 2, 3


CREATE VIEW  perofrollingpeoplevaccinated  AS
WITH povvsvacc ( continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT  dea. continent, dea.location, dea.date, dea.population, vacc.new_vaccinations,
SUM (CONVERT ( bigint, vacc.new_vaccinations )) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM  ['covid death data] dea
JOIN [covid vaccination data] vacc
ON  dea.date = vacc.date
and dea.location = vacc. location
WHERE dea. continent IS NOT NULL
--ORDER BY 2, 3 
)
SELECT *, (RollingPeopleVaccinated / population)*100  as perofrollingpeoplevaccinated FROM povvsvacc



CREATE VIEW
SELECT  dea. continent, dea.location, dea.date, dea.population, vacc.new_vaccinations,
SUM (CONVERT ( bigint, vacc.new_vaccinations )) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM  ['covid death data] dea
JOIN [covid vaccination data] vacc
ON  dea.date = vacc.date
and dea.location = vacc. location
WHERE dea. continent IS NOT NULL
ORDER BY 2, 3



CREATE VIEW Deathpercentage AS 
SELECT location, date, total_deaths, total_cases, (total_deaths/total_cases)*100 AS Deathpercentage
FROM ['covid death data]
WHERE location LIKE '%Nigeria%'





CREATE VIEW USADeathpercentage AS 
SELECT location, date, total_deaths, total_cases, (total_deaths/total_cases)*100 AS Deathpercentage
FROM ['covid death data]
WHERE location LIKE '%states%'

