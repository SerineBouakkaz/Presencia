package com.presencia.dao.impl;

import com.presencia.dao.AttendanceRecordDao;
import com.presencia.model.AttendanceRecord;
import com.presencia.model.AttendanceStatus;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class AttendanceRecordDaoImpl implements AttendanceRecordDao {

    private final JdbcTemplate jdbcTemplate;

    private final RowMapper<AttendanceRecord> rowMapper = this::mapRow;

    public AttendanceRecordDaoImpl(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private AttendanceRecord mapRow(ResultSet rs, int rowNum) throws SQLException {
        AttendanceRecord r = new AttendanceRecord();
        r.setId(rs.getLong("id"));
        r.setSessionId(rs.getLong("session_id"));
        r.setStudentId(rs.getLong("student_id"));
        r.setStatus(AttendanceStatus.valueOf(rs.getString("status")));
        r.setNote(rs.getString("note"));
        return r;
    }

    @Override
    public List<AttendanceRecord> findBySessionId(Long sessionId) {
        return jdbcTemplate.query("SELECT * FROM attendance_records WHERE session_id = ?", rowMapper, sessionId);
    }

    @Override
    public void batchUpsert(List<AttendanceRecord> records) {
        if (records.isEmpty()) return;

        String sql = "INSERT INTO attendance_records (session_id, student_id, status, note) VALUES (?, ?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE status = VALUES(status), note = VALUES(note)";

        jdbcTemplate.batchUpdate(sql, new BatchPreparedStatementSetter() {
            @Override
            public void setValues(PreparedStatement ps, int i) throws SQLException {
                AttendanceRecord r = records.get(i);
                ps.setLong(1, r.getSessionId());
                ps.setLong(2, r.getStudentId());
                ps.setString(3, r.getStatus().name());
                ps.setString(4, r.getNote());
            }

            @Override
            public int getBatchSize() {
                return records.size();
            }
        });
    }

    @Override
    public Map<Long, Integer> getAttendancePctAndTotal(String department) {
        String sql = "SELECT s.id, " +
                "(SELECT COUNT(*) FROM attendance_records ar2 " +
                " JOIN sessions se ON ar2.session_id = se.id " +
                " JOIN courses c ON se.course_id = c.id " +
                " WHERE ar2.student_id = s.id AND c.department = ? AND ar2.status = 'present') as present, " +
                "(SELECT COUNT(*) FROM attendance_records ar2 " +
                " JOIN sessions se ON ar2.session_id = se.id " +
                " JOIN courses c ON se.course_id = c.id " +
                " WHERE ar2.student_id = s.id AND c.department = ?) as total " +
                "FROM students s WHERE s.department = ?";

        List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql, department, department, department);
        Map<Long, Integer> result = new HashMap<>();
        for (Map<String, Object> row : rows) {
            Long studentId = ((Number) row.get("id")).longValue();
            Object presentObj = row.get("present");
            Object totalObj = row.get("total");
            int present = presentObj != null ? ((Number) presentObj).intValue() : 0;
            int total = totalObj != null ? ((Number) totalObj).intValue() : 0;
            int pct = total > 0 ? Math.round((float) present / total * 100) : 100;
            result.put(studentId, pct);
        }
        return result;
    }

    @Override
    public int countByStatusAndSession(Long sessionId, String status) {
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM attendance_records WHERE session_id = ? AND status = ?",
                Integer.class, sessionId, status);
        return count != null ? count : 0;
    }

    @Override
    public void deleteBySessionId(Long sessionId) {
        jdbcTemplate.update("DELETE FROM attendance_records WHERE session_id = ?", sessionId);
    }
}
