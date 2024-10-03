-- Part-02 Exploratory Data Analysis
select *
from employee_layoffs.layoffs;

-- check total laid off
select *
from layoffs2
where percentage_laid_off = 1
order by total_laid_off desc;

-- check  laid off by funds raised in millions
select *
from layoffs2
where percentage_laid_off = 1
order by funds_raised_millions desc;

-- check total laid off by company
select company, sum(total_laid_off)
from layoffs2
group by company
order by 2 desc
;

select count(*) 
from layoffs2
where total_laid_off is null
and percentage_laid_off is not null
;

-- check laid off starting and ending date
select min(`date`), max(`date`)
from layoffs2; 

-- check which industry has highest sum of  laid off
select industry, sum(total_laid_off)
from layoffs2
group by industry
order by 2 desc
;

-- check which country has highest sum of laid off
select country, sum(total_laid_off)
from layoffs2
group by country
order by 2 desc
;

-- check recent highest sum of laid off
select `date`, sum(total_laid_off)
from layoffs2
group by `date`
order by 1 desc
;

-- check  highest sum of laid off by year
select year(`date`), sum(total_laid_off)
from layoffs2
group by year(`date`)
order by 1 desc
;
-- check  highest sum of laid off by stage
select stage, sum(total_laid_off)
from layoffs2
group by stage
order by 2 desc
;

-- check rolling total laid off
select substring(`date`, 6,2) as `Month`, Sum(total_laid_off)
from layoffs2
where date is not null
group by `Month`
order by 1 asc; 

select substring(`date`, 1, 7) as `Month`, Sum(total_laid_off)
from layoffs2
where substring(`date`, 1,7) is not null
group by `Month`
order by 1 asc;

-- using cte to calculate rolling total
with Rolling_Total as 
(
	select substring(`date`, 1, 7) as `Month`, Sum(total_laid_off) as total_off
	from layoffs2
	where substring(`date`, 1,7) is not null
	group by `Month`
	order by 1 asc
)
select `month`, total_off
,sum(total_off) over(order by `month`) as rolling_total
from Rolling_Total
;

select country, sum(total_laid_off)
from layoffs2
group by country
order by 2 desc
;

select country, year(`date`) as Year, sum(total_laid_off) as total_off
from layoffs2
group by country, year(`date`)
order by 3 desc
;

-- Using  CTE show top companies partition them by years and rank them 
with Company_Year(Company, Years, Sum_of_total_laid_off) as
(
	select company, year(`date`) as Year, sum(total_laid_off) as total_off
	from layoffs2
	group by company, year(`date`)
)
 select *, 
 dense_rank() over(partition by Years order by Sum_of_total_laid_off desc ) as Ranking
 from Company_Year
 where Sum_of_total_laid_off and Years is not null
 order by Ranking asc
;

-- Using multiple CTEs show top 5 companies each year by ranking
with Company_Year(Company, Years, Sum_of_total_laid_off) as
(
	select company, year(`date`) as Year, sum(total_laid_off) as total_off
	from layoffs2
	group by company, year(`date`)
), 
company_year_rank as
(
 select *, 
 dense_rank() over(partition by Years order by Sum_of_total_laid_off desc ) as Ranking
 from Company_Year
 where Sum_of_total_laid_off and Years is not null
)
select *
from company_year_rank
where Ranking <=5
;



