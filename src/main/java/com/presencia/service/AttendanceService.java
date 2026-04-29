package com.presencia.service;

import com.presencia.dao.AttendanceRecordDao;
import com.presencia.model.AttendanceRecord;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class AttendanceService {

    private final AttendanceRecordDao attendanceRecordDao;

    public AttendanceService(AttendanceRecordDao attendanceRecordDao) {
        this.attendanceRecordDao = attendanceRecordDao;
    }

    public List<AttendanceRecord> getRecordsBySession(Long sessionId) {
        return attendanceRecordDao.findBySessionId(sessionId);
    }

    public void saveRecords(Long sessionId, List<AttendanceRecord> records) {
        attendanceRecordDao.batchUpsert(records);
    }

    public Map<String, Integer> getSessionStats(Long sessionId, int totalStudents) {
        Map<String, Integer> stats = new HashMap<>();
        stats.put("present", attendanceRecordDao.countByStatusAndSession(sessionId, "present"));
        stats.put("absent", attendanceRecordDao.countByStatusAndSession(sessionId, "absent"));
        stats.put("late", attendanceRecordDao.countByStatusAndSession(sessionId, "late"));
        stats.put("excused", attendanceRecordDao.countByStatusAndSession(sessionId, "excused"));
        return stats;
    }

    public Map<Long, Integer> getAttendancePctAndTotal(String department) {
        return attendanceRecordDao.getAttendancePctAndTotal(department);
    }
}
