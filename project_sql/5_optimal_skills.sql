/*
Question: What are the most optimal skills to learn (i.e it's in high demand and a high paying skill )
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries),
    offering strategic insights for career development in data analysis
*/

WITH skills_demand AS (
    SELECT
        skills_job_dim.skill_id,
        skills,
        COUNT(job_postings_fact.job_id) AS demand_count
    FROM
        job_postings_fact
    INNER JOIN
        skills_job_dim
        ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN
        skills_dim
        ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND job_work_from_home = TRUE
        AND salary_year_avg IS NOT NULL
    GROUP BY
        skills_job_dim.skill_id,
        skills
), average_salary AS (
    SELECT
        skills_job_dim.skill_id,
        skills,
        ROUND(AVG(salary_year_avg), 2) AS avg_salary
    FROM
        job_postings_fact
    INNER JOIN
        skills_job_dim
        ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN
        skills_dim
        ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_work_from_home = TRUE
        AND job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
    GROUP BY
        skills_job_dim.skill_id,
        skills
)

SELECT
    skills_demand.*,
    avg_salary
FROM
    skills_demand
INNER JOIN
    average_salary
    ON average_salary.skill_id = skills_demand.skill_id
ORDER BY
    demand_count DESC,
    avg_salary DESC
