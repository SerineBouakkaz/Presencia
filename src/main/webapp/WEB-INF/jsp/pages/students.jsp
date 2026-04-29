<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../layout/header.jsp" %>

<jsp:include page="../layout/sidebar.jsp"/>

<main class="main">
    <div class="topbar">
        <div class="topbar-left"><button class="hamburger" onclick="openSidebar()" aria-label="Menu"><span></span><span></span><span></span></button>
            <div class="page-title">Students</div>
            <span class="date-chip">${total} total</span>
        </div>
        <div class="topbar-actions">
            <a href="<c:url value='/dashboard'/>" class="btn btn-ghost">← Back</a>
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#studentModal">＋ Add Student</button>
            <form method="post" action="<c:url value='/logout'/>" class="d-inline">
                <button class="btn btn-ghost" type="submit" style="margin-left:8px;">Logout</button>
            </form>
        </div>
    </div>

    <div class="content">
        <div class="search-bar mb-3" style="max-width:360px">
            <span style="color:var(--muted);font-size:14px">🔍</span>
            <c:url value="/students" var="searchUrl">
                <c:param name="page" value="1"/>
                <c:param name="limit" value="10"/>
            </c:url>
            <form action="${searchUrl}" method="get" style="flex:1; display:flex;">
                <input type="text" name="search" class="form-control" placeholder="Search students by name or code…"
                       value="${search}" style="background:var(--cream); border:1px solid var(--border); border-radius:6px; padding:8px 12px; font-size:13px;">
            </form>
        </div>

        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Student Code</th>
                        <th>Name</th>
                        <th>Group</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th style="text-align:right">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="s" items="${students}" varStatus="vs">
                        <tr>
                            <td style="font-family:'DM Mono',monospace;font-size:12px;color:var(--muted);">
                                <fmt:formatNumber value="${(page-1)*10 + vs.count}" type="number" minIntegerDigits="2" maxFractionDigits="0"/>
                            </td>
                            <td style="font-family:'DM Mono',monospace;font-size:13px">${s.studentCode}</td>
                            <td>
                                <div class="student-cell">
                                    <div class="stu-name">${s.firstName} ${s.lastName}</div>
                                </div>
                            </td>
                            <td style="font-size:13px;color:var(--muted)">${s.groupName}</td>
                            <td style="font-size:13px;color:var(--muted)">${s.email}</td>
                            <td style="font-size:13px;color:var(--muted)">${s.phone}</td>
                            <td style="text-align:right">
                                <button class="btn btn-sm btn-ghost" data-bs-toggle="modal" data-bs-target="#studentModal"
                                        onclick="editStudent('${s.id}','${s.firstName}','${s.lastName}','${s.studentCode}','${s.email}','${s.phone}','${s.groupName}')">✏️</button>
                                <form method="post" action="<c:url value='/students/delete'/>" style="display:inline;">
                                    <input type="hidden" name="id" value="${s.id}">
                                    <button class="btn btn-sm btn-ghost" type="submit" onclick="return confirm('Delete this student?')">🗑️</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty students}">
                        <tr><td colspan="6" class="text-center py-4" style="color:var(--muted);">No students found.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <!-- PAGINATION -->
        <nav class="d-flex justify-content-between align-items-center mt-3" style="font-size:13px; color:var(--muted);">
            <div>Page ${page} of ${totalPages}</div>
            <div>
                <c:if test="${page > 1}">
                    <c:url value="/students" var="prevUrl">
                        <c:param name="page" value="${page - 1}"/>
                        <c:param name="limit" value="10"/>
                        <c:param name="search" value="${search}"/>
                    </c:url>
                    <a href="${prevUrl}" class="btn btn-sm btn-ghost">← Previous</a>
                </c:if>
                <c:if test="${page < totalPages}">
                    <c:url value="/students" var="nextUrl">
                        <c:param name="page" value="${page + 1}"/>
                        <c:param name="limit" value="10"/>
                        <c:param name="search" value="${search}"/>
                    </c:url>
                    <a href="${nextUrl}" class="btn btn-sm btn-ghost">Next →</a>
                </c:if>
            </div>
        </nav>
    </div>
</main>

<!-- MODAL -->
<div class="modal fade" id="studentModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius:16px; border:none;">
            <div class="modal-header" style="border-bottom:1px solid var(--border);">
                <h5 class="modal-title" style="font-family:'DM Serif Display',serif;">Add / Edit Student</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="<c:url value='/students/save'/>">
                <input type="hidden" name="id" id="editId" value="">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label" style="font-size:12px; font-weight:600; letter-spacing:1px; text-transform:uppercase; color:var(--muted); font-family:'DM Mono',monospace;">First Name</label>
                        <input type="text" name="firstName" id="editFirstName" class="form-control" required style="border:1px solid var(--border);border-radius:8px;padding:10px 14px;">
                    </div>
                    <div class="mb-3">
                        <label class="form-label" style="font-size:12px; font-weight:600; letter-spacing:1px; text-transform:uppercase; color:var(--muted); font-family:'DM Mono',monospace;">Last Name</label>
                        <input type="text" name="lastName" id="editLastName" class="form-control" required style="border:1px solid var(--border);border-radius:8px;padding:10px 14px;">
                    </div>
                    <div class="mb-3">
                        <label class="form-label" style="font-size:12px; font-weight:600; letter-spacing:1px; text-transform:uppercase; color:var(--muted); font-family:'DM Mono',monospace;">Student Code</label>
                        <input type="text" name="studentCode" id="editStudentCode" class="form-control" required style="border:1px solid var(--border);border-radius:8px;padding:10px 14px;">
                    </div>
                    <div class="mb-3">
                        <label class="form-label" style="font-size:12px; font-weight:600; letter-spacing:1px; text-transform:uppercase; color:var(--muted); font-family:'DM Mono',monospace;">Email</label>
                        <input type="email" name="email" id="editEmail" class="form-control" style="border:1px solid var(--border);border-radius:8px;padding:10px 14px;">
                    </div>
                    <div class="mb-3">
                        <label class="form-label" style="font-size:12px; font-weight:600; letter-spacing:1px; text-transform:uppercase; color:var(--muted); font-family:'DM Mono',monospace;">Phone</label>
                        <input type="text" name="phone" id="editPhone" class="form-control" style="border:1px solid var(--border);border-radius:8px;padding:10px 14px;">
                    </div>
                    <div class="mb-3">
                        <label class="form-label" style="font-size:12px; font-weight:600; letter-spacing:1px; text-transform:uppercase; color:var(--muted); font-family:'DM Mono',monospace;">Group</label>
                        <select name="groupName" id="editGroupName" class="form-control" style="border:1px solid var(--border);border-radius:8px;padding:10px 14px;">
                            <option value="">— No Group —</option>
                            <c:forEach var="g" items="${groups}">
                                <option value="${g}">${g}</option>
                            </c:forEach>
                        </select>
                        <div style="font-size:11px;color:var(--muted);margin-top:4px;">
                            Or type a new group name: <input type="text" id="newGroupInput" placeholder="e.g. L2-A" style="border:1px solid var(--border);border-radius:6px;padding:4px 8px;font-size:12px;margin-left:4px;width:100px;"
                                oninput="if(this.value){ document.getElementById('editGroupName').value=''; }">
                        </div>
                    </div>
                </div>
                <div class="modal-footer" style="border-top:1px solid var(--border);">
                    <button type="button" class="btn btn-ghost" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Student</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%-- inline script for edit student --%>
<script>
function editStudent(id, fn, ln, code, email, phone, group) {
    document.getElementById('editId').value          = id;
    document.getElementById('editFirstName').value   = fn;
    document.getElementById('editLastName').value    = ln;
    document.getElementById('editStudentCode').value = code;
    document.getElementById('editEmail').value       = email  || '';
    document.getElementById('editPhone').value       = phone  || '';
    document.getElementById('newGroupInput').value   = '';
    // Select existing group in dropdown if it exists; otherwise clear
    var sel = document.getElementById('editGroupName');
    var found = false;
    for (var i = 0; i < sel.options.length; i++) {
        if (sel.options[i].value === group) { sel.selectedIndex = i; found = true; break; }
    }
    if (!found) {
        sel.selectedIndex = 0;
        if (group) document.getElementById('newGroupInput').value = group;
    }
}

// Before form submits, merge newGroupInput into the groupName select if typed
document.querySelector('#studentModal form').addEventListener('submit', function() {
    var newGrp = document.getElementById('newGroupInput').value.trim();
    if (newGrp) {
        // Ensure an option exists and is selected
        var sel = document.getElementById('editGroupName');
        var found = false;
        for (var i = 0; i < sel.options.length; i++) {
            if (sel.options[i].value === newGrp) { sel.selectedIndex = i; found = true; break; }
        }
        if (!found) {
            var opt = document.createElement('option');
            opt.value = newGrp; opt.text = newGrp; opt.selected = true;
            sel.appendChild(opt);
        }
    }
});
</script>
<%@ include file="../layout/footer.jsp" %>
