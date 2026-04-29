package com.presencia.dao.impl;

import com.presencia.dao.CourseDao;
import com.presencia.model.Course;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

@Repository
public class CourseDaoImpl implements CourseDao {

    private final JdbcTemplate jdbcTemplate;

    private final RowMapper<Course> rowMapper = this::mapRow;

    public CourseDaoImpl(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private Course mapRow(ResultSet rs, int rowNum) throws SQLException {
        Course c = new Course();
        c.setId(rs.getLong("id"));
        c.setName(rs.getString("name"));
        c.setDepartment(rs.getString("department"));
        c.setProfessorId(rs.getLong("professor_id"));
        return c;
    }

    @Override
    public List<Course> findByProfessorId(Long professorId) {
        return jdbcTemplate.query("SELECT * FROM courses WHERE professor_id = ? ORDER BY name", rowMapper, professorId);
    }

    @Override
    public Optional<Course> findById(Long id) {
        try {
            return Optional.of(jdbcTemplate.queryForObject("SELECT * FROM courses WHERE id = ?", rowMapper, id));
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    @Override
    public void insert(Course course) {
        jdbcTemplate.update("INSERT INTO courses (name, department, professor_id) VALUES (?, ?, ?)",
                course.getName(), course.getDepartment(), course.getProfessorId());
    }

    @Override
    public void update(Course course) {
        jdbcTemplate.update("UPDATE courses SET name=?, department=? WHERE id=?",
                course.getName(), course.getDepartment(), course.getId());
    }

    @Override
    public void deleteById(Long id) {
        jdbcTemplate.update("DELETE FROM courses WHERE id = ?", id);
    }
}
