Create table healthcare(
    name varchar(100),
	age integer,
	gender varchar(20),
	blood_type VARCHAR(10),
    medical_condition VARCHAR(100),
    date_of_admission DATE,
    doctor VARCHAR(150),
    hospital VARCHAR(200),
    insurance_provider VARCHAR(100),
    billing_amount NUMERIC(12,2),
    room_number INTEGER,
    admission_type VARCHAR(50),
    discharge_date DATE,
    medication VARCHAR(100),
    test_results VARCHAR(50)
);

select *
from healthcare; 

update healthcare 
set name = initcap(name);

SELECT name
FROM healthcare
LIMIT 20;

----general----
select count(*) as no_of_admissions
from healthcare;

select admission_type, count(*) as no_of_admissions
from healthcare
group by admission_type
order by no_of_admissions desc;

select medical_condition, count(*) as no_of_admissions
from healthcare
group by medical_condition
order by no_of_admissions desc;

select extract(year from date_of_admission) as year_of_admission,
       count(*) as no_of_admissions
from healthcare
group by year_of_admission
order by year_of_admission desc;

select (
  case 
    when age < 18 then '<18'
	when age between 18 and 29 then '18-29'
	when age between 30 and 44 then '30-44'
	when age between 45 and 59 then '45-59'
	else '60+'
  end ) as age_group,
   count(*) as no_of_admissions
from healthcare 
group by age_group 
order by no_of_admissions desc; 

----- length of stay----

create view length_of_stay_analysis as
select *,discharge_date - date_of_admission as length_of_stay
from healthcare; 

select round(avg(length_of_stay),2) as avg_los
from length_of_stay_analysis; 

select medical_condition, 
       round(avg(length_of_stay),2) as avg_los
from length_of_stay_analysis
group by medical_condition
order by avg_los desc; 

select admission_type, 
       round(avg(length_of_stay),2) as avg_los
from length_of_stay_analysis
group by admission_type
order by avg_los desc; 

select 
 case 
    when age < 18 then '<18'
	when age between 18 and 29 then '18-29'
	when age between 30 and 44 then '30-44'
	when age between 45 and 59 then '45-59'
	else '60+'
  end  as age_group,
  round(avg(length_of_stay),2) as avg_los
from length_of_stay_analysis
group by age_group
order by avg_los;

select hospital, 
round(avg(length_of_stay),2) as avg_los
from length_of_stay_analysis
group by hospital
order by avg_los desc; 

-----billing----
select round(avg(billing_amount),2) as avg_billing_amount 
from healthcare; 

select round(sum(billing_amount),2) as sum_billing_amount 
from healthcare;

select medical_condition, round(avg(billing_amount),2) as avg_billing
from healthcare
group by medical_condition
order by avg_billing desc;

select admission_type, round(avg(billing_amount),2) as avg_billing 
from healthcare
group by admission_type
order by avg_billing desc;

select insurance_provider, round(avg(billing_amount),2) as avg_billing
from healthcare
group by insurance_provider
order by avg_billing desc;

select hospital,
round(avg(billing_amount),2) as avg_billing
from healthcare 
group by hospital
order by avg_billing desc;

SELECT gender, ROUND(AVG(billing_amount), 2) AS avg_billing
FROM healthcare
GROUP BY gender
ORDER BY avg_billing DESC;

SELECT
    CASE
        WHEN age < 18 THEN '<18'
        WHEN age BETWEEN 18 AND 29 THEN '18-29'
        WHEN age BETWEEN 30 AND 44 THEN '30-44'
        WHEN age BETWEEN 45 AND 59 THEN '45-59'
        ELSE '60+'
    END AS age_group,
    ROUND(AVG(billing_amount), 2) AS avg_billing
FROM healthcare
GROUP BY age_group
ORDER BY avg_billing DESC;

select doctor, round(avg(billing_amount),2) as avg_billing
from healthcare 
group by doctor
order by avg_billing desc;

----patients-----
select test_results, count(*) as no_of_admissions
from healthcare
group by test_results
order by test_results desc; 

select test_results, medical_condition, count(*) as no_of_admissions, 
round( count(*) * 100.0 / sum(count(*)) over(partition by medical_condition),2) as percentage_condition
from healthcare
group by medical_condition, test_results
order by no_of_results desc; 

select test_results, admission_type, count(*) as no_of_admissions,
round( count(*) * 100.0 / sum(count(*)) over(partition by admission_type),2) as percentage_admission
from healthcare
group by test_results,admission_type
order by no_of_results desc; 

select test_results, 
 CASE
        WHEN age < 18 THEN '<18'
        WHEN age BETWEEN 18 AND 29 THEN '18-29'
        WHEN age BETWEEN 30 AND 44 THEN '30-44'
        WHEN age BETWEEN 45 AND 59 THEN '45-59'
        ELSE '60+'
    END AS age_group,
    count(*) as no_of_results
from healthcare
group by test_results,age_group
order by no_of_results desc;

select test_results, medication, count(*) as no_of_admissions
from healthcare
group by test_results,medication
order by no_of_results desc; 

-----hospital performance----
select hospital,count(*) as no_of_admissions 
from healthcare 
group by hospital
having count(*) >= 30
order by no_of_admissions desc;

select hospital, round(avg(discharge_date - date_of_admission),2) as avg_stay_length
from healthcare
group by hospital
having count(*) >= 30
order by avg_stay_length desc;

select hospital, 
round(avg(billing_amount),2) as avg_billing, 
rank() over(order by avg(billing_amount) desc)  
as ranking
from healthcare
group by hospital
having count(*) >= 30
order by avg_billing desc;

select hospital, round(sum(billing_amount),2) as total_billing 
from healthcare
group by hospital 
having count(*) >= 30
order by total_billing desc; 

select hospital,
round( count(CASE WHEN test_results = 'Abnormal' THEN 1 END) * 100.0 / count(*),2) as percent_abnormal
from healthcare 
group by hospital 
having count(*) >= 30
order by percent_abnormal desc; 

select hospital, 
round( count(case when admission_type = 'Emergency' then 1 end) * 100.0 / count(*),2) as percent_emergency
from healthcare 
group by hospital 
having count(*) >= 30
order by percent_emergency desc; 

CREATE TABLE hospital_performance AS
SELECT 
    hospital,COUNT(*) AS no_of_admissions,

    ROUND(AVG(discharge_date - date_of_admission),2) AS avg_stay_length,

    ROUND(AVG(billing_amount),2) AS avg_billing,

    RANK() OVER (ORDER BY AVG(billing_amount) DESC) AS billing_ranking,

    ROUND( SUM(billing_amount),2) AS total_billing,

    ROUND(COUNT(CASE 
                WHEN test_results = 'Abnormal' THEN 1 
            END ) * 100.0 / COUNT(*),2) AS percent_abnormal,

    ROUND(COUNT(CASE 
                WHEN admission_type = 'Emergency' THEN 1 
            END) * 100.0 / COUNT(*),2) AS percent_emergency

FROM healthcare
GROUP BY hospital
HAVING COUNT(*) >= 30;


select *
from hospital_performance;


