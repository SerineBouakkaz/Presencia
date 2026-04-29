package com.presencia.service;

import com.presencia.dao.SessionDao;
import com.presencia.model.Session;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class SessionService {

    private final SessionDao sessionDao;

    public SessionService(SessionDao sessionDao) {
        this.sessionDao = sessionDao;
    }

    public List<Session> findByCourse(Long courseId) {
        return sessionDao.findByCourseId(courseId);
    }

    public Session findById(Long id) {
        return sessionDao.findById(id).orElse(null);
    }

    public Session getOrCreateSession(Long courseId, LocalDate date, String timeSlot) {
        return sessionDao.findByCourseIdAndDateAndTime(courseId, date, timeSlot)
                .orElseGet(() -> {
                    Session session = new Session();
                    session.setCourseId(courseId);
                    session.setSessionDate(date);
                    session.setTimeSlot(timeSlot);
                    Long id = sessionDao.insert(session);
                    session.setId(id);
                    return session;
                });
    }

    /** Always inserts a brand-new session row (for "New Session" button). */
    public Long insertFresh(Long courseId, LocalDate date, String timeSlot) {
    Session session = new Session();
    session.setCourseId(courseId);
    session.setSessionDate(date);
    session.setTimeSlot(timeSlot);

    // ✅ GENERATE REAL CODE
    String code = java.util.UUID.randomUUID().toString().substring(0,6).toUpperCase();
    session.setSessionCode(code);

    return sessionDao.insert(session);
}

    /** Deletes a session (FK cascade removes attendance records). */
    public void deleteById(Long id) {
        sessionDao.deleteById(id);
    }
}