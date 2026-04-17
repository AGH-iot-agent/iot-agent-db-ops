INSERT INTO users (username, password_hash, email)
VALUES ('admin', '$2b$10$Io1vrrLw6CCe4JAOniGT5O9Kx5Gq25MLTDWhLauPDwbl.6x/mB0lO', 'admin@iotag.local')
ON CONFLICT (username) DO UPDATE SET password_hash = EXCLUDED.password_hash, email = EXCLUDED.email;
-- Hasło: admin123

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

INSERT INTO alerts (device_id, severity, message)
VALUES
  ('dev-001', 'HIGH',   'Temperature threshold exceeded'),
  ('dev-002', 'MEDIUM', 'Battery level below 30%'),
  ('dev-003', 'LOW',    'Heartbeat delayed'),
  ('dev-010', 'HIGH',   'Air quality sensor offline'),
  ('dev-020', 'MEDIUM', 'Humidity spike detected')
ON CONFLICT DO NOTHING;
