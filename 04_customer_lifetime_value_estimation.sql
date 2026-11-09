-- For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, 
-- calculate:
-- Account tenure (months since signup)
-- Total transactions
-- Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
-- Order by estimated CLV from highest to lowest

with reference_date as (
	select max(transaction_date) as max_date 
	from savings_savingsaccount)

select 
	u.id as customer_id,
	concat(u.first_name, ' ', u.last_name) as name,
    -- u.date_joined as date_joined,
    timestampdiff(month, u.date_joined, r.max_date) as tenure_months,
    sum(s.confirmed_amount) as total_transactions,
    format((sum(s.confirmed_amount)/
    nullif(timestampdiff(month, u.date_joined, r.max_date), 0)
    * 12 * 0.001),2) as estimated_clv
from users_customuser u
left join savings_savingsaccount s
	on u.id = s.owner_id
cross join reference_date r
group by u.id, u.first_name, u.last_name, r.max_date
order by (sum(s.confirmed_amount)/
    nullif(timestampdiff(month, u.date_joined, r.max_date), 0)
    * 12 * 0.001) desc
;
