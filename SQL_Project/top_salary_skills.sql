-----SKILLS NEEDED FOR TOP 10 HIGHEST PAYING DATA ANALYST JOB--------
SELECT
        DISTINCT(jpf.job_id),
        jpf.job_title_short,
        jpf.job_title,
        jpf.job_location,
        cd.name,
        jpf.salary_year_avg,
        STRING_AGG(sd.skills,',') AS skills_needed
FROM 
        job_postings_fact AS jpf
LEFT JOIN company_dim AS CD ON cd.company_id = jpf.company_id
INNER JOIN skills_job_dim AS sjd ON sjd.job_id = jpf.job_id
INNER JOIN skills_dim AS sd ON sd.skill_id = sjd.skill_id
WHERE 
        job_title_short LIKE '%Data%Analyst%' AND
        salary_year_avg IS NOT NULL AND
        job_work_from_home = 'TRUE'
GROUP BY 
        DISTINCT(jpf.job_id),
        jpf.job_title_short,
        jpf.job_title,
        jpf.job_location,
        cd.name,
        jpf.salary_year_avg
ORDER BY
        salary_year_avg DESC
LIMIT 10;

----------- SKILL NEEDED FOR DATA ANALYST JOB----------------
SELECT
        DISTINCT(jpf.job_id),
        jpf.job_title_short,
        jpf.job_title,
        jpf.job_location,
        cd.name,
        jpf.salary_year_avg,
        sd.skills AS skills_needed
FROM 
        job_postings_fact AS jpf
LEFT JOIN company_dim AS CD ON cd.company_id = jpf.company_id
INNER JOIN skills_job_dim AS sjd ON sjd.job_id = jpf.job_id
INNER JOIN skills_dim AS sd ON sd.skill_id = sjd.skill_id
WHERE 
        job_title_short LIKE '%Data%Analyst%' AND
        salary_year_avg IS NOT NULL AND
        job_work_from_home = 'TRUE'
ORDER BY
        salary_year_avg DESC;