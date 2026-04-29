package com.presencia.service;

import com.presencia.dao.ProfessorDao;
import com.presencia.model.Professor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class ProfessorService {

    private final ProfessorDao professorDao;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    public ProfessorService(ProfessorDao professorDao) {
        this.professorDao = professorDao;
    }

    public Optional<Professor> login(String email, String password) {
        Optional<Professor> professor = professorDao.findByEmail(email);
        if (professor.isPresent() && passwordEncoder.matches(password, professor.get().getPassword())) {
            return professor;
        }
        return Optional.empty();
    }

    public Optional<Professor> findById(Long id) {
        return professorDao.findById(id);
    }

    public void update(Professor professor) {
        professorDao.update(professor);
    }
}