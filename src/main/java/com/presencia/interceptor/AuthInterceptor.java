package com.presencia.interceptor;

import com.presencia.model.Professor;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class AuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String uri = request.getRequestURI();
        String ctx = request.getContextPath();
        String path = uri.substring(ctx.length());

        // Tell ngrok to skip the browser warning page for all requests
        response.setHeader("ngrok-skip-browser-warning", "true");

        // Always public
        if (path.equals("/login") || path.equals("/logout")
                || path.equals("/register")
                || path.equals("/contact")
                || path.startsWith("/student-register")
                || path.startsWith("/student-login")
                || path.startsWith("/student-logout")
                || path.startsWith("/static/")
                || path.startsWith("/webjars/")
                || path.equals("/setup")) {
            return true;
        }

        // Student routes
        if (path.startsWith("/student/")) {
            if (request.getSession().getAttribute("student") == null) {
                response.sendRedirect(ctx + "/login");
                return false;
            }
            return true;
        }

        // Teacher/Admin routes — must be logged in
        Professor prof = (Professor) request.getSession().getAttribute("professor");
        if (prof == null) {
            response.sendRedirect(ctx + "/login");
            return false;
        }

        // Force password change — only /first-login is accessible
        if (prof.isForcePasswordChange()) {
            if (!path.equals("/first-login")) {
                response.sendRedirect(ctx + "/first-login");
                return false;
            }
        }

        return true;
    }
}