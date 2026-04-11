# 00 - Project Framework & Analysis

## Overview
This folder contains the strategic foundation of the project. It uses **Dice Dreams** as a primary case study to demonstrate product strategy and event taxonomy design. The practical implementations in this repository (SQL models and Dashboards) utilize **synthetic datasets** modeled after the social-casual gaming genre to demonstrate technical proficiency in a production-ready environment.

## Contents

### 1. Dice Dreams: Product Analytics & Behavior Deep-Dive (PDF)
The **Master Document** of the project, covering the following core analytical pillars:

* **Onboarding Funnel & Conversion Analysis:** An in-depth evaluation of the First Time User Experience (FTUE), identifying friction points and optimizing the path to conversion.
* **Core Gameplay & Analytics Framework:** Definition of the game's "Build & Raid" loop and the required event structure for behavioral tracking.
* **Strategic Analytics & Performance Metrics:** A deep dive into North Star KPIs and a strategic comparison between Raw Event storage and optimized Fact Table modeling for BI.
* **Product Strategy & Feature Specification:** Analysis of feature evolution in casual games, including a formal product proposal for the "Royal Architects" mechanic.
* **A/B Testing & Statistical Analysis:** A simulated experiment for the proposed feature, including hypothesis setting, Z-Test calculations, and significance reporting.

### 2. Dice Dreams Tracking Plan (PDF)
A technical specification document mapping the data architecture:
* **Critical Event Taxonomy:** Comprehensive definitions for 10 high-impact gameplay events and their triggers (linked to the Framework chapter).
* **Data Schema:** Detailed breakdown of event-specific attributes and global "Super Properties" required for multi-dimensional analysis.

---
**Note on Data:** While the strategic framework focuses on Dice Dreams, the SQL queries and dashboards in this repository (Folders 01-03) operate on **synthetic gaming data**. This approach demonstrates the ability to apply high-level product logic to industry-standard datasets.
