<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../layout/header.jsp" %>

<jsp:include page="../layout/sidebar.jsp"/>

<main class="main">
    <div class="topbar">
        <div class="topbar-left"><button class="hamburger" onclick="openSidebar()" aria-label="Menu"><span></span><span></span><span></span></button>
            <div class="page-title">Reports</div>
            <span class="date-chip">Attendance History</span>
        </div>
        <div class="topbar-actions">
            <a href="<c:url value='/dashboard'/>" class="btn btn-ghost">← Back</a>
            <form method="post" action="<c:url value='/logout'/>" class="d-inline">
                <button class="btn btn-ghost" type="submit" style="margin-left:8px;">Logout</button>
            </form>
        </div>
    </div>

    <div class="content">
        <!-- Course Filter -->
        <div class="class-strip">
            <label>Filter by Course</label>
            <form method="get" action="<c:url value='/reports'/>" style="display:inline-flex; align-items:center; gap:12px;">
                <select class="select-styled" name="courseId" onchange="this.form.submit()">
                    <option value="">All Courses</option>
                    <c:forEach var="c" items="${courses}">
                        <option value="${c.id}" ${selectedCourseId == c.id ? 'selected' : ''}>${c.name}</option>
                    </c:forEach>
                </select>
            </form>
        </div>

        <div class="table-wrap">
            <table class="report-table">
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Time Slot</th>
                        <th>Present</th>
                        <th>Absent</th>
                        <th>Late</th>
                        <th>Excused</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="s" items="${sessions}">
                        <tr>
                            <td>${s.formattedDate}</td>
                            <td style="font-family:'DM Mono',monospace; font-size:13px;">${s.timeSlot}</td>
                            <td>
                                <span style="color:var(--present); font-weight:600;">
                                    ${session != null && session.id == s.id ? stats.present : '—'}
                                </span>
                            </td>
                            <td>
                                <span style="color:var(--absent); font-weight:600;">
                                    ${session != null && session.id == s.id ? stats.absent : '—'}
                                </span>
                            </td>
                            <td>
                                <span style="color:var(--late); font-weight:600;">
                                    ${session != null && session.id == s.id ? stats.late : '—'}
                                </span>
                            </td>
                            <td>
                                <span style="color:var(--excused); font-weight:600;">
                                    ${session != null && session.id == s.id ? stats.excused : '—'}
                                </span>
                            </td>
                            <td>
                                <a href="<c:url value='/reports/session/${s.id}'/>" class="btn btn-sm btn-ghost">📄 View</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty sessions}">
                        <tr><td colspan="7" class="text-center py-4" style="color:var(--muted);">No sessions found for this course.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <!-- If viewing a specific session, show student detail -->
        <c:if test="${session != null}">
            <h3 style="font-family:'DM Serif Display',serif; font-size:18px; margin-top:32px; margin-bottom:16px;">
                Session Details — ${session.formattedDate} ${session.timeSlot}
            </h3>
            <div class="table-wrap">
                <div class="table-header">
                    <div class="table-title">Attendance Records</div>
                    <div>
                        <a href="<c:url value='/reports/export/${session.id}'/>" class="btn btn-sm btn-ghost">📥 Export CSV</a>
                    </div>
                </div>
                <table>
                    <thead>
                        <tr><th>Student</th><th>Code</th><th>Status</th><th>Note</th></tr>
                    </thead>
                    <tbody>
                        <c:forEach var="r" items="${records}">
                            <tr>
                                <td>${r.studentId}</td>
                                <td style="font-family:'DM Mono',monospace; font-size:12px; color:var(--muted);">—</td>
                                <td>
                                    <span class="status-btn ${r.status} active" style="cursor:default; padding:4px 10px;">
                                        ${r.status}
                                    </span>
                                </td>
                                <td style="font-size:13px; color:var(--muted);">${r.note}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
    </div>
</main>

<%@ include file="../layout/footer.jsp" %>
