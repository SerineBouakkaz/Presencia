<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Presencia — Contact Us</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600&family=DM+Serif+Display&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
    <link href="<c:url value='/static/css/style.css'/>" rel="stylesheet">
    <style>
        body { display:flex; align-items:center; justify-content:center; min-height:100vh; }
        .contact-card { max-width:480px; width:100%; }
        .brand-mark { font-family:'DM Serif Display',serif; font-size:32px; text-align:center; margin-bottom:4px; }
        .brand-mark span { color:var(--gold); }
        .brand-sub { font-family:'DM Mono',monospace; font-size:11px; text-align:center; color:var(--muted); letter-spacing:2px; text-transform:uppercase; margin-bottom:28px; }
        .contact-item { display:flex; align-items:center; gap:14px; padding:16px; border-radius:10px; border:1px solid var(--border); background:white; margin-bottom:12px; }
        .contact-icon { font-size:24px; width:40px; text-align:center; flex-shrink:0; }
        .contact-label { font-size:11px; font-weight:600; letter-spacing:.9px; text-transform:uppercase; color:var(--muted); font-family:'DM Mono',monospace; }
        .contact-value { font-size:14px; font-weight:500; color:var(--ink); }
        .contact-value a { color:var(--ink); text-decoration:none; }
        .contact-value a:hover { color:var(--gold); }
    </style>
</head>
<body>
<div class="contact-card card border-0 shadow-lg" style="border-radius:16px; padding:40px; background:var(--paper);">
    <div class="brand-mark">Pres<span>encia</span></div>
    <div class="brand-sub">Contact Us</div>

    <p style="font-size:14px; color:var(--muted); text-align:center; margin-bottom:24px;">
        Have a question or issue? Reach out to us and we'll get back to you soon.
    </p>

    <div class="contact-item">
        <div class="contact-icon">📧</div>
        <div>
            <div class="contact-label">Support Email</div>
            <div class="contact-value">
                <a href="mailto:support@presencia-univ.dz">support@presencia-univ.dz</a>
            </div>
        </div>
    </div>

    <div class="contact-item">
        <div class="contact-icon">🎓</div>
        <div>
            <div class="contact-label">Academic Affairs</div>
            <div class="contact-value">
                <a href="mailto:academic@lagh-univ.dz">academic@lagh-univ.dz</a>
            </div>
        </div>
    </div>

    <div class="contact-item">
        <div class="contact-icon">🏫</div>
        <div>
            <div class="contact-label">Department</div>
            <div class="contact-value">Faculty of Exact Sciences &amp; IT</div>
        </div>
    </div>

    <div style="text-align:center; margin-top:24px;">
        <a href="<c:url value='/login'/>" style="font-size:13px; color:var(--ink); font-weight:500;">← Back to Login</a>
    </div>
</div>
</body>
</html>
