------TOP PAYING DATA ANALYST JOB-------------
SELECT
        job_id,
        job_title_short,
        job_location,
        salary_year_avg
FROM 
        job_postings_fact
WHERE 
        job_title_short LIKE '%Data%Analyst%' AND
        salary_year_avg IS NOT NULL
ORDER BY
        salary_year_avg DESC;

------TOP 10 HIGHEST DATA ANALYST SALARY THAT AVAILABLE REMOTELY----------
SELECT
        jpf.job_id,
        jpf.job_title_short,
        jpf.job_title,
        jpf.job_location,
        cd.name,
        jpf.salary_year_avg
FROM 
        job_postings_fact AS jpf
LEFT JOIN company_dim AS CD ON cd.company_id = jpf.company_id
WHERE 
        job_title_short LIKE '%Data%Analyst%' AND
        salary_year_avg IS NOT NULL AND
        job_work_from_home = 'TRUE'
ORDER BY
        salary_year_avg DESC
LIMIT 10;