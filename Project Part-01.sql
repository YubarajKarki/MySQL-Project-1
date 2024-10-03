/*
	Employee Layoffs Data
    Part- 01 Data Cleaning and Standardization
	1. Remove Duplicates
    2. Standardize the data
    3. Null values or blank values
    4. Remove any columns or rows
*/

select *
from layoffs;

create table layoffs1
like layoffs;

select * 
from layoffs1;

insert  layoffs1
select *
from layoffs;

-- create a new field as row number using window functions
select *,
row_number() over(partition by company, location, industry, 
total_laid_off, percentage_laid_off, `date`, country, funds_raised_millions) as row_num
from layoffs1;

-- create cte as row number to dintinguish duplicate value
with duplicate_cte as
(
	select *,
	row_number() over(partition by company, location, industry, 
	total_laid_off, percentage_laid_off, `date`, country, funds_raised_millions) as row_num
	from layoffs1
)
select *
from duplicate_cte
where row_num > 1
;

select *
from layoffs1
where company = 'Casper';

-- create a seperate table to work on
create table layoffs2 
like layoffs1;

select *
from layoffs2;

-- add new column as row_num in new table
alter table layoffs2
add column row_num int;

-- add records in row_num column using window functions
insert into layoffs2
select *,
row_number() over(partition by company, location, industry, 
total_laid_off, percentage_laid_off, `date`, 
country, funds_raised_millions) as row_num
from layoffs1;

select *
from layoffs2
;

-- select duplicate values
select *
from layoffs2
where row_num > 1;

-- delete duplicate values from new table
delete
from layoffs2
where row_num > 1;

select  distinct(company)
from layoffs2;

-- trim unwanted spaces before and after company name
select company, trim(company)
from layoffs2;

-- update table
update layoffs2
set company = trim(company);


select distinct(location)
from layoffs2
order by 1;

-- replaces unwanted character other than a-z and add replaces them with space like FlorianÃ³polis	to Florian  polis 
SELECT distinct(location), 
       REGEXP_REPLACE(location, '[^a-zA-Z]', ' ') AS cleaned_location
FROM layoffs2;

select distinct(industry)
from layoffs2
order by 1;

-- select crypto like industry
select industry
from layoffs2
where industry like 'crypto%';

-- update table and set industry to crypto if there is any record starting with the name crypto
update layoffs2
set industry = 'Crypto'
where industry like 'Crypto%';

select distinct(country)
from layoffs2
order by 1;

select distinct country 
from layoffs2
where country like 'United States%'
order by 1;

-- update table and remove . after United States if there is any
update layoffs2
set country= trim(trailing '.' from country) 
where country like 'United States%';

select `date`
from layoffs2;

-- convert string to date in the format 2023-06-03 from 3/6/2023 
select `date`,
str_to_date(`date`, '%m/%d/%Y') as new_date
from layoffs2;

-- update the table and set string to date
update layoffs2
set `date` = str_to_date(`date`, '%m/%d/%Y') ;

-- still `date` column is shown as text so modify it to date format
alter table layoffs2
modify column `date` date;

-- select if there is any industry value null or empty
select  industry
from layoffs2
where industry is null
 or industry= '';
 
select  *
from layoffs2
where company = 'Airbnb';

-- set industry to null if there is any empty value in industry field
update  layoffs2
set industry = null
where industry = '';

select l1.industry, l2.industry
from layoffs2 l1
join layoffs2 l2
	on l1.company = l2.company
where l1.industry is null 
and l2.industry is not null;

select *
from layoffs2;

-- simply, using join check if same company has industry values null and xyz 
-- then set null value of industry column to xyz
update layoffs2 l1
join layoffs2 l2
	on l1.company = l2.company
set l1.industry = l2.industry
where l1.industry is null 
and l2.industry is not null;

select *
from layoffs2
where industry is null
 or industry= '';

-- finally, drop the column row_num 
alter table layoffs2
drop column row_num;

-- check if both the columns total_laid_off and percentage_laid_off has null value or not
select *
from layoffs2
where total_laid_off is null
and percentage_laid_off is null;

select count(*)
from layoffs2
where total_laid_off is null
and percentage_laid_off is null;

-- delete if both column has null
delete
from layoffs2
where total_laid_off is null
and percentage_laid_off is null;
