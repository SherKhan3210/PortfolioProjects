Select distinct DepartmentName
From HRProject..HRData


--Average Absence hours grouped by Length of Service
select lengthservice.range as [Length of Service], count(*) as [Number of Employees],
Sum(absenth) as [Total Absent Hours], (Sum(absenth)/count(*)) as [Average Absent Hours]
from (
  select absenth,case  
    when lengthservice between 0 and 9.9999 then '0-9'
    when lengthservice between 10 and 19.9999 then '10-19'
	when lengthservice between 20 and 29.9999 then '20-29'
    else '30+' end as range
	from HRProject..HRData)lengthservice
group by lengthservice.range


--Average Absent Hours Grouped by Store Location and Department
select count(*) as [Number of Employees], Sum(absenth) as [Total Absent Hours], 
(Sum(absenth)/count(*)) as [Average Absent Hours], StoreLocation, DepartmentName
from HRProject..HRData
group by StoreLocation, DepartmentName


--Absent Hours Grouped by Age
select age.agerange as [Age Range], count(*) as [Number of Employees],
Sum(absenth) as [Total Absent Hours], (Sum(absenth)/count(*)) as [Average Absent Hours]
from (
  select absenth,case  
    when age between 18 and 23.9999 then '18-23'
    when age between 24 and 29.9999 then '24-29'
	when age between 30 and 35.9999 then '30-35'
	when age between 36 and 41.9999 then '36-41'
    when age between 42 and 47.9999 then '42-47'
	when age between 48 and 53.9999 then '48-53'
	when age between 54 and 59.9999 then '54-59'
    else '60+' end as agerange
  from HRProject..HRData) age
group by age.agerange


--Put them all together to allow for filtering in tableau
select lengthservice.range as [Length of Service], agerange, StoreLocation, DepartmentName, count(*) as [Number of Employees],
Sum(absenth) as [Total Absent Hours], (Sum(absenth)/count(*)) as [Average Absent Hours], gender
from (
  select age.agerange, StoreLocation, DepartmentName, gender,absenth,case  
    when lengthservice between 0 and 9.9999 then '0-9'
    when lengthservice between 10 and 19.9999 then '10-19'
	when lengthservice between 20 and 29.9999 then '20-29'
    else '30+' end as range
	from (
	select StoreLocation, DepartmentName, lengthservice,gender,absenth,case  
		when age between 18 and 23.9999 then '18-23'
		when age between 24 and 29.9999 then '24-29'
		when age between 30 and 35.9999 then '30-35'
		when age between 36 and 41.9999 then '36-41'
		when age between 42 and 47.9999 then '42-47'
		when age between 48 and 53.9999 then '48-53'
		when age between 54 and 59.9999 then '54-59'
		else '60+' end as agerange
	from HRProject..HRData) age) lengthservice
group by lengthservice.range, gender, agerange, StoreLocation, DepartmentName


