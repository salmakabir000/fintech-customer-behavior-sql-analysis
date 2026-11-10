-- Q4: Customer Lifetime Value (CLV) Estimation
-- Calculate customer tenure, transaction count and estimated annualized CLV.
-- Monetary values are stored in Kobo and converted to Naira.

with reference_date as (
    select MAX(transaction_date) as max_date
    from savings_savingsaccount
),

customer_metrics as (
    select
        u.id as customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,

        -- Calculate customer tenure in complete months
        TIMESTAMPDIFF(
            month,
            u.date_joined,
            r.max_date
        ) as tenure_months,

        -- Count deposit transactions
        count(s.id) as total_transactions,

        -- Calculate total deposit value and convert Kobo to Naira
        COALESCE(SUM(s.confirmed_amount), 0) / 100
            as total_transaction_value

    from users_customuser u
    cross join reference_date r
    left join savings_savingsaccount s
        on u.id = s.owner_id
    group by
        u.id,
        u.first_name,
        u.last_name,
        u.date_joined,
        r.max_date
)

select
    customer_id,
    name,
    tenure_months,
    total_transactions,
    -- Annualized estimated profit at 0.1% of transaction value
    ROUND(
        (total_transaction_value / NULLIF(tenure_months, 0))
        * 12 * 0.001,
        2
    ) as estimated_clv
from customer_metrics
order by estimated_clv desc;

