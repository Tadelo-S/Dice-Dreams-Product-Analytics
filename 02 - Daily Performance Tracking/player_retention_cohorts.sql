/* Name: player_retention_cohorts.sql
DESCRIPTION: 
This query calculates Day-N retention by defining user cohorts based on their first appearance 
(Install Date) and tracking their return rate over time.

LOGIC STEPS:
1. Identify the 'Install Date' for each unique user (Cohort Definition).
2. Map all active dates (DAU) to each user.
3. Calculate 'day_in_game' using DATE_DIFF between activity and install date.
4. Use a Window Function (MAX OVER) to determine the baseline cohort size for percentage calculation.
*/
WITH Ret_temp AS (
SELECT
 user_id,
 Installs.install_date,
 DATE_DIFF(DAU.Date,Installs.install_date,day) + 1 AS day_in_game
FROM (
 SELECT uid AS user_id, MIN(DATE(event_time)) AS install_date
 FROM `ppltx-ba-course.ds_game.fact`
 GROUP BY ALL
 ) AS Installs
 JOIN (
  SELECT
    uid AS user_id,
    DATE(event_time) AS Date
  FROM `ppltx-ba-course.ds_game.fact`
 ) AS DAU USING(user_id)
)
,
Ret_temp2 AS (
  SELECT
    user_id,
    install_date,
    day_in_game,
    COUNT(user_id) AS total_users
  FROM Ret_temp
  GROUP BY ALL
)

SELECT
 *,
 MAX(total_users) OVER(PARTITION BY install_date) AS installs
FROM Ret_temp2