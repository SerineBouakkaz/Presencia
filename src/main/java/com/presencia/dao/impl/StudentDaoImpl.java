package com.presencia.dao.impl;

import com.presencia.dao.StudentDao;
import com.presencia.model.Student;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Repository
public class StudentDaoImpl implements StudentDao {

    private final JdbcTemplate jdbcTemplate;
    private final RowMapper<Student> rowMapper = this::mapRow;

    public StudentDaoImpl(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private Student mapRow(ResultSet rs, int rowNum) throws SQLException {
        Student s = new Student();
        s.setId(rs.getLong("id"));
        s.setFirstName(rs.getString("first_name"));
        s.setLastName(rs.getString("last_name"));
        s.setStudentCode(rs.getString("student_code"));
        s.setDepartment(rs.getString("department"));
        s.setEmail(rs.getString("email"));
        s.setPhone(rs.getString("phone"));
        try { s.setGroupName(rs.getString("group_name")); } catch (Exception ignored) {}
        return s;
    }

    @Override
    public List<Student> findAllByDepartment(String department) {
        return jdbcTemplate.query("SELECT * FROM students WHERE department LIKE ? ORDER BY group_name, last_name, first_name",
                rowMapper, department + "%");
    }

    @Override
    public List<Student> findByGroup(String department, String groupName) {
        return jdbcTemplate.query(
            "SELECT * FROM students WHERE department LIKE ? AND group_name = ? ORDER BY last_name, first_name",
            rowMapper, department + "%", groupName);
    }

    @Override
    public List<String> findGroupsByDepartment(String department) {
        return jdbcTemplate.queryForList(
            "SELECT DISTINCT group_name FROM students WHERE department LIKE ? AND group_name IS NOT NULL ORDER BY group_name",
            String.class, department + "%");
    }

    @Override
    public List<Student> findAllByDepartmentPaged(String department, int offset, int limit, String query) {
        StringBuilder sql = new StringBuilder("SELECT * FROM students WHERE department LIKE ?");
        List<Object> params = new ArrayList<>();
        params.add(department + "%");
        if (query != null && !query.isEmpty()) {
            sql.append(" AND (first_name LIKE ? OR last_name LIKE ? OR student_code LIKE ?)");
            String q = "%" + query + "%";
            params.add(q); params.add(q); params.add(q);
        }
        sql.append(" ORDER BY group_name, last_name, first_name LIMIT ? OFFSET ?");
        params.add(limit); params.add(offset);
        return jdbcTemplate.query(sql.toString(), rowMapper, params.toArray());
    }

    @Override
    public int countAllByDepartment(String department, String query) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM students WHERE department LIKE ?");
        List<Object> params = new ArrayList<>();
        params.add(department + "%");
        if (query != null && !query.isEmpty()) {
            String q = "%" + query + "%";
            sql.append(" AND (first_name LIKE ? OR last_name LIKE ? OR student_code LIKE ?)");
            params.add(q); params.add(q); params.add(q);
        }
        Integer count = jdbcTemplate.queryForObject(sql.toString(), Integer.class, params.toArray());
        return count != null ? count : 0;
    }

    @Override
    public Optional<Student> findById(Long id) {
        try {
            return Optional.of(jdbcTemplate.queryForObject("SELECT * FROM students WHERE id = ?", rowMapper, id));
        } catch (Exception e) { return Optional.empty(); }
    }

    @Override
    public Optional<Student> findByStudentCode(String code) {
        try {
            return Optional.of(jdbcTemplate.queryForObject("SELECT * FROM students WHERE student_code = ?", rowMapper, code));
        } catch (Exception e) { return Optional.empty(); }
    }

    @Override
    public void insert(Student student) {
        jdbcTemplate.update(
            "INSERT INTO students (first_name, last_name, student_code, department, email, phone, group_name) VALUES (?, ?, ?, ?, ?, ?, ?)",
            student.getFirstName(), student.getLastName(), student.getStudentCode(),
            student.getDepartment(), student.getEmail(), student.getPhone(), student.getGroupName());
    }

    @Override
    public void update(Student student) {
        jdbcTemplate.update(
            "UPDATE students SET first_name=?, last_name=?, student_code=?, department=?, email=?, phone=?, group_name=? WHERE id=?",
            student.getFirstName(), student.getLastName(), student.getStudentCode(),
            student.getDepartment(), student.getEmail(), student.getPhone(), student.getGroupName(), student.getId());
    }

    @Override
    public void deleteById(Long id) {
        jdbcTemplate.update("DELETE FROM students WHERE id = ?", id);
    }

    @Override
    public List<Student> findAll() {
        return jdbcTemplate.query("SELECT * FROM students ORDER BY group_name, last_name", rowMapper);
    }

    @Override
    public List<Student> findAllPaged(String query, int offset, int limit) {
        StringBuilder sql = new StringBuilder("SELECT * FROM students WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (query != null && !query.isEmpty()) {
            sql.append(" AND (first_name LIKE ? OR last_name LIKE ? OR student_code LIKE ?)");
            String q = "%" + query + "%";
            params.add(q); params.add(q); params.add(q);
        }
        sql.append(" ORDER BY group_name, last_name LIMIT ? OFFSET ?");
        params.add(limit); params.add(offset);
        return jdbcTemplate.query(sql.toString(), rowMapper, params.toArray());
    }

    @Override
    public int countAll(String query) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM students WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (query != null && !query.isEmpty()) {
            String q = "%" + query + "%";
            sql.append(" AND (first_name LIKE ? OR last_name LIKE ? OR student_code LIKE ?)");
            params.add(q); params.add(q); params.add(q);
        }
        Integer count = jdbcTemplate.queryForObject(sql.toString(), Integer.class, params.toArray());
        return count != null ? count : 0;
    }
}
