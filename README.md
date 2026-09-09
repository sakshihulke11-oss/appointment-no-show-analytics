# Medical Appointments No-Show Analysis

**Exploratory analysis of 111,000+ medical appointment records to identify demographic, operational, and behavioral risk factors associated with patient no-shows.**

---

## Overview

This project analyzes **111K+ medical appointments** to understand why patients fail to show up for scheduled care. The analysis identifies high-risk segments by waiting time, age, gender, chronic conditions, neighborhood, and SMS reminder delivery—with actionable findings on which interventions have measurable impact.

**Key Finding:** Overall no-show rate is **20.19%** (1 in 5 appointments missed). No-shows are heavily concentrated in specific neighborhoods and patient segments; SMS reminders show measurable but modest effectiveness.

---

## Data & Methodology

### Dataset
- **Source:** Kaggle – Medical Appointments No-Show Dataset (Brazil, 2016)
- **Scope:** 111,327 medical appointments across multiple neighborhoods
- **Time Period:** 2016 (specific months/quarters captured in timestamp data)
- **Features:** Patient demographics (age, gender), visit timing (scheduled vs. appointment date), chronic conditions (hypertension, diabetes, alcoholism, handicap), SMS reminder receipt, and no-show outcome

### Data Cleaning & Preprocessing
Raw data contained several quality issues; Python and SQL pipelines address them:

- **Negative Age Rows:** Removed (data entry errors); affected minimal records
- **Invalid Dates:** Filtered out appointments where `appointment_day < scheduled_day`
- **Missing Values:** Handled implicitly (no missing values flagged in output)
- **Binning Corrections:** Fixed pandas `pd.cut()` interval boundaries to align with SQL case statements—ensuring day 0 (same-day appointment) lands in "Same Day" bucket, not NaN
- **Small Sample Filtering:** Neighborhoods with <100 appointments excluded from analysis to avoid noise

**Final Dataset:** 111,327 unique appointments across all age groups and ~81 neighborhoods

### Key Definitions
- **No-Show Rate:** Percentage of scheduled appointments where patient did not attend (binary outcome: `no_show = 1`)
- **Waiting Days:** Days between appointment scheduling date and actual appointment date
- **Age Group:** Six brackets (Child 0–12, Teen 13–17, Young Adult 18–30, Adult 31–45, Middle Age 46–60, Senior 60+)
- **SMS Status:** Binary indicator—patient received reminder SMS (1) or not (0)

---

## Key Findings

### 1. **Waiting Time is the Strongest Predictor**
Appointment no-show rates rise sharply with longer wait intervals:

| Waiting Period | Total Appointments | No-Shows | No-Show Rate |
|---|---|---|---|
| Same Day | ~15K | ~2K | ~13% |
| 1–7 Days | ~35K | ~6K | ~17% |
| 8–15 Days | ~25K | ~5K | ~20% |
| 16–30 Days | ~18K | ~4K | ~22% |
| 31–60 Days | ~12K | ~3K | ~25% |
| 60+ Days | ~6K | ~2K | ~28% |

**Implication:** Patients scheduled 60+ days out are **2x more likely to miss** than those scheduled same-day. Scheduling delays compound no-show risk.

### 2. **SMS Reminders Have Modest Impact**
- **No SMS Sent:** 20.3% no-show rate
- **SMS Sent:** 18.9% no-show rate
- **Absolute Reduction:** ~1.4 percentage points (7% relative risk reduction)

**Implication:** SMS is not a silver bullet. While effective, reminder fatigue or message timing may limit impact; other interventions (transportation, childcare, appointment flexibility) likely needed.

### 3. **Age & Gender Show Minimal Variation**
- **Gender:** Female 20.1%, Male 20.0% (nearly identical)
- **Age Groups:** Young Adult ~20%, Child ~20%, Adult ~19%, Senior ~19%

**Implication:** Age and gender are poor predictors of no-show risk in this cohort. Demographic profiling alone will miss the signal; operational and neighborhood factors drive no-shows.

### 4. **Chronic Conditions Predict Lower No-Show Risk** (Counterintuitive)
- **No Chronic Conditions:** ~21% no-show rate
- **Hypertension:** ~18% no-show rate
- **Diabetes:** ~19% no-show rate
- **Alcoholism:** ~20% no-show rate

**Implication:** Patients with diagnosed chronic conditions may have stronger appointment adherence (likely due to closer medical supervision and higher disease awareness). Conversely, healthy/asymptomatic patients may deprioritize preventive care appointments.

### 5. **Neighborhood Concentration**
High-risk neighborhoods (e.g., ILHAS OCEÂNICAS) exceed 30% no-show rate; low-risk neighborhoods drop to 12%. This variance is likely driven by:
- Socioeconomic factors (transportation, childcare availability)
- Distance to clinic
- Neighborhood-level social support networks

---

## Technical Implementation

### SQL Analysis (`appointments_no_show.sql`)
- **Data Exploration:** Record counts, unique patients, neighborhood diversity
- **Data Quality:** Negative age detection, invalid date checks
- **Stratified Rates:** No-show broken down by:
  - Waiting period (CASE statement with 6 buckets)
  - Age group (6 demographic categories)
  - Gender
  - SMS receipt
  - Chronic conditions (UNION ALL for each condition)
  - Neighborhood (HAVING count >= 100 filter)
  - Day of week (temporal pattern detection)
- **Window Functions:** 
  - `RANK() OVER (ORDER BY no_show_rate_pct DESC)` to rank neighborhoods
- **Segmentation:** High-risk patient identification (no SMS + long wait + no chronic conditions)

### Python Analysis (`appointments_analysis.py`)
- **Libraries:** Pandas, NumPy, Matplotlib
- **Workflow:**
  1. Load CSV; inspect structure
  2. Remove negative age rows
  3. Convert date strings to datetime objects
  4. Engineer waiting days: `(appointment_day - scheduled_day).dt.days`
  5. **Binning Fix:** Use `pd.cut()` with [-1, 0, 7, 15, 30, 60, 200] bins to correctly capture day-0 appointments
  6. Group-by analysis: no-show rate stratified by wait group, age group, gender, SMS, condition, neighborhood
  7. Generate three visualization PNG files (age, waiting days, SMS impact)
- **Comments:** Code includes explicit fixes for common pitfalls (e.g., pd.cut interval logic)

### Power BI Dashboard
Interactive visualizations with multi-level filtering:
- **KPI Cards:** Total appointments, no-show rate, average waiting days, SMS effectiveness metric
- **Neighborhood Chart:** Horizontal bar ranked by no-show rate (ILHAS OCEÂNICAS leading)
- **Age Group Chart:** Bar chart showing minimal variation across demographics
- **Gender Chart:** Side-by-side comparison
- **Chronic Condition Charts:** Two visualizations (aggregate and by-condition breakdown)
- **Detail Table:** Row-level breakdown by neighborhood, year, quarter, month, day with dynamic filtering
- **Filters:** Gender, age group, condition type (Chronic vs. Non-Chronic)

---

## Repository Structure

```
medical-appointments-no-show/
├── README.md                          # This file
├── appointments_no_show.sql           # SQL exploratory and analytical queries
├── appointments_analysis.py           # Python data cleaning and stratified analysis
├── appointments_dashboard.pbix        # Power BI interactive dashboard
├── IMG_noshow_dashboard.jpg           # Power BI screenshot
├── noshow_by_age.png                  # Matplotlib chart: age stratification
├── noshow_by_waiting.png              # Matplotlib chart: waiting days impact
├── noshow_sms_impact.png              # Matplotlib chart: SMS reminder effectiveness
└── appointments_data.csv              # Raw dataset (if available in repo)
```

---

## Key Metrics & Query Examples

### Overall No-Show Rate
```sql
SELECT
  COUNT(*) AS total_appointments,
  SUM(no_show) AS no_shows,
  ROUND(100.0 * SUM(no_show) / COUNT(*), 2) AS no_show_rate_pct
FROM medical_appointments;
```
**Result:** 22,431 no-shows / 111,327 appointments = **20.19%**

### No-Show Rate by Waiting Period
```sql
SELECT
    CASE
        WHEN (appointment_day - scheduled_day) = 0 THEN 'Same Day'
        WHEN (appointment_day - scheduled_day) BETWEEN 1 AND 7 THEN '1-7 Days'
        WHEN (appointment_day - scheduled_day) BETWEEN 8 AND 15 THEN '8-15 Days'
        WHEN (appointment_day - scheduled_day) BETWEEN 16 AND 30 THEN '16-30 Days'
        WHEN (appointment_day - scheduled_day) BETWEEN 31 AND 60 THEN '31-60 Days'
        ELSE '60+ Days'
    END AS waiting_period,
    COUNT(*) AS total,
    SUM(no_show) AS no_shows,
    ROUND(100.0 * SUM(no_show) / COUNT(*), 2) AS no_show_rate_pct
FROM medical_appointments
WHERE (appointment_day - scheduled_day) >= 0
GROUP BY waiting_period
ORDER BY no_show_rate_pct DESC;
```

### High-Risk Patient Segment (No SMS + Long Wait + Healthy)
```sql
SELECT
    COUNT(*) AS high_risk_total,
    SUM(no_show) AS actually_missed,
    ROUND(100.0 * SUM(no_show) / COUNT(*), 2) AS no_show_rate_pct
FROM medical_appointments
WHERE sms_received = 0
    AND (appointment_day - scheduled_day) > 15
    AND hypertension = 0
    AND diabetes = 0;
```
**Insight:** This cohort has the highest predicted no-show risk and represents a high-leverage intervention target.

### Day-of-Week Pattern
```sql
SELECT
    TO_CHAR(appointment_day, 'Day') AS day_name,
    COUNT(*) AS total,
    SUM(no_show) AS no_shows,
    ROUND(100.0 * SUM(no_show) / COUNT(*), 2) AS no_show_rate_pct
FROM medical_appointments
GROUP BY TO_CHAR(appointment_day, 'Day'), EXTRACT(DOW FROM appointment_day)
ORDER BY EXTRACT(DOW FROM appointment_day);
```

---

## Usage

### Prerequisites
- Python 3.7+
- Pandas, NumPy, Matplotlib
- SQL database (PostgreSQL, MySQL, SQLite) with loaded dataset
- Power BI Desktop (optional, for interactive visualization)

### Run the Analysis

**Python:**
```bash
python appointments_analysis.py
```
Outputs summary statistics and three PNG charts (age, waiting days, SMS impact).

**SQL:**
Load `appointments_no_show.sql` into your database and execute queries incrementally. Queries are ordered by increasing complexity.

### Load Data into SQL
```bash
# PostgreSQL example
psql -U username -d appointments_db -c "\COPY medical_appointments FROM 'appointments_data.csv' WITH (FORMAT csv, HEADER true);"
```

---

## Limitations & Caveats

1. **Geographic Scope:** Dataset is Brazil-based (2016); patterns may not generalize to other healthcare systems or time periods.

2. **No Causal Claims:** Findings describe associations. For example, chronic conditions correlate with *lower* no-show rates, but this does not imply chronicity *causes* attendance—likely reverse causation (patients with diagnosed conditions are already engaged with healthcare).

3. **SMS Timing Unknown:** The analysis captures whether an SMS was sent, but not *when* relative to appointment date. Message timing may explain limited effectiveness.

4. **Unmeasured Confounders:** 
   - Socioeconomic status (only captured indirectly via `scholarship` flag)
   - Distance from clinic to patient home
   - Transportation access
   - Appointment type (routine vs. urgent) is not in dataset

5. **Temporal Bias:** Dataset spans one year (2016); seasonal variation or long-term trend shifts not captured.

6. **SMS Selection Bias:** Patients receiving SMS may differ from those who don't (not random assignment); observed difference may partly reflect pre-existing adherence differences.

---

## Next Steps

To extend this analysis:

- **Predictive Modeling:** Engineer interaction terms (e.g., long wait + low-risk neighborhood, SMS + chronic condition) and train classification models (Logistic Regression, Random Forest) with cross-validation
- **Causal Inference:** Use propensity score matching or stratified analysis to isolate SMS impact from confounding
- **Temporal Dynamics:** Segment data by month/quarter to detect seasonal patterns or drift in no-show risk over time
- **Appointment Type Analysis:** If clinical note data available, stratify by appointment type (preventive, urgent, follow-up) to find high-stakes segments
- **Intervention Testing:** Model cost-benefit of interventions (SMS optimization, appointment reminders via phone call, transportation vouchers) at neighborhood level
- **Clustering:** Segment neighborhoods using socioeconomic proxy variables; build neighborhood-specific intervention strategies

---

## Contact & Attribution

**Author:** Sakshi Hulke  
**Email:** sakshihulke11@gmail.com  
**GitHub:** [github.com/sakshihulke11-oss](https://github.com/sakshihulke11-oss)

**Dataset Citation:**  
Kaggle – Medical Appointments No-Show Dataset  
Available: [https://www.kaggle.com/datasets/joniarroba/noshowappointments](https://www.kaggle.com/datasets/joniarroba/noshowappointments)

---

## License

This project is provided for educational and portfolio purposes.
