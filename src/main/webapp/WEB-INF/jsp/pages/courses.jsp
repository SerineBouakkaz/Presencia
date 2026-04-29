<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../layout/header.jsp" %>
<%@ include file="../layout/sidebar.jsp" %>

<main class="main">
    <div class="topbar">
        <div class="topbar-left"><button class="hamburger" onclick="openSidebar()" aria-label="Menu"><span></span><span></span><span></span></button>
            <div class="page-title">Courses</div>
            <span class="date-chip">${professor.department}</span>
        </div>
        <div class="topbar-actions">
            <a href="<c:url value='/dashboard'/>" class="btn btn-ghost">← Dashboard</a>
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#courseModal">＋ New Course</button>
        </div>
    </div>

    <div class="content" style="max-width:800px;">
        <c:if test="${param.added == 'true'}">
            <div class="alert py-2 mb-3" style="font-size:13px; border-radius:8px; background:rgba(61,122,90,0.1); color:var(--present); border:1px solid rgba(61,122,90,0.2);">
                Course created successfully!
            </div>
        </c:if>

        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>Course Name</th>
                        <th>Department</th>
                        <th style="text-align:right">Sessions</th>
                        <th style="text-align:right">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="c" items="${courses}">
                        <tr>
                            <td style="font-weight:500">${c.name}</td>
                            <td style="font-size:13px;color:var(--muted)">${c.department}</td>
                            <td style="text-align:right; font-family:'DM Mono',monospace; font-size:13px; color:var(--muted)">—</td>
                            <td style="text-align:right">
                                <a href="<c:url value='/dashboard?courseId=${c.id}'/>" class="btn btn-sm btn-ghost">Take Attendance</a>
                                <form method="post" action="<c:url value='/courses/delete'/>" style="display:inline;" onsubmit="return confirm('Delete this course? All sessions and attendance records will be lost.')">
                                    <input type="hidden" name="id" value="${c.id}">
                                    <button class="btn btn-sm btn-ghost" type="submit" style="color:var(--absent);">Delete</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty courses}">
                        <tr>
                            <td colspan="4" class="text-center py-4" style="color:var(--muted);">
                                No courses yet. Click <strong>＋ New Course</strong> to create one.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</main>

<!-- Add Course Modal -->
<div class="modal fade" id="courseModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius:16px; border:none;">
            <div class="modal-header" style="border-bottom:1px solid var(--border);">
                <h5 class="modal-title" style="font-family:'DM Serif Display',serif;">Create New Course</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="<c:url value='/courses/save'/>">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label" style="font-size:12px; font-weight:600; letter-spacing:1px; text-transform:uppercase; color:var(--muted); font-family:'DM Mono',monospace;">Course Name</label>
                        <input type="text" name="name" class="form-control" placeholder="e.g. Web Development" required
                               style="border:1px solid var(--border); border-radius:8px; padding:10px 14px;">
                    </div>
                    <div class="mb-3">
                        <label class="form-label" style="font-size:12px; font-weight:600; letter-spacing:1px; text-transform:uppercase; color:var(--muted); font-family:'DM Mono',monospace;">Department</label>
                        <input type="text" class="form-control" value="${professor.department}" readonly
                               style="border:1px solid var(--border); border-radius:8px; padding:10px 14px; background:var(--cream); color:var(--muted);">
                    </div>
                </div>
                <div class="modal-footer" style="border-top:1px solid var(--border);">
                    <button type="button" class="btn btn-ghost" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Create Course</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="../layout/footer.jsp" %>
