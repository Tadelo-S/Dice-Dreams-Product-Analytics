# Gaming Analytics Portfolio: From Raw Events to Executive Insights

## Project Overview
This project demonstrates a complete Data Analytics pipeline in the Gaming industry. Using a synthetic gaming dataset, I have modeled raw event data into structured layers to track user behavior, monetization, and tutorial performance.

The goal is to provide stakeholders with actionable insights through automated SQL transformations and interactive BI dashboards.

---

## Live Dashboards (Quick Links)
Get straight to the results. Access the interactive Looker Studio reports here:
* 📊 **[Onboarding & Tutorial Analysis Dashboard](https://lookerstudio.google.com/reporting/ed7aa2d5-3958-467d-b06e-51a1e4c35546/page/tEnnC)** – Focuses on FTUE (First-Time User Experience) and friction points.
* 📈 **[Executive Daily Performance Dashboard](https://lookerstudio.google.com/reporting/27e87884-08a2-4349-adc4-f32a37623407)** – Monitors DAU, Revenue, and In-game Economy health.

---

## Project Structure

### [00 - Documentation & Setup](./00%20-%20Documentation%20%26%20Setup)
Defines the strategic product framework, featuring a deep-dive analysis of Dice Dreams' taxonomy and a feature specification with A/B test modeling.

### [01 - Onboarding](./01%20-%20Onboarding)
Focuses on the **Tutorial Performance Analysis**.
* **Key Logic:** Funnel completion rates, error mapping (UX vs. Technical), and version benchmarking.
* **Tech:** BigQuery SQL (User-level aggregation).

### [02 - Daily Performance](./02%20-%20Daily%20Performance)
The core **Data Layer** for game health monitoring.
* **Key Logic:** DAU/ARPU calculations, Monetization breakdown by product group, and Retention cohorts (D1, D7, D30).
* **Tech:** BigQuery SQL (ETL & Summary tables).

### [03 - Visual Dashboards](./03%20-%20Visual%20Dashboards)
The visualization layer showcasing the final reports.
* **Contents:** Screenshots of core dashboard pages and direct access links.
* **Tech:** Looker Studio.

---

## Tech Stack
* **Storage & Analysis:** Google BigQuery (Standard SQL)
* **Visualization:** Looker Studio

