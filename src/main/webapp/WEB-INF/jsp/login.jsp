<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Presencia — Sign In</title>
  <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@400;500;600&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet"/>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: 'DM Sans', sans-serif;
      background: #f0ebe2;
      min-height: 100vh;
      display: flex; align-items: center; justify-content: center;
      padding: 1.5rem;
    }
    .card {
      background: #fff; border-radius: 20px;
      padding: 2.75rem 2.25rem; width: 100%; max-width: 420px;
      box-shadow: 0 8px 40px rgba(30,45,64,.10);
    }
    .logo-wrap { text-align: center; margin-bottom: 2rem; }
    .logo-pre  { font-family: 'Cormorant Garamond', serif; font-size: 3rem; font-weight: 600; color: #c4883a; letter-spacing: -1px; line-height: 1; }
    .logo-sub  { font-size: .68rem; font-weight: 500; letter-spacing: .22em; color: #9a9085; margin-top: .3rem; }

    .role-toggle {
      display: grid; grid-template-columns: 1fr 1fr;
      background: #f0ebe2; border-radius: 50px; padding: 4px;
      margin-bottom: 2rem;
    }
    .role-btn {
      display: flex; align-items: center; justify-content: center;
      gap: .45rem; padding: .65rem 1rem; border-radius: 50px;
      font-size: .875rem; font-weight: 500; color: #7a7269;
      background: transparent; border: none; cursor: pointer;
      transition: all .25s; font-family: 'DM Sans', sans-serif;
    }
    .role-btn.active {
      background: #1e2d40; color: #fff;
      box-shadow: 0 2px 10px rgba(30,45,64,.25);
    }

    .field-group { margin-bottom: 1.25rem; }
    .field-label {
      display: block; font-size: .68rem; font-weight: 600;
      letter-spacing: .14em; color: #9a9085; margin-bottom: .5rem;
    }
    .field-input {
      width: 100%; padding: .85rem 1rem;
      border: 1.5px solid #e5ded4; border-radius: 10px;
      font-size: .92rem; color: #1a1a1a; background: #fff;
      font-family: 'DM Sans', sans-serif;
      transition: border-color .2s; outline: none;
    }
    .field-input:focus { border-color: #1e2d40; }
    .field-input::placeholder { color: #c0b8b0; }

    .error-msg {
      color: #c93a3a; font-size: .8rem; margin-bottom: .75rem;
      padding: .5rem .75rem; background: #fbeaea; border-radius: 8px;
    }

    .btn-submit {
      width: 100%; padding: .95rem 1.5rem;
      background: #1e2d40; color: #fff; border: none;
      border-radius: 10px; font-size: .95rem; font-weight: 500;
      font-family: 'DM Sans', sans-serif; cursor: pointer;
      transition: background .2s, transform .15s; margin-top: .25rem;
    }
    .btn-submit:hover { background: #2c3e55; transform: translateY(-1px); }

    .login-help {
      text-align: center; margin-top: 1.5rem;
      font-size: .85rem; color: #9a9085;
    }
    .login-help a { color: #1e2d40; font-weight: 500; text-decoration: none; }
  </style>
</head>
<body>
<div class="card">
  <div class="logo-wrap">
    <div class="logo-pre">Presencia</div>
    <div class="logo-sub">ATTENDANCE SYSTEM</div>
  </div>

  <div class="role-toggle">
    <button class="role-btn active" id="btn-teacher" type="button" onclick="setRole('teacher')">🎓 Teacher</button>
    <button class="role-btn"        id="btn-student" type="button" onclick="setRole('student')">🎒 Student</button>
  </div>

  <%-- TEACHER FORM --%>
  <div id="form-teacher">
    <form method="post" action="<c:url value='/login'/>">
      <c:if test="${not empty error and (empty param.role or param.role != 'student')}">
        <div class="error-msg">${error}</div>
      </c:if>
      <div class="field-group">
        <label class="field-label" for="t-email">EMAIL</label>
        <input id="t-email" name="email" class="field-input" type="email"
               placeholder="teacher@univ.edu" autocomplete="email"
               value="${not empty param.email ? param.email : ''}"/>
      </div>
      <div class="field-group">
        <label class="field-label" for="t-password">PASSWORD</label>
        <input id="t-password" name="password" class="field-input" type="password"
               placeholder="••••••••" autocomplete="current-password"/>
      </div>
      <button type="submit" class="btn-submit">Sign In as Teacher</button>
    </form>
  </div>

  <%-- STUDENT FORM --%>
  <div id="form-student" style="display:none;">
    <form method="post" action="<c:url value='/student-login'/>">
      <c:if test="${not empty error and param.role == 'student'}">
        <div class="error-msg">${error}</div>
      </c:if>
      <c:if test="${param.role == 'student' and not empty error}">
        <div class="error-msg">Matricule or password is incorrect.</div>
      </c:if>
      <div class="field-group">
        <label class="field-label" for="s-code">MATRICULE</label>
        <input id="s-code" name="studentCode" class="field-input" type="text"
               placeholder="e.g. 232339052317" autocomplete="username"
               value="${not empty param.studentCode ? param.studentCode : ''}"/>
      </div>
      <div class="field-group">
        <label class="field-label" for="s-password">PASSWORD</label>
        <input id="s-password" name="password" class="field-input" type="password"
               placeholder="••••••••" autocomplete="current-password"/>
      </div>
      <button type="submit" class="btn-submit">Sign In as Student</button>
    </form>
  </div>

  <div class="login-help">
    Need help? <a href="<c:url value='/contact'/>">Contact Us</a>
    &nbsp;·&nbsp;
    <span id="link-teacher"><a href="<c:url value='/register'/>">Register</a></span>
    <span id="link-student" style="display:none"><a href="<c:url value='/student-register'/>">Student Register</a></span>
  </div>
</div>

<script>
  // If server sent back a student error, keep student tab active
  var initialRole = '${param.role}' === 'student' ? 'student' : 'teacher';
  if (initialRole === 'student') setRole('student');

  function setRole(role) {
    var isStudent = role === 'student';
    document.getElementById('btn-teacher').classList.toggle('active', !isStudent);
    document.getElementById('btn-student').classList.toggle('active',  isStudent);
    document.getElementById('form-teacher').style.display = isStudent ? 'none' : '';
    document.getElementById('form-student').style.display = isStudent ? '' : 'none';
    document.getElementById('link-teacher').style.display = isStudent ? 'none' : '';
    document.getElementById('link-student').style.display = isStudent ? '' : 'none';
  }
</script>
</body>
</html>
