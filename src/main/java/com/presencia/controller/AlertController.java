package com.presencia.controller;

import com.presencia.model.Professor;
import com.presencia.service.AlertService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/alerts")
public class AlertController {

    private final AlertService alertService;

    public AlertController(AlertService alertService) {
        this.alertService = alertService;
    }

    @GetMapping
    public String alertsPage(HttpServletRequest request, Model model) {
        Professor prof = (Professor) request.getSession().getAttribute("professor");
        if (prof == null || !prof.isAdmin()) {
            return "redirect:/dashboard";
        }
        model.addAttribute("professor", prof);
        model.addAttribute("alerts", alertService.getAllAlerts());
        return "pages/alerts";
    }

    @PostMapping("/resolve")
    public String resolve(@RequestParam Long id, HttpServletRequest request) {
        Professor prof = (Professor) request.getSession().getAttribute("professor");
        if (prof == null || !prof.isAdmin()) return "redirect:/dashboard";
        alertService.resolveAlert(id);
        return "redirect:/alerts";
    }

    @PostMapping("/run-checks")
    public String runChecks(HttpServletRequest request) {
        Professor prof = (Professor) request.getSession().getAttribute("professor");
        if (prof == null || !prof.isAdmin()) return "redirect:/dashboard";
        alertService.runChecksNow();
        return "redirect:/alerts?checked=true";
    }
}
