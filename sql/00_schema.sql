-- ============================================
-- SQLite schema for USDA commodity production
-- ============================================

PRAGMA foreign_keys = ON;

-- Drop in dependency order (safe for reruns)
DROP TABLE IF EXISTS cheese_production;
DROP TABLE IF EXISTS honey_production;
DROP TABLE IF EXISTS milk_production;
DROP TABLE IF EXISTS coffee_production;
DROP TABLE IF EXISTS egg_production;
DROP TABLE IF EXISTS yogurt_production;
DROP TABLE IF EXISTS state_lookup;

-- Core tables
CREATE TABLE IF NOT EXISTS cheese_production (
  Year         INTEGER,
  Period       TEXT,
  Geo_Level    TEXT,
  State_ANSI   INTEGER,
  Commodity_ID INTEGER,
  Domain       TEXT,
  Value        INTEGER
);

CREATE TABLE IF NOT EXISTS honey_production (
  Year         INTEGER,
  Geo_Level    TEXT,
  State_ANSI   INTEGER,
  Commodity_ID INTEGER,
  Value        INTEGER
);

CREATE TABLE IF NOT EXISTS milk_production (
  Year         INTEGER,
  Period       TEXT,
  Geo_Level    TEXT,
  State_ANSI   INTEGER,
  Commodity_ID INTEGER,
  Domain       TEXT,
  Value        INTEGER
);

CREATE TABLE IF NOT EXISTS coffee_production (
  Year         INTEGER,
  Period       TEXT,
  Geo_Level    TEXT,
  State_ANSI   INTEGER,
  Commodity_ID INTEGER,
  Value        INTEGER
);

CREATE TABLE IF NOT EXISTS egg_production (
  Year         INTEGER,
  Period       TEXT,
  Geo_Level    TEXT,
  State_ANSI   INTEGER,
  Commodity_ID INTEGER,
  Value        INTEGER
);

CREATE TABLE IF NOT EXISTS yogurt_production (
  Year         INTEGER,
  Period       TEXT,
  Geo_Level    TEXT,
  State_ANSI   INTEGER,
  Commodity_ID INTEGER,
  Domain       TEXT,
  Value        INTEGER
);

CREATE TABLE IF NOT EXISTS state_lookup (
  State      TEXT,
  State_ANSI INTEGER
);

-- Helpful indexes (makes joins and filters fast; looks professional)
CREATE INDEX IF NOT EXISTS idx_state_lookup_ansi
  ON state_lookup(State_ANSI);

CREATE INDEX IF NOT EXISTS idx_milk_year_state_period
  ON milk_production(Year, State_ANSI, Period);

CREATE INDEX IF NOT EXISTS idx_cheese_year_state_period
  ON cheese_production(Year, State_ANSI, Period);

CREATE INDEX IF NOT EXISTS idx_yogurt_year_state_period
  ON yogurt_production(Year, State_ANSI, Period);

CREATE INDEX IF NOT EXISTS idx_honey_year_state
  ON honey_production(Year, State_ANSI);

CREATE INDEX IF NOT EXISTS idx_coffee_year_state_period
  ON coffee_production(Year, State_ANSI, Period);

CREATE INDEX IF NOT EXISTS idx_egg_year_state_period
  ON egg_production(Year, State_ANSI, Period);
