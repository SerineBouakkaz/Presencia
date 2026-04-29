<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../layout/header.jsp" %>
<jsp:include page="../layout/sidebar.jsp"/>

<main class="main">
    <div class="topbar">
        <div class="topbar-left"><button class="hamburger" onclick="openSidebar()" aria-label="Menu"><span></span><span></span><span></span></button>
            <div class="page-title">🔔 Automation Alerts</div>
        </div>
        <div class="topbar-actions">
            <form method="post" action="<c:url value='/alerts/run-checks'/>" class="d-inline">
                <button class="btn btn-primary" type="submit" style="font-size:13px;">▶ Run Checks Now</button>
            </form>
        </div>
    </div>

    <div class="content">

        <c:if test="${param.checked != null}">
            <div style="margin-bottom:16px; padding:12px 16px; border-radius:8px;
                        background:rgba(61,122,90,0.08); color:var(--present);
                        border:1px solid rgba(61,122,90,0.2); font-size:13px;">
                ✅ Checks completed. New alerts generated if conditions were met.
            </div>
        </c:if>

        <%-- Summary row --%>
        <c:set var="activeCount" value="0"/>
        <c:forEach var="a" items="${alerts}">
            <c:if test="${!a.resolved}"><c:set var="activeCount" value="${activeCount + 1}"/></c:if>
        </c:forEach>

        <div style="display:grid; grid-template-columns:repeat(3,1fr); gap:14px; margin-bottom:24px;">
            <div class="table-wrap" style="padding:20px; text-align:center;">
                <div style="font-size:28px; font-weight:700; color:var(--absent);">${activeCount}</div>
                <div style="font-size:12px; color:var(--muted); margin-top:4px;">Active Alerts</div>
            </div>
            <div class="table-wrap" style="padding:20px; text-align:center;">
                <c:set var="absCount" value="0"/>
                <c:forEach var="a" items="${alerts}">
                    <c:if test="${a.type == 'student_absence' && !a.resolved}"><c:set var="absCount" value="${absCount+1}"/></c:if>
                </c:forEach>
                <div style="font-size:28px; font-weight:700; color:var(--late);">${absCount}</div>
                <div style="font-size:12px; color:var(--muted); margin-top:4px;">Student Absence Alerts</div>
            </div>
            <div class="table-wrap" style="padding:20px; text-align:center;">
                <c:set var="inactCount" value="0"/>
                <c:forEach var="a" items="${alerts}">
                    <c:if test="${a.type == 'professor_inactive' && !a.resolved}"><c:set var="inactCount" value="${inactCount+1}"/></c:if>
                </c:forEach>
                <div style="font-size:28px; font-weight:700; color:var(--muted);">${inactCount}</div>
                <div style="font-size:12px; color:var(--muted); margin-top:4px;">Inactive Professor Alerts</div>
            </div>
        </div>

        <%-- Alert list --%>
        <div class="table-wrap" style="padding:0; overflow:hidden;">
            <div style="padding:18px 24px; border-bottom:1px solid var(--border); display:flex; align-items:center; gap:10px;">
                <span style="font-family:'DM Serif Display',serif; font-size:16px;">All Alerts</span>
                <span style="font-size:12px; color:var(--muted);">· auto-runs daily at 08:00</span>
            </div>

            <c:choose>
                <c:when test="${empty alerts}">
                    <div style="padding:40px; text-align:center; color:var(--muted); font-size:14px;">
                        No alerts yet. Click "Run Checks Now" to scan for issues.
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="alert" items="${alerts}">
                        <div style="display:flex; align-items:center; justify-content:space-between;
                                    padding:16px 24px; border-bottom:1px solid var(--border);
                                    background:${alert.resolved ? 'transparent' : (alert.type == 'student_absence' ? 'rgba(220,53,69,0.04)' : 'rgba(255,193,7,0.06)')};
                                    opacity:${alert.resolved ? '0.5' : '1'};">
                            <div style="display:flex; align-items:flex-start; gap:12px;">
                                <div style="margin-top:2px; font-size:18px;">
                                    <c:choose>
                                        <c:when test="${alert.type == 'student_absence'}">🎓</c:when>
                                        <c:otherwise>🕐</c:otherwise>
                                    </c:choose>
                                </div>
                                <div>
                                    <div style="font-size:14px; color:var(--ink); font-weight:${alert.resolved ? '400' : '500'};">
                                        ${alert.message}
                                    </div>
                                    <div style="font-size:11px; color:var(--muted); margin-top:3px; font-family:'DM Mono',monospace;">
                                        <c:choose>
                                            <c:when test="${alert.type == 'student_absence'}">STUDENT ABSENCE</c:when>
                                            <c:otherwise>PROFESSOR INACTIVE</c:otherwise>
                                        </c:choose>
                                        &nbsp;·&nbsp; ${alert.createdAt}
                                        <c:if test="${alert.resolved}"> &nbsp;·&nbsp; <span style="color:var(--present);">✓ resolved</span></c:if>
                                    </div>
                                </div>
                            </div>
                            <c:if test="${!alert.resolved}">
                                <form method="post" action="<c:url value='/alerts/resolve'/>">
                                    <input type="hidden" name="id" value="${alert.id}"/>
                                    <button type="submit" class="btn btn-ghost"
                                            style="font-size:12px; padding:6px 12px; white-space:nowrap;">
                                        ✓ Resolve
                                    </button>
                                </form>
                            </c:if>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<%@ include file="../layout/footer.jsp" %>
