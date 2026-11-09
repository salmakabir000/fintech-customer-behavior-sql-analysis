# 💳 Fintech Customer Behavior & Lifecycle Analytics

## Overview
This project explores customer behavior and business insights using advanced SQL. It addresses key business challenges around customer value, cross-selling, engagement patterns, account inactivity, and lifetime value estimation using transactional and demographic data from a fintech ecosystem.

> *Note: Sample output tables contain synthetic illustrative data generated to demonstrate query behavior while ensuring complete privacy compliance (NDPR/GDPR).*
- `results/`: Contains synthetic CSV output files matching production query schemas.
---

## Dataset Schema & Architecture

The analysis integrates four core relational tables:

- **`users_customuser`** → Customer demographic and contact information  
- **`plans_plan`** → Records of savings and investment plans created by customers  
- **`savings_savingsaccount`** → Deposit and inflow transaction records
- **`savings_savingsaccount`** *(Withdrawals view/table)* → Records of withdrawal transactions  

### Key Relationships & Data Notes
- **`owner_id`** → Foreign key linking to `users_customuser.id`  
- **`plan_id`** → Foreign key linking to `plans_plan.id`  
- **Product Categorization:** 
  - Savings plans → `is_regular_savings = 1`  
  - Investment plans → `is_a_fund = 1`  
- **Transaction Fields:** `confirmed_amount` (deposits/inflows) and `amount_withdrawn` (withdrawals).  
- **Currency Convention:** Monetary values are natively stored in **Kobo** and normalized to Naira where required.  

---

## Key Business Findings & SQL Methodology

### 1. Identifying Cross-Sell Opportunities (High-Value Customers)
* **The Business Problem:** Marketing wanted to identify customers holding both savings and investment products to target for cross-selling.
* **The Solution:** Built a multi-level CTE architecture joining user demographics with aggregated plan counts and deposit totals, filtering for active multi-product holders sorted by total capital inflow.

### 2. Transaction Frequency Segmentation
* **The Business Problem:** Finance needed to segment user engagement levels (High, Medium, Low) based on monthly transaction volume to track platform stickiness.
* **The Solution:** Implemented nested CTEs to calculate monthly transaction averages per user, categorized via conditional `CASE` logic (High: ≥ 10, Medium: 3–9, Low: ≤ 2), and aggregated total customer distribution per tier.

### 3. Dormant Account & Inactivity Alert System
* **The Business Problem:** Operations wanted to flag active savings or investment accounts experiencing no inflows for over 365 days to support risk and retention teams.
* **The Solution:** Standardized account types and established a dynamic baseline reference date using the latest system transaction. Employed a `LEFT JOIN` structure with conditional fallback math to calculate exact dormancy days from either the last transaction or the account start date.

### 4. Customer Lifetime Value (CLV) Estimation Model
* **The Business Problem:** Marketing wanted to estimate forward-looking customer value based on tenure and transaction volume to optimize acquisition spending.
* **The Solution:** Integrated user profile data with transaction summaries to calculate tenure in months and total transaction value. Applied the predictive formula $\text{CLV} = (\frac{\text{Total Transactions}}{\text{Tenure}}) \times 12 \times 0.001$, embedding `NULLIF` guards to prevent division-by-zero errors for new accounts.

---

## Technical Skills & SQL Concepts Demonstrated

- **Advanced Query Structures:** Common Table Expressions (CTEs) for multi-step data pipelines and modular subqueries.
- **Complex Joins:** Strategic use of `INNER JOIN`, `LEFT JOIN`, and `CROSS JOIN` for reference-date evaluation.
- **Aggregations & Grouping:** Advanced utilization of `SUM`, `COUNT`, `AVG`, and `MAX`.
- **Conditional Expressions:** Dynamic categorization using `CASE WHEN` logic.
- **Date & Numeric Functions:** `DATEDIFF`, `TIMESTAMPDIFF`, `NULLIF`, and currency conversion formatting.

---

## Final Takeaways

- Successfully translated ambiguous business requirements into clean, modular, and optimized SQL pipelines.
- Demonstrated strong foundational ability in structuring complex multi-table joins and handling data edge-cases cleanly.
