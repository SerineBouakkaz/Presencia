-- Update professor department to match imported students
UPDATE professors SET department = 'Informatique' WHERE email = 'amina@univ.edu';

-- Also update the test professor
UPDATE professors SET department = 'Informatique' WHERE email = 's.boudouh@lagh-univ.dz';