package com.presencia.dao;

import com.presencia.model.Session;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface SessionDao {
    List<Session> findByCourseId(Long courseId);
    List<Session> findByCourseIdAndDateRange(Long courseId, LocalDate from, LocalDate to);
    Optional<Session> findById(Long id);
    Optional<Session> findByCourseIdAndDateAndTime(Long courseId, LocalDate date, String timeSlot);
    Long insert(Session session);
    void deleteById(Long id);
}
