-- Transaction Frequency Analysis
-- This query calculates the average number of transactions per customer per month and categorizes them into High, Medium and Low categories

use adashi_staging;

-- Count transactions per user per month-year
with user_trx_mom as (
    Select	ss.owner_id, date_format(ss.transaction_date, '%Y-%m') as month, count(*) as transaction_count
    from savings_savingsaccount ss
    group by ss.owner_id, month
),
-- Average transactions per user per month
total_avg_trx_per_user as (
    Select	uc.id, round(coalesce(avg(utm.transaction_count), 0), 1) as avg_trx
    from users_customuser uc left join user_trx_mom utm on uc.id = utm.owner_id
    group by uc.id
)
-- Final output: Categorize users by transaction frequency
Select case when avg_trx >= 10 then 'High Frequency' when avg_trx between 3 and 9 then 'Medium Frequency'
	else 'Low Frequency' end as frequency_category, count(*) as customer_count,	round(avg(avg_trx), 1) as avg_transactions_per_month
from total_avg_trx_per_user
group by frequency_category
