-- find all active accounts (savings or investments) with 
-- no transactions in the last 1 year (365 days)

with accounts as(
	select id, 
		owner_id, 
		is_a_fund, 
		is_regular_savings, 
		start_date,
		case
			when is_a_fund =1 then 'investment'
			when is_regular_savings =1 then 'savings'
			else 'neither'
		end as account_type
	from plans_plan
	-- where is_a_fund =1 or is_regular_savings =1
),
reference_date as (
	select max(transaction_date) as max_date 
	from savings_savingsaccount
)
select 
	a.id as plan_id,
    a.owner_id,
    a.account_type as type,
    -- a.start_date,
    -- datediff(r.max_date, a.start_date) as account_age,
    max(s.transaction_date) as last_transaction_date,
    case 
		when max(s.transaction_date) is not null then datediff(r.max_date, max(s.transaction_date))
		else datediff(r.max_date, a.start_date)
	end as inactivity_days
    
from accounts a
left join savings_savingsaccount s
	on a.id = s.plan_id
cross join reference_date r
group by a.id, a.owner_id, a.account_type, a.start_date, r.max_date
having 
    (max(s.transaction_date) is not null and datediff(r.max_date , max(s.transaction_date)) > 365)
    or
    (max(s.transaction_date) is null and datediff(r.max_date, a.start_date) > 365)
order by inactivity_days asc
-- datediff(r.max_date , max(s.transaction_date)) asc
;

