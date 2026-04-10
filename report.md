# USDA Commodity Production — Business Case Analysis (SQLite)

**Role:** Data Scientist at USDA (United States Department of Agriculture)

**Context:** USDA tracks production of agricultural commodities across states and years to support planning, program prioritization, and stakeholder reporting.

**Dataset: Kaggle “USA Department of Agriculture’s (USDA) Database” (CC0 / Public Domain)**
- `milk_production`
- `cheese_production`
- `coffee_production`
- `honey_production`
- `yogurt_production`
- `state_lookup`

**Goal:** Generate reliable, meeting-ready insights using SQL—state-by-state production, trends, anomalies, and data-backed recommendations.

## Impact (Why this matters)
This analysis produces decision-ready outputs for USDA-style commodity planning:
- **Improves reporting integrity** by identifying coverage gaps (e.g., 26 states missing milk records in 2023).
- **Supports targeting** by identifying high-production states for a given commodity and period (cheese in April 2023).
- **Enables coordination** by quantifying cross-commodity overlap (yogurt in cheese-producing states).
- **Flags data quality risks** that would affect stakeholder-facing reports (blank `State_ANSI` preventing state attribution).
| Note: results reflect dataset coverage; some states/years may be missing.

**SQL source:** `sql/10_analysis.sql`  
**Environment:** SQLite + DBeaver  

---

## Business Definitions & Assumptions
To keep stakeholder answers consistent, this report uses:

- **High-production cheese state (April 2023):** `Value >= 100,000,000` for `Year = 2023` and `Period = 'APR'`, and the record must map to a valid state (`State_ANSI` not blank and present in `state_lookup`).
- **All-states snapshot:** `state_lookup LEFT JOIN production_table` with missing values filled as `0` using `COALESCE`.
- **Missing milk record (2023):** state exists in `state_lookup` but has **no matching row** in `milk_production` for 2023.
- **High-honey year:** annual honey total where `SUM(honey.Value) > 1,000,000`. (Used to provide cross-signal context for coffee.)

---

## 1) Executive Reporting: What are our headline production metrics?

| Metric | Value |
|---|---:|
| Total milk production (2023) | **91,812,000,000** |
| Average honey production (2022) | **3,133,275** |
| Peak yogurt production value (2022) | **793,256,000** |

**What this supports**
- Leadership reporting baselines and commodity-level scale context for planning.

---

## 2) Market Targeting: Which states are strongest for cheese in April 2023?

### High-production states (valid state mapping only)
State-targeting focuses on records that map cleanly to `state_lookup`.

| State | Production value |
|---|---:|
| **Wisconsin** | **289,699,000** |
| **California** | **208,807,000** |

**Count of high-production states (valid states):** **2**

### Data quality note (important)
The raw threshold query also returned **one additional high-production record** with:
- `State_ANSI` stored as **empty text (`''`)** and therefore **not attributable to any state**, producing a NULL join result.

**Why this matters**
- It’s a stakeholder reporting risk: a high-value record cannot be assigned to a state label.
- For targeting decisions, the record must be excluded until the key is corrected or identified.

**Recommended action**
- Add a QA check for blank/invalid `State_ANSI` values and enforce consistent key formats before publishing.

---

## 3) Stakeholder-Friendly Output: Can we produce a complete “all states” cheese snapshot (April 2023)?

Using an all-states table prevents missing states from disappearing in reports.

**Selected values from the all-states snapshot**
- Wisconsin: **289,699,000**
- California: **208,807,000**
- New Mexico: **79,038,000**
- Idaho: **86,452,000**
- Minnesota: **69,728,000**
- New York: **66,256,000**
- Pennsylvania: **39,420,000**
- New Jersey: **4,889,000**
- Delaware: **0**

**What this supports**
- A clean stakeholder table where every state appears and missing production shows as `0`.

---

## 4) Cross-Commodity Planning: Where do dairy commodities overlap?

### 4A) How much yogurt production occurred in cheese-producing states (2022)?
**Total yogurt production (2022) in states with cheese production (2022):**  
**1,171,095,000**

### 4B) Which states show yogurt production (2022) and cheese activity in 2023?
| State | Yogurt total (2022) |
|---|---:|
| **California** | **377,839,000** |
| **New York** | **793,256,000** |

**What this supports**
- Coordinated dairy initiatives in states with sustained activity across categories/years.

---

## 5) Reporting Integrity: Which states are missing milk production records in 2023?

**Coverage result**
- **26 states** appear in `state_lookup` but have **no milk record** in 2023.

**Examples (subset)**
ALABAMA, ALASKA, CONNECTICUT, DELAWARE, HAWAII, MASSACHUSETTS, NEW JERSEY, NORTH CAROLINA, RHODE ISLAND, WEST VIRGINIA, WYOMING.

*(Full list is reproducible from the SQL script.)*

**What this supports**
- Prevents publishing incomplete rollups without a coverage disclaimer.
- Enables QA and data pipeline investigation when gaps are unexpected.

---

## 6) Long-Range Planning: How has coffee production changed over time?

**Key points from yearly totals (1970–2016)**
- Late-1990s peak: **1999 = 10,000,000**
- **2011 = 7,600,000**
- **2015 total = 6,600,000**
- **2016 = 5,400,000**

**What this supports**
- Trend context for planning and forecasting discussions (baseline expectations).

---

## 7) Cross-Signal Context: What is coffee production during high-honey years?

**Average coffee production for years where annual honey exceeded 1,000,000:**  
**6,426,666.666666667**

**Interpretation**
- Not causal, but useful as a quick “year context” comparison across commodities.

---

## Recommendations (Next Steps)
### Immediate (reporting safety)
1. **Fix/flag invalid `State_ANSI` keys**  
   - Convert `''` to `NULL` and/or correct mapping where possible.
   - Add QA queries to track blank or non-numeric state codes.

2. **Standardize stakeholder tables as “complete coverage” outputs**  
   - Use `state_lookup LEFT JOIN ... COALESCE(Value, 0)` for any state-facing report.

### Near-term (planning enhancements)
3. Add YoY change metrics and simple anomaly flags for coffee/milk/honey.
4. Create reusable “yearly totals” and “state-year totals” views to reduce rework and support dashboards.

---

## Reproduce
0. Download the CSVs from the Kaggle dataset (linked in README).
1. Create tables (`sql/00_schema.sql`)
2. Import CSVs into tables (DBeaver import)
3. Normalize numeric fields (`sql/02_clean.sql`)
4. Run the business analysis (`sql/10_analysis.sql`)
