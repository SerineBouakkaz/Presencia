package com.presencia.controller;

import com.presencia.model.Course;
import com.presencia.model.Professor;
import com.presencia.service.CourseService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/courses")
public class CourseController {

    private final CourseService courseService;

    public CourseController(CourseService courseService) {
        this.courseService = courseService;
    }

    @GetMapping
    public String coursesPage(Model model, HttpServletRequest request) {
        Professor prof = (Professor) request.getSession().getAttribute("professor");
        model.addAttribute("professor", prof);
        model.addAttribute("courses", courseService.findByProfessor(prof.getId()));
        model.addAttribute("success", false);
        return "pages/courses";
    }

    @PostMapping("/save")
    public String saveCourse(@ModelAttribute Course course, HttpServletRequest request) {
        Professor prof = (Professor) request.getSession().getAttribute("professor");
        course.setProfessorId(prof.getId());
        course.setDepartment(prof.getDepartment());
        courseService.save(course);
        return "redirect:/courses?added=true";
    }

    @PostMapping("/delete")
    public String deleteCourse(@RequestParam Long id) {
        courseService.delete(id);
        return "redirect:/courses";
    }

    @PostMapping("/api/save")
    @ResponseBody
    public Map<String, Object> saveCourseAjax(@RequestBody Map<String, String> payload, HttpServletRequest request) {
        Professor prof = (Professor) request.getSession().getAttribute("professor");
        Course course = new Course();
        course.setName(payload.get("name"));
        course.setProfessorId(prof.getId());
        course.setDepartment(prof.getDepartment());
        courseService.save(course);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("courseId", course.getId());
        return result;
    }
}
