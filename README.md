# Healthcare Appointment No-Show Analysis

## Overview

Analyzed 111,000+ healthcare appointment records to find patterns behind patient no-shows. Worked across SQL, Python and Power BI to clean the data, run KPI analysis and build an interactive dashboard.

---

## Dataset

- **Source:** Kaggle — Medical Appointment No Shows
- **Link:** https://www.kaggle.com/datasets/joniarroba/noshowappointments
- **Size:** 111,000+ appointment records

Columns used in analysis: `patient_id`, `appointment_id`, `gender`, `age`, `neighborhood`, `scholarship`, `hypertension`, `diabetes`, `alcoholism`, `handicap`, `sms_received`, `scheduled_day`, `appointment_day`, `no_show`

---

## What I did

- Cleaned the dataset — removed negative age rows, fixed date columns
- Used SQL to calculate no-show KPIs, age group analysis, neighbourhood breakdown, SMS effectiveness and chronic condition analysis
- Used Python (Pandas, Matplotlib) for EDA and visualizations
- Built a Power BI dashboard with filters for age, gender and neighbourhood

---

## Dashboard KPIs

| Metric | Value |
|---|---|
| Total Appointments | 111K+ |
| Overall No-Show Rate | ~20% |
| Average Waiting Days | 10.18 |
| No-Show % with SMS | 27.6% |

---

## Key Findings

- Overall no-show rate was around **20%**
- **Teen** and **Young Adult** age groups had the highest no-show rates
- Longer waiting days between scheduling and appointment increased no-show probability
- SMS reminders alone did not reduce no-shows significantly
- Patients with chronic conditions showed slightly better attendance

---

## Files
├── medical.appointments.sql     — SQL queries
├── appointments.py              — Python EDA script
├── medical.appointments pbi.pbix — Power BI dashboard
