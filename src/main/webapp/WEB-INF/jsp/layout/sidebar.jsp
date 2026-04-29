<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<aside class="sidebar">
  <div class="sidebar-brand">
    <div class="brand-mark">Presencia</div>
    <div class="brand-sub">ATTENDANCE SYSTEM</div>
  </div>

  <c:set var="uri" value="${pageContext.request.requestURI}"/>

  <div class="nav-label">WORKSPACE</div>
  <a href="<c:url value='/dashboard'/>"  class="nav-item ${uri.contains('dashboard') ? 'active' : ''}"><span class="nav-icon" style="font-family:'Apple Color Emoji','Segoe UI Emoji','Noto Color Emoji',sans-serif">📋</span> Attendance</a>
  <a href="<c:url value='/students'/>"   class="nav-item ${uri.contains('students')  ? 'active' : ''}"><span class="nav-icon" style="font-family:'Apple Color Emoji','Segoe UI Emoji','Noto Color Emoji',sans-serif">👥</span> Students</a>
  <a href="<c:url value='/reports'/>"    class="nav-item ${uri.contains('reports')   ? 'active' : ''}"><span class="nav-icon" style="font-family:'Apple Color Emoji','Segoe UI Emoji','Noto Color Emoji',sans-serif">📊</span> Reports</a>
  <a href="<c:url value='/courses'/>"    class="nav-item ${uri.contains('courses')   ? 'active' : ''}"><span class="nav-icon" style="font-family:'Apple Color Emoji','Segoe UI Emoji','Noto Color Emoji',sans-serif">📚</span> Courses</a>

  <c:if test="${professor.admin}">
    <div class="nav-label">ADMIN</div>
    <a href="<c:url value='/alerts'/>" class="nav-item ${uri.contains('alerts') ? 'active' : ''}"><span class="nav-icon" style="font-family:'Apple Color Emoji','Segoe UI Emoji','Noto Color Emoji',sans-serif">🔔</span> Alerts</a>
  </c:if>

  <div class="nav-label">ACCOUNT</div>
  <a href="<c:url value='/settings'/>" class="nav-item ${uri.contains('settings') ? 'active' : ''}"><span class="nav-icon" style="font-family:'Apple Color Emoji','Segoe UI Emoji','Noto Color Emoji',sans-serif">⚙️</span> Settings</a>

  <div class="sidebar-footer">
    <div class="teacher-card">
      <div class="teacher-avatar">${professor.initials}</div>
      <div class="teacher-info">
        <div class="name">${professor.name}<c:if test="${professor.admin}"> <span class="badge badge-admin" style="font-size:.55rem;padding:1px 6px;">ADMIN</span></c:if></div>
        <div class="role">${professor.department}</div>
      </div>
    </div>
  </div>
</aside>
