package com.presencia.service;

import com.presencia.dao.CourseDao;
import com.presencia.model.Course;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CourseService {

    private final CourseDao courseDao;

    public CourseService(CourseDao courseDao) {
        this.courseDao = courseDao;
    }

    public List<Course> findByProfessor(Long professorId) {
        return courseDao.findByProfessorId(professorId);
    }

    public Course findById(Long id) {
        return courseDao.findById(id).orElse(null);
    }

    public void save(Course course) {
        if (course.getId() == null || course.getId() == 0) {
            courseDao.insert(course);
        } else {
            courseDao.update(course);
        }
    }

    public void delete(Long id) {
        courseDao.deleteById(id);
    }
}
