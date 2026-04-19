-- Migration: add 'active' column to 'alerts' table
ALTER TABLE alerts ADD COLUMN IF NOT EXISTS active BOOLEAN DEFAULT false;