
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

INSERT INTO alerts (
  timestamp, device_id, severity, reason, temperature, threshold, leak, anomaly, anomaly_score, krakow_zone, active
)
VALUES
  (EXTRACT(EPOCH FROM NOW())::BIGINT * 1000, 'dev-001', 'HIGH',   'Temperature threshold exceeded', 38.5, 30.0, true, true, 0.95, 'KROWODRZA', true),
  (EXTRACT(EPOCH FROM NOW())::BIGINT * 1000, 'dev-002', 'MEDIUM', 'Battery level below 30%', 22.1, 30.0, false, false, 0.12, 'NOWA_HUTA', false),
  (EXTRACT(EPOCH FROM NOW())::BIGINT * 1000, 'dev-003', 'LOW',    'Heartbeat delayed', 19.8, 30.0, false, false, 0.0, 'PODGORZE', false),
  (EXTRACT(EPOCH FROM NOW())::BIGINT * 1000, 'dev-010', 'HIGH',   'Air quality sensor offline', 35.2, 30.0, true, true, 0.88, 'SRODMIESCIE', true),
  (EXTRACT(EPOCH FROM NOW())::BIGINT * 1000, 'dev-020', 'MEDIUM', 'Humidity spike detected', 28.7, 30.0, false, false, 0.33, 'BRONOWICE', false)
ON CONFLICT DO NOTHING;
