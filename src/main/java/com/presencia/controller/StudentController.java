package com.presencia.controller;

import com.presencia.model.Professor;
import com.presencia.model.Student;
import com.presencia.service.StudentService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/students")
public class StudentController {

    private final StudentService studentService;

    public StudentController(StudentService studentService) {
        this.studentService = studentService;
    }

    @GetMapping
    public String studentsPage(@RequestParam(defaultValue = "1") int page,
                               @RequestParam(defaultValue = "10") int limit,
                               @RequestParam(defaultValue = "") String search,
                               HttpServletRequest request, Model model) {
        Professor prof = (Professor) request.getSession().getAttribute("professor");
        model.addAttribute("professor", prof);

        // Show all students regardless of department for admin users
        String department = prof != null && prof.isAdmin() ? null : prof.getDepartment();
        int total = studentService.countAll(department, search);
        java.util.List<Student> students = studentService.findAllPaged(department, page, limit, search);
        int totalPages = Math.max(1, (int) Math.ceil((double) total / limit));

        model.addAttribute("students", students);
        model.addAttribute("page", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("total", total);
        model.addAttribute("search", search);
        // Groups for the Add/Edit modal dropdown
        java.util.List<String> groups = studentService.findGroups(department != null ? department : "");
        model.addAttribute("groups", groups);
        return "pages/students";
    }

    @PostMapping("/save")
    public String save(@ModelAttribute Student student, HttpServletRequest request) {
        Professor prof = (Professor) request.getSession().getAttribute("professor");
        studentService.save(student, prof.getDepartment());
        return "redirect:/students";
    }

    @PostMapping("/delete")
    public String delete(@RequestParam Long id) {
        studentService.delete(id);
        return "redirect:/students";
    }
}
