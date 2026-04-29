package com.presencia.model;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

public class Session {
    private Long id;
    private Long courseId;
    private LocalDate sessionDate;
    private String timeSlot;

    // ✅ ADD THIS
    private String sessionCode;

    public Session() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getCourseId() { return courseId; }
    public void setCourseId(Long courseId) { this.courseId = courseId; }

    public LocalDate getSessionDate() { return sessionDate; }
    public void setSessionDate(LocalDate sessionDate) { this.sessionDate = sessionDate; }

    public String getTimeSlot() { return timeSlot; }
    public void setTimeSlot(String timeSlot) { this.timeSlot = timeSlot; }

    // ✅ NEW
    public String getSessionCode() { return sessionCode; }
    public void setSessionCode(String sessionCode) { this.sessionCode = sessionCode; }

    public String getFormattedDate() {
        return sessionDate != null ? sessionDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) : "";
    }
}