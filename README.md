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

## 📊 Business Intelligence & Executive Dashboard

To translate raw analytical outputs into executive-level visual storytelling, an interactive 4-quadrant Power BI dashboard was engineered utilizing an explicit DAX measure architecture and custom visual hierarchy.

![Fintech Executive Dashboard](assets/dashboard_overview.png)

### Key Dashboard Quadrants & Narrative Flow
1. **Executive KPI Banner (Top Layer):** Delivers at-a-glance portfolio scale including active cohort volume, cross-sell adoption rate, churn exposure, and average projected CLV.
2. **Top Cross-Sell Customers by Total Deposits (Top-Left):** Ranks top-tier multi-product users by total deposit volume to highlight key high-net-worth accounts.
3. **Customer Distribution by Engagement Tier (Top-Right):** Segmented donut breakdown displaying user distribution across Low, Medium, and High monthly transaction frequencies.
4. **Customer Lifetime Value (CLV) vs. Tenure (Bottom-Left):** Dual-axis visual evaluating projected account value against user longevity to guide retention budgeting.
5. **Operational Risk: Accounts Inactive > 365 Days (Bottom-Right):** Line-item audit table highlighting dormant investment and savings plans for immediate re-engagement.

---

## 📐 Data Modeling & DAX Architecture

Moving away from default implicit aggregations, core metrics are governed via a dedicated `_Measures` container using explicit DAX calculations:

### 1. Total Active Cohort
Calculates the total count of unique active customers across the portfolio.
```dax
Total Active Cohort = 
DISTINCTCOUNT('01_high_value_cross_sell_customers'[owner_id])
```
### 2. Cross-Sell Penetration (%)
Determines the percentage of users actively holding both Savings and Investment plans relative to the overall base.
```dax
Cross-Sell Penetration = 
DIVIDE(
    CALCULATE(
        DISTINCTCOUNT('01_high_value_cross_sell_customers'[owner_id]),
        '01_high_value_cross_sell_customers'[savings_count] > 0 && 
        '01_high_value_cross_sell_customers'[investment_count] > 0
    ),
    DISTINCTCOUNT('01_high_value_cross_sell_customers'[owner_id]),
    0
)
```
### 3. Flagged Inactive Accounts
Tracks the exact volume of high-risk accounts exceeding 365 days of transaction inactivity.
```dax
Flagged Inactive Accounts = 
COUNTROWS('03_account_inactivity_alert')
```
### 4. Average Projected CLV
Generates the baseline expected lifetime value across modeled cohorts.
```dax
Average Projected CLV = 
AVERAGE('04_customer_lifetime_value_estimation'[estimated_clv])
```

## Final Takeaways

- Successfully translated business requirements into clean, modular, and optimized SQL pipelines.
- Demonstrated strong foundational ability in structuring complex multi-table joins and handling data cleanly.
- Implemented  DAX calculations and visualization techniques in Power BI to deliver actionable cohort insights.
