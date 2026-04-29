package com.presencia.dao;

import com.presencia.model.AttendanceRecord;
import java.util.List;
import java.util.Map;

public interface AttendanceRecordDao {
    List<AttendanceRecord> findBySessionId(Long sessionId);
    void batchUpsert(List<AttendanceRecord> records);
    Map<Long, Integer> getAttendancePctAndTotal(String department);
    int countByStatusAndSession(Long sessionId, String status);
    void deleteBySessionId(Long sessionId);
}
