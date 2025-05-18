-- Customer Lifetime Value (CLV) Estimation
-- This query calculates account tenure (in months), total confirmed transactions,
-- and an estimated CLV per user using the formula:
-- CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction
-- Assumed average profit per transaction = 0.1% of the transaction amount

use adashi_staging;

Select	uc.id as customer_id, concat(uc.first_name, ' ', uc.last_name) as name, 
	-- Tenure in months since the user joined
	timestampdiff(month, uc.date_joined, CURDATE()) as tenure_months, 
    -- Total number of transactions by user
	count(ss.id) as total_transactions, 
    -- Estimated CLV calculation
    case when timestampdiff(month, uc.date_joined, curdate()) is not null or timestampdiff(month, uc.date_joined, curdate()) > 0 then 
    round((count(ss.id) / timestampdiff(month, uc.date_joined, curdate())) * 12 * (0.001 * avg(ss.confirmed_amount)) , 2) else 0 end as estimated_clv
from users_customuser uc inner join savings_savingsaccount ss on ss.owner_id = uc.id
where ss.confirmed_amount > 0 
group by customer_id, name
order by estimated_clv desc;
