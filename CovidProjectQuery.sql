--Mortality rate(deaths vs. cases) of covid infection for each country
Select location, date, total_cases, total_deaths, 
(Cast(total_deaths as float)/total_cases)*100 as mortality_rate
From CovidProject.dbo.CovidDeaths
Order by 1,2


--Infection rate(cases vs. population) of each country
Select location, date, population,total_cases, 
(Cast(total_cases as float)/population)*100 as infections_rate
From CovidProject.dbo.CovidDeaths
Order by 1,2


--Countries with highest infections rates (total cases vs. population)
Select location, population, MAX(total_cases) as HighestInfectionCount, 
MAX((Cast(total_cases as float)/population))*100 as infections_rate
From CovidProject..CovidDeaths
Group by location,population
Order by infections_rate desc


--Countries with highest death counts
Select location, MAX(total_deaths) TotalDeaths
From CovidProject..CovidDeaths
Group by location
Order by TotalDeaths desc


--Continents with highest death counts
Select location, MAX(total_deaths) TotalDeaths
From CovidProject..CovidDeaths
Where continent is null AND location not in ('High income','Upper middle income','Lower middle income','low income','World','European Union')
Group by location
Order by TotalDeaths desc


--Global Statistics
Select location, MAX(total_cases) as TotalCases, MAX(total_deaths) as TotalDeaths, 
(Cast(MAX(total_deaths) as float)/MAX(total_cases))*100 as mortality_rate
From CovidProject..CovidDeaths
Where location = 'World'
Group by location


/*New vaccinations per day, running count per country, total people vaccinated 
/ and percentage of population vaccinated
*/
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location,
dea.date ROWS UNBOUNDED PRECEDING) as TotalVacAdministered, vac.people_vaccinated, 
(CAST(vac.people_fully_vaccinated as bigint)/dea.population)*100 as PopPercentVac
From CovidProject..CovidDeaths dea
Join CovidProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3

--Creating views to store data for later visualizations
Use CovidProject
GO
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location,
dea.date ROWS UNBOUNDED PRECEDING) as TotalVacAdministered, vac.people_vaccinated, 
(CAST(vac.people_fully_vaccinated as bigint)/dea.population)*100 as PopPercentVac
From CovidProject..CovidDeaths dea
Join CovidProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null


Use CovidProject
GO
Create View CovidMortalityRate as
Select location, date, total_cases, total_deaths, 
(Cast(total_deaths as float)/total_cases)*100 as mortality_rate
From CovidProject.dbo.CovidDeaths
--Order by 1,2


Use CovidProject
GO
Create View CovidInfectionRate as
Select location, date, population,total_cases, 
(Cast(total_cases as float)/population)*100 as infections_rate
From CovidProject.dbo.CovidDeaths
--Order by 1,2


Use CovidProject
GO
Create View TotalDeathsContinent as
Select location, MAX(total_deaths) TotalDeaths
From CovidProject..CovidDeaths
Where continent is null AND location not in ('High income','Upper middle income','Lower middle income','low income','World','European Union')
Group by location
--Order by TotalDeaths desc