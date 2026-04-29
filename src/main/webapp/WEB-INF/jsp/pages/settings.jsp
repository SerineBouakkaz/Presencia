<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../layout/header.jsp" %>

<jsp:include page="../layout/sidebar.jsp"/>

<main class="main">
    <div class="topbar">
        <div class="topbar-left"><button class="hamburger" onclick="openSidebar()" aria-label="Menu"><span></span><span></span><span></span></button>
            <div class="page-title">Settings</div>
        </div>
        <div class="topbar-actions">
            <a href="<c:url value='/dashboard'/>" class="btn btn-ghost">← Back</a>
            <form method="post" action="<c:url value='/logout'/>" class="d-inline">
                <button class="btn btn-ghost" type="submit" style="margin-left:8px;">Logout</button>
            </form>
        </div>
    </div>

    <div class="content" style="max-width:660px;">

        <c:if test="${updated}">
            <div style="margin-bottom:18px; padding:12px 16px; border-radius:8px;
                        background:rgba(61,122,90,0.08); color:var(--present);
                        border:1px solid rgba(61,122,90,0.2); font-size:13px;">
                ✅ Profile updated successfully.
            </div>
        </c:if>

        <%-- ── Profile card ── --%>
        <div class="table-wrap" style="padding:28px; margin-bottom:18px;">

            <div style="display:flex; align-items:center; gap:18px; margin-bottom:28px;">
                <div class="teacher-avatar" style="width:56px; height:56px; font-size:20px; flex-shrink:0;">
                    ${professor.initials}
                </div>
                <div>
                    <div style="font-family:'DM Serif Display',serif; font-size:18px; font-weight:600;">
                        ${professor.name}
                    </div>
                    <div style="font-size:12px; color:var(--muted); margin-top:2px;">
                        ${professor.department} &nbsp;·&nbsp; ${professor.email}
                    </div>
                </div>
            </div>

            <h3 style="font-family:'DM Serif Display',serif; font-size:15px; margin-bottom:18px;
                       padding-bottom:10px; border-bottom:1px solid var(--border);">
                Edit Profile
            </h3>

            <form method="post" action="<c:url value='/settings/update'/>">

                <div style="display:grid; grid-template-columns:1fr 1fr; gap:14px; margin-bottom:14px;">
                    <div>
                        <label style="display:block; font-size:11px; font-weight:600; letter-spacing:.9px;
                                      text-transform:uppercase; color:var(--muted);
                                      font-family:'DM Mono',monospace; margin-bottom:6px;">
                            Full Name
                        </label>
                        <input type="text" name="name" required
                               value="${professor.name}"
                               class="form-control"
                               style="border:1px solid var(--border); border-radius:8px; padding:10px 14px; width:100%; box-sizing:border-box;">
                    </div>
                    <div>
                        <label style="display:block; font-size:11px; font-weight:600; letter-spacing:.9px;
                                      text-transform:uppercase; color:var(--muted);
                                      font-family:'DM Mono',monospace; margin-bottom:6px;">
                            Department
                        </label>
                        <input type="text" name="department" required
                               value="${professor.department}"
                               class="form-control"
                               style="border:1px solid var(--border); border-radius:8px; padding:10px 14px; width:100%; box-sizing:border-box;">
                    </div>
                </div>

                <div style="margin-bottom:20px;">
                    <label style="display:block; font-size:11px; font-weight:600; letter-spacing:.9px;
                                  text-transform:uppercase; color:var(--muted);
                                  font-family:'DM Mono',monospace; margin-bottom:6px;">
                        Email
                    </label>
                    <input type="email" name="email" required
                           value="${professor.email}"
                           class="form-control"
                           style="border:1px solid var(--border); border-radius:8px; padding:10px 14px; width:100%; box-sizing:border-box;">
                </div>

                <button type="submit" class="btn btn-primary">Save Changes</button>
            </form>
        </div>

        <%-- ── Modules / Courses ── --%>
        <div class="table-wrap" style="padding:28px; margin-bottom:18px;">
            <h3 style="font-family:'DM Serif Display',serif; font-size:15px; margin-bottom:18px;
                       padding-bottom:10px; border-bottom:1px solid var(--border);">
                📚 My Modules
            </h3>

            <c:choose>
                <c:when test="${empty courses}">
                    <p style="font-size:13px; color:var(--muted); text-align:center; padding:20px 0;">
                        No modules assigned yet.
                        <a href="<c:url value='/courses'/>" style="color:var(--ink);">Go to Courses →</a>
                    </p>
                </c:when>
                <c:otherwise>
                    <div style="display:flex; flex-direction:column; gap:10px;">
                        <c:forEach var="course" items="${courses}">
                            <div style="display:flex; align-items:center; justify-content:space-between;
                                        padding:12px 16px; border-radius:8px;
                                        border:1px solid var(--border); background:var(--cream);">
                                <div>
                                    <div style="font-size:14px; font-weight:600; color:var(--ink);">
                                        ${course.name}
                                    </div>
                                    <div style="font-size:12px; color:var(--muted); margin-top:2px;">
                                        ${course.department}
                                    </div>
                                </div>
                                <a href="<c:url value='/courses'/>"
                                   style="font-size:12px; color:var(--muted); text-decoration:none;">
                                    Manage →
                                </a>
                            </div>
                        </c:forEach>
                    </div>
                    <p style="font-size:12px; color:var(--muted); margin-top:14px;">
                        ${courses.size()} module(s) · <a href="<c:url value='/courses'/>" style="color:var(--ink);">Add or remove modules in Courses</a>
                    </p>
                </c:otherwise>
            </c:choose>
        </div>


        <%-- ── Change Password ── --%>
        <div class="table-wrap" style="padding:28px; margin-bottom:18px;">
            <h3 style="font-family:'DM Serif Display',serif; font-size:15px; margin-bottom:18px;
                       padding-bottom:10px; border-bottom:1px solid var(--border);">
                🔑 Change Password
            </h3>
            <c:if test="${pwdError != null}">
                <div style="margin-bottom:14px; padding:10px 14px; border-radius:8px;
                            background:rgba(200,75,49,0.08); color:var(--absent); border:1px solid rgba(200,75,49,0.2); font-size:13px;">
                    ❌ ${pwdError}
                </div>
            </c:if>
            <c:if test="${pwdUpdated}">
                <div style="margin-bottom:14px; padding:10px 14px; border-radius:8px;
                            background:rgba(61,122,90,0.08); color:var(--present); border:1px solid rgba(61,122,90,0.2); font-size:13px;">
                    ✅ Password updated successfully.
                </div>
            </c:if>
            <form method="post" action="<c:url value='/settings/change-password'/>">
                <div style="margin-bottom:14px;">
                    <label style="display:block; font-size:11px; font-weight:600; letter-spacing:.9px;
                                  text-transform:uppercase; color:var(--muted);
                                  font-family:'DM Mono',monospace; margin-bottom:6px;">Current Password</label>
                    <input type="password" name="currentPassword" required class="form-control"
                           style="border:1px solid var(--border); border-radius:8px; padding:10px 14px; width:100%; box-sizing:border-box;">
                </div>
                <div style="display:grid; grid-template-columns:1fr 1fr; gap:14px; margin-bottom:14px;">
                    <div>
                        <label style="display:block; font-size:11px; font-weight:600; letter-spacing:.9px;
                                      text-transform:uppercase; color:var(--muted);
                                      font-family:'DM Mono',monospace; margin-bottom:6px;">New Password</label>
                        <input type="password" name="newPassword" required class="form-control" minlength="4"
                               style="border:1px solid var(--border); border-radius:8px; padding:10px 14px; width:100%; box-sizing:border-box;">
                    </div>
                    <div>
                        <label style="display:block; font-size:11px; font-weight:600; letter-spacing:.9px;
                                      text-transform:uppercase; color:var(--muted);
                                      font-family:'DM Mono',monospace; margin-bottom:6px;">Confirm New Password</label>
                        <input type="password" name="confirmPassword" required class="form-control" minlength="4"
                               style="border:1px solid var(--border); border-radius:8px; padding:10px 14px; width:100%; box-sizing:border-box;">
                    </div>
                </div>
                <button type="submit" class="btn btn-primary">Update Password</button>
            </form>
        </div>

        <%-- ── Session ── --%>
        <div class="table-wrap" style="padding:28px;">
            <h3 style="font-family:'DM Serif Display',serif; font-size:15px; margin-bottom:10px;">
                Session
            </h3>
            <form method="post" action="<c:url value='/logout'/>">
                <p style="font-size:13px; color:var(--muted); margin-bottom:12px;">
                    Log out and end your current session.
                </p>
                <button type="submit" class="btn btn-ghost"
                        style="border-color:var(--absent); color:var(--absent);">
                    🚪 Log Out
                </button>
            </form>
        </div>

    </div>
</main>

<%@ include file="../layout/footer.jsp" %>
