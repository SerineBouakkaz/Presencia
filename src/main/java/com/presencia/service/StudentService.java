package com.presencia.service;

import com.presencia.dao.StudentDao;
import com.presencia.model.Student;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class StudentService {

    private final StudentDao studentDao;

    public StudentService(StudentDao studentDao) {
        this.studentDao = studentDao;
    }

    public List<Student> findAll(String department) {
        if (department == null) return studentDao.findAll();
        return studentDao.findAllByDepartment(department);
    }

    public List<Student> findByGroup(String department, String groupName) {
        return studentDao.findByGroup(department, groupName);
    }

    public List<String> findGroups(String department) {
        if (department == null) return List.of();
        return studentDao.findGroupsByDepartment(department);
    }

    public List<Student> findAllPaged(String department, int page, int limit, String query) {
        int offset = Math.max(0, page - 1) * limit;
        if (department == null) return studentDao.findAllPaged(query, offset, limit);
        return studentDao.findAllByDepartmentPaged(department, offset, limit, query);
    }

    public int countAll(String department, String query) {
        if (department == null) return studentDao.countAll(query);
        return studentDao.countAllByDepartment(department, query);
    }

    public Student findById(Long id) {
        return studentDao.findById(id).orElse(null);
    }

    public void save(Student student, String department) {
        student.setDepartment(department);
        if (student.getId() == null || student.getId() == 0) {
            studentDao.insert(student);
        } else {
            studentDao.update(student);
        }
    }

    public void delete(Long id) {
        studentDao.deleteById(id);
    }
}
