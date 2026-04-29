<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Presencia — Registration Closed</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600&family=DM+Serif+Display&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
    <link href="<c:url value='/static/css/style.css'/>" rel="stylesheet">
    <style>body{display:flex;align-items:center;justify-content:center;min-height:100vh;}</style>
</head>
<body>
<div class="card border-0 shadow-lg" style="border-radius:16px;padding:40px;background:var(--paper);max-width:420px;width:100%;text-align:center;">
    <div style="font-family:'DM Serif Display',serif;font-size:32px;margin-bottom:4px;">Pres<span style="color:var(--gold);">encia</span></div>
    <div style="font-family:'DM Mono',monospace;font-size:11px;color:var(--muted);letter-spacing:2px;text-transform:uppercase;margin-bottom:28px;">Registration</div>
    <div style="font-size:36px;margin-bottom:16px;">🔒</div>
    <div style="font-size:15px;font-weight:600;margin-bottom:10px;">Teacher registration is closed.</div>
    <div style="font-size:13px;color:var(--muted);margin-bottom:24px;">Teacher and admin accounts are created by the system administrators. Please contact your institution for access.</div>
    <a href="<c:url value='/contact'/>" class="btn btn-ghost mb-2" style="display:block;border-radius:8px;">✉️ Contact Us</a>
    <a href="<c:url value='/login'/>" style="font-size:13px;color:var(--ink);font-weight:500;">← Back to Login</a>
</div>
</body>
</html>
