
--Average defensive rating of teams by year
SELECT Year, AVG(ORtg) as AvgORtg
FROM NBAProject..TeamData
Where year >= '2012'
Group by year
Order by year asc


--Best defensive rating of any team in a given year
Select Year, MIN(DRtg) as BestDRtg
FROM NBAProject..TeamData
Group by year
Order by year asc

--Best offensive rating of any team in a given year
Select Year, MAX(ORtg) as BestORtg
FROM NBAProject..TeamData
Group by year
Order by year asc

--Temp table total FGA and 3PA by all teams each season
Select year, SUM(FGA) as total_FGA, SUM(TPA) as total_TPA
Into ThreePointFGA
From NBAProject..TeamShooting
Group by year

--Percentage of total FGA from three each year
Select year, total_FGA, total_TPA, (total_TPA/total_FGA)*100 as PercentageOfFGAfromThree
From ThreePointFGA


/*Looking at how the Golden State Warriors ORtg fluctuated based on
* # of three pointers attempted
*/
Select S.TEAM,D.TeamID,S.YEAR,TPA,D.ORtg
From NBAProject..TeamShooting as S join NBAProject..TeamData as D
ON S.TeamID = D.TeamID
Where S.TeamID like 'GSW%'


/*While three point percentages have remained consistent,
  three point shooting has doubled in volume
*/
SELECT Year, AVG(ABTFGP) as AvgThreePointPerc, AVG(ABTFGA)
From NBAProject..ShotEff
Where year is not NULL
Group by year



--Temp table to be used for further calculations
SELECT Year, AVG(RAFGP) as RAFGP, AVG(PFGP) as PFGP, AVG(MFG) as MFGP, AVG(LCFGP) as LCFGP, 
AVG(RCFGP) as RCFGP, AVG(ABTFGP) as ABTFGP
Into LeagueZoneShooting
FROM NBAProject..ShotEff
Group by year

/*Multiplied the shooting percentage from each zone by the amount of points a made
  shot would yield in order to calculate the points per shot over the past
  ten seasons
*/
SELECT (AVG(RAFGP)*.01)*2 as RAPPS,(AVG(PFGP)*.01)*2 as PaintPPS,
(AVG(MFGP)*.01)*2 as MidPPS,(AVG(LCFGP)*.01)*3 as LeftCPPS,(AVG(RCFGP)*.01)*3 as RightCPPS,
(AVG(ABTFGP)*.01)*3 as ABTPPS
From LeagueZoneShooting