package com.presencia.controller;

import com.presencia.model.*;
import com.presencia.service.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import java.util.*;
import java.util.stream.Collectors;

@Controller
public class DashboardController {

    private final CourseService courseService;
    private final SessionService sessionService;
    private final StudentService studentService;
    private final AttendanceService attendanceService;

    public DashboardController(CourseService courseService, SessionService sessionService,
                               StudentService studentService, AttendanceService attendanceService) {
        this.courseService = courseService;
        this.sessionService = sessionService;
        this.studentService = studentService;
        this.attendanceService = attendanceService;
    }

    @GetMapping("/dashboard")
    public String dashboard(@RequestParam(required = false) Long courseId,
                           @RequestParam(required = false) Long sessionId,
                           @RequestParam(required = false) String group,
                           Model model,
                           HttpServletRequest request) {
        Professor prof = (Professor) request.getSession().getAttribute("professor");

        List<Course> courses = courseService.findByProfessor(prof.getId());
        model.addAttribute("courses", courses);
        model.addAttribute("professor", prof);

        // Default to first course
        Course currentCourse = null;
        if (courseId != null) {
            currentCourse = courseService.findById(courseId);
        } else if (!courses.isEmpty()) {
            currentCourse = courses.get(0);
        }

        List<Session> sessions = new ArrayList<>();
        if (currentCourse != null) {
            sessions = sessionService.findByCourse(currentCourse.getId());
        }
        model.addAttribute("sessions", sessions);

        Session currentSession = null;
        if (sessionId != null) {
            currentSession = sessionService.findById(sessionId);
        } else if (!sessions.isEmpty()) {
            currentSession = sessions.get(0);
        }
        model.addAttribute("currentSession", currentSession);

        // Available groups for this department
        List<String> groups = studentService.findGroups(prof.getDepartment());
        model.addAttribute("groups", groups);
        model.addAttribute("selectedGroup", group);

        // Load students — filtered by group if selected
        List<Student> students;
        if (group != null && !group.isEmpty()) {
            students = studentService.findByGroup(prof.getDepartment(), group);
        } else {
            students = studentService.findAll(prof.getDepartment());
        }

        // Enhance with attendance percentages
        Map<Long, Integer> pctMap = attendanceService.getAttendancePctAndTotal(prof.getDepartment());
        students.forEach(s -> {
            Integer pct = pctMap.get(s.getId());
            if (pct != null) s.setAttendancePercentage(pct);
        });
        model.addAttribute("students", students);

        // Load existing attendance if session is selected
        Map<Long, AttendanceRecord> recordMap = new HashMap<>();
        Map<String, Integer> stats = new LinkedHashMap<>();
        stats.put("present", 0);
        stats.put("absent", 0);
        stats.put("late", 0);
        stats.put("excused", 0);

        if (currentSession != null) {
            List<AttendanceRecord> records = attendanceService.getRecordsBySession(currentSession.getId());
            recordMap = records.stream().collect(Collectors.toMap(AttendanceRecord::getStudentId, r -> r));
            stats = attendanceService.getSessionStats(currentSession.getId(), students.size());
        }
        model.addAttribute("records", recordMap);
        model.addAttribute("stats", stats);
        model.addAttribute("selectedCourseId", currentCourse != null ? currentCourse.getId() : null);
        model.addAttribute("selectedSessionId", currentSession != null ? currentSession.getId() : null);

        return "pages/dashboard";
    }

    @GetMapping("/sessions/list")
    public String sessionsList(@RequestParam Long courseId, Model model) {
        List<Session> sessions = sessionService.findByCourse(courseId);
        model.addAttribute("sessions", sessions);
        return "fragments/sessions-dropdown";
    }

    @GetMapping("/")
    public String index() {
        return "redirect:/dashboard";
    }
}
