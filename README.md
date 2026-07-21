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
- Cleaned the dataset — removed negative age rows, validated scheduled/appointment date ordering
- Used SQL to calculate no-show KPIs, waiting-day buckets, age group analysis, neighbourhood breakdown, SMS effectiveness, and chronic condition analysis
- Used Python (Pandas, Matplotlib) for EDA and visualizations
- Built a Power BI dashboard with filters for age, gender and neighbourhood

---

## Waiting Days Buckets
Waiting-day buckets (Same Day, 1-7 days, 8-15 days, 16-30 days, 31-60 days, 60+ days) are defined identically across SQL and Python, so the same appointment lands in the same bucket regardless of which script computed it.

---

## Dashboard KPIs
*(Re-run `appointments.py` after the no-show flag and waiting-day bucket fixes below to confirm these numbers before publishing.)*

| Metric                | Value |
| ---------------------- | ----- |
| Total Appointments     | TBD — re-run |
| Overall No-Show Rate   | TBD — re-run |
| Average Waiting Days   | TBD — re-run |
| No-Show % with SMS     | TBD — re-run |

---

## Key Findings
- Patterns in no-show rate by age group and waiting period (see `noshow_by_age.png`, `noshow_by_waiting.png`)
- SMS reminder impact on no-show rate (see `noshow_sms_impact.png`)
- A rule-based high-risk segment (no SMS reminder + waiting period over 15 days + no chronic condition) is used to flag patients most likely to miss an appointment

---

## Files
```
├── Medical appointments sql       — SQL queries (no-show KPIs, waiting-day/age/neighbourhood breakdowns, window functions)
├── appointments.py                — Python EDA script (cleaning, KPI calc, visualizations)
├── medical.appointments pbi.pbix  — Power BI dashboard
├── noshow_by_age.png              — No-show rate by age group chart
├── noshow_by_waiting.png          — No-show rate by waiting days chart
├── noshow_sms_impact.png          — SMS reminder impact chart
```
