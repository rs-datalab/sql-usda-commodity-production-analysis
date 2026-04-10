# USDA Commodity Production Analysis

## Overview

This project demonstrates a practical SQL analytics workflow for USDA-style production data across states and years. It is structured around schema creation, data cleaning, and business-focused analysis designed to answer stakeholder questions related to reporting, planning, and cross-commodity coordination.

The project shows how SQL can be used not only for querying data, but also for building a repeatable workflow that supports decision-making.

## Objective

The goal of this project is to:

- create a clean SQL workflow from schema setup to analysis
- answer business-style questions using production data across commodities
- identify high-performing states and trends across time
- surface cross-commodity overlaps for planning purposes
- detect data coverage issues that could affect reporting quality

## Dataset

**Source:** Kaggle — USA Department of Agriculture’s (USDA) Database  
https://www.kaggle.com/datasets/jacopoferretti/usa-department-of-agricultures-usda-database

The project uses production data for multiple commodities, including:

- milk
- cheese
- coffee
- honey
- yogurt
- state lookup data

The dataset is used to simulate realistic stakeholder questions around reporting, market targeting, and data quality.

## Tools

- SQL
- SQLite
- DBeaver

## What This Project Does

The workflow is split into three main stages:

- creates tables for each production dataset
- defines a lookup table for state information
- adds indexes to support joins and filtered analysis
- normalizes numeric `Value` fields
- removes comma formatting from imported values
- standardizes values for downstream analysis
- calculates annual totals and summary statistics
- identifies top-producing states for a given commodity and period
- creates all-state reporting views using `LEFT JOIN` and `COALESCE`
- checks cross-commodity overlap across states and years
- identifies missing records that could affect reporting coverage
- examines longer-term production trends

## Highlights

Sample results from the analysis include:

- total milk production in 2023: **91,812,000,000**
- average honey production in 2022: **3,133,275**
- peak yogurt production value in 2022: **793,256,000**
- **26 states** in the lookup table have no milk production record for 2023
- top cheese-producing states in April 2023 include:
  - Wisconsin: **289,699,000**
  - California: **208,807,000**
- one high-production cheese record requires lookup QA because it could not be mapped cleanly to a state

## Outputs

This project includes:

- `00_schema.sql` — table creation and indexing
- `01_clean.sql` — numeric cleanup and normalization
- `10_analysis.sql` — stakeholder-focused analytical queries
- `report.md` — written business summary of findings

## Project Structure

```text
sql-usda-commodity-production-analysis/
├── sql/
│   ├── 00_schema.sql
│   ├── 01_clean.sql
│   └── 10_analysis.sql
├── README.md
└── report.md
```

## How to Run

1. Download the source CSV files from the Kaggle dataset.
2. Create the database and tables using `sql/00_schema.sql`.
3. Import the CSV files into the corresponding tables.
4. Run `sql/01_clean.sql` to normalize the numeric values.
5. Run `sql/10_analysis.sql` to reproduce the reporting and analytical queries.
6. Review `report.md` for a written summary of the outputs.

This project can be run in:

- SQLite CLI
- DBeaver
- DB Browser for SQLite

## Notes

- The workflow is written specifically for SQLite syntax.
- The `state_lookup` table is used to support state-level labeling and coverage analysis.
- Some records require QA because missing or invalid lookup keys affect state attribution.
- The results reflect dataset coverage and should be interpreted with that limitation in mind.
- This project focuses on query design, analysis structure, and reporting logic rather than dashboarding.

## Future Improvements

Potential next steps include:

- adding reusable SQL views for yearly totals and state-year summaries
- introducing year-over-year change metrics
- creating anomaly checks for unusually high or missing production values
- expanding the project into a simple dashboard or reporting layer
- adding automated QA checks for blank or invalid state keys