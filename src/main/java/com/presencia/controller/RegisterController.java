package com.presencia.controller;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class RegisterController {

    private final JdbcTemplate jdbcTemplate;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    public RegisterController(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @GetMapping("/register")
    public String registerPage(Model model) {
        // Teacher/Admin registration is disabled - accounts are created by admins
        return "register";
    }

    @PostMapping("/register")
    public String registerPost() {
        // Disabled - redirect to login
        return "redirect:/login";
    }

    @SuppressWarnings("unused")
    private String register(@RequestParam String name,
                           @RequestParam String email,
                           @RequestParam String department,
                           @RequestParam String password,
                           @RequestParam(defaultValue = "professor") String role,
                           Model model) {
        String normalizedEmail = email.trim().toLowerCase();

        Integer count = jdbcTemplate.queryForObject(
            "SELECT COUNT(*) FROM professors WHERE LOWER(email) = ?",
            Integer.class, normalizedEmail);

        if (count != null && count > 0) {
            model.addAttribute("error", "An account with this email already exists.");
            model.addAttribute("success", false);
            return "register";
        }

        // Only allow "professor" or "admin"
        String safeRole = "admin".equals(role) ? "admin" : "professor";
        String hashedPassword = passwordEncoder.encode(password);

        jdbcTemplate.update(
            "INSERT INTO professors (name, email, password, department, role) VALUES (?, ?, ?, ?, ?)",
            name.trim(), normalizedEmail, hashedPassword, department.trim(), safeRole
        );

        model.addAttribute("success", true);
        return "register";
    }
}
