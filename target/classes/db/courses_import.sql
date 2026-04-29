-- ============================================================
-- Courses Import - Presencia System
-- Université Amar Telidji - Laghouat
-- ============================================================

USE presencia_db;

-- Saida Sarra Boudouh → Web Development
INSERT INTO courses (name, department, professor_id)
SELECT 'Web Development', 'Informatique', id FROM professors WHERE email = 'boudouh.sarra@univ-laghouat.dz' LIMIT 1
ON DUPLICATE KEY UPDATE id=id;

-- Youssra Cheriguene → Object Oriented Programming
INSERT INTO courses (name, department, professor_id)
SELECT 'Object Oriented Programming', 'Informatique', id FROM professors WHERE email = 'cheriguene.youssra@univ-laghouat.dz' LIMIT 1
ON DUPLICATE KEY UPDATE id=id;

-- Tarek Bouzid → System Operating
INSERT INTO courses (name, department, professor_id)
SELECT 'System Operating', 'Informatique', id FROM professors WHERE email = 'bouzid.tarek@univ-laghouat.dz' LIMIT 1
ON DUPLICATE KEY UPDATE id=id;

-- Hicham Madjidi → Network
INSERT INTO courses (name, department, professor_id)
SELECT 'Network', 'Informatique', id FROM professors WHERE email = 'madjidi.hicham@univ-laghouat.dz' LIMIT 1
ON DUPLICATE KEY UPDATE id=id;

-- Messaoud Babaghayou → Theory of Languages
INSERT INTO courses (name, department, professor_id)
SELECT 'Theory of Languages', 'Informatique', id FROM professors WHERE email = 'babaghayou.messaoud@univ-laghouat.dz' LIMIT 1
ON DUPLICATE KEY UPDATE id=id;

-- Tahar Allaoui → System Operating
INSERT INTO courses (name, department, professor_id)
SELECT 'System Operating', 'Informatique', id FROM professors WHERE email = 'allaoui.tahar@univ-laghouat.dz' LIMIT 1
ON DUPLICATE KEY UPDATE id=id;

-- Mohamed Lahcen Bensaad → Theory of Languages
INSERT INTO courses (name, department, professor_id)
SELECT 'Theory of Languages', 'Informatique', id FROM professors WHERE email = 'bensaad.lahcen@univ-laghouat.dz' LIMIT 1
ON DUPLICATE KEY UPDATE id=id;

-- Verify
SELECT c.name as course, p.name as professor FROM courses c JOIN professors p ON c.professor_id = p.id ORDER BY p.name;
