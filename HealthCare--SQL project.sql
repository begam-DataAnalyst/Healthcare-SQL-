--  \create database
create database healthcare;
use healthcare;
show tables;
-- \create table
CREATE TABLE patients (
    patient_id INT,
    patient_name VARCHAR(100),
    gender VARCHAR(10),
    age INT,
    city VARCHAR(50),
    registration_date DATE
);

-- \Total number of patients
SELECT COUNT(*) AS total_patients 
FROM patients;
-- \Gender-wise patient count
SELECT gender, COUNT(*) AS patient_count 
FROM patients 
GROUP BY gender;
-- \City-wise patient distribution
SELECT city, COUNT(*) AS patient_count 
FROM patients 
GROUP BY city 
ORDER BY patient_count DESC;
-- \Patients registered month-wise
SELECT DATE_FORMAT(registration_date, '%Y-%m') AS month, 
       COUNT(*) AS patient_count 
FROM patients 
GROUP BY DATE_FORMAT(registration_date, '%Y-%m') 
ORDER BY month;
-- \Patients registered after a specific date
SELECT * 
FROM patients 
WHERE registration_date > '2024-01-01';
-- \Age-wise patient grouping (20–30, 31–40, etc.)
SELECT 
  CASE 
    WHEN age BETWEEN 20 AND 30 THEN '20-30'
    WHEN age BETWEEN 31 AND 40 THEN '31-40'
    WHEN age BETWEEN 41 AND 50 THEN '41-50'
    WHEN age BETWEEN 51 AND 60 THEN '51-60'
    WHEN age > 60 THEN '60+'
    ELSE 'Below 20'
  END AS age_group,
  COUNT(*) AS patient_count
FROM patients 
GROUP BY age_group 
ORDER BY age_group;
-- \Average age of patients
SELECT ROUND(AVG(age), 2) AS average_age 
FROM patients;
-- \Senior citizens count (age > 60)
SELECT COUNT(*) AS senior_citizen_count 
FROM patients 
WHERE age > 60;
-- \ Patients from Chennai who registered after 2023
SELECT * 
FROM patients 
WHERE city = 'Chennai' 
  AND registration_date > '2023-12-31';
  
  -- \Top 5 cities with highest patients\
  SELECT city, COUNT(*) AS patient_count 
FROM patients 
GROUP BY city 
ORDER BY patient_count DESC 
LIMIT 5;

-- \•	Total number of doctors.
SELECT COUNT(*) AS total_doctors 
FROM doctors;
-- \•	Specialization-wise doctor count.
SELECT specialization, COUNT(*) AS doctor_count 
FROM doctors 
GROUP BY specialization 
ORDER BY doctor_count DESC;
-- \ Average experience by specialization
SELECT specialization, ROUND(AVG(experience_years), 2) AS avg_experience_years
FROM doctors 
GROUP BY specialization 
ORDER BY avg_experience_years DESC;
-- \•	Doctors with experience greater than 10 years.
SELECT * 
FROM doctors 
WHERE experience_years > 10 
ORDER BY experience_years DESC;
-- \List doctors with their specialization
SELECT doctor_name, specialization 
FROM doctors 
ORDER BY doctor_name;
-- \Most experienced doctor
SELECT * 
FROM doctors 
ORDER BY experience_years DESC 
LIMIT 1;
-- \  Least experienced doctor
SELECT * 
FROM doctors 
ORDER BY experience_years ASC 
LIMIT 1;
-- \. Doctors without any appointments
SELECT d.* 
FROM doctors d
LEFT JOIN appointments a ON d.doctor_id = a.doctor_id
WHERE a.doctor_id IS NULL;
-- \ Doctor count per experience range
SELECT 
  CASE 
    WHEN experience_years BETWEEN 0 AND 5 THEN '0-5 years'
    WHEN experience_years BETWEEN 6 AND 10 THEN '6-10 years'
    WHEN experience_years BETWEEN 11 AND 15 THEN '11-15 years'
    WHEN experience_years BETWEEN 16 AND 20 THEN '16-20 years'
    WHEN experience_years > 20 THEN '20+ years'
    ELSE 'Not specified'
  END AS experience_range,
  COUNT(*) AS doctor_count
FROM doctors 
GROUP BY experience_range 
ORDER BY MIN(experience_years);
-- \Top 3 most experienced doctors
SELECT * 
FROM doctors 
ORDER BY experience_years DESC 
LIMIT 3;
CREATE TABLE appointments (
    appointment_id INT,
    doctor_id INT,
    patient_id INT,
    appointment_date DATE,
    disease VARCHAR(100)
);

-- \Total number of appointments
SELECT COUNT(*) AS total_appointments 
FROM appointments;

-- \ Doctor-wise appointment count
SELECT doctor_id, COUNT(*) AS appointment_count 
FROM appointments 
GROUP BY doctor_id 
ORDER BY appointment_count DESC;

-- \Patient-wise visit count
SELECT patient_id, COUNT(*) AS visit_count 
FROM appointments 
GROUP BY patient_id 
ORDER BY visit_count DESC;

-- \Month-wise appointment trend
SELECT DATE_FORMAT(visit_date, '%Y-%m') AS month, 
       COUNT(*) AS appointment_count 
FROM appointments 
GROUP BY DATE_FORMAT(visit_date, '%Y-%m') 
ORDER BY month;

-- \Disease-wise appointment count
SELECT disease, COUNT(*) AS appointment_count 
FROM appointments 
GROUP BY disease 
ORDER BY appointment_count DESC;

-- \ Most frequently treated disease
SELECT disease, COUNT(*) AS appointment_count 
FROM appointments 
GROUP BY disease 
ORDER BY appointment_count DESC 
LIMIT 1;

-- \ Doctors who treated more than 50 patients
SELECT doctor_id, COUNT(DISTINCT patient_id) AS unique_patients 
FROM appointments 
GROUP BY doctor_id 
HAVING COUNT(DISTINCT patient_id) > 50 
ORDER BY unique_patients DESC;
select * from appointments;

-- \Patients who visited in the last 6 months
SELECT DISTINCT patient_id 
FROM appointments 
WHERE visit_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

-- \First and last visit date per patient
SELECT patient_id, 
       MIN(visit_date) AS first_visit, 
       MAX(visit_date) AS last_visit 
FROM appointments 
GROUP BY patient_id 
ORDER BY patient_id;

-- \Patients with more than 3 visits
SELECT patient_id, COUNT(*) AS visit_date_count 
FROM appointments 
GROUP BY patient_id 
HAVING COUNT(*) > 3 
ORDER BY visit_date_count DESC;

-- \Total hospital revenue
SELECT SUM(bill_amount) AS total_revenue 
FROM billing;

-- \Average bill amount
SELECT ROUND(AVG(bill_amount), 2) AS avg_bill_amount 
FROM billing;

-- \Payment mode-wise revenue
SELECT payment_mode, SUM(bill_amount) AS total_revenue 
FROM billing 
GROUP BY payment_mode 
ORDER BY total_revenue DESC;

-- \Payment mode-wise transaction count
SELECT payment_mode, COUNT(*) AS transaction_count 
FROM billing 
GROUP BY payment_mode 
ORDER BY transaction_count DESC;

-- \Highest and lowest bill amount
SELECT 
    MAX(bill_amount) AS highest_bill, 
    MIN(bill_amount) AS lowest_bill 
FROM billing;

-- \ Day-wise revenue
SELECT payment_date, SUM(bill_amount) AS daily_revenue 
FROM billing 
GROUP BY payment_date 
ORDER BY payment_date;

-- \Month-wise revenue trend
SELECT DATE_FORMAT(payment_date, '%Y-%m') AS month, 
       SUM(bill_amount) AS monthly_revenue 
FROM billing 
GROUP BY DATE_FORMAT(payment_date, '%Y-%m') 
ORDER BY month;

-- \Appointments with bill amount > average bill
SELECT * 
FROM billing 
WHERE bill_amount > (SELECT AVG(bill_amount) FROM billing) 
ORDER BY bill_amount DESC;

-- \ Patients with total bill > 50,000
SELECT bill_id, SUM(bill_amount) AS total_bill
FROM billing 
GROUP BY bill_id 
HAVING SUM(bill_amount) > 50000 
ORDER BY total_bill DESC;

-- \ Top 10 highest bills
SELECT * 
FROM billing 
ORDER BY bill_amount DESC 
LIMIT 10;

create table billing(bill_id int,appointment_id int,bill_amount int,payment_date Date,payment_mode varchar(30));

-- \ City-wise revenue
SELECT p.city, SUM(b.bill_amount) AS revenue
FROM billing b
JOIN appointments a ON b.appointment_id = a.appointment_id
JOIN patients p ON a.patient_id = p.patient_id
GROUP BY p.city;

-- \Doctor-wise revenue
SELECT d.doctor_name, SUM(b.bill_amount) AS revenue
FROM billing b
JOIN appointments a ON b.appointment_id = a.appointment_id
JOIN doctors d ON a.doctor_id = d.doctor_id
GROUP BY d.doctor_name;

-- \•	Specialization-wise revenue.
SELECT d.specialization, SUM(b.bill_amount) AS revenue
FROM billing b
JOIN appointments a ON b.appointment_id = a.appointment_id
JOIN doctors d ON a.doctor_id = d.doctor_id
GROUP BY d.specialization;

-- \ •	Patient-wise total spending.
SELECT  p.patient_name, SUM(b.bill_amount) AS total_spending
FROM billing b
JOIN appointments a ON b.appointment_id = a.appointment_id
JOIN patients p ON a.patient_id = p.patient_id
GROUP BY p.patient_name;

-- \•	Top 3 doctors by revenue.
SELECT  d.doctor_name, SUM(b.bill_amount) AS revenue
FROM billing b
JOIN appointments a ON b.appointment_id = a.appointment_id
JOIN doctors d ON a.doctor_id = d.doctor_id
GROUP BY  d.doctor_name ORDER BY revenue DESC LIMIT 3;

-- \ •	Repeat patients vs new patients.
select case when count(a.doctor_id)> 1 then 'Repeat patient' else 'New patient' end As patient_type, count(p.patient_id) As patient_count from appointments a Join patients p on a.patient_id=p.patient_id group by 'patient_type';


-- \ 	Patients consulting multiple doctors.

SELECT p.patient_id, p.patient_name, COUNT( a.doctor_id ) AS doctor_count
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
GROUP BY p.patient_id, p.patient_name
HAVING COUNT(a.doctor_id) > 1;

-- \ •	Disease-wise revenue.
SELECT a.disease, SUM(b.bill_amount) AS revenue
FROM billing b
JOIN appointments a ON b.appointment_id = a.appointment_id
GROUP BY a.disease;

-- \ •	Doctor performance based on revenue.
SELECT d.doctor_id, 
       d.specialization,
       COUNT(a.patient_id) AS unique_patients,
       COUNT(a.appointment_id) AS total_appointments,
       SUM(b.bill_amount) AS total_revenue,
       ROUND(SUM(b.bill_amount) / COUNT(a.patient_id), 2) AS revenue_per_patient
FROM doctors d
JOIN appointments a ON d.doctor_id = a.doctor_id
JOIN billing b ON a.appointment_id = b.appointment_id 
GROUP BY d.doctor_id,d.specialization 
ORDER BY total_revenue DESC;


SELECT d.doctor_id, d.doctor_name, d.specialization, SUM(b.bill_amount) AS total_revenue
FROM billing b
JOIN appointments a ON b.appointment_id = a.appointment_id
JOIN doctors d ON a.doctor_id = d.doctor_id
GROUP BY d.doctor_id, d.doctor_name, d.specialization ORDER BY total_revenue DESC;

-- \ •	High-value patients identification.

SELECT p.patient_id, 
       p.name, 
       p.city,
       COUNT(DISTINCT a.appointment_id) AS visit_count,
       SUM(b.bill_amount) AS total_spending 
FROM patients p
JOIN billing b ON p.patient_id = b.patient_id
JOIN appointments a ON b.appointment_id = a.appointment_id 
GROUP BY p.patient_id, p.name, p.city 
HAVING SUM(b.bill_amount) > 50000 
ORDER BY total_spending DESC;


