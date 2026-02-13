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

select * from medical_appointments;
select count(*) from medical_appointments;


select patient_id from medical_appointments
where no_show = 1;

select  round(sum(case when no_show=1 then 1 else 0 end )* 100.0/ count(*),2
)as no_show_percentage from medical_appointments;

select sum(no_show) * 100.0 / count(*),2 as no_show_percentage
from medical_appointments;

select  gender,round(sum(no_show) * 100.0/count(*),2 )
from medical_appointments
group by gender;

select gender,round(sum (case when no_show=1 then 1 else 0 end )*100.0/
count(*),2) as no_show_pct from medical_appointments
group by gender;

select gender, count(*) as total_appointments,
sum(no_show) as total_no_shows, round(sum(no_show) * 100.0/count(*),2) as no_show_percentage
from medical_appointments
group by gender;

select case 
when age<18 then '0-17'
when age between 18 and 35 then '18-35'
when age between 36 and 60 then '36-60'
else '60+'
end as age_group,
count(*) as total_appointments,sum(no_show) as total_no_shows,
round(sum(no_show)* 100.0/count(*),2) as no_show_percentage from medical_appointments
group by age_group
order by age_group;

select hypertension,
count(*) as total_appointments,sum(no_show) as total_no_shows,
round(sum(no_show)*100.0/count(*),2) as no_show_percentage 
from medical_appointments
group by hypertension;


select diabetes,
count(*) as total_appointments,sum(no_show) as total_no_show,
round(sum(no_show) *100.0/count(*),2) as total_no_percentage
from medical_appointments
group by diabetes;

select sms_received,
count(*) as total_appointments,sum(no_show) as total_no_show,
round(sum(no_show)*100.0/count(*),2) as no_show_percentage from medical_appointments
group by sms_received;

select sms_received,hypertension,diabetes,
count(*) as total_appointments,sum(no_show) as total_no_shows,round(sum(no_show)*100.0/count(*),2) as no_show_percentage
from medical_appointments
group by sms_received,hypertension,diabetes
order by no_show_percentage desc;

select count(no_show) as total_shows
from medical_appointments
where no_show = 0;

select distinct gender,count(no_show) from medical_appointments
group by gender;

select count(*) from medical_appointments
where sms_received =1;

select count(*) from medical_appointments
where age>60;

select round(sum(no_show)*100.0/count(*),2) as no_show_percentage from medical_appointments;

select avg(appointment_day - scheduled_day) from medical_appointments;

select max(appointment_day - scheduled_day) from medical_appointments;

select to_char(appointment_day,'day') as day,
round(sum(no_show)*100.0/count(*),2)from medical_appointments
group by day;

select no_show,count(*) as count from medical_appointments
group by no_show;

select 
case when appointment_day - scheduled_day = 0 then 'same day'
when appointment_day - scheduled_day between 1 and 7 then '1-7 days'
when appointment_day - scheduled_day between 8 and 30 then '8-30 days'
else '30+ days'
end as waiting_group,
round(sum(no_show)*100.0/count(*),2) as no_show_percentage
from medical_appointments
group by waiting_group
order by no_show_percentage desc;


select 
case when hypertension = 1 or diabetes = 1 or alcoholism = 1 then 'chronic'
else 'non-chronic' 
end as patient_type,
round(sum(no_show)*100.0/count(*),2) as no_show_percentage
from medical_appointments
group by patient_type;

select neighborhood,count(*) as total_appointments,
round(sum(no_show)*100.0/count(*),2) as no_show_percentage
from medical_appointments
group by neighborhood
having count(*)>100
order by no_show_percentage desc;

select scholarship,count(*)
from medical_appointments
group by scholarship;

select appointment_day,count(*) from medical_appointments
group by appointment_day;

select appointment_day,count(*) from medical_appointments
group by appointment_day
order by count(*) desc
limit 1;

select count(*) from medical_appointments
where scholarship = 0 and no_show=1;

select count(*) from medical_appointments
where handicap>0;

select count(*) from medical_appointments
where age <0;

select sms_received,count(*) from medical_appointments
group by sms_received;

select scholarship,count(*) from medical_appointments
group by scholarship;

select count(*) from medical_appointments
where  hypertension=1 or diabetes=1 or alcoholism=1;

select neighborhood,count(*),round(sum(no_show)*100.0/count(*),2) as no_show_percentage
from medical_appointments
group by neighborhood
having count(*)> 100
order by no_show_percentage desc
limit 10;

select patient_id,count(*) from medical_appointments
group by patient_id
having count(*)>1;

select patient_id,avg(appointment_day) from medical_appointments
group by patient_id;


select gender, count(*) as total_appointments,sum(no_show) as total_noshows ,
round(sum(no_show)*100/count(*),2) as no_show_percentage
from medical_appointments
group by gender;

select patient_id,count(*) from medical_appointments
group by patient_id
having count(*) > 1;

select round(sum(no_show)*100/count(*),2) as no_show_percentage
from medical_appointments
where appointment_day-scheduled_day>7;

select  sms_received, round(sum(no_show)*100/count(*),2) as no_show_percentage
from medical_appointments
where hypertension=1 or diabetes=1 or alcoholism=1
group by sms_received;

select round(sum(sms_received)*100/count(*),2)
from medical_appointments;

select round(sum(case when hypertension =1 or diabetes=1 or alcoholism=1 then 1 else 0 end)*100.0/count(*),2)
from medical_appointments;

select 
case 
when appointment_day - scheduled_day = 0 then 'low risk'
when appointment_day - scheduled_day = 1-7 then 'medium risk'
else 'high risk'
end as risk_group,
round(sum(no_show)*100/count(*),2) from medical_appointments
group by risk_group;













