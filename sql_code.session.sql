SELECT 
        sd.skills,
        COUNT(jpf.job_id) AS job_count
FROM
        job_postings_fact AS jpf
JOIN skills_job_dim AS sjd ON sjd.job_id = jpf.job_id
JOIN skills_dim AS sd ON sd.skill_id = sjd.skill_id
WHERE job_title_short LIKE '%Data%Analyst%'
GROUP BY sd.skills
ORDER BY job_count DESC
LIMIT 10;

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
    ORDER BY job_count DESC
    GROUP BY sd.skills