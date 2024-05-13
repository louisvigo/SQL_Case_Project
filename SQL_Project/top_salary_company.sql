----JOINS TABLES -------
WITH job_table AS
(SELECT
        *
FROM
        job_postings_fact AS jpf
JOIN skills_job_dim AS sjd on sjd.job_id = jpf.job_id
JOIN skills_dim AS sd ON sd.skill_id = sjd.skill_id
JOIN company_dim AS cd ON cd.company_id = jpf.company_id
)

------TOP PAYING JOB ON COMPANY AND SKILL NEEDED---------
SELECT
        name AS company_name,
        job_title,
        STRING_AGG(skills,',') AS skill_req,
        ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM 
        job_table
WHERE 
        salary_year_avg IS NOT NULL AND
        job_title_short LIKE '%Data%Analyst%'
GROUP BY 
        name,
        job_title
ORDER BY avg_salary DESC;