-- Migration: Add student_password column for student self-registration
ALTER TABLE students ADD COLUMN IF NOT EXISTS student_password VARCHAR(255) NULL;

-- Migration: Add role column to professors if not exists
ALTER TABLE professors ADD COLUMN IF NOT EXISTS role VARCHAR(20) NOT NULL DEFAULT 'professor';
ALTER TABLE professors ADD COLUMN IF NOT EXISTS is_admin BOOLEAN NOT NULL DEFAULT FALSE;

-- Add force_password_change flag to professors table
-- Set TRUE for any new teacher added by admin; they must set their own password on first login
ALTER TABLE professors ADD COLUMN IF NOT EXISTS force_password_change BOOLEAN NOT NULL DEFAULT FALSE;
