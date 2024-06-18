-- Data Cleaning
-- Step 1: Remove Duplicates
-- Step 2: Standardization of  Data
-- Step 3: Look at Null Values or Blank Values
-- Step 4: Remove any columns and rows if its not necessary

SELECT * FROM layoffs;

-- Create a Back Up Table as a Staging Table

CREATE TABLE world_layoffs.layoffs_staging 
LIKE world_layoffs.layoffs;

INSERT layoffs_staging 
SELECT * FROM world_layoffs.layoffs;

-- 1. Remove Duplicates

SELECT *
FROM world_layoffs.layoffs_staging;


-- Add all the columns to find the Row Number > 1

WITH DUPLICATE_CTE AS
(
SELECT *,
ROW_NUMBER() OVER
(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS ROW_NUM
FROM layoffs_staging 
)
SELECT * FROM  DUPLICATE_CTE WHERE ROW_NUM > 1;

SELECT * FROM world_layoffs.layoffs WHERE company = 'Casper';

-- To delete the Duplicates lets create a new table and delete all the rows where row_number > 1
-- Create a new column and add those row numbers into it. Then delete where row numbers are greater than 1, then delete that row number column.

CREATE TABLE `world_layoffs`.`layoffs_staging2`
(
`company` text,
`location`text,
`industry`text,
`total_laid_off` INT,
`percentage_laid_off` text,
`date` text,
`stage`text,
`country` text,
`funds_raised_millions` int,
row_num INT
);

SELECT * FROM world_layoffs.layoffs_staging2;

INSERT INTO `world_layoffs`.`layoffs_staging2`
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS ROW_NUM
FROM world_layoffs.layoffs_staging ;

SELECT * FROM world_layoffs.layoffs_staging2;

SELECT * FROM world_layoffs.layoffs_staging2 WHERE row_num > 1 ;

SELECT * FROM world_layoffs.layoffs_staging2 WHERE company = 'Casper';

SELECT * FROM world_layoffs.layoffs_staging2 WHERE company = 'Cazoo';

SELECT * FROM world_layoffs.layoffs_staging2 WHERE company = 'Hibob';

SELECT * FROM world_layoffs.layoffs_staging2 WHERE company = 'Wildlife Studios';

SELECT * FROM world_layoffs.layoffs_staging2 WHERE company = 'Yahoo';


-- To Delete all the duplicates


DELETE FROM world_layoffs.layoffs_staging2 WHERE row_num > 1 ;

SELECT * FROM world_layoffs.layoffs_staging2 WHERE row_num > 1;

SELECT * FROM world_layoffs.layoffs_staging2;


-- 2. Standardize Data

SELECT DISTINCT(company)
from layoffs_staging2;

SELECT DISTINCT(TRIM(company))
from layoffs_staging2;


SELECT company, TRIM(company)
FROM world_layoffs.layoffs_staging2;

UPDATE world_layoffs.layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT(industry)
FROM world_layoffs.layoffs_staging2;

SELECT DISTINCT industry
FROM world_layoffs.layoffs_staging2
ORDER BY industry;

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE world_layoffs.layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE industry LIKE 'Crypto';

SELECT DISTINCT(industry)
FROM world_layoffs.layoffs_staging2;

SELECT DISTINCT(location)
FROM world_layoffs.layoffs_staging2;

SELECT DISTINCT(country)
FROM world_layoffs.layoffs_staging2;

SELECT DISTINCT(country), TRIM(TRAILING '.' FROM country)
FROM world_layoffs.layoffs_staging2
ORDER BY country;

UPDATE world_layoffs.layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT DISTINCT(country)
FROM world_layoffs.layoffs_staging2
WHERE country LIKE 'United States%';

-- Changing date format

SELECT `date`,
STR_TO_DATE(`date`,'%m/%d/%Y')
from world_layoffs.layoffs_staging2;


UPDATE world_layoffs.layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE world_layoffs.layoffs_staging2
MODIFY COLUMN `date` DATE;

-- To Check for NULL Values and Blank Values

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL;

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


-- Remove Any Rows and Columns which are not necessary

SELECT DISTINCT industry
FROM world_layoffs.layoffs_staging2;

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE industry IS NULL
OR industry = '';



SELECT *
FROM world_layoffs.layoffs_staging2
WHERE company = 'Airbnb';

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE company = 'Carvana';


SELECT *
FROM world_layoffs.layoffs_staging2
WHERE company = 'Juul';

SELECT *
FROM world_layoffs.layoffs_staging2 TABLE1
JOIN world_layoffs.layoffs_staging2 TABLE2
ON TABLE1.company = TABLE2.company
WHERE (TABLE1.industry IS NULL OR TABLE1.industry ='')
AND TABLE2.industry IS NOT NULL;

UPDATE world_layoffs.layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT TABLE1.industry, TABLE2.industry
FROM world_layoffs.layoffs_staging2 TABLE1
JOIN world_layoffs.layoffs_staging2 TABLE2
ON TABLE1.company = TABLE2.company
WHERE TABLE1.industry IS NULL
AND TABLE2.industry IS NOT NULL;


UPDATE world_layoffs.layoffs_staging2 TABLE1
JOIN world_layoffs.layoffs_staging2 TABLE2
ON TABLE1.company = TABLE2.company
SET TABLE1.industry = TABLE2.industry
WHERE TABLE1.industry IS NULL 
AND TABLE2.industry IS NOT NULL;

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE company LIKE 'Bally%';


SELECT *
FROM world_layoffs.layoffs_staging2
WHERE company = 'Airbnb';

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE company = 'Carvana';


SELECT *
FROM world_layoffs.layoffs_staging2
WHERE company = 'Juul';

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM world_layoffs.layoffs_staging2;

ALTER TABLE world_layoffs.layoffs_staging2
DROP COLUMN row_num;

SELECT *
FROM world_layoffs.layoffs_staging2;

-- Recap
-- Data Cleaning
-- Step 1: Remove Duplicates
-- Step 2: Standardization of  Data
-- Step 3: Look at Null Values or Blank Values
-- Step 4: Remove any columns and rows if its not necessary

