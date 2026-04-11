# 00 - Project Framework & Analysis

## Overview
This folder serves as the strategic backbone of the entire project. [cite_start]It contains the "Master Documents" that define the product logic, business objectives, and technical specifications used to build every SQL query and dashboard in this repository[cite: 5, 13, 224].

## Contents

### 1. Dice Dreams: Product Analytics & Behavior Deep-Dive (PDF)
[cite_start]This is the **Primary Project Document** covering the end-to-end analytical lifecycle[cite: 1, 2, 5]. It includes all strategic chapters:
* [cite_start]**Product Definition & Strategy:** Analysis of the "Build & Raid" core loop and the game's freemium business model[cite: 27, 30, 31].
* [cite_start]**Onboarding Funnel Analysis:** Identification of friction points within the First Time User Experience (FTUE) to optimize player conversion[cite: 10, 37, 46].
* [cite_start]**A/B Testing Methodology:** A complete experimental design for the "Royal Architects" feature, including hypothesis setting and statistical significance criteria (Z-Test)[cite: 177, 274, 275].
* [cite_start]**Strategic KPIs:** Definition of the "Three Pillars" of game health: Staying (Retention), Playing (Engagement), and Paying (Monetization)[cite: 178, 180, 199, 210].
* [cite_start]**Actionable Recommendations:** Data-driven product insights focused on economy balancing and retention optimization[cite: 4, 12, 251, 254].

### 2. Dice Dreams Tracking Plan (PDF)
[cite_start]The technical blueprint defining the data schema and event taxonomy[cite: 9, 14, 50]:
* [cite_start]**High-Impact Events:** Detailed definitions for the 10 most critical gameplay events, such as `session_start`, `dice_roll_completed`, and `kingdom_building_finished`[cite: 110, 111, 112, 120].
* [cite_start]**Event Attributes:** Specific parameters captured for each interaction (e.g., `outcome`, `multiplier`, `cost`, `is_bullseye`) to enable deep-dive behavioral analysis[cite: 123, 126, 145, 291].
* [cite_start]**Global Super Properties:** Global attributes sent with every event—such as App Version, Platform, Player Level, and Resource Balances—ensuring consistent cross-segmentation[cite: 163, 164, 167, 171, 285, 286].

---
**Strategic Importance:** These documents act as the "Single Source of Truth." [cite_start]The data models in folders `01` and `02` and the visualizations in folder `03` are direct implementations of the logic and event definitions established here[cite: 16, 109, 224, 230].
