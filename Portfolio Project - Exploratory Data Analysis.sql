-- Exploratory Data Analysis 
-- Here we are just going to explore the data and find trends or patterns or anything interesting like outliers. 
-- with this info we are just going to look around and see what we find!


SELECT *
FROM layoffs_staging2;


SELECT *
FROM layoffs_staging2
ORDER BY country;


SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;


SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;


SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;


SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company 
Order BY 2 DESC;


SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;


SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry 
Order BY 2 DESC;


SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country 
Order BY 2 DESC;


SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
Order BY 1 DESC;


SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
Order BY 2 DESC;


SELECT SUBSTRING(`date`, 1, 7) AS `month`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT  NULL
group by `month` 
order by 1 ASC ;


WITH Rolling_Total AS 
(
SELECT SUBSTRING(`date`, 1, 7) AS `month`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT  NULL
group by `month` 
order by 1 ASC 
)
SELECT `month`, total_off
, SUM(total_off) OVER(ORDER BY `month`)
FROM Rolling_Total;


SELECT company, YEAR(`date`) ,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company , YEAR(`date`)
Order BY 3 DESC;


WITH Company_Year (company, years, total_laid_off) AS 
(
SELECT company, YEAR(`date`) ,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company , YEAR(`date`)
), Company_Year_Rank AS 
(
SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;
