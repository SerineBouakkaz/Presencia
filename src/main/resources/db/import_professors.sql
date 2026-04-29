-- ============================================================
-- Professors / Teachers Import - Presencia System
-- Université Amar Telidji - Laghouat
-- Département Informatique
-- Default password for all: Presencia@2026
-- ============================================================

USE presencia_db;

INSERT INTO professors (name, email, password, department) VALUES
('Saida Sarra Boudouh',    'boudouh.sarra@univ-laghouat.dz',       '$2a$10$dPkFHd1vyDlxhaI5UGf53.SO5AHcjgPS9WDxn2GHOgsGNOrGKpUBq', 'Informatique'),
('Youssra Cheriguene',     'cheriguene.youssra@univ-laghouat.dz',   '$2a$10$mJbQ6l4AlOkpgeLj.o7vN.wEzFt1CQt.aNY6FEEBTgq3XvdxPQEJ.', 'Informatique'),
('Tarek Bouzid',           'bouzid.tarek@univ-laghouat.dz',         '$2a$10$s8OxX9w53LwHobO4.L4MnerHmDmK/bZIzpb2m/1tcCdaWvZ49jfoK', 'Informatique'),
('Hicham Madjidi',         'madjidi.hicham@univ-laghouat.dz',       '$2a$10$k2j2iA2ovoKYxba74dmIDualCwG.urLmvIfJJufAxu999nB9WJyFu', 'Informatique'),
('Messaoud Babaghayou',    'babaghayou.messaoud@univ-laghouat.dz',  '$2a$10$83vtjFzqhOjE3Tns1OGCR.cvcROUl5qedGVwTIY2HRZjCZymzoJF2', 'Informatique'),
('Tahar Allaoui',          'allaoui.tahar@univ-laghouat.dz',        '$2a$10$dc/SAEJZLKaPP5XrfDQbh.DPbm80LJ/uLetNPniWp43sxEs6jQUwG', 'Informatique'),
('Mohamed Al Habib Maicha','maicha.habib@univ-laghouat.dz',         '$2a$10$1Jx8GdOyi.kTdUojwg/4h.U1Si9iChcT7R2cavPmYXRis81t1Da8G', 'Informatique'),
('Mohamed Lahcen Bensaad', 'bensaad.lahcen@univ-laghouat.dz',       '$2a$10$7Q.2oatvyxlwQ3ATiMpm2ujExsHnpb0ms6j37wK/tY1YDk81gku/y', 'Informatique')
ON DUPLICATE KEY UPDATE id=id;

-- Verify
SELECT id, name, email, department FROM professors ORDER BY name;
