# Top 10 In-Demand Skills for Remote Data Analyst Jobs (2023)

## Project Overview

Which skills should an aspiring Data Analyst prioritise when looking for remote opportunities? This project uses SQL to explore Data Analyst job postings, compare skill demand with average advertised salaries, and identify skills that may be worth prioritising for career development.

The analysis examines five related questions: the highest-paying remote Data Analyst roles, the skills requested by those roles, the most frequently requested Data Analyst skills, the skills associated with the highest average salaries, and the overlap between demand and salary among remote roles.

## Business Questions

1. What are the 10 highest-paying remote Data Analyst job postings with reported annual average salaries?
2. Which skills are requested in those highest-paying roles?
3. Which skills appear most frequently in Data Analyst job postings?
4. Which skills are associated with the highest average salaries for Data Analyst roles?
5. Which skills combine relatively high demand with attractive average salaries in remote Data Analyst postings?

## Tools and SQL Techniques

- **SQL** for querying and analysing relational job-posting data.
- **Joins** to connect job postings, company information, and skill records.
- **Common Table Expressions (CTEs)** to organise multi-step analysis.
- **Aggregate functions** (COUNT, AVG, ROUND) to measure demand and average salary.
- **Filtering, grouping, sorting, and limiting** to focus the analysis on relevant roles and rankings.

## Analysis Files

The SQL scripts are available in the [project_sql](project_sql/) folder:

| File | Purpose |
|---|---|
| [1_top_paying_jobs.sql](project_sql/1_top_paying_jobs.sql) | Finds the 10 highest-paying remote Data Analyst postings with reported salaries. |
| [2_top_paying_job_skills.sql](project_sql/2_top_paying_job_skills.sql) | Identifies skills listed for the highest-paying roles returned by the first query. |
| [3_top_demanded_skills.sql](project_sql/3_top_demanded_skills.sql) | Counts the most frequently requested skills across Data Analyst postings. |
| [4_top_paying_skill.sql](project_sql/4_top_paying_skill.sql) | Ranks skills by average annual salary across Data Analyst postings with reported salaries. |
| [5_optimal_skills.sql](project_sql/5_optimal_skills.sql) | Compares skill demand and average salary among remote Data Analyst postings with reported salaries. |

## Key Findings: Skills to Prioritise

The output from the fifth query ranks skills primarily by the number of remote Data Analyst postings in which they appear, using average salary as a secondary sort. The attached result contains the following values:

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

### What the results suggest

- **SQL leads by demand** in this result, appearing in 398 postings. It is a strong candidate for an early learning priority based on frequency in the analysed sample.
- **Excel, Python, and Tableau** also appear frequently, suggesting that spreadsheet analysis, programming, and data visualisation are relevant skill areas in this dataset.
- **Looker has the highest displayed average salary** among the listed rows ($103,795.30), but it appears in only 49 postings. A high average salary does not, by itself, mean a skill offers the most opportunities.
- **Python and R show relatively high average salaries** in this result, while Excel and PowerPoint have lower displayed averages. These are associations in the dataset, not proof that learning a particular skill causes a higher salary.
- **Demand and salary should be considered together.** A practical learning decision should account for how often a skill is requested, the salaries associated with postings mentioning it, and the learner's target roles.

*Data-quality note:* SAS appears twice because the SQL result groups by skill_id as well as skill name, and the source data contains two skill IDs labelled SAS. The table preserves the query output rather than treating these as two different skills. The query should be adjusted to consolidate identical skill labels before interpreting this as a definitive top-10 list.

## Methodology and Scope

The queries use job-posting, company, and skill tables. The analysis filters for Data Analyst roles and uses reported annual average salary where required. Remote work is identified using the dataset's remote-work flag in the optimal-skills query; the highest-paying-jobs queries use the location value Anywhere.

The scope differs between queries: the demand query considers Data Analyst postings generally, and the salary-by-skill query includes postings with reported salaries regardless of location. Therefore, those results should not be described as remote-only findings. The fifth query is the one specifically designed to compare demand and average salary for remote Data Analyst roles.

The demand count represents how many job-to-skill records are counted for a skill in the query, not the number of unique employers or a guarantee of current vacancies. Salary averages are calculated only from postings with reported annual average salaries and may be influenced by sample size, job seniority, employer, and location.

## Conclusion

For someone deciding what to learn for remote Data Analyst opportunities, the results support considering **SQL first**, followed by a combination of **Excel, Python, and a visualisation tool such as Tableau or Power BI**. The salary figures can help inform further investigation, but should not be used in isolation to choose a skill.

These findings describe the analysed 2023 job-posting sample; they are not a guarantee of today's hiring demand or future earnings. Before using the ranking as a strict top-10 recommendation, the duplicate SAS label should be consolidated and the source dataset and salary coverage should be documented.

## Repository

Browse the [SQL analysis scripts](project_sql/) to review the queries used for each question.
