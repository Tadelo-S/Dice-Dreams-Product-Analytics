SELECT 
    step_index,
    step_name,
    COUNT(DISTINCT user_id) AS total_users_at_step
FROM `ppltx-ba-course.final_project.tutorial`
WHERE step_name is not null
GROUP BY 1, 2
ORDER BY 1 ASC;