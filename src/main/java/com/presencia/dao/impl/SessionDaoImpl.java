package com.presencia.dao.impl;

import com.presencia.dao.SessionDao;
import com.presencia.model.Session;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public class SessionDaoImpl implements SessionDao {

    private final JdbcTemplate jdbcTemplate;

    private final RowMapper<Session> rowMapper = this::mapRow;

    public SessionDaoImpl(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private Session mapRow(ResultSet rs, int rowNum) throws SQLException {
    Session s = new Session();
    s.setId(rs.getLong("id"));
    s.setCourseId(rs.getLong("course_id"));
    s.setSessionDate(rs.getDate("session_date").toLocalDate());
    s.setTimeSlot(rs.getString("time_slot"));

    // ✅ ADD THIS
    s.setSessionCode(rs.getString("session_code"));

    return s;
}

    @Override
    public List<Session> findByCourseId(Long courseId) {
        return jdbcTemplate.query("SELECT * FROM sessions WHERE course_id = ? ORDER BY session_date DESC, time_slot ASC",
                rowMapper, courseId);
    }

    @Override
    public List<Session> findByCourseIdAndDateRange(Long courseId, LocalDate from, LocalDate to) {
        return jdbcTemplate.query(
                "SELECT * FROM sessions WHERE course_id = ? AND session_date BETWEEN ? AND ? ORDER BY session_date DESC",
                rowMapper, courseId, from, to);
    }

    @Override
    public Optional<Session> findById(Long id) {
        try {
            return Optional.of(jdbcTemplate.queryForObject("SELECT * FROM sessions WHERE id = ?", rowMapper, id));
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    @Override
    public Optional<Session> findByCourseIdAndDateAndTime(Long courseId, LocalDate date, String timeSlot) {
        try {
            return Optional.of(jdbcTemplate.queryForObject(
                    "SELECT * FROM sessions WHERE course_id = ? AND session_date = ? AND time_slot = ?",
                    rowMapper, courseId, date, timeSlot));
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    @Override
     public Long insert(Session session) {
    KeyHolder keyHolder = new GeneratedKeyHolder();

    jdbcTemplate.update(con -> {
        PreparedStatement ps = con.prepareStatement(
                "INSERT INTO sessions (course_id, session_date, time_slot, session_code) VALUES (?, ?, ?, ?)",
                Statement.RETURN_GENERATED_KEYS
        );

        ps.setLong(1, session.getCourseId());
        ps.setDate(2, java.sql.Date.valueOf(session.getSessionDate()));
        ps.setString(3, session.getTimeSlot());
        ps.setString(4, session.getSessionCode());

        return ps;
    }, keyHolder);

    return keyHolder.getKey().longValue();
}

@Override
public void deleteById(Long id) {
    jdbcTemplate.update("DELETE FROM sessions WHERE id = ?", id);
}
}