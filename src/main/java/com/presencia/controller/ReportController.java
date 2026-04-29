package com.presencia.controller;

import com.presencia.model.AttendanceRecord;
import com.presencia.model.Professor;
import com.presencia.model.Session;
import com.presencia.service.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Controller
@RequestMapping("/reports")
public class ReportController {

    private final CourseService courseService;
    private final SessionService sessionService;
    private final AttendanceService attendanceService;
    private final StudentService studentService;

    public ReportController(CourseService courseService, SessionService sessionService,
                            AttendanceService attendanceService, StudentService studentService) {
        this.courseService = courseService;
        this.sessionService = sessionService;
        this.attendanceService = attendanceService;
        this.studentService = studentService;
    }

    @GetMapping
    public String reportsPage(@RequestParam(required = false) Long courseId,
                              HttpServletRequest request, Model model) {
        Professor prof = (Professor) request.getSession().getAttribute("professor");
        model.addAttribute("professor", prof);

        var courses = courseService.findByProfessor(prof.getId());
        model.addAttribute("courses", courses);

        if (courseId != null) {
            model.addAttribute("sessions", sessionService.findByCourse(courseId));
        } else if (!courses.isEmpty()) {
            model.addAttribute("sessions", sessionService.findByCourse(courses.get(0).getId()));
        }
        return "pages/reports";
    }

    @GetMapping("/session/{id}")
    public String sessionDetail(@PathVariable Long id, HttpServletRequest request, Model model) {
        Professor prof = (Professor) request.getSession().getAttribute("professor");
        model.addAttribute("professor", prof);

        Session session = sessionService.findById(id);
        var records = attendanceService.getRecordsBySession(id);
        var courses = courseService.findByProfessor(prof.getId());
        model.addAttribute("professor", prof);
        model.addAttribute("courses", courses);
        model.addAttribute("session", session);
        model.addAttribute("records", records);

        // Include student names
        if (!records.isEmpty()) {
            var studentIds = records.stream().map(AttendanceRecord::getStudentId).toList();
            // For simplicity, load each student
        }

        model.addAttribute("stats", attendanceService.getSessionStats(id, 0));
        model.addAttribute("selectedCourseId", session != null ? session.getCourseId() : null);
        return "pages/reports";
    }

    @GetMapping("/export/{id}")
    public void exportCsv(@PathVariable Long id, HttpServletResponse response) throws IOException {
        Session session = sessionService.findById(id);
        var records = attendanceService.getRecordsBySession(id);

        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=attendance_session_" + id + ".csv");

        PrintWriter out = response.getWriter();
        out.println("Student ID,Name,Status,Note");
        for (AttendanceRecord r : records) {
            var student = studentService.findById(r.getStudentId());
            String name = student != null ? student.getFullName() : "Unknown";
            out.printf("%s,%s,%s,%s%n",
                    student != null ? student.getStudentCode() : "",
                    name,
                    r.getStatus(),
                    r.getNote() != null ? r.getNote() : "");
        }
    }
}
