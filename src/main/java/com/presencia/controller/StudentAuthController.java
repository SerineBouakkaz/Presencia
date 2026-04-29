package com.presencia.controller;

import com.presencia.model.Student;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

@Controller
public class StudentAuthController {

    private final JdbcTemplate jdbcTemplate;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    public StudentAuthController(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // ── Student Registration ──

    @GetMapping("/student-register")
    public String registerPage(Model model) {
        model.addAttribute("success", false);
        return "student-register";
    }

    @PostMapping("/student-register")
    public String register(@RequestParam String studentCode,
                           @RequestParam String firstName,
                           @RequestParam String lastName,
                           @RequestParam String password,
                           @RequestParam(required = false) String confirmPassword,
                           Model model) {
        model.addAttribute("success", false);

        String trimCode      = studentCode.trim().toUpperCase();
        String trimFirst     = firstName.trim();
        String trimLast      = lastName.trim().toUpperCase();

        // 1. Passwords match?
        if (confirmPassword != null && !password.equals(confirmPassword)) {
            model.addAttribute("error", "Passwords do not match. Please try again.");
            return "student-register";
        }

        // 2. Find student by matricule
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
            "SELECT * FROM students WHERE UPPER(student_code) = ?", trimCode);

        if (rows.isEmpty()) {
            model.addAttribute("error",
                "Matricule \"" + trimCode + "\" not found. Contact your teacher to add you.");
            return "student-register";
        }

        Map<String, Object> student = rows.get(0);

        // 3. Verify first + last name match (case-insensitive)
        String dbFirst = ((String) student.get("first_name")).trim().toUpperCase();
        String dbLast  = ((String) student.get("last_name")).trim().toUpperCase();

        if (!dbFirst.equals(trimFirst.toUpperCase()) || !dbLast.equals(trimLast)) {
            model.addAttribute("error",
                "Name does not match our records. Check your first and last name carefully.");
            return "student-register";
        }

        // 4. Already registered?
        if (student.get("student_password") != null) {
            model.addAttribute("error",
                "This matricule is already registered. Go to login or contact your teacher.");
            return "student-register";
        }

        // 5. Set password
        jdbcTemplate.update(
            "UPDATE students SET student_password = ? WHERE UPPER(student_code) = ?",
            passwordEncoder.encode(password), trimCode);

        model.addAttribute("success", true);
        return "student-register";
    }

    // ── Student Login ──

    @PostMapping("/student-login")
    public String login(@RequestParam String studentCode,
                        @RequestParam String password,
                        HttpServletRequest request, Model model) {
        String trimCode = studentCode.trim().toUpperCase();

        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
            "SELECT * FROM students WHERE UPPER(student_code) = ? AND student_password IS NOT NULL",
            trimCode);

        if (!rows.isEmpty()) {
            String stored = (String) rows.get(0).get("student_password");
            if (passwordEncoder.matches(password, stored)) {
                // Build student object
                Student s = new Student();
                s.setId(((Number) rows.get(0).get("id")).longValue());
                s.setFirstName((String) rows.get(0).get("first_name"));
                s.setLastName((String) rows.get(0).get("last_name"));
                s.setStudentCode((String) rows.get(0).get("student_code"));
                s.setDepartment((String) rows.get(0).get("department"));
                s.setEmail((String) rows.get(0).get("email"));
                request.getSession().setAttribute("student", s);
                return "redirect:/student/dashboard";
            }
        }

        model.addAttribute("error", "Incorrect matricule or password.");
        model.addAttribute("role", "student");
        return "login";
    }

    @PostMapping("/student-logout")
    public String logout(HttpServletRequest request) {
        request.getSession().removeAttribute("student");
        return "redirect:/login";
    }

    // ── Student Dashboard ──

    @GetMapping("/student/dashboard")
    public String dashboard(HttpServletRequest request, Model model) {
        Student student = (Student) request.getSession().getAttribute("student");
        if (student == null) return "redirect:/login";

        model.addAttribute("student", student);

        // Get attendance stats for this student
        List<Map<String, Object>> statRows = jdbcTemplate.queryForList(
            "SELECT status, COUNT(*) as cnt FROM attendance_records WHERE student_id = ? GROUP BY status",
            student.getId());

        java.util.HashMap<String, Integer> stats = new java.util.HashMap<>();
        stats.put("present", 0); stats.put("absent", 0); stats.put("late", 0); stats.put("excused", 0);
        for (Map<String, Object> row : statRows) {
            stats.put((String) row.get("status"), ((Number) row.get("cnt")).intValue());
        }
        model.addAttribute("stats", stats);

        // Get courses for manual absence
        List<Map<String, Object>> courseRows = jdbcTemplate.queryForList(
            "SELECT id, name FROM courses WHERE department = ?", student.getDepartment());
        java.util.List<java.util.Map<String, Object>> courses = courseRows;
        model.addAttribute("courses", courses);

        return "student-dashboard";
    }

    // ── Mark Absence Manually ──

    @PostMapping("/student/mark-absence")
    public String markAbsence(@RequestParam Long courseId,
                              @RequestParam String sessionDate,
                              @RequestParam String reason,
                              HttpServletRequest request) {
        Student student = (Student) request.getSession().getAttribute("student");
        if (student == null) return "redirect:/login";

        // Find or create session
        List<Map<String, Object>> sessions = jdbcTemplate.queryForList(
            "SELECT id FROM sessions WHERE course_id = ? AND session_date = ? LIMIT 1",
            courseId, sessionDate);

        Long sessionId;
        if (sessions.isEmpty()) {
            jdbcTemplate.update("INSERT INTO sessions (course_id, session_date, time_slot) VALUES (?,?,'Manual')",
                courseId, sessionDate);
            sessionId = jdbcTemplate.queryForObject("SELECT LAST_INSERT_ID()", Long.class);
        } else {
            sessionId = ((Number) sessions.get(0).get("id")).longValue();
        }

        // Upsert attendance record as absent
        jdbcTemplate.update(
            "INSERT INTO attendance_records (session_id, student_id, status, note) VALUES (?,?,'absent',?) " +
            "ON DUPLICATE KEY UPDATE status='absent', note=?",
            sessionId, student.getId(), reason, reason);

        request.getSession().setAttribute("attendanceMessage", "Absence submitted for " + sessionDate);
        return "redirect:/student/dashboard";
    }

    // ── Mark Present via QR (legacy, kept for backward compat) ──
    private static final double UNIV_LAT = 33.799732;
    private static final double UNIV_LNG = 2.849006;
    private static final double MAX_DIST_METERS = 300.0;

    @PostMapping("/student/mark-present-qr")
    public String markPresentQR(@RequestParam Long sessionId,
                                @RequestParam(required = false) Double lat,
                                @RequestParam(required = false) Double lng,
                                HttpServletRequest request) {
        Student student = (Student) request.getSession().getAttribute("student");
        if (student == null) return "redirect:/login";

        if (lat != null && lng != null) {
            double dist = haversineDistance(lat, lng, UNIV_LAT, UNIV_LNG);
            if (dist > MAX_DIST_METERS) {
                return "redirect:/student/dashboard?error=location";
            }
        }

        jdbcTemplate.update(
            "INSERT INTO attendance_records (session_id, student_id, status, note) VALUES (?,?,'present','QR scan') " +
            "ON DUPLICATE KEY UPDATE status='present', note='QR scan'",
            sessionId, student.getId());

        return "redirect:/student/dashboard?msg=present";
    }

    // ── Mark Present via Session Code (no camera required) ──
    // Active session codes: code -> [sessionId, issuedEpochSeconds]
    private static final java.util.concurrent.ConcurrentHashMap<String, long[]> SESSION_CODES =
        new java.util.concurrent.ConcurrentHashMap<>();
    private static final long CODE_TTL_SECONDS = 30 * 60; // 30 minutes

    /**
     * Called by the teacher's dashboard (via AJAX or form) to register an active session code.
     * The dashboard should POST { sessionId, code } here when a session is opened.
     */
    @PostMapping("/api/session-code/register")
    @ResponseBody
    public java.util.Map<String, Object> registerCode(@RequestBody java.util.Map<String, Object> body,
                                                       HttpServletRequest request) {
        // Only professors (session attribute "professor") may register codes
        if (request.getSession().getAttribute("professor") == null) {
            return java.util.Map.of("success", false, "error", "Unauthorized");
        }
        String code      = body.get("code").toString().toUpperCase().trim();
        Long   sessionId = Long.valueOf(body.get("sessionId").toString());
        long   now       = System.currentTimeMillis() / 1000L;
        SESSION_CODES.put(code, new long[]{sessionId, now});
        return java.util.Map.of("success", true);
    }

    @PostMapping("/student/mark-present-code")
    public String markPresentCode(@RequestParam String sessionCode,
                                  HttpServletRequest request) {
        Student student = (Student) request.getSession().getAttribute("student");
        if (student == null) return "redirect:/login";

        String code = sessionCode.toUpperCase().trim();
        long[] entry = SESSION_CODES.get(code);

        if (entry == null) {
            return "redirect:/student/dashboard?error=invalid_code";
        }

        long sessionId   = entry[0];
        long issuedAt    = entry[1];
        long now         = System.currentTimeMillis() / 1000L;

        if (now - issuedAt > CODE_TTL_SECONDS) {
            SESSION_CODES.remove(code);
            return "redirect:/student/dashboard?error=expired_code";
        }

        jdbcTemplate.update(
            "INSERT INTO attendance_records (session_id, student_id, status, note) VALUES (?,?,'present','Session code') " +
            "ON DUPLICATE KEY UPDATE status='present', note='Session code'",
            sessionId, student.getId());

        return "redirect:/student/dashboard?msg=present";
    }

    private double haversineDistance(double lat1, double lng1, double lat2, double lng2) {
        final int R = 6371000;
        double dLat = Math.toRadians(lat2 - lat1);
        double dLng = Math.toRadians(lng2 - lng1);
        double a = Math.sin(dLat/2) * Math.sin(dLat/2)
                 + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                 * Math.sin(dLng/2) * Math.sin(dLng/2);
        return R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    }

    // ── Contact Page ──

    @GetMapping("/contact")
    public String contactPage() {
        return "contact";
    }
}