INSERT INTO devices (device_id, name, status)
VALUES
  ('sim-001', 'Simulator 001', 'ACTIVE'),
  ('sim-002', 'Simulator 002', 'ACTIVE'),
  ('sim-003', 'Simulator 003', 'INACTIVE')
ON CONFLICT (device_id) DO NOTHING;

INSERT INTO alerts (device_id, severity, message)
VALUES
  ('sim-001', 'HIGH', 'Temperature threshold exceeded'),
  ('sim-002', 'MEDIUM', 'Battery level below 30%'),
  ('sim-003', 'LOW', 'Heartbeat delayed')
ON CONFLICT DO NOTHING;
