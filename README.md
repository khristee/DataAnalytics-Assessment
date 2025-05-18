# SQL Analytics Assessment

This repository contains solutions to four SQL-based analytical problems related to customer behavior, transactions, and account activity.

Each section includes:
- **Approach**: Explanation of how the problem was tackled.
- **Challenges**: Any difficulties encountered and how they were resolved.

---

## Assessment_Q1

### Approach
I used Common Table Expressions (CTEs) to simplify the query into three parts:  
- One for user info (`users_customuser`) where I got the full names using `CONCAT(first_name, last_name)` function  
- The second to aggregate only funded savings plans (`is_regular_savings = 1`) with `confirmed_amount > 0`  
- The third to aggregate only funded investment plans (`is_a_fund = 1`) with `confirmed_amount > 0`.

Finally, I joined the three CTEs on `owner_id` and computed the total deposits in naira by dividing the sum of confirmed amounts by 100. The result was sorted in descending order of `total_deposits` as requested in the task.

### Challenges
Initially, I tried combining savings and investment plans in one query using `OR`, but it returned incorrect or incomplete data. I realized that users could have neither, one, or both types of plans, and some plans might not be funded. Separating them into distinct CTEs allowed for clearer logic and easier filtering.

---

## Assessment_Q2

### Approach
I used a CTE to break the query into two parts:
- First, I grouped the transactions by user and month using the `transaction_date` field.  
- Then I calculated the average transactions per user per month using `AVG()` in the second CTE.

Finally, I categorized users using a `CASE` statement based on their average transaction frequency and grouped them accordingly to count how many users fall into each frequency band.

### Challenges
When I calculated the average monthly transaction count for each user, I had to put into consideration users with no transactions at all to be included. So I `LEFT JOINED` with the `users_customuser` table and used `COALESCE` to treat missing data as 0.

---

## Assessment_Q3

### Approach
I joined `plans_plan` and `savings_savingsaccount` tables to get the latest transaction per plan using the `MAX(transaction_date)` function.  
I used the `MAX(transaction_date)` and `TIMESTAMPDIFF` functions to calculate how many days had passed since each plan’s most recent transaction. By comparing to `CURDATE()`, this logic remains dynamic and will reflect real-time inactivity if rerun later.

Lastly, I selected only plans with inactivity over 365 days using a `HAVING` clause.

---

## Assessment_Q4

### Approach
I used `TIMESTAMPDIFF` to calculate tenure, aggregated transactions using `COUNT(ss.id)` and `AVG(ss.confirmed_amount)`, and used a `CASE` statement to handle users with zero or null tenure to avoid division errors. I sorted the final result in descending order of `estimated_clv` to surface the most valuable customers.

### Challenges
Users with no recorded tenure (e.g., newly joined users) could cause errors in the CLV formula.  
To avoid this, I wrapped the calculation in a `CASE` statement to return `0` when tenure is null or zero.
