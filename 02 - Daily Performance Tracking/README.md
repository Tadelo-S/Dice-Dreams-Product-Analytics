# 02 - Daily Performance Tracking
This folder contains the core ETL processes and transformation logic designed to monitor game health and player behavior. These queries form the backbone of the Executive Dashboard, aggregating raw transactional data into high-performance summary tables ready for BI visualization.

## Overview
The goal of this directory is to centralize the logic for key performance indicators (KPIs), allowing for scalable data analysis and efficient reporting without requiring heavy computation at the visualization layer.

## Queries Summary
1. agg_daily_performance.sql
Purpose: The primary source for the Executive Dashboard.

Key Logic: Implements ETL processes to materialize daily aggregated metrics (DAU, Revenue, Transactions, Installs).

Key Feature: Uses Dynamic Time-Shifting to align historical data with the present day, ensuring the dashboard always displays "fresh" relative data.

2. agg_product_monetization.sql
Purpose: In-depth analysis of the game's internal economy.

Key Logic: Maps product consumption (Spins, Coins, VIP) against player progression (Villages).

Key Feature: Calculates Lifetime Value (LTV) per user and provides a granular breakdown of how revenue is distributed across different game stages ("Village Economy").

3. agg_retention_cohorts.sql
Purpose: Tracks long-term player engagement and health.

Key Logic: Computes Day-N retention cohorts based on the user's first-touch (install) date.

Key Feature: Employs Performance Optimization techniques by pre-aggregating data to a 'User-Day' grain, enabling efficient tracking of return rates at standard milestones (Day 1-7, 14, 28, 60).

## Data Workflow

```mermaid
graph TD
    A[(Raw Fact Data)] --> B[ETL Processing]
    B --> C[agg_daily_performance]
    B --> D[agg_product_monetization]
    B --> E[agg_retention_cohorts]
    C --> F((Executive Dashboard))
    D --> F
    E --> F
