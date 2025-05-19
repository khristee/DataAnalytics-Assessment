-- High-Value Customers with Multiple Products
-- This query identifies users with at least one funded savings plan AND one funded investment plan , sorted by total deposits.

Select	uc.id as owner_id, concat(uc.first_name, ' ', uc.last_name) as name, 
    -- Count of distinct funded savings plans
    count(distinct case when pp.is_regular_savings = 1 then pp.id end) as savings_count,
     -- Count of distinct funded investment plans
	count(distinct case when pp.is_a_fund = 1 then pp.id end) as investment_count, 
     -- Sum of confirmed deposit amounts (converted from kobo to naira)
    round(sum(ss.confirmed_amount) / 100, 2) as total_deposits
from users_customuser uc join plans_plan pp on pp.owner_id = uc.id
	join savings_savingsaccount ss on ss.plan_id = pp.id
where ss.confirmed_amount > 0 and (pp.is_regular_savings = 1 or pp.is_a_fund = 1) -- Only consider plans with confirmed (funded) deposits
group by uc.id, uc.first_name, uc.last_name
having savings_count > 0 and investment_count > 0  -- Only include users with at least one funded savings AND one funded investment plan
order by total_deposits desc;
