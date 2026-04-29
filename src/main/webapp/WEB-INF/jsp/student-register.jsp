<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Presencia — Student Registration</title>
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
    .logo-pre  { font-family: 'Cormorant Garamond', serif; font-size: 2.8rem; font-weight: 600; color: #c4883a; letter-spacing: -1px; line-height: 1; }
    .logo-sub  { font-size: .68rem; font-weight: 500; letter-spacing: .22em; color: #9a9085; margin-top: .3rem; }
    .page-title { font-size: 1.05rem; font-weight: 600; color: #1e2d40; text-align: center; margin-bottom: 1.75rem; }

    .field-group { margin-bottom: 1.2rem; }
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

    .hint { font-size: .75rem; color: #aaa; margin-top: .35rem; }

    .alert-error {
      background: #fbeaea; color: #c93a3a;
      border: 1px solid rgba(201,58,58,.2);
      border-radius: 8px; padding: .65rem .9rem;
      font-size: .82rem; margin-bottom: 1.1rem;
    }
    .alert-success {
      background: rgba(61,122,90,0.08); color: #2d7a4a;
      border: 1px solid rgba(61,122,90,.2);
      border-radius: 8px; padding: .9rem 1rem;
      font-size: .85rem; margin-bottom: 1.1rem; line-height: 1.6;
    }

    .btn-submit {
      width: 100%; padding: .95rem 1.5rem;
      background: #1e2d40; color: #fff; border: none;
      border-radius: 10px; font-size: .95rem; font-weight: 500;
      font-family: 'DM Sans', sans-serif; cursor: pointer;
      transition: background .2s, transform .15s; margin-top: .25rem;
    }
    .btn-submit:hover { background: #2c3e55; transform: translateY(-1px); }

    .divider { border: none; border-top: 1px solid #e5ded4; margin: 1.5rem 0; }

    .footer-link { text-align: center; font-size: .85rem; color: #9a9085; margin-top: 1.25rem; }
    .footer-link a { color: #1e2d40; font-weight: 500; text-decoration: none; }
  </style>
</head>
<body>
<div class="card">
  <div class="logo-wrap">
    <div class="logo-pre">Presencia</div>
    <div class="logo-sub">ATTENDANCE SYSTEM</div>
  </div>
  <div class="page-title">🎒 Student Registration</div>

  <%-- SUCCESS STATE --%>
  <c:if test="${success}">
    <div class="alert-success">
      ✅ <strong>Account created successfully!</strong><br/>
      You can now sign in with your matricule and password.
    </div>
    <a href="<c:url value='/login'/>" class="btn-submit" style="display:block;text-align:center;text-decoration:none;">
      Go to Login →
    </a>
  </c:if>

  <%-- FORM STATE --%>
  <c:if test="${!success}">

    <c:if test="${not empty error}">
      <div class="alert-error">⚠️ ${error}</div>
    </c:if>

    <form method="post" action="<c:url value='/student-register'/>">

      <div class="field-group">
        <label class="field-label">MATRICULE (Student Code)</label>
        <input type="text" name="studentCode" class="field-input"
               placeholder="e.g. 232339052317"
               value="${not empty param.studentCode ? param.studentCode : ''}"
               required autocomplete="off"/>
        <div class="hint">Enter your matricule exactly as given by your teacher</div>
      </div>

      <div class="field-group">
        <label class="field-label">FIRST NAME</label>
        <input type="text" name="firstName" class="field-input"
               placeholder="e.g. Amira"
               value="${not empty param.firstName ? param.firstName : ''}"
               required/>
      </div>

      <div class="field-group">
        <label class="field-label">LAST NAME</label>
        <input type="text" name="lastName" class="field-input"
               placeholder="e.g. BOUDJEMAA"
               value="${not empty param.lastName ? param.lastName : ''}"
               required/>
        <div class="hint">Must match exactly what your teacher entered</div>
      </div>

      <hr class="divider"/>

      <div class="field-group">
        <label class="field-label">CHOOSE PASSWORD</label>
        <input type="password" name="password" class="field-input"
               placeholder="At least 4 characters" required minlength="4"/>
      </div>

      <div class="field-group">
        <label class="field-label">CONFIRM PASSWORD</label>
        <input type="password" name="confirmPassword" class="field-input"
               placeholder="Repeat your password" required minlength="4"/>
      </div>

      <button type="submit" class="btn-submit">Create My Account</button>
    </form>

  </c:if>

  <div class="footer-link">
    Already registered? <a href="<c:url value='/login'/>">Sign in here</a>
  </div>
</div>
</body>
</html>
