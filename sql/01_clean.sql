-- ============================================
-- Cleaning: normalize numeric Value fields
-- - Removes commas in numbers like "1,234,567"
-- - Casts back to INTEGER
-- - Leaves NULLs as NULL
-- ============================================

-- NOTE:
-- Even if Value was imported as INTEGER, some CSV imports bring it in as TEXT.
-- This makes the conversion safe either way.

UPDATE cheese_production
SET Value = CAST(REPLACE(CAST(Value AS TEXT), ',', '') AS INTEGER)
WHERE Value IS NOT NULL;

UPDATE honey_production
SET Value = CAST(REPLACE(CAST(Value AS TEXT), ',', '') AS INTEGER)
WHERE Value IS NOT NULL;

UPDATE milk_production
SET Value = CAST(REPLACE(CAST(Value AS TEXT), ',', '') AS INTEGER)
WHERE Value IS NOT NULL;

UPDATE coffee_production
SET Value = CAST(REPLACE(CAST(Value AS TEXT), ',', '') AS INTEGER)
WHERE Value IS NOT NULL;

UPDATE egg_production
SET Value = CAST(REPLACE(CAST(Value AS TEXT), ',', '') AS INTEGER)
WHERE Value IS NOT NULL;

UPDATE yogurt_production
SET Value = CAST(REPLACE(CAST(Value AS TEXT), ',', '') AS INTEGER)
WHERE Value IS NOT NULL;

-- Optional sanity checks (returns should be 0 rows if clean)
-- SELECT 'cheese' AS table_name, COUNT(*) AS bad_rows
-- FROM cheese_production
-- WHERE CAST(Value AS TEXT) LIKE '%,%';
