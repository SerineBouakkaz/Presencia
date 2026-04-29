package com.presencia.dao;

import com.presencia.model.Student;
import java.util.List;
import java.util.Optional;

public interface StudentDao {
    List<Student> findAllByDepartment(String department);
    List<Student> findAllByDepartmentPaged(String department, int offset, int limit, String query);
    List<Student> findByGroup(String department, String groupName);
    List<String> findGroupsByDepartment(String department);
    List<Student> findAll();
    List<Student> findAllPaged(String query, int offset, int limit);
    int countAllByDepartment(String department, String query);
    int countAll(String query);
    Optional<Student> findById(Long id);
    Optional<Student> findByStudentCode(String code);
    void insert(Student student);
    void update(Student student);
    void deleteById(Long id);
}
