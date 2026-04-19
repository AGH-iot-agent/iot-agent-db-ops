
-- 10-seed-dev.sql: Seed data for IoT Agent DB

INSERT INTO devices (id, name, status, krakow_zone, sample_interval_ms,
                     temperature_sensor_enabled, humidity_sensor_enabled,
                     air_quality_sensor_enabled, map_sensor_enabled)
SELECT
  'dev-' || LPAD(i::text, 3, '0'),
  'IoT Device ' || LPAD(i::text, 3, '0'),
  CASE WHEN i % 10 = 0 THEN 'INACTIVE' ELSE 'ACTIVE' END,
  (ARRAY['KROWODRZA','NOWA_HUTA','PODGORZE','SRODMIESCIE','BRONOWICE',
         'PRADNIK_BIALY','PRADNIK_CZERWONY','DEBNIKI','LAGIEWNIKI','BOREK_FALECKI'])[(((i-1) % 10) + 1)],
  CASE WHEN i % 3 = 0 THEN 10000 WHEN i % 3 = 1 THEN 5000 ELSE 2000 END,
  true, true, true, true
FROM generate_series(1, 100) AS t(i)
ON CONFLICT (id) DO NOTHING;

INSERT INTO alerts (device_id, severity, message, created_at, active, anomaly_score, krakow_zone, leak)
VALUES
  ('dev-001', 'HIGH',   'Temperature threshold exceeded', NOW(), true, 0.95, 'KROWODRZA', true),
  ('dev-002', 'MEDIUM', 'Battery level below 30%', NOW(), false, 0.12, 'NOWA_HUTA', false),
  ('dev-003', 'LOW',    'Heartbeat delayed', NOW(), false, NULL, 'PODGORZE', false),
  ('dev-010', 'HIGH',   'Air quality sensor offline', NOW(), true, 0.88, 'SRODMIESCIE', true),
  ('dev-020', 'MEDIUM', 'Humidity spike detected', NOW(), false, 0.33, 'BRONOWICE', false)
ON CONFLICT DO NOTHING;
