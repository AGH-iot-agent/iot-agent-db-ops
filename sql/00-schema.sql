
-- 00-schema.sql: Full schema for IoT Agent DB

CREATE TABLE IF NOT EXISTS users (
  id BIGSERIAL PRIMARY KEY,
  username VARCHAR(64) UNIQUE NOT NULL,
  password_hash VARCHAR(256) NOT NULL,
  email VARCHAR(128) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS devices (
  id VARCHAR(128) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  status VARCHAR(32) NOT NULL DEFAULT 'ACTIVE',
  krakow_zone VARCHAR(64) NOT NULL DEFAULT 'KROWODRZA',
  sample_interval_ms INTEGER NOT NULL DEFAULT 5000,
  temperature_sensor_enabled BOOLEAN NOT NULL DEFAULT true,
  humidity_sensor_enabled BOOLEAN NOT NULL DEFAULT true,
  air_quality_sensor_enabled BOOLEAN NOT NULL DEFAULT true,
  map_sensor_enabled BOOLEAN NOT NULL DEFAULT true
);


CREATE TABLE IF NOT EXISTS alerts (
  id BIGSERIAL PRIMARY KEY,
  device_id VARCHAR(128) NOT NULL,
  severity VARCHAR(16) NOT NULL,
  message TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  active BOOLEAN DEFAULT false,
  anomaly BOOLEAN,
  anomaly_score NUMERIC,
  krakow_zone VARCHAR(255),
  leak BOOLEAN
);

CREATE INDEX IF NOT EXISTS idx_alerts_device_id ON alerts(device_id);
CREATE INDEX IF NOT EXISTS idx_alerts_created_at ON alerts(created_at);
