package com.presencia.controller;

import com.presencia.model.AttendanceRecord;
import com.presencia.model.AttendanceStatus;
import com.presencia.model.Session;
import com.presencia.service.*;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Map;
import java.util.HashMap;

@RestController
@RequestMapping("/attendance")
public class AttendanceController {

    private final SessionService sessionService;
    private final AttendanceService attendanceService;

    public AttendanceController(SessionService sessionService, AttendanceService attendanceService) {
        this.sessionService = sessionService;
        this.attendanceService = attendanceService;
    }

    @PostMapping("/save")
    public ResponseEntity<?> save(@RequestBody Map<String, Object> payload) {
        try {
            Long sessionId = Long.valueOf(payload.get("sessionId").toString());
            Long courseId  = Long.valueOf(payload.get("courseId").toString());
            String dateStr = payload.get("date").toString();
            LocalDate date = LocalDate.parse(dateStr);

            String timeSlot = LocalTime.now().format(DateTimeFormatter.ofPattern("HH:mm"));
            Session existing = sessionId > 0 ? sessionService.findById(sessionId) : null;

            Session session;
            if (existing != null) {
                session = existing;
            } else {
                session = sessionService.getOrCreateSession(courseId, date, timeSlot);
            }

            @SuppressWarnings("unchecked")
            java.util.List<Map<String, Object>> recordsData =
                    (java.util.List<Map<String, Object>>) payload.get("records");

            java.util.List<AttendanceRecord> records = new java.util.ArrayList<>();
            for (Map<String, Object> rd : recordsData) {
                AttendanceRecord record = new AttendanceRecord();
                record.setSessionId(session.getId());
                record.setStudentId(Long.valueOf(rd.get("studentId").toString()));
                record.setStatus(AttendanceStatus.valueOf(rd.get("status").toString()));
                Object note = rd.get("note");
                record.setNote(note != null ? note.toString() : "");
                records.add(record);
            }

            attendanceService.saveRecords(session.getId(), records);

            Map<String, Object> response = new HashMap<>();
            response.put("success",   true);
            response.put("sessionId", session.getId());
            response.put("timeSlot",  session.getTimeSlot());
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("error",   e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @PostMapping("/validate")
    public ResponseEntity<?> validateCode(@RequestBody Map<String, String> payload) {
        try {
            String inputCode = payload.get("code").trim().toUpperCase();
            Long sessionId = Long.valueOf(payload.get("sessionId"));
            Session session = sessionService.findById(sessionId);
            if (session == null) {
                return ResponseEntity.badRequest().body("Session not found");
            }
            String sessionCode = session.getTimeSlot().trim().toUpperCase();
            if (!sessionCode.equals(inputCode)) {
                return ResponseEntity.badRequest().body("Invalid code");
            }
            return ResponseEntity.ok("Valid code");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error: " + e.getMessage());
        }
    }

    /**
     * Creates a brand-new session for the given course right now.
     */
    @PostMapping("/new-session")
    public ResponseEntity<?> newSession(@RequestBody Map<String, Object> payload) {
        try {
            Long courseId  = Long.valueOf(payload.get("courseId").toString());
            LocalDate today    = LocalDate.now();
            String    timeSlot = LocalTime.now().format(DateTimeFormatter.ofPattern("HH:mm"));

            Long newId = sessionService.insertFresh(courseId, today, timeSlot);

            Map<String, Object> response = new HashMap<>();
            response.put("success",   true);
            response.put("sessionId", newId);
            response.put("timeSlot",  timeSlot);
            response.put("date",      today.toString());
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("error",   e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    /**
     * Deletes a session and all its attendance records (FK cascade).
     */
    @PostMapping("/delete-session")
    public ResponseEntity<?> deleteSession(@RequestBody Map<String, Object> payload) {
        try {
            Long sessionId = Long.valueOf(payload.get("sessionId").toString());
            sessionService.deleteById(sessionId);
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("error",   e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
}