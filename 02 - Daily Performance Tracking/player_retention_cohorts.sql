/* Name: player_retention_cohorts.sql
DESCRIPTION: 
This query calculates Day-N retention cohorts, defining the "Install Date" as the user's 
first appearance in the dataset. It tracks player return rates over specific industry-standard 
milestones (Day 1-7, 14, 28, 60).

TECHNICAL HIGHLIGHTS:
1. DYNAMIC TIME-SHIFTING: Implements a dynamic offset logic using CURRENT_DATE() to align 
   historical data with the present day, ensuring a "live" dashboard experience.
2. PERFORMANCE OPTIMIZATION: Pre-aggregates daily active users (DAU) to 'User-Day' grain 
   before joining, significantly reducing processing costs for large-scale datasets (15.8M+ rows).
3. COHORT NORMALIZATION: Utilizes Window Functions (MAX OVER PARTITION) to calculate 
   the baseline cohort size, enabling seamless percentage calculations in the BI layer.

LOGIC STEPS:
1. Time_Constants: Calculates the daily offset between the dataset's max date and today.
2. Installs: Defines user cohorts based on their time-shifted first-ever event.
3. DAU: Maps unique active days per user, adjusted to the current calendar.
4. Ret_temp: Calculates 'day_in_game' via DATE_DIFF and aggregates daily user counts.
5. Final Select: Filters for high-impact retention days and derives the cohort baseline.
*/
WITH
  Time_Constants AS (
    SELECT DATE_DIFF(CURRENT_DATE(), DATE(MAX(time)), DAY) AS offset
    FROM `ppltx-ba-course.gamepltx.fact`
  ),
  Installs AS (
    SELECT
      user_id,
      DATE_ADD(
        MIN(DATE(time)), INTERVAL (SELECT offset FROM Time_Constants) DAY)
        AS install_date
    FROM `ppltx-ba-course.gamepltx.fact`
    GROUP BY ALL
  ),
  DAU AS (
    SELECT
      user_id,
      DATE_ADD(
        DATE(time), INTERVAL (SELECT offset FROM Time_Constants) DAY)
        AS date
    FROM `ppltx-ba-course.gamepltx.fact`
    GROUP BY ALL
  ),
  Ret_temp AS (
    SELECT
      user_id,
      Installs.install_date,
      DATE_DIFF(DAU.date, Installs.install_date, day) + 1 AS day_in_game
    FROM Installs
    JOIN DAU
      USING (user_id)
  ),
  Ret_temp2 AS (
    SELECT
      install_date,
      day_in_game,
      COUNT(user_id) AS active_users
    FROM Ret_temp
    GROUP BY ALL
  )
SELECT
  *,
  MAX(active_users) OVER (PARTITION BY install_date) AS installs
FROM Ret_temp2
WHERE day_in_game < 8       
   OR day_in_game IN (14, 28, 60)
