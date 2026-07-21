# Healthcare Appointment No-Show Analysis

## Overview
Analyzed 110K+ healthcare appointment records to find patterns behind patient no-shows. Worked across SQL, Python and Power BI to clean the data, run KPI analysis and build an interactive dashboard.

---

## Dataset
- **Source:** Kaggle — Medical Appointment No Shows
- **Link:** https://www.kaggle.com/datasets/joniarroba/noshowappointments
- **Raw size:** 110,527 appointment records

Columns used in analysis: `PatientId`, `AppointmentID`, `Gender`, `Age`, `Neighbourhood`, `Scholarship`, `Hipertension`, `Diabetes`, `Alcoholism`, `Handcap`, `SMS_received`, `ScheduledDay`, `AppointmentDay`, `No-show`

---

## What I did
- Cleaned the dataset — removed 1 invalid negative-age row, converted scheduling/appointment timestamps, validated date ordering
- Used SQL to calculate no-show KPIs, waiting-day buckets, age group analysis, neighbourhood breakdown, SMS effectiveness, and chronic condition analysis
- Used Python (Pandas, Matplotlib) for EDA and visualizations
- Built a Power BI dashboard with filters for age, gender and neighbourhood

---

## Waiting Days Buckets
Waiting-day buckets (Same Day, 1-7 days, 8-15 days, 16-30 days, 31-60 days, 60+ days) are defined identically across SQL and Python, so the same appointment lands in the same bucket regardless of which script computed it.

---

## Dashboard KPIs
| Metric                           | Value       |
| ---------------------------------- | ----------- |
| Raw Appointments                   | 110,527     |
| Appointments After Cleaning*       | 110,526     |
| Overall No-Show Rate               | 20.19%      |
| No-Shows                           | 22,319      |
| Average Waiting Days               | 10.18 days  |
| No-Show Rate — No SMS Reminder     | 16.70%      |
| No-Show Rate — SMS Reminder Sent   | 27.57%      |

*After removing 1 row with an invalid negative age.

---

## Key Findings
- SMS reminders correlate with a **higher** no-show rate in this dataset (27.57% vs 16.70% without one) — this is a known counter-intuitive pattern in this dataset, likely because SMS reminders were sent disproportionately to appointments booked with longer waiting periods, which independently carry higher no-show rates. Worth calling out as a correlation, not a causal reminder effect, if asked about it.
- Patterns in no-show rate by age group and waiting period (see `noshow_by_age.png`, `noshow_by_waiting.png`)
- A rule-based high-risk segment (no SMS reminder + waiting period over 15 days + no chronic condition) flags patients most likely to miss an appointment

---

## Files
```
├── Medical appointments sql       — SQL queries (no-show KPIs, waiting-day/age/neighbourhood breakdowns, window functions)
├── appointments.py                — Python EDA script (cleaning, KPI calc, visualizations)
├── medical.appointments pbi.pbix  — Power BI dashboard
├── noshow_by_age.png              — No-show rate by age group chart
├── noshow_by_waiting.png          — No-show rate by waiting days chart
├── noshow_sms_impact.png          — SMS reminder impact chart
├── SAS file
├── R file
```
