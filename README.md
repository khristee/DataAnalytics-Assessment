# SQL Analytics Assessment

This repository contains solutions to four SQL-based analytical problems related to customer behavior, transactions, and account activity.

Each section includes:
- **Approach**: Explanation of how the problem was tackled.
- **Challenges**: Any difficulties encountered and how they were resolved.

---

## Assessment_Q1

### Approach:

To achieve this, I joined the users_customuser, plans_plan, and savings_savingsaccount tables using their respective foreign key relationships. I focused only on funded plans by filtering for confirmed_amount > 0.

Next, I narrowed the scope to include only plans classified as:

Savings plans (is_regular_savings = 1), and

Investment plans (is_a_fund = 1).

I used COUNT(DISTINCT ...) to avoid double-counting plans for each user and calculated the total deposit amount by summing the confirmed amounts and converting the result from kobo to Naira by dividing by 100.

To ensure each user had at least one savings and one investment plan, I used a HAVING clause. Finally, I ordered the output by total deposits in descending order to identify top-tier customers.


---

### Challenges:

- I had to include p.is_regular_savings = 1 OR p.is_a_fund = 1 in the WHERE clause after noticing the initial query was summing all deposits per user — including unrelated plan types like wallets or donations. Without this, deposit totals were inaccurate.

- I used the HAVING clause to ensure that only users with both funded savings and investment plans were returned. The WHERE clause alone couldn’t distinguish users with both types.

- I ensured that only funded plans were counted by filtering with confirmed_amount > 0, preventing plans with no financial activity from affecting the results.



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
