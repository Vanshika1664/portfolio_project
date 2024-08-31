SELECT *
FROM PortfoliProject ..CovidDeaths$
where continent is not null
order by 3,4 

--SELECT *
--FROM PortfoliProject..CovidVaccinations$
--order by 3,4
select location, date, total_cases,new_cases,total_deaths, population
from PortfoliProject..CovidDeaths$
order by 1,2
select location, date, total_cases,new_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage 
from PortfoliProject..CovidDeaths$
--where location like '%india%'
where continent is not null
order by 1,2
select location, date, max(total_cases) as highestcasescount ,max((total_deaths/total_cases))*100 as highestpercentpoplulationinfected
from PortfoliProject..CovidDeaths$
--where location like '%india%'
Group by location, date
order by highestpercentpoplulationinfected desc

select location, max(cast (total_deaths as int)) as totaldeathcount
from PortfoliProject..CovidDeaths$
--where location like '%india%'
where continent is not null
Group by location
order by totaldeathcount desc

select continent, max(cast (total_deaths as int)) as totaldeathcount
from PortfoliProject..CovidDeaths$
--where location like '%india%'
where continent is not null
Group by continent
order by totaldeathcount desc

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths ,sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
from PortfoliProject..CovidDeaths$
--where location like '%india%'
where continent is not null
--group by date 
order by 1,2

with PopvsVac (continent,location,date,population,new_vaccinations,rollingpeoplevaccinated )as
(select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
from PortfoliProject..CovidDeaths$ dea
join PortfoliProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (rollingpeoplevaccinated/population)*100
from PopvsVac

drop table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent nvarchar(255),
lacation nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rollingpeoplevaccinated numeric
)
insert into #percentpopulationvaccinated

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
from PortfoliProject..CovidDeaths$ dea
join PortfoliProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3
Select *, (rollingpeoplevaccinated/population)*100
from #percentpopulationvaccinated

CREATE VIEW percentpopulationvaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
from PortfoliProject..CovidDeaths$ dea
join PortfoliProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select * 
from percentpopulationvaccinated