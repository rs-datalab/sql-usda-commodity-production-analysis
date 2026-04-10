# USDA Commodity Production — SQL Business Analysis (SQLite)

This project demonstrates a practical SQL analytics workflow for USDA-style production data across states and years. The goal is to answer stakeholder questions that come up in reporting, planning, and cross-commodity coordination.

## Business Context
A USDA analytics team tracks production for multiple commodities. Leadership needs quick answers to:
- annual reporting totals and summary statistics
- which states are high-performing for a given commodity and month
- cross-commodity overlaps to coordinate planning
- data coverage gaps that could impact rollups and dashboards
- longer-term trends to support forecasting discussions

## Highlights (sample outputs)
- Total milk production (2023): 91,812,000,000  
- Average honey production (2022): 3,133,275  
- Peak yogurt production value (2022): 793,256,000  
- States missing milk records (2023): 26  
- Top cheese producers in April 2023 include Wisconsin (289,699,000) and California (208,807,000); one high-production record requires lookup QA.

## Dataset
Kaggle dataset: **“USA Department of Agriculture’s (USDA) Database”** (CC0 / Public Domain).  
Source: https://www.kaggle.com/datasets/jacopoferretti/usa-department-of-agricultures-usda-database

## Tech Stack
- SQLite
- DBeaver (used for database creation + CSV import)
- SQL scripts (schema, cleanup, analysis)

## Contents
```text
.
├── sql/
│   ├── 00_schema.sql
│   ├── 02_clean.sql
│   └── 10_analysis.sql
├── report.md
├── README.md

