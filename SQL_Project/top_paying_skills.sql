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
        salary_year_avg IS NOT NULL
GROUP BY sd.skills
ORDER BY avg_salary DESC;