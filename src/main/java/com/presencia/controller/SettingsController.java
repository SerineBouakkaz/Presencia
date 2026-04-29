package com.presencia.controller;

import com.presencia.model.Course;
import com.presencia.model.Professor;
import com.presencia.service.CourseService;
import com.presencia.service.ProfessorService;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
public class SettingsController {

    private final ProfessorService professorService;
    private final CourseService courseService;
    private final JdbcTemplate jdbcTemplate;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    public SettingsController(ProfessorService professorService, CourseService courseService, JdbcTemplate jdbcTemplate) {
        this.professorService = professorService;
        this.courseService = courseService;
        this.jdbcTemplate = jdbcTemplate;
    }

    // ── Settings Page ──

    @GetMapping("/settings")
    public String settingsPage(@RequestParam(required = false) String updated,
                               HttpServletRequest request, Model model) {
        Professor prof = (Professor) request.getSession().getAttribute("professor");
        List<Course> courses = courseService.findByProfessor(prof.getId());
        model.addAttribute("professor", prof);
        model.addAttribute("courses", courses);
        model.addAttribute("updated", "true".equals(updated));
        return "pages/settings";
    }

    // ── Update Profile ──

    @PostMapping("/settings/update")
    public String updateProfile(@RequestParam String name,
                                @RequestParam String email,
                                @RequestParam String department,
                                HttpServletRequest request) {
        Professor prof = (Professor) request.getSession().getAttribute("professor");
        prof.setName(name);
        prof.setEmail(email.trim().toLowerCase());
        prof.setDepartment(department);
        professorService.update(prof);
        request.getSession().setAttribute("professor", prof);
        return "redirect:/settings?updated=true";
    }

    // ── Change Password ──

    @PostMapping("/settings/change-password")
    public String changePassword(@RequestParam String currentPassword,
                                 @RequestParam String newPassword,
                                 @RequestParam String confirmPassword,
                                 HttpServletRequest request, Model model) {
        Professor prof = (Professor) request.getSession().getAttribute("professor");
        List<Course> courses = courseService.findByProfessor(prof.getId());
        model.addAttribute("professor", prof);
        model.addAttribute("courses", courses);
        model.addAttribute("updated", false);

        if (!newPassword.equals(confirmPassword)) {
            model.addAttribute("pwdError", "New passwords do not match.");
            return "pages/settings";
        }
        if (newPassword.length() < 4) {
            model.addAttribute("pwdError", "Password must be at least 4 characters.");
            return "pages/settings";
        }

        String storedHash = jdbcTemplate.queryForObject(
            "SELECT password FROM professors WHERE id = ?", String.class, prof.getId());

        if (!passwordEncoder.matches(currentPassword, storedHash)) {
            model.addAttribute("pwdError", "Current password is incorrect.");
            return "pages/settings";
        }

        String newHash = passwordEncoder.encode(newPassword);
        jdbcTemplate.update("UPDATE professors SET password = ? WHERE id = ?", newHash, prof.getId());
        model.addAttribute("pwdUpdated", true);
        return "pages/settings";
    }

    // ── First Login — Forced Password Change ──

    @GetMapping("/first-login")
    public String firstLoginPage(HttpServletRequest request, Model model) {
        Professor prof = (Professor) request.getSession().getAttribute("professor");
        if (prof == null) return "redirect:/login";
        if (!prof.isForcePasswordChange()) return "redirect:/dashboard";
        model.addAttribute("professor", prof);
        return "first-login";
    }

    @PostMapping("/first-login")
    public String firstLoginSubmit(@RequestParam String newPassword,
                                   @RequestParam String confirmPassword,
                                   HttpServletRequest request, Model model) {
        Professor prof = (Professor) request.getSession().getAttribute("professor");
        if (prof == null) return "redirect:/login";

        model.addAttribute("professor", prof);

        if (!newPassword.equals(confirmPassword)) {
            model.addAttribute("error", "Passwords do not match.");
            return "first-login";
        }
        if (newPassword.length() < 6) {
            model.addAttribute("error", "Password must be at least 6 characters.");
            return "first-login";
        }

        String newHash = passwordEncoder.encode(newPassword);
        jdbcTemplate.update(
            "UPDATE professors SET password = ?, force_password_change = FALSE WHERE id = ?",
            newHash, prof.getId());

        prof.setPassword(newHash);
        prof.setForcePasswordChange(false);
        request.getSession().setAttribute("professor", prof);

        return "redirect:/dashboard";
    }
}
