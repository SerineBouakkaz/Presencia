package com.presencia.controller;

import com.presencia.model.Professor;
import com.presencia.service.ProfessorService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class AuthController {

    private final ProfessorService professorService;
    private final JdbcTemplate jdbcTemplate;

    public AuthController(ProfessorService professorService, JdbcTemplate jdbcTemplate) {
        this.professorService = professorService;
        this.jdbcTemplate = jdbcTemplate;
    }

    @GetMapping("/setup")
    @ResponseBody
    public String setup() {
        try {
            jdbcTemplate.update(
                "INSERT INTO professors (name, email, password, department) VALUES (?, ?, ?, ?) " +
                "ON DUPLICATE KEY UPDATE password=VALUES(password)",
                "S. Boudouh",
                "s.boudouh@lagh-univ.dz",
                "$2a$10$zfuN5gmKRchSfStDK1r4T.3yCXWMGumeYY9TaY1Wqs.F0H5gcNSZe",
                "Computer Science"
            );
            return "Done! You can now login with s.boudouh@lagh-univ.dz / 12345";
        } catch (Exception e) {
            return "Error: " + e.getMessage();
        }
    }

    @GetMapping("/login")
    public String loginPage(Model model) {
        // no error attribute = no error message shown
        return "login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String email, @RequestParam String password,
                        HttpServletRequest request, Model model) {
        String trimmedEmail    = email    != null ? email.trim().toLowerCase()    : "";
        String trimmedPassword = password != null ? password.trim() : "";

        var professor = professorService.login(trimmedEmail, trimmedPassword);
        if (professor.isPresent()) {
            request.getSession().setAttribute("professor", professor.get());
            if (professor.get().isForcePasswordChange()) {
                return "redirect:/first-login";
            }
            return "redirect:/dashboard";
        }
        model.addAttribute("error", "Invalid email or password. Please try again.");
        return "login";
    }

    @PostMapping("/logout")
    public String logout(HttpServletRequest request) {
        request.getSession().invalidate();
        return "redirect:/login";
    }
}