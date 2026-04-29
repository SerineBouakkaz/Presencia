package com.presencia.dao;

import com.presencia.model.Course;
import java.util.List;
import java.util.Optional;

public interface CourseDao {
    List<Course> findByProfessorId(Long professorId);
    Optional<Course> findById(Long id);
    void insert(Course course);
    void update(Course course);
    void deleteById(Long id);
}
