#📊 User Onboarding Tutorial Analysis: Data Layer
This folder contains the SQL logic used to transform raw event data into a structured data layer for the Tutorial Performance Dashboard in Looker Studio.

📁 Repository Structure
The data transformation is divided into three specialized SQL scripts, each serving a unique role in the dashboard architecture:

1. 01_user_level_kpi_metrics.sql
Purpose: Foundations for Scorecards and Global KPIs.

Granularity: User-Level.

Logic: Aggregates event-level data into single rows per user.

Key Metrics: Completion flags (0/1), Success duration (min), Error/Skip indicators, and total error counts.

Usage: Powers the top-level KPIs and allows dynamic filtering by app_version.

2. 02_funnel_and_friction_analysis.sql
Purpose: Funnel Visualization and Step-by-Step Friction.

Granularity: Step-Level per App Version.

Logic: Uses COALESCE to map error events to their respective tutorial steps. Separates "User Errors" (UX friction) from "App Errors" (Technical friction/Timeouts).

Key Metrics: Unique user counts per step, Average Error Rate per step, and Total Step Duration (including recovery time).

Usage: Powers the Funnel Chart and the Combined Friction vs. Time graph.

3. 03_app_version_performance_benchmark.sql
Purpose: Comparative Version Benchmarking.

Granularity: App-Version Level.

Logic: High-level aggregation to compare performance across different product releases.

Key Metrics: Total Starters, Success Rate (%), Weighted Average Errors per user, and Average Completion Time.

Usage: Powers the "Version Comparison Table" at the bottom of the dashboard.

🛠️ Tech Stack
Database: Google BigQuery

Visualization: Looker Studio

SQL Dialect: Standard SQL

💡 Analytical Highlights
Friction Separation: By categorizing errors into 'User' vs 'App' types, we can distinguish between poor UX design and technical instability.

Weighted Metrics: Error and time averages are weighted by the starting population to ensure fair comparison between versions with different drop-off rates.

Data Integrity: Implemented DISTINCT counting and conditional aggregation to prevent double-counting in multi-event user sessions.
