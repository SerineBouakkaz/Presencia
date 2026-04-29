package com.presencia.dao;

import com.presencia.model.Professor;
import java.util.List;
import java.util.Optional;

public interface ProfessorDao {
    Optional<Professor> findByEmail(String email);
    Optional<Professor> findById(Long id);
    List<Professor> findAll();
    void update(Professor professor);
}
