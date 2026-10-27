SELECT
    job_title_short title,
    job_location location,
    job_posted_date :: DATE date_time
FROM
    job_postings_fact
LIMIT 5;

SELECT
    job_title_short title,
    job_location location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'WAT' date_time
FROM
    job_postings_fact
LIMIT 5;

SELECT
    job_title_short title,
    job_location location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'WAT' date_time,
    EXTRACT(MONTH FROM job_posted_date) AS date_month
FROM
    job_postings_fact
LIMIT 5;

CREATE TABLE january_jobs AS
    SELECT *
    FROM
        job_postings_fact
    WHERE 
        EXTRACT(MONTH FROM job_posted_date) = 1;

CREATE TABLE february_jobs AS
    SELECT *
    FROM
        job_postings_fact
    WHERE 
        EXTRACT(MONTH FROM job_posted_date) = 2;

CREATE TABLE march_jobs AS
    SELECT *
    FROM
        job_postings_fact
    WHERE 
        EXTRACT(MONTH FROM job_posted_date) = 3;