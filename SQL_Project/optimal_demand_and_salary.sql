---------------------ABOVE AVERAGE SALARY AND DEMAND--------------------------------
WITH top_demand_salary AS (
    SELECT
        sd.skills,
        COUNT(sjd.job_id) AS job_count,
        ROUND(AVG(jpf.salary_year_avg)) AS avg_salary
    FROM
        skills_dim AS sd
    JOIN skills_job_dim AS sjd ON sjd.skill_id = sd.skill_id
    JOIN job_postings_fact AS jpf ON jpf.job_id = sjd.job_id
    WHERE 
        job_title_short LIKE '%Data%Analyst%' AND
        jpf.salary_year_avg IS NOT NULL
    GROUP BY sd.skills
    ORDER BY job_count DESC
    
) 
-- SELECT AVG(job_count), AVG(avg_salary) FROM top_demand_salary

SELECT * FROM top_demand_salary
WHERE 
    job_count > (SELECT AVG(job_count) FROM top_demand_salary) AND
    avg_salary > (SELECT AVG(avg_salary) FROM top_demand_salary)
ORDER BY top_demand_salary.job_count DESC;

-------------------TOP DEMANDED SKILL AND SALARY--------------------------
SELECT
        sd.skills,
        COUNT(sjd.job_id) AS job_count,
        ROUND(AVG(jpf.salary_year_avg)) AS avg_salary
FROM
        skills_dim AS sd
JOIN skills_job_dim AS sjd ON sjd.skill_id = sd.skill_id
JOIN job_postings_fact AS jpf ON jpf.job_id = sjd.job_id
WHERE 
        job_title_short LIKE '%Data%Analyst%' AND
        jpf.salary_year_avg IS NOT NULL
GROUP BY sd.skills
ORDER BY job_count DESC