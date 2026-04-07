/* Name: product_monetization_by_village.sql
/*
DESCRIPTION: 
This query analyzes the game's internal economy within the Business-Analytics-Sandbox 
by mapping product consumption (Spins, Coins, etc.) against player progression (Villages). 
It transforms raw data into the `agg_product_monetization` summary table, identifying 
spending patterns and calculating Lifetime Value (LTV) per user.

TECHNICAL HIGHLIGHTS:
1. DATA WAREHOUSING: Materializes results into the `final_project` schema to provide 
   an optimized data layer for monetization and progression dashboards.
2. CURRENCY NORMALIZATION: Implements a multi-currency conversion logic (JPY, EUR to USD) 
   to ensure a unified revenue metric across global markets.
3. PRODUCT CATEGORIZATION: Utilizes CASE WHEN logic to group granular SKU-level data 
   into high-level business categories (e.g., Access & VIP, Spins).
4. PROGRESSION MAPPING: Connects transactional revenue directly to the 'Current Village' 
   at the time of purchase, enabling a deep-dive into the "Village Economy."

LOGIC STEPS:
1. base_data: Cleanses the fact table, applies currency conversion, and groups products.
2. user_lifecycle: Calculates the 'Max Village Reached' and cumulative LTV for each unique user.
3. village_product_aggr: Aggregates revenue by user, village, and product group.
4. Final Select: Joins the user-level progression data with the granular spending data 
   to create a multi-dimensional view of monetization and progress.
*/
CREATE OR REPLACE TABLE `Project-ID.final_project.agg_product_monetization` AS
WITH date_offset AS (
  SELECT DATE_DIFF(CURRENT_DATE(), MAX(DATE(time)), DAY) AS offset_days
  FROM `Business-Analytics-Sandbox.gamepltx.fact`
),
base_data AS (
  SELECT 
    user_id,
    current_village,
    CASE 
      WHEN product_name LIKE '%Spin Pack%' THEN 'Spins'
      WHEN product_name LIKE '%Coin Pack%' THEN 'Coins'
      WHEN product_name IN ('VIP Pass', 'Event Ticket') THEN 'Access & VIP'
      WHEN product_name = 'Special Offer' THEN 'Offers'
      ELSE 'Other'
    END AS product_group,
    ROUND(
      CASE 
        WHEN currency = 'JPY' THEN price * 0.0066 
        WHEN currency = 'EUR' THEN price * 1.08 
        ELSE price 
      END, 0) AS rev
  FROM `Business-Analytics-Sandbox.gamepltx.fact`
  WHERE product_name IS NOT NULL AND price IS NOT NULL
),
user_lifecycle AS (
  SELECT 
    user_id,
    MAX(current_village) AS max_village_reached,
    SUM(rev) AS total_user_spend
  FROM base_data
  GROUP BY 1
),
village_product_aggr AS (
  SELECT 
    user_id,
    current_village,
    product_group,
    SUM(rev) AS village_revenue_usd
  FROM base_data
  GROUP BY 1, 2, 3
)
SELECT 
    v.user_id,
    v.current_village,
    v.product_group AS product_name, 
    v.village_revenue_usd,
    u.total_user_spend,
    u.max_village_reached
FROM village_product_aggr v
JOIN user_lifecycle u ON v.user_id = u.user_id;
