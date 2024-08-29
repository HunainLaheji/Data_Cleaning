SELECT *
FROM layoffs_staging2;


SELECT MAX( total_laid_off ), MAX( percentage_laid_off )
FROM layoffs_staging2;


SELECT *
FROM layoffs_staging2
WHERE total_laid_off = 12000;


SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;


SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;


SELECT company, MAX( total_laid_off ), MAX( percentage_laid_off )
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


SELECT company, SUM( total_laid_off ), SUM( percentage_laid_off )
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


SELECT industry, MAX( total_laid_off ), MAX( percentage_laid_off )
FROM layoffs_staging2
GROUP BY industry
ORDER BY 1;


SELECT industry, SUM( total_laid_off ), SUM( percentage_laid_off )
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;


SELECT country, MAX( total_laid_off ), MAX( percentage_laid_off )
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;


SELECT country, SUM( total_laid_off ), SUM( percentage_laid_off )
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;


SELECT country, `date`, SUM( total_laid_off ), SUM( percentage_laid_off )
FROM layoffs_staging2
GROUP BY country, `date`
ORDER BY 2 DESC;


SELECT company, industry, country, YEAR(`date`), SUM( total_laid_off ), SUM( percentage_laid_off )
FROM layoffs_staging2
GROUP BY company, industry, country, YEAR(`date`)
ORDER BY 3 DESC;


SELECT YEAR(`date`), SUM( total_laid_off ), SUM( percentage_laid_off )
FROM layoffs_staging2
GROUP BY company, industry, country,YEAR(`date`)
ORDER BY 2 DESC;


SELECT stage, SUM( total_laid_off ), SUM( percentage_laid_off )
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;



SELECT SUBSTRING(`date`,1,7) AS Year_and_Month , 
SUM( total_laid_off ), SUM( percentage_laid_off )
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY YEAR_and_Month
ORDER BY 1;


WITH Rolling_total AS
(
SELECT SUBSTRING(`date`,1,7) AS YEAR_AND_MONTH , 
SUM( total_laid_off ) AS total_off, SUM( percentage_laid_off ) AS total_percent_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY YEAR_AND_MONTH 
ORDER BY 1
)
SELECT YEAR_AND_MONTH, total_off ,
SUM( total_off ) OVER(ORDER BY YEAR_AND_MONTH  ) AS Rolling_total,
total_percent_off, SUM( total_percent_off ) OVER(ORDER BY YEAR_AND_MONTH  ) AS Rolling_percent_total
FROM Rolling_total;


WITH Company_Year AS
(
SELECT company, YEAR(`date`) AS Years, SUM( total_laid_off ) AS Total_laid_off
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
),
Company_Year_Rank AS
(
SELECT *, DENSE_RANK() OVER( PARTITION BY Years ORDER BY  Total_laid_off ) AS Ranking
FROM Company_Year
WHERE Years AND Total_laid_off IS NOT NULL
)
SELECT *
FROM COmpany_Year_Rank
WHERE Ranking <= 5;