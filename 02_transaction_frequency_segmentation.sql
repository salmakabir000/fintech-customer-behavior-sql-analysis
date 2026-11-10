-- Calculate the average number of transactions per customer per month and categorize them:
-- "High Frequency" (≥10 transactions/month)
-- "Medium Frequency" (3-9 transactions/month)
-- "Low Frequency" (≤2 transactions/month)

-- average transaction per each owner_id per month
-- common table expression
with avg_table as (
	select owner_id, 
	avg(monthly_transactions) as avg_monthly 
	from (
		select 
		owner_id, 
		year(transaction_date) as year,
		month(transaction_date) as month,
		count(*) as monthly_transactions
		from savings_savingsaccount
		group by owner_id, year(transaction_date),
		month(transaction_date)
	) as monthly_counts
	group by owner_id
	order by avg(monthly_transactions) asc
), 
categorized as (
	select 
		owner_id, 
        avg_monthly,
        case
			when avg_monthly < 2 then 'low frequency'
            when avg_monthly between 3 and 9 then 'medium frequency'
            else 'high frequency'
		end as frequency
	from avg_table
)
select 
frequency,
count(*) as customer_count,
format(avg(avg_monthly), 2) as avg_transactions_per_month 
from categorized
group by frequency
order by avg(avg_monthly) desc ;
