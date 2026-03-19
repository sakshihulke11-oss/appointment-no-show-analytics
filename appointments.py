import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

df = pd.read_csv("appointments_data.csv")
print(df.shape)
print(df.head())
print(df.columns.tolist())
print(df.head())

# columns are already clean in this dataset
print(df.columns.tolist())

# removing negative age rows
print("negative age rows:", (df['age'] < 0).sum())
df = df[df['age'] >= 0]

# 1 = no show, 0 = showed up
print(df['no_show'].unique())
df['no_show_flag'] = df['no_show']

df['scheduled_day']    = pd.to_datetime(df['scheduled_day'])
df['appointment_day']  = pd.to_datetime(df['appointment_day'])

df['scheduled_day']   = pd.to_datetime(df['scheduled_day'])
df['appointment_day'] = pd.to_datetime(df['appointment_day'])

# removing negative age rows - data entry error
print("negative age rows:", (df['age'] < 0).sum())
df = df[df['age'] >= 0]

# 1 = no show, 0 = showed up
df['no_show_flag'] = df['no_show']

total    = len(df)
no_shows = df['no_show_flag'].sum()
rate     = round(no_shows / total * 100, 2)

print(f"Total Appointments: {total}")
print(f"No Shows          : {no_shows}")
print(f"No Show Rate      : {rate}%")

# -----------------------------------------------
# Waiting Days Analysis
# days between scheduling and actual appointment
# -----------------------------------------------

df['waiting_days'] = (df['appointment_day'] - df['scheduled_day']).dt.days
df = df[df['waiting_days'] >= 0]

print(f"\nAverage Waiting Days: {round(df['waiting_days'].mean(), 2)}")

df['wait_group'] = pd.cut(
    df['waiting_days'],
    bins=[0, 1, 7, 15, 30, 60, 200],
    labels=['Same Day', '1-7 days', '8-15 days', '16-30 days', '31-60 days', '60+ days']
)

wait_summary = df.groupby('wait_group', observed=False)['no_show_flag'].agg(
    total='count',
    no_shows='sum'
)
wait_summary['no_show_rate_%'] = round(
    wait_summary['no_shows'] / wait_summary['total'] * 100, 2
)
print("\nNo Show Rate by Waiting Days:")
print(wait_summary)

# -----------------------------------------------
# Age Group Analysis
# -----------------------------------------------

df['age_group'] = pd.cut(
    df['age'],
    bins=[0, 12, 17, 30, 45, 60, 100],
    labels=['Child', 'Teen', 'Young Adult', 'Adult', 'Middle Age', 'Senior']
)

age_summary = df.groupby('age_group', observed=False)['no_show_flag'].agg(
    total='count',
    no_shows='sum'
)
age_summary['no_show_rate_%'] = round(
    age_summary['no_shows'] / age_summary['total'] * 100, 2
)
print("\nNo Show Rate by Age Group:")
print(age_summary.sort_values('no_show_rate_%', ascending=False))

# -----------------------------------------------
# Gender Analysis
# -----------------------------------------------

gender_summary = df.groupby('gender')['no_show_flag'].agg(
    total='count',
    no_shows='sum'
)
gender_summary['no_show_rate_%'] = round(
    gender_summary['no_shows'] / gender_summary['total'] * 100, 2
)
print("\nNo Show Rate by Gender:")
print(gender_summary)

# -----------------------------------------------
# SMS Reminder Effectiveness
# -----------------------------------------------

sms_summary = df.groupby('sms_received')['no_show_flag'].agg(
    total='count',
    no_shows='sum'
)
sms_summary['no_show_rate_%'] = round(
    sms_summary['no_shows'] / sms_summary['total'] * 100, 2
)
sms_summary.index = ['No SMS', 'SMS Sent']
print("\nSMS Reminder Impact:")
print(sms_summary)

# -----------------------------------------------
# Chronic Conditions Analysis
# -----------------------------------------------

for condition in ['hypertension', 'diabetes', 'alcoholism']:
    condition_rate = round(
        df[df[condition] == 1]['no_show_flag'].mean() * 100, 2
    )
    print(f"{condition} patients no show rate: {condition_rate}%")


# -----------------------------------------------
# Neighborhood Analysis
# only areas with 100+ appointments to avoid small sample bias
# -----------------------------------------------

nb_summary = df.groupby('neighborhood')['no_show_flag'].agg(
    total='count',
    no_shows='sum'
)
nb_summary = nb_summary[nb_summary['total'] >= 100]
nb_summary['no_show_rate_%'] = round(
    nb_summary['no_shows'] / nb_summary['total'] * 100, 2
)
print("\nTop 10 Neighborhoods by No Show Rate:")
print(nb_summary.sort_values('no_show_rate_%', ascending=False).head(10))

# -----------------------------------------------
# Visualizations
# -----------------------------------------------

# no show rate by age group
plt.figure(figsize=(10, 5))
plot_data = age_summary.sort_values('no_show_rate_%')
plt.barh(plot_data.index.astype(str), plot_data['no_show_rate_%'], color='tomato')
plt.xlabel('No Show Rate (%)')
plt.title('No Show Rate by Age Group')
plt.tight_layout()
plt.savefig('noshow_by_age.png')
plt.show()

# no show rate by waiting days
plt.figure(figsize=(9, 5))
plt.bar(wait_summary.index.astype(str), wait_summary['no_show_rate_%'], color='steelblue')
plt.xticks(rotation=20)
plt.ylabel('No Show Rate (%)')
plt.title('No Show Rate by Waiting Days')
plt.tight_layout()
plt.savefig('noshow_by_waiting.png')
plt.show()

# sms reminder impact
plt.figure(figsize=(6, 4))
plt.bar(sms_summary.index, sms_summary['no_show_rate_%'], color=['steelblue', 'coral'])
plt.ylabel('No Show Rate (%)')
plt.title('SMS Reminder Impact on No Show Rate')
plt.tight_layout()
plt.savefig('noshow_sms_impact.png')
plt.show()

print("\ndone")

