-- Run this once in your MySQL to add the new columns and alerts table

-- 1. Add role column to professors (defaults to 'professor' for existing rows)
ALTER TABLE professors
  ADD COLUMN IF NOT EXISTS role VARCHAR(20) NOT NULL DEFAULT 'professor';

-- 2. Make s.boudouh an admin (optional — or use the register page)
-- UPDATE professors SET role = 'admin' WHERE email = 's.boudouh@lagh-univ.dz';

-- 3. Create alerts table
CREATE TABLE IF NOT EXISTS alerts (
    id           BIGINT AUTO_INCREMENT PRIMARY KEY,
    type         VARCHAR(50) NOT NULL,
    message      TEXT NOT NULL,
    resolved     BOOLEAN NOT NULL DEFAULT FALSE,
    student_id   BIGINT NULL,
    professor_id BIGINT NULL,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_alert_type (type),
    INDEX idx_alert_resolved (resolved)
) ENGINE=InnoDB;
