-- High-Value Customers with Multiple Products
-- This query identifies users with at least one funded savings plan AND one funded investment plan , sorted by total deposits.
use adashi_staging;

-- CTE to get user names
with user as (
    select	id, concat(first_name, ' ', last_name) as name
    from users_customuser
),

-- CTE to aggregate funded savings plans per user
savings as (
    select ss.owner_id, count(distinct ss.plan_id) as savings_count, sum(ss.confirmed_amount) as savings_amount
    from savings_savingsaccount ss join plans_plan pp on ss.plan_id = pp.id
    where ss.confirmed_amount > 0 and pp.is_regular_savings = 1
    group by ss.owner_id
),
-- CTE to aggregate funded investment plans per user
investment as ( 
    select	ss.owner_id, count(distinct ss.plan_id) as investment_count, sum(ss.confirmed_amount) as investment_amount
    from savings_savingsaccount ss join plans_plan pp on ss.plan_id = pp.id
    where ss.confirmed_amount > 0 and pp.is_a_fund = 1
    group by ss.owner_id
)
-- Final result combining users who have both savings and investment plans
select u.id as owner_id, u.name, s.savings_count, i.investment_count, round((s.savings_amount + i.investment_amount) / 100, 2) as total_deposits
from user u join savings s on u.id = s.owner_id join investment i on u.id = i.owner_id
order by total_deposits desc