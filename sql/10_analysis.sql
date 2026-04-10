/* ============================================================
   USDA Commodity Production | Business-Driven SQL Analysis
   Database: SQLite
   Tables: milk_production, cheese_production, coffee_production,
           honey_production, yogurt_production, state_lookup

   Purpose:
   Support USDA planning and reporting by answering common stakeholder
   questions across commodities: annual totals, state targeting, cross-
   commodity overlap, and data coverage gaps.
   ============================================================ */


/* ------------------------------------------------------------
   1) Executive reporting metrics (annual totals / summary stats)
   ------------------------------------------------------------ */

-- Annual milk production total (reporting)
SELECT SUM(mp.Value) AS total_milk_production
FROM milk_production mp
WHERE mp."Year" = 2023;

-- Honey production average for stakeholder briefing
SELECT AVG(hp.Value) AS avg_honey_production
FROM honey_production hp
WHERE hp."Year" = 2022;

-- Peak yogurt production value (helps identify scale / outliers)
SELECT MAX(yp.Value) AS max_yogurt_production
FROM yogurt_production yp
WHERE yp."Year" = 2022;


/* ------------------------------------------------------------
   2) Reference mapping (state names ↔ ANSI codes)
   ------------------------------------------------------------ */

-- State lookup table (reference for joining production tables to names)
SELECT sl.State_ANSI, sl.State
FROM state_lookup sl
ORDER BY sl.State;


/* ------------------------------------------------------------
   3) Market targeting: high-performing cheese states (April 2023)
   ------------------------------------------------------------ */

-- Identify states with cheese production >= 100M in April 2023
-- NOTE: SQLite strings use single quotes => 'APR'
-- High-production cheese states

SELECT cp.State_ANSI, sl.State, cp.Value
FROM cheese_production cp
JOIN state_lookup sl ON sl.State_ANSI = cp.State_ANSI
WHERE cp.Value >= 100000000
  AND cp.Year = 2023
  AND cp.Period = 'APR'
ORDER BY cp.Value DESC;



SELECT
  cp.Year, cp.Period, cp.Geo_Level, cp.State_ANSI, cp.Commodity_ID, cp.Domain, cp.Value
FROM cheese_production cp
WHERE cp.Value >= 100000000
  AND cp.Year = 2023
  AND cp.Period = 'APR'
  AND cp.State_ANSI IS NULL;


-- How many states meet the high-production threshold (April 2023)
SELECT COUNT(DISTINCT cp.State_ANSI) AS states_over_100m_apr_2023
FROM cheese_production cp
JOIN state_lookup sl ON sl.State_ANSI = cp.State_ANSI
WHERE cp.Value >= 100000000
  AND cp.Year = 2023
  AND cp.Period = 'APR';



/* ------------------------------------------------------------
   4) Full coverage view: cheese values for all states (April 2023)
      (include states even if they produced zero / have no record)
   ------------------------------------------------------------ */

-- State-by-state cheese snapshot (April 2023); missing values treated as 0
SELECT
  sl.State,
  COALESCE(cp.Value, 0) AS CheeseValue
FROM state_lookup sl
LEFT JOIN cheese_production cp
  ON cp.State_ANSI = sl.State_ANSI
  AND cp."Year" = 2023
  AND cp.Period = 'APR'
ORDER BY sl.State;

-- List of state ANSI codes present in April 2023 cheese rows
SELECT DISTINCT cp.State_ANSI
FROM cheese_production cp
WHERE cp."Year" = 2023
  AND cp.Period = 'APR'
ORDER BY cp.State_ANSI;


/* ------------------------------------------------------------
   5) Cross-commodity planning: dairy overlap (yogurt + cheese)
   ------------------------------------------------------------ */

-- Total yogurt production (2022) for states that have cheese production in 2022
SELECT SUM(yp.Value) AS total_yogurt_production_2022
FROM yogurt_production yp
JOIN (
  SELECT DISTINCT State_ANSI
  FROM cheese_production
  WHERE Year = 2022
) cp
  ON cp.State_ANSI = yp.State_ANSI
WHERE yp."Year" = 2022;

-- Yogurt totals by state (2022) where the same state shows cheese activity in 2023
-- (useful for aligning dairy division initiatives across years)
SELECT
  sl.State,
  SUM(yp.Value) AS TotalYogurt2022
FROM yogurt_production yp
JOIN state_lookup sl
  ON sl.State_ANSI = yp.State_ANSI
WHERE yp."Year" = 2022
  AND EXISTS (
    SELECT 1
    FROM cheese_production cp
    WHERE cp.State_ANSI = yp.State_ANSI
      AND cp."Year" = 2023
      AND cp.Value <> 0
  )
GROUP BY sl.State
ORDER BY sl.State;


/* ------------------------------------------------------------
   6) Cross-commodity planning: states producing both honey and milk (2022)
   ------------------------------------------------------------ */

-- Identify states with both honey and milk production in 2022
SELECT DISTINCT h.State_ANSI
FROM honey_production h
JOIN milk_production m ON h.State_ANSI = m.State_ANSI
WHERE h.Year = 2022
  AND m.Year = 2022
ORDER BY h.State_ANSI;


/* ------------------------------------------------------------
   7) Data coverage: states missing milk records in 2023
      (helps explain gaps in reporting and prevents bad rollups)
   ------------------------------------------------------------ */

-- States in lookup not present in milk_production for 2023
SELECT sl.State
FROM state_lookup sl
LEFT JOIN milk_production mp
  ON sl.State_ANSI = mp.State_ANSI
  AND mp."Year" = 2023
WHERE mp.State_ANSI IS NULL
ORDER BY sl.State;


/* ------------------------------------------------------------
   8) Coffee trend exploration (longitudinal planning)
   ------------------------------------------------------------ */

-- Coffee production totals by year (trend line input)
SELECT
  cp."Year",
  SUM(cp.Value) AS TotalCoffeeProd
FROM coffee_production cp
WHERE cp."Year" BETWEEN 1970 AND 2023
GROUP BY cp."Year"
ORDER BY cp."Year";

-- Detail view: coffee production records for 2015 (auditing / drill-down)
SELECT *
FROM coffee_production cp
WHERE cp."Year" = 2015;

-- Total coffee value for 2015 (quick annual metric)
SELECT SUM(cp.Value) AS total_coffee_2015
FROM coffee_production cp
WHERE cp."Year" = 2015;


/* ------------------------------------------------------------
   9) Cross-signal analysis: coffee production during high-honey years
      (tests whether certain years show broader agricultural shifts)
   ------------------------------------------------------------ */

-- Average coffee production for years where annual honey production exceeded 1M
SELECT AVG(cp.Value) AS AvgCoffeeProd
FROM coffee_production cp
WHERE cp."Year" IN (
  SELECT hp."Year"
  FROM honey_production hp
  GROUP BY hp."Year"
  HAVING SUM(hp.Value) > 1000000
);