# Top 10 In-Demand Skills for Remote Data Analyst Jobs (2023)

## Project Overview

Which skills should an aspiring Data Analyst prioritise when pursuing remote opportunities? This project uses SQL to explore 2023 Data Analyst job postings, compare skill demand with advertised annual average salaries, and identify skills that may be worth prioritising for career development.

The analysis covers the highest-paying remote Data Analyst postings, the skills associated with those roles, the most frequently requested skills, salary averages by skill, and skills that combine demand with salary potential.

## Business Questions

1. What are the 10 highest-paying remote Data Analyst job postings with reported annual average salaries?
2. Which skills are listed for these highest-paying roles?
3. Which skills appear most frequently in Data Analyst job postings?
4. Which skills are associated with the highest average salaries for Data Analyst roles?
5. Which skills combine relatively high demand with attractive average salaries in remote Data Analyst postings?

## Tools and SQL Techniques

- **Visual Studio Code (VS Code)** as the code editor used to write and organise the SQL scripts.
- **PostgreSQL** as the relational database management system used to store and query the job-posting data, connected to VS Code.
- **SQL** to query and analyse the data in PostgreSQL.
- **Joins** to connect job postings, company information, and skill records.
- **Common Table Expressions (CTEs)** to organise multi-step analysis.
- **Aggregate functions** such as COUNT, AVG, and ROUND.
- **Filtering, grouping, sorting, and limiting** to focus analysis and rank results.

## Analysis Files

The SQL scripts are available in the [project_sql](project_sql/) folder.

| File | Purpose |
|---|---|
| [1_top_paying_jobs.sql](project_sql/1_top_paying_jobs.sql) | Finds the 10 highest-paying remote Data Analyst postings with reported salaries. |
| [2_top_paying_job_skills.sql](project_sql/2_top_paying_job_skills.sql) | Identifies skills listed for the highest-paying roles returned by the first query. |
| [3_top_demanded_skills.sql](project_sql/3_top_demanded_skills.sql) | Counts the most frequently requested skills across Data Analyst postings. |
| [4_top_paying_skill.sql](project_sql/4_top_paying_skill.sql) | Ranks skills by average annual salary across Data Analyst postings with reported salaries. |
| [5_optimal_skills.sql](project_sql/5_optimal_skills.sql) | Compares skill demand and average salary among remote Data Analyst postings with reported salaries. |

## SQL Queries for Each Business Question

The following SQL queries show how each business question was answered. They were written in **VS Code** and executed against the data stored in **PostgreSQL**. Each query is also available as a separate file in the [`project_sql`](project_sql/) folder.

### Business Question 1: What are the 10 highest-paying remote Data Analyst job postings with reported annual average salaries?

This query joins job postings to company information, filters for remote postings labelled `Anywhere`, excludes postings without a reported annual average salary, and returns the 10 highest salaries.

```sql
SELECT 
    job_id,
    name AS company_name, 
    job_title_short,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact
LEFT JOIN
    company_dim
    ON company_dim.company_id = job_postings_fact.company_id
WHERE
    job_location = 'Anywhere' AND
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```

[View the full SQL script](project_sql/1_top_paying_jobs.sql).

### Business Question 2: Which skills are listed for these highest-paying roles?

A Common Table Expression (CTE) first identifies the 10 highest-paying remote Data Analyst postings. The query then joins those postings to the job-skill mapping and skills tables to retrieve their associated skills.

```sql
WITH top_paying_jobs AS (
    SELECT 
        job_id, 
        job_title_short,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN
        company_dim
        ON company_dim.company_id = job_postings_fact.company_id
    WHERE
        job_location = 'Anywhere' AND
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)
SELECT 
   top_paying_jobs.*,
   skills
FROM
    top_paying_jobs
INNER JOIN
    skills_job_dim
    ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id;
```

[View the full SQL script](project_sql/2_top_paying_job_skills.sql).

### Business Question 3: Which skills appear most frequently in Data Analyst job postings?

This query joins job postings to their associated skills, counts job-skill records for each skill, sorts the results by demand, and returns the top five. It covers Data Analyst postings generally, not remote roles only.

```sql
SELECT
    skills,
    COUNT(job_postings_fact.job_id) AS demand_count
FROM 
    job_postings_fact
INNER JOIN
    skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst'
GROUP BY 
    skills
ORDER BY
    demand_count DESC
LIMIT 5;
```

[View the full SQL script](project_sql/3_top_demanded_skills.sql).

### Business Question 4: Which skills are associated with the highest average salaries for Data Analyst roles?

This query calculates the average reported annual salary for Data Analyst postings associated with each skill. It excludes postings without salary data and returns the top 25 skills by average salary, regardless of location.

```sql
SELECT 
    skills,
    ROUND(AVG(job_postings_fact.salary_year_avg), 2) AS average_salary
FROM
    job_postings_fact
INNER JOIN
    skills_job_dim
    ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN
    skills_dim
    ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    average_salary DESC
LIMIT 25;
```

[View the full SQL script](project_sql/4_top_paying_skill.sql).

### Business Question 5: Which skills combine relatively high demand with attractive average salaries in remote Data Analyst postings?

Two CTEs calculate skill demand and average salary for remote Data Analyst postings with reported salaries. The results are joined by skill ID and ranked by demand first, then average salary.

```sql
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
        ON skills_dim.skill_id = skills_job_dim.skill_id
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
LIMIT 10;
```

[View the full SQL script](project_sql/5_optimal_skills.sql).

## Findings

### 1. Highest-Paying Remote Data Analyst Postings

The query returned the following 10 job postings with the highest reported annual average salaries. All are labelled as remote/“Anywhere” and full-time in the query output.

| Company | Average annual salary (USD) | Posting date |
|---|---:|---|
| Mantys | $650,000.00 | 2023-02-20 |
| Meta | $336,500.00 | 2023-08-23 |
| AT&T | $255,829.50 | 2023-06-18 |
| Pinterest Job Advertisements | $232,423.00 | 2023-12-05 |
| Uclahealthcareers | $217,000.00 | 2023-01-17 |
| SmartAsset | $205,000.00 | 2023-08-09 |
| Inclusively | $189,309.00 | 2023-12-07 |
| Motional | $189,000.00 | 2023-01-05 |
| SmartAsset | $186,000.00 | 2023-07-11 |
| Get It Recruit - Information Technology | $184,000.00 | 2023-06-09 |

**Key observation:** Mantys had the highest reported annual average salary in this result at $650,000, substantially above the other listed postings. Because this is an extreme value, it should be treated as an individual advertised figure to investigate, not as a typical Data Analyst salary.

### 2. Skills Listed in the Highest-Paying Roles

Across the skill records returned for these roles, the most frequently listed skills were:

| Skill | Number of returned job-skill records |
|---|---:|
| SQL | 8 |
| Python | 7 |
| Tableau | 6 |
| R | 4 |
| Excel | 3 |
| Pandas | 3 |
| Snowflake | 3 |
| Azure | 2 |
| Power BI | 2 |
| Go | 2 |

SQL appeared most often in the returned skill records, followed by Python and Tableau. This suggests that querying, programming, and data visualisation were common among the highest-paying roles represented in this sample.

**Coverage note:** The top-paying-jobs query returned 10 postings, while the skills query returned skill records for 8 distinct job IDs. Two of the 10 postings did not appear in the skill results, likely because no matching skill records were available through the joins. The counts above describe the returned records, not all 10 postings.

### 3. Most In-Demand Skills

The third query ranks skills by their frequency across Data Analyst job postings. Its results should be used to identify commonly requested skills across the dataset, rather than only within remote roles, because this query does not apply a remote-work filter.

### 4. Skills Associated With Higher Average Salaries

The fourth query calculates average annual salary by skill for Data Analyst postings with reported salaries, regardless of location. These values indicate an association between a skill and the salaries of postings that mention it; they do not prove that the skill itself causes higher pay.

### 5. Skills Combining Demand and Salary

The fifth query compares demand and average salary specifically for remote Data Analyst postings with reported salaries. Its output ranks skills primarily by demand count and uses average salary as a secondary sort.

| Skill | Postings listing the skill | Average annual salary (USD) |
|---|---:|---:|
| SQL | 398 | $97,237.16 |
| Excel | 256 | $87,288.21 |
| Python | 236 | $101,397.22 |
| Tableau | 230 | $99,287.65 |
| R | 148 | $100,498.77 |
| Power BI | 110 | $97,431.30 |
| SAS | 63 | $98,902.37 |
| SAS* | 63 | $98,902.37 |
| PowerPoint | 58 | $88,701.09 |
| Looker | 49 | $103,795.30 |

**Interpretation:**

- **SQL leads by demand**, appearing in 398 postings in this result. It is a strong candidate for an early learning priority based on frequency in the analysed sample.
- **Excel, Python, and Tableau** also appear frequently, suggesting that spreadsheet analysis, programming, and visualisation are relevant skill areas.
- **Looker has the highest displayed average salary** in this list ($103,795.30), but appears in 49 postings. A higher average salary does not necessarily mean a skill offers the most opportunities.
- **Python and R** also have relatively high displayed average salaries. These are associations in the data, not evidence that learning a particular skill directly causes higher pay.
- A practical learning decision should consider both demand and salary, as well as target roles and existing skills.

**Data-quality note:** SAS appears twice because the SQL groups by skill ID as well as skill name and the source data contains two skill IDs labelled SAS. Consolidate identical skill labels before treating the result as a definitive top-10 list.

## Methodology and Scope

The queries use job-posting, company, and skill tables. They filter for Data Analyst roles and use reported annual average salary where required. The top-paying-jobs query uses the location value `Anywhere`; the optimal-skills query uses the dataset's remote-work flag.

The scope differs across queries. The general demand query includes Data Analyst postings without a remote-only filter, and the salary-by-skill query includes postings with reported salaries regardless of location. Therefore, those two analyses should not be described as remote-only findings. The fifth query is specifically designed to compare demand and average salary among remote Data Analyst postings with reported salaries.

Demand counts represent job-to-skill records counted by the query, not unique employers or a guarantee of current vacancies. Salary averages are based only on postings with reported annual average salaries and may be affected by sample size, job seniority, employer, location, and unusually high or low values.

## Conclusion and Practical Takeaways

The results suggest that **SQL is a strong starting point** because it appears frequently both in the remote skills analysis and among the skill records associated with the highest-paying roles. **Python, Excel, and a visualisation tool such as Tableau or Power BI** are also worth considering as part of a broader Data Analyst toolkit.

The salary results add context, but should not be used in isolation to choose a skill. The very high Mantys salary is an example of why individual postings and average salary figures need careful interpretation. The missing skill matches for two top-paying postings and the duplicate SAS label are also worth addressing before making firm claims from the rankings.

These findings describe the analysed 2023 job-posting sample. They are not a guarantee of current hiring demand or future earnings.

## Repository

Browse the [SQL analysis scripts](project_sql/) to review the queries used for each question.
