-- Account Inactivity Alert
-- This query identifies all active accounts (savings or investments) with no transactions in the last 1 year (365 days)
use adashi_staging;
Select pp.id as plan_id, pp.owner_id, 
	-- Determine the type of plan (Savings or Investment)
	case when Pp.is_a_fund = 1 then "Investment"  when pp.is_regular_savings = 1 then "Savings" end as type,
	-- Last transaction date for the account
    max(ss.transaction_date) as last_transaction_date, 
    -- Days since the last transaction
    timestampdiff(day,max(ss.transaction_date),curdate()) as inactivity_days
from plans_plan pp join savings_savingsaccount ss on ss.plan_id = pp.id
where (pp.is_regular_savings = 1 or pp.is_a_fund = 1) and ss.confirmed_amount > 0
group by plan_id,owner_id,type
-- Only return plans inactive for more than 365 days
having inactivity_days > 365;