package com.presencia.dao.impl;

import com.presencia.dao.ProfessorDao;
import com.presencia.model.Professor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

@Repository
public class ProfessorDaoImpl implements ProfessorDao {

    private final JdbcTemplate jdbcTemplate;

    private final RowMapper<Professor> rowMapper = this::mapRow;

    public ProfessorDaoImpl(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private Professor mapRow(ResultSet rs, int rowNum) throws SQLException {
        Professor p = new Professor();
        p.setId(rs.getLong("id"));
        p.setName(rs.getString("name"));
        p.setEmail(rs.getString("email"));
        p.setPassword(rs.getString("password"));
        p.setDepartment(rs.getString("department"));
        try { p.setRole(rs.getString("role")); } catch (Exception ignored) {}
        try { p.setForcePasswordChange(rs.getBoolean("force_password_change")); } catch (Exception ignored) {}
        return p;
    }

    @Override
    public Optional<Professor> findByEmail(String email) {
        try {
            return Optional.of(jdbcTemplate.queryForObject(
                    "SELECT * FROM professors WHERE LOWER(email) = LOWER(?)", rowMapper, email));
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    @Override
    public Optional<Professor> findById(Long id) {
        try {
            return Optional.of(jdbcTemplate.queryForObject(
                    "SELECT * FROM professors WHERE id = ?", rowMapper, id));
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    @Override
    public List<Professor> findAll() {
        return jdbcTemplate.query("SELECT * FROM professors ORDER BY name", rowMapper);
    }

    @Override
    public void update(Professor professor) {
        String email = professor.getEmail() != null ? professor.getEmail().trim().toLowerCase() : professor.getEmail();
        jdbcTemplate.update(
            "UPDATE professors SET name=?, email=?, department=? WHERE id=?",
            professor.getName(), email, professor.getDepartment(), professor.getId());
    }
}
