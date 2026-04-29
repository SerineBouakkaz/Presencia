CREATE DATABASE IF NOT EXISTS presencia_db
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE presencia_db;

CREATE TABLE IF NOT EXISTS professors (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    department VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS students (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    student_code VARCHAR(20) NOT NULL UNIQUE,
    department VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS courses (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(100) NOT NULL,
    professor_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_course_professor
        FOREIGN KEY (professor_id) REFERENCES professors(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS sessions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    course_id BIGINT NOT NULL,
    session_date DATE NOT NULL,
    time_slot VARCHAR(30) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_session_course
        FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    INDEX idx_session_course_date (course_id, session_date)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS attendance_records (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    session_id BIGINT NOT NULL,
    student_id BIGINT NOT NULL,
    status ENUM('present','absent','late','excused') NOT NULL DEFAULT 'present',
    note TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_record_session
        FOREIGN KEY (session_id) REFERENCES sessions(id) ON DELETE CASCADE,
    CONSTRAINT fk_record_student
        FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    UNIQUE KEY uk_session_student (session_id, student_id)
) ENGINE=InnoDB;

-- ── Seed data ──

-- Test professor (password = "password", BCrypt-encoded)
INSERT INTO professors (name, email, password, department) VALUES
('Dr. Amina Benali', 'amina@univ.edu',
 '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7GAt6KUau',
 'Computer Science')
ON DUPLICATE KEY UPDATE id=id;

SET @pid = (SELECT id FROM professors WHERE email='amina@univ.edu' LIMIT 1);

-- Sample students
INSERT INTO students (first_name, last_name, student_code, department, email, phone) VALUES
('Amira', 'Boudjemaa',   'STU-001', 'Computer Science', 'amira@univ.edu',   '0551000001'),
('Yacine','Chabane',     'STU-002', 'Computer Science', 'yacine@unif.edu',  '0551000002'),
('Lina',  'Hamidouche',  'STU-003', 'Computer Science', 'lina@univ.edu',    '0551000003'),
('Omar',  'Benali',      'STU-004', 'Computer Science', 'omar@univ.edu',    '0551000004'),
('Sara',  'Meziane',     'STU-005', 'Computer Science', 'sara@univ.edu',    '0551000005'),
('Riad',  'Khaldi',      'STU-006', 'Computer Science', 'riad@univ.edu',    '0551000006'),
('Nour',  'Belkacemi',   'STU-007', 'Computer Science', 'nour@univ.edu',    '0551000007'),
('Karim', 'Zerrouk',     'STU-008', 'Computer Science', 'karim@univ.edu',   '0551000008'),
('Meriem','Touati',      'STU-009', 'Computer Science', 'meriem@univ.edu',  '0551000009'),
('Anis',  'Djaballah',   'STU-010', 'Computer Science', 'anis@univ.edu',    '0551000010')
ON DUPLICATE KEY UPDATE id=id;

-- Sample courses
INSERT INTO courses (name, department, professor_id) VALUES
('Math 3A', 'Computer Science', @pid),
('Math 3B', 'Computer Science', @pid),
('Algorithms', 'Computer Science', @pid)
ON DUPLICATE KEY UPDATE id=id;

-- ── How to add a new teacher (admin only) ──
-- The temporary password below is "temp1234" (BCrypt encoded).
-- On first login the teacher will be forced to change it.
--
-- INSERT INTO professors (name, email, password, department, role, force_password_change)
-- VALUES ('Dr. Example', 'teacher@univ.dz',
--         '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7GAt6KUau',
--         'Computer Science', 'professor', TRUE);
