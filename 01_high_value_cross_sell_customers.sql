
-- Write a query to find customers with at least one funded savings plan 
-- AND one funded investment plan, sorted by total deposits.

select 
	  u.id as owner_id
	, concat(u.first_name, ' ', u.last_name) as name
    , p.savings_count 
	, p.investment_count
	, s.total_deposit_naira
from users_customuser u

inner join
(select 
	owner_id
	,count(case when is_a_fund =1 then 1 end) as investment_count
	,count(case when is_regular_savings =1 then 1 end) as savings_count
from plans_plan
group by owner_id
) p on u.id = p.owner_id

inner join 
(select
	owner_id
	,sum(confirmed_amount)/100 as total_deposit_naira
from savings_savingsaccount
group by owner_id
) s on u.id = s.owner_id

where p.investment_count > 0
and p.savings_count > 0
order by total_deposit_naira desc;
