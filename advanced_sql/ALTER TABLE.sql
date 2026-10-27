ALTER TABLE 
    job_applied
ADD 
    contact VARCHAR(50);

SELECT * 
FROM 
    job_applied;

UPDATE 
    job_applied
SET
    contact = 'Ahmad Jibril-Adeyemi'
WHERE 
    job_id = 1;

UPDATE 
    job_applied
SET
    contact = 'Faidah Lawal'
WHERE 
    job_id = 2;

UPDATE 
    job_applied
SET
    contact = 'Abdullah Abdulwaahid'
WHERE 
    job_id = 3;

UPDATE 
    job_applied
SET
    contact = 'Sumayyah Jibril-Adeyemi'
WHERE 
    job_id = 4;

UPDATE 
    job_applied
SET
    contact = 'Zaynab Jibril-Adeyemi'
WHERE 
    job_id = 5;

ALTER TABLE
    job_applied
RENAME COLUMN 
    contact TO
    contact_name;

ALTER TABLE
    job_applied
ALTER COLUMN 
    contact_name TYPE TEXT;

