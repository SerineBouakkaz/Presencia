package com.presencia.service;

import com.presencia.model.Alert;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Service
public class AlertService {

    private final JdbcTemplate jdbcTemplate;

    private final RowMapper<Alert> alertMapper = this::mapAlert;

    public AlertService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private Alert mapAlert(ResultSet rs, int rowNum) throws SQLException {
        Alert a = new Alert();
        a.setId(rs.getLong("id"));
        a.setType(rs.getString("type"));
        a.setMessage(rs.getString("message"));
        a.setResolved(rs.getBoolean("resolved"));
        a.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        try { a.setStudentId(rs.getLong("student_id")); } catch (Exception ignored) {}
        try { a.setProfessorId(rs.getLong("professor_id")); } catch (Exception ignored) {}
        return a;
    }

    public List<Alert> getActiveAlerts() {
        return jdbcTemplate.query(
            "SELECT * FROM alerts WHERE resolved = false ORDER BY created_at DESC",
            alertMapper);
    }

    public List<Alert> getAllAlerts() {
        return jdbcTemplate.query(
            "SELECT * FROM alerts ORDER BY resolved ASC, created_at DESC",
            alertMapper);
    }

    public void resolveAlert(Long alertId) {
        jdbcTemplate.update("UPDATE alerts SET resolved = true WHERE id = ?", alertId);
    }

    // Runs every day at 8:00 AM
    @Scheduled(cron = "0 0 8 * * *")
    public void runDailyChecks() {
        checkStudentAbsences();
        checkInactiveProfessors();
    }

    // Also expose for manual trigger
    public void runChecksNow() {
        checkStudentAbsences();
        checkInactiveProfessors();
    }

    private void checkStudentAbsences() {
        // Find students with 3+ absences who don't already have an unresolved alert
        String sql =
            "SELECT s.id, CONCAT(s.first_name, ' ', s.last_name) as full_name, " +
            "       COUNT(ar.id) as absence_count " +
            "FROM students s " +
            "JOIN attendance_records ar ON ar.student_id = s.id " +
            "WHERE ar.status = 'absent' " +
            "GROUP BY s.id, full_name " +
            "HAVING absence_count >= 3 " +
            "AND s.id NOT IN (" +
            "  SELECT student_id FROM alerts " +
            "  WHERE type = 'student_absence' AND resolved = false AND student_id IS NOT NULL" +
            ")";

        List<java.util.Map<String, Object>> rows = jdbcTemplate.queryForList(sql);
        for (java.util.Map<String, Object> row : rows) {
            Long studentId = ((Number) row.get("id")).longValue();
            String name = (String) row.get("full_name");
            int count = ((Number) row.get("absence_count")).intValue();

            jdbcTemplate.update(
                "INSERT INTO alerts (type, message, student_id) VALUES (?, ?, ?)",
                "student_absence",
                "⚠️ " + name + " has " + count + " absences and may be at risk of exclusion.",
                studentId
            );
        }
    }

    private void checkInactiveProfessors() {
        // Find professors who haven't created a session in 15+ days
        String sql =
            "SELECT p.id, p.name, MAX(s.session_date) as last_session " +
            "FROM professors p " +
            "LEFT JOIN courses c ON c.professor_id = p.id " +
            "LEFT JOIN sessions s ON s.course_id = c.id " +
            "GROUP BY p.id, p.name " +
            "HAVING last_session IS NULL OR last_session < DATE_SUB(CURDATE(), INTERVAL 15 DAY) " +
            "AND p.id NOT IN (" +
            "  SELECT professor_id FROM alerts " +
            "  WHERE type = 'professor_inactive' AND resolved = false AND professor_id IS NOT NULL" +
            ")";

        List<java.util.Map<String, Object>> rows = jdbcTemplate.queryForList(sql);
        for (java.util.Map<String, Object> row : rows) {
            Long profId = ((Number) row.get("id")).longValue();
            String name = (String) row.get("name");
            Object lastSession = row.get("last_session");
            String detail = lastSession == null ? "has never started a session." : "hasn't started a session in over 15 days.";

            jdbcTemplate.update(
                "INSERT INTO alerts (type, message, professor_id) VALUES (?, ?, ?)",
                "professor_inactive",
                "🕐 Prof. " + name + " " + detail,
                profId
            );
        }
    }
}
