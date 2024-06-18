-- BASIC QUERIES

SELECT MAX(total_laid_off) 
FROM world_layoffs.layoffs_staging2;


SELECT MAX(total_laid_off) , MAX(percentage_laid_off)
FROM world_layoffs.layoffs_staging2;

-- Which companies have laid off 100 percent of the Employees.

SELECT * FROM
world_layoffs.layoffs_staging2 
WHERE percentage_laid_off = 1;


SELECT * FROM
world_layoffs.layoffs_staging2 
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;


SELECT * FROM
world_layoffs.layoffs_staging2 
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off) AS TOTAL
FROM world_layoffs.layoffs_staging2 
GROUP BY company
ORDER BY TOTAL DESC;

-- Range/Time Period of these Layoffs
SELECT MIN(date), MAX(date)
FROM world_layoffs.layoffs_staging2;

-- To find which Industries are impacted most in the layoffs.
SELECT industry, SUM(total_laid_off) AS TOTAL
FROM world_layoffs.layoffs_staging2 
GROUP BY industry
ORDER BY TOTAL DESC;

-- To find which Countries are impacted most in the layoffs.
SELECT country, SUM(total_laid_off) AS TOTAL
FROM world_layoffs.layoffs_staging2 
GROUP BY country
ORDER BY TOTAL DESC;

-- To find which dates layoffs has happened
SELECT date, SUM(total_laid_off) AS TOTAL
FROM world_layoffs.layoffs_staging2 
GROUP BY date
ORDER BY date DESC;

-- To find which Year layoffs has happened
SELECT YEAR(date)  YR, SUM(total_laid_off) AS TOTAL
FROM world_layoffs.layoffs_staging2 
GROUP BY YR
ORDER BY YR DESC;





-- To find the Stage of the Company

SELECT stage, SUM(total_laid_off) AS TOTAL
FROM world_layoffs.layoffs_staging2 
GROUP BY stage
ORDER BY TOTAL DESC;


-- To find the Percentage of Laid Offs in every Company
SELECT company, AVG(percentage_laid_off) AS TOTAL
FROM world_layoffs.layoffs_staging2 
GROUP BY company
ORDER BY TOTAL DESC;

-- To find the Substring of Month
SELECT SUBSTRING(date,6,2) AS 'MONTH'
FROM world_layoffs.layoffs_staging2;

-- To find the Monthwise Lay off Details
SELECT SUBSTRING(date,6,2) AS 'MONTH', SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY MONTH;

-- To find the Month and Year wise Lay off Details
SELECT SUBSTRING(date,1,7) AS 'MONTH', SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY MONTH;

-- To find the Month and Year wise Lay off Details
SELECT SUBSTRING(date,1,7) AS 'MONTH', SUM(total_laid_off) AS TOTAL_LAID_OFF
FROM world_layoffs.layoffs_staging2
WHERE SUBSTRING(date,1,7) IS NOT NULL
GROUP BY MONTH
ORDER BY MONTH ASC;


-- To find the Rolling Sum/ Running Total /Cumulative Value of Total_Laid_off Monthwise
WITH Rolling_Sum AS
(
SELECT SUBSTRING(date,1,7) AS `MONTH`, SUM(total_laid_off) AS TOTAL_LAID_OFF
FROM world_layoffs.layoffs_staging2
WHERE SUBSTRING(date,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY `MONTH` ASC
)
SELECT `MONTH`, TOTAL_LAID_OFF , SUM(TOTAL_LAID_OFF) OVER(ORDER BY `MONTH`) AS ROLLING_TOTAL
FROM 
Rolling_Sum;


SELECT company, SUM(total_laid_off) AS TOTAL
FROM world_layoffs.layoffs_staging2 
GROUP BY company
ORDER BY TOTAL DESC;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY company ASC;


SELECT company, YEAR(`date`), SUM(total_laid_off) AS TOTAL
FROM world_layoffs.layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY TOTAL DESC;

WITH company_years (Company, Year, Total_Laid_Off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off) AS TOTAL
FROM world_layoffs.layoffs_staging2
GROUP BY company, YEAR(`date`)
)
SELECT * 
FROM company_years;

WITH company_years (Company, Year, Total_Laid_Off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off) AS TOTAL
FROM world_layoffs.layoffs_staging2
GROUP BY company, YEAR(`date`)
)
SELECT * , DENSE_RANK() OVER(PARTITION BY Year ORDER BY Total_Laid_Off DESC) AS RANKING
FROM company_years
WHERE Year IS NOT NULL
ORDER BY RANKING ASC;

-- To Filter the Top 5 Companies which Lay Off Per Year.
-- We Use 2 CTEs for this Query to find the Year of Lay off in the First CTE and 
--  We Second CTE to give Ranks to the Company.
WITH company_years (Company, Year, Total_Laid_Off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off) AS TOTAL
FROM world_layoffs.layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(SELECT *,
DENSE_RANK() OVER(PARTITION BY Year ORDER BY Total_Laid_Off DESC) AS RANKING
FROM company_years
WHERE Year IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE RANKING <= 5;
