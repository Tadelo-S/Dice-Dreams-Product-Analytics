/* Name: product_monetization_by_village.sql
DESCRIPTION: 
This query analyzes the game's internal economy by mapping product consumption (Spins, Coins, etc.) 
against player progression (Villages). It identifies spending patterns and calculates 
the Lifetime Value (LTV) per user to segment players by their economic contribution.

TECHNICAL HIGHLIGHTS:
1. CURRENCY NORMALIZATION: Implements a multi-currency conversion logic (JPY, EUR to USD) 
   to ensure a unified revenue metric across global markets.
2. PRODUCT CATEGORIZATION: Utilizes CASE WHEN logic to group granular SKU-level data 
   into high-level business categories (e.g., Access & VIP, Spins).
3. PROGRESSION MAPPING: Connects transactional revenue directly to the 'Current Village' 
   at the time of purchase, enabling a deep-dive into the "Village Economy."

LOGIC STEPS:
1. base_data: Cleanses the fact table, applies currency conversion, and groups products.
2. user_lifecycle: Calculates the 'Max Village Reached' and cumulative LTV for each unique user.
3. village_product_aggr: Aggregates revenue by user, village, and product group.
4. Final Select: Joins the user-level progression data with the granular spending data 
   to create a multi-dimensional view of monetization and progress.
*/
WITH base_data AS (
  SELECT 
    DATE_ADD(DATE(time), INTERVAL (SELECT DATE_DIFF(CURRENT_DATE(), MAX(DATE(time)), DAY) FROM `ppltx-ba-course.gamepltx.fact`) DAY) AS date,
    user_id,
    country,
    device_type,
    MIN(DATE(time)) OVER(PARTITION BY user_id) AS raw_install_date,
    ROUND(
      CASE 
      WHEN currency = 'JPY' THEN price * 0.0066 
      WHEN currency = 'EUR' THEN price * 1.08 
      ELSE price 
    END,0) AS rev,
    transaction_id
  FROM `ppltx-ba-course.gamepltx.fact`
)
SELECT 
  date,
  country,
  device_type,
  COUNT(DISTINCT user_id) AS dau,
  SUM(rev) AS revenue,
  COUNT(DISTINCT transaction_id) AS transactions,
  COUNT(DISTINCT CASE 
    WHEN date = DATE_ADD(raw_install_date, INTERVAL (SELECT DATE_DIFF(CURRENT_DATE(), MAX(DATE(time)), DAY) FROM `ppltx-ba-course.gamepltx.fact`) DAY) 
    THEN user_id END) AS installs
FROM base_data
GROUP BY 1, 2, 3