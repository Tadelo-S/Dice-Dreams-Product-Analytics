WITH date_offset AS (
  SELECT DATE_DIFF(CURRENT_DATE(), MAX(DATE(time)), DAY) AS offset_days
  FROM `ppltx-ba-course.gamepltx.fact`
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
  FROM `ppltx-ba-course.gamepltx.fact`
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