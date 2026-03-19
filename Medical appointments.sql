Healthcare Appointment No-Show Analysis
-- Dataset: medical_appointments (111k+ records)

create table medical_appointments(
patient_id text,
appointment_id text,
gender char(1),
age int,
neighborhood text,
scholarship smallint,
hypertension smallint,
diabetes smallint,
alcoholism smallint,
handicap smallint,
sms_received smallint,
scheduled_day date,
appointment_day date,
no_show smallint
);


-- checking the data first
SELECT * FROM medical_appointments LIMIT 10;


-- basic overview
SELECT
    COUNT(*) AS total_appointments,
    COUNT(DISTINCT PatientId) AS unique_patients,
    COUNT(DISTINCT Neighbourhood) AS total_neighbourhoods,
    ROUND(AVG(Age), 1) AS avg_age
FROM medical_appointments;


-- checking for data issues
SELECT COUNT(*) AS negative_age_rows FROM medical_appointments WHERE Age < 0;

SELECT COUNT(*) AS invalid_dates FROM medical_appointments WHERE ScheduledDay > AppointmentDay;


-- overall no-show rate - this is the main KPI
SELECT
    COUNT(*) AS total_appointments,
    SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) AS no_shows,
    SUM(CASE WHEN "No-show" = 'No' THEN 1 ELSE 0 END) AS showed_up,
    ROUND(100.0 * SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS no_show_rate_pct
FROM medical_appointments;


-- does waiting longer mean more no-shows?
SELECT
    CASE
        WHEN DATEDIFF(AppointmentDay, ScheduledDay) = 0 THEN 'Same Day'
        WHEN DATEDIFF(AppointmentDay, ScheduledDay) BETWEEN 1 AND 7 THEN '1-7 Days'
        WHEN DATEDIFF(AppointmentDay, ScheduledDay) BETWEEN 8 AND 15 THEN '8-15 Days'
        WHEN DATEDIFF(AppointmentDay, ScheduledDay) BETWEEN 16 AND 30 THEN '16-30 Days'
        WHEN DATEDIFF(AppointmentDay, ScheduledDay) BETWEEN 31 AND 60 THEN '31-60 Days'
        ELSE '60+ Days'
    END AS waiting_period,
    COUNT(*) AS total,
    SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) AS no_shows,
    ROUND(100.0 * SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS no_show_rate_pct
FROM medical_appointments
WHERE DATEDIFF(AppointmentDay, ScheduledDay) >= 0
GROUP BY waiting_period
ORDER BY no_show_rate_pct DESC;


-- no show by age group
SELECT
    CASE
        WHEN Age BETWEEN 0 AND 12 THEN 'Child (0-12)'
        WHEN Age BETWEEN 13 AND 17 THEN 'Teen (13-17)'
        WHEN Age BETWEEN 18 AND 30 THEN 'Young Adult (18-30)'
        WHEN Age BETWEEN 31 AND 45 THEN 'Adult (31-45)'
        WHEN Age BETWEEN 46 AND 60 THEN 'Middle Age (46-60)'
        WHEN Age > 60 THEN 'Senior (60+)'
    END AS age_group,
    COUNT(*) AS total,
    SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) AS no_shows,
    ROUND(100.0 * SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS no_show_rate_pct
FROM medical_appointments
WHERE Age >= 0
GROUP BY age_group
ORDER BY no_show_rate_pct DESC;


-- gender comparison
SELECT
    Gender,
    COUNT(*) AS total,
    SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) AS no_shows,
    ROUND(100.0 * SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS no_show_rate_pct
FROM medical_appointments
GROUP BY Gender;


-- did SMS reminders actually help?
SELECT
    CASE SMS_received WHEN 1 THEN 'SMS Sent' ELSE 'No SMS' END AS sms_status,
    COUNT(*) AS total,
    SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) AS no_shows,
    ROUND(100.0 * SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS no_show_rate_pct
FROM medical_appointments
GROUP BY SMS_received;


-- no show rates for patients with chronic conditions
SELECT 'Hypertension' AS condition_name,
    COUNT(*) AS total,
    SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) AS no_shows,
    ROUND(100.0 * SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS no_show_rate_pct
FROM medical_appointments WHERE Hipertension = 1

UNION ALL

SELECT 'Diabetes',
    COUNT(*),
    SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END),
    ROUND(100.0 * SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2)
FROM medical_appointments WHERE Diabetes = 1

UNION ALL

SELECT 'Alcoholism',
    COUNT(*),
    SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END),
    ROUND(100.0 * SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2)
FROM medical_appointments WHERE Alcoholism = 1;


-- top neighbourhoods with most no-shows
-- only looking at areas with 100+ appointments to avoid misleading rates
SELECT
    Neighbourhood,
    COUNT(*) AS total_appointments,
    SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) AS no_shows,
    ROUND(100.0 * SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS no_show_rate_pct
FROM medical_appointments
GROUP BY Neighbourhood
HAVING COUNT(*) >= 100
ORDER BY no_show_rate_pct DESC
LIMIT 10;


-- ranking all neighbourhoods using window function
SELECT
    Neighbourhood,
    total_appointments,
    no_shows,
    no_show_rate_pct,
    RANK() OVER (ORDER BY no_show_rate_pct DESC) AS rank_by_noshow
FROM (
    SELECT
        Neighbourhood,
        COUNT(*) AS total_appointments,
        SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) AS no_shows,
        ROUND(100.0 * SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS no_show_rate_pct
    FROM medical_appointments
    GROUP BY Neighbourhood
    HAVING COUNT(*) >= 100
) nb
ORDER BY rank_by_noshow;


-- which day of the week has most no-shows
SELECT
    DAYNAME(AppointmentDay) AS day_name,
    COUNT(*) AS total,
    SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) AS no_shows,
    ROUND(100.0 * SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS no_show_rate_pct
FROM medical_appointments
GROUP BY DAYNAME(AppointmentDay), DAYOFWEEK(AppointmentDay)
ORDER BY DAYOFWEEK(AppointmentDay);


-- patients most likely to miss - no sms + long wait + no chronic condition
SELECT
    COUNT(*) AS high_risk_total,
    SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) AS actually_missed,
    ROUND(100.0 * SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS no_show_rate_pct
FROM medical_appointments
WHERE SMS_received = 0
    AND DATEDIFF(AppointmentDay, ScheduledDay) > 15
    AND Hipertension = 0
    AND Diabetes = 0;
