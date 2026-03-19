# Healthcare Appointment No-Show Analysis

This project analyzes why patients miss their scheduled healthcare appointments. The dataset has around 111,000 appointment records and I used it to find patterns in no-show behavior across different patient groups.

---

## Why I did this project

Missed appointments waste clinical resources and delay patient care. I wanted to understand which patients are most likely to not show up and whether things like SMS reminders or waiting time actually make a difference.

---

## Dataset

- 111,000+ appointment records from Brazilian public health clinics
- Includes patient age, gender, neighbourhood, chronic conditions, SMS reminder status and attendance outcome

---

## What I analyzed

- Overall no-show rate
- How waiting days between scheduling and appointment affect attendance
- No-show patterns by age group and gender
- Whether SMS reminders actually reduced no-shows
- Attendance behavior in patients with chronic conditions like diabetes and hypertension
- Neighbourhoods with the highest no-show rates

---

## Tools used

- Excel - initial data cleaning and formatting
- SQL - KPI queries, segmentation, window functions for neighbourhood ranking
- Python - data cleaning, EDA, visualizations using Pandas and Matplotlib
- Power BI - interactive dashboard tracking attendance KPIs

---

## Key findings

- About 20% of appointments result in a no-show
- Longer waiting time between scheduling and appointment increases no-show probability
- Interestingly patients who received SMS reminders had a higher no-show rate - likely because reminders are sent to high-risk patients more often
- Young adults had the most unpredictable attendance patterns
- Certain neighbourhoods consistently showed higher no-show rates

---

## Files in this repo

- `medical appointments.sql` - SQL queries for all KPI and segmentation analysis
- `appointments.py` - Python script for cleaning and exploring the data
- `medical appointment data.xlsx` - dataset used for the project
- `medical.appointments pbi.pbix` - Power BI dashboard file




