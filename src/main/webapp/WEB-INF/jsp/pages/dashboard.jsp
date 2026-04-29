<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../layout/header.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/qrcodejs@1.0.0/qrcode.min.js"></script>

<jsp:include page="../layout/sidebar.jsp"/>

<main class="main">
  <!-- Topbar -->
  <div class="topbar">
    <div class="topbar-left">
      <button class="hamburger" onclick="openSidebar()" aria-label="Menu"><span></span><span></span><span></span></button>
      <div class="page-title">Attendance</div>
      <span class="date-chip">
        <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd MMM yyyy"/>
      </span>
    </div>
    <div class="topbar-actions">
      <button class="btn btn-ghost" onclick="openQR()">
        📷 QR
      </button>
      <button class="btn btn-ghost" id="new-session-btn" onclick="startNewSession()" style="border:1.5px solid var(--border);">
        ➕ New Session
      </button>
      <button class="btn btn-ghost" id="delete-session-btn" onclick="deleteSession()" style="border:1.5px solid #f5c0c0; color:#c84b31;" title="Delete current session">
        🗑️ Delete Session
      </button>
      <button class="btn btn-primary" id="save-btn" onclick="saveAttendance()">
        💾 Save Session
      </button>
      <form method="post" action="<c:url value='/logout'/>" class="d-inline">
        <button class="btn btn-ghost" type="submit">Logout</button>
      </form>
    </div>
  </div>

  <!-- Class / Group / Session strip -->
  <div class="class-strip">
    <label>COURSE</label>
    <select class="select-styled" id="courseSelect" onchange="changeCourse()">
      <option value="">— Select —</option>
      <c:forEach var="c" items="${courses}">
        <option value="${c.id}" ${selectedCourseId == c.id ? 'selected' : ''}>${c.name}</option>
      </c:forEach>
    </select>

    <label>GROUP</label>
    <select class="select-styled" id="groupSelect" onchange="changeGroup()">
      <option value="">— All Groups —</option>
      <c:forEach var="g" items="${groups}">
        <option value="${g}" ${selectedGroup == g ? 'selected' : ''}>${g}</option>
      </c:forEach>
    </select>

    <label>SESSION</label>
    <select class="select-styled" id="sessionSelect" onchange="changeSession()">
      <c:if test="${empty sessions}">
        <option value="">— No sessions —</option>
      </c:if>
      <c:forEach var="s" items="${sessions}">
        <option value="${s.id}" ${selectedSessionId == s.id ? 'selected' : ''}>
          ${s.formattedDate} · ${s.timeSlot}
        </option>
      </c:forEach>
    </select>

    <button class="btn btn-ghost" style="border-radius:50px;font-size:.78rem;" onclick="markAllPresent()">
      ✓ All Present
    </button>
  </div>

  <!-- Stat cards -->
  <div class="stats-row">
    <div class="stat-card s-present">
      <div>
        <div class="stat-number" id="cnt-present">0</div>
        <div class="stat-label">Present</div>
      </div>
      <div class="stat-icon">✓</div>
    </div>
    <div class="stat-card s-absent">
      <div>
        <div class="stat-number" id="cnt-absent">0</div>
        <div class="stat-label">Absent</div>
      </div>
      <div class="stat-icon">⊘</div>
    </div>
    <div class="stat-card s-late">
      <div>
        <div class="stat-number" id="cnt-late">0</div>
        <div class="stat-label">Late</div>
      </div>
      <div class="stat-icon">⏰</div>
    </div>
    <div class="stat-card s-excused">
      <div>
        <div class="stat-number" id="cnt-excused">0</div>
        <div class="stat-label">Excused</div>
      </div>
      <div class="stat-icon">📋</div>
    </div>
  </div>

  <!-- Donut chart -->
  <div class="chart-card">
    <div class="donut-wrap">
      <canvas id="sessionPie" style="max-width:160px;max-height:160px;"></canvas>
    </div>
    <div class="chart-legend">
      <div class="legend-item"><div class="legend-dot" style="background:var(--green)"></div>Present</div>
      <div class="legend-item"><div class="legend-dot" style="background:var(--red)"></div>Absent</div>
      <div class="legend-item"><div class="legend-dot" style="background:var(--amber)"></div>Late</div>
      <div class="legend-item"><div class="legend-dot" style="background:var(--blue)"></div>Excused</div>
    </div>
  </div>

  <!-- Student list header -->
  <div class="section-header">
    <div class="section-title">Student List</div>
    <div class="search-box">
      <input type="text" placeholder="Search students…" id="search-inp" oninput="filterStudents(this.value)">
    </div>
  </div>

  <!-- Student rows -->
  <div id="student-list">
    <c:forEach var="student" items="${students}" varStatus="st">
      <c:set var="rec" value="${records[student.id]}"/>
      <c:set var="status" value="${rec != null ? rec.status : 'present'}"/>
      <div class="student-row" id="row-${student.id}" data-id="${student.id}" data-name="${fn:escapeXml(student.fullName)}" data-code="${fn:escapeXml(student.studentCode)}">
        <input type="checkbox" class="row-cb" data-id="${student.id}" onchange="toggleRow(${student.id}, this.checked)"/>
        <span class="student-num">${String.format('%02d', st.index + 1)}</span>
        <div class="student-avatar av-${student.id % 10}">${student.initials}</div>
        <div class="student-info">
          <div class="student-name">${student.fullName}</div>
          <div class="student-code">${student.studentCode}<c:if test="${not empty student.groupName}"> · ${student.groupName}</c:if></div>
        </div>
        <div class="status-btns" id="btns-${student.id}">
          <button type="button" class="status-btn${status == 'present' ? ' active-P' : ''}" data-status="present" data-sid="${student.id}">P</button>
          <button type="button" class="status-btn${status == 'absent'  ? ' active-A' : ''}" data-status="absent"  data-sid="${student.id}">A</button>
          <button type="button" class="status-btn${status == 'late'    ? ' active-L' : ''}" data-status="late"    data-sid="${student.id}">L</button>
          <button type="button" class="status-btn${status == 'excused' ? ' active-E' : ''}" data-status="excused" data-sid="${student.id}">E</button>
        </div>
        <input type="hidden" class="status-val" id="status-${student.id}" value="${status}"/>
        <input type="text" class="note-field-inline" data-student="${student.id}" placeholder="Add note…" value="${rec != null ? rec.note : ''}"/>
      </div>
    </c:forEach>
  </div>

  <div style="height:2rem;"></div>
</main>

<!-- Bulk bar -->
<div id="bulkBar" style="display:none;position:fixed;bottom:1.5rem;left:50%;transform:translateX(-50%);background:var(--navy);color:#fff;padding:.6rem 1.2rem;border-radius:50px;display:flex;align-items:center;gap:.8rem;z-index:200;box-shadow:0 4px 20px rgba(0,0,0,.3);">
  <span id="bulkText"></span>
  <button onclick="bulkSet('present')" style="background:#2d7a4a;border:none;color:#fff;border-radius:20px;padding:.25rem .7rem;cursor:pointer;font-size:.8rem;">✓ Present</button>
  <button onclick="bulkSet('absent')"  style="background:#c93a3a;border:none;color:#fff;border-radius:20px;padding:.25rem .7rem;cursor:pointer;font-size:.8rem;">⊘ Absent</button>
  <button onclick="clearSelection()"   style="background:transparent;border:1px solid rgba(255,255,255,.4);color:#fff;border-radius:20px;padding:.25rem .7rem;cursor:pointer;font-size:.8rem;">✕ Clear</button>
</div>

<!-- Toast container -->
<div id="toastContainer" style="position:fixed;bottom:1rem;right:1rem;z-index:9999;display:flex;flex-direction:column;gap:.5rem;"></div>

<!-- QR Modal -->
<div id="qr-modal" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,.5);z-index:500;align-items:center;justify-content:center;">
  <div style="background:#fff;border-radius:20px;padding:2rem;text-align:center;max-width:360px;width:90%;">
    <div style="font-family:var(--serif);font-size:1.3rem;margin-bottom:1rem;">Open Attendance</div>
    <div id="qrCanvas" style="display:flex;justify-content:center;margin-bottom:.75rem;"></div>
    <p style="font-size:.78rem;color:var(--muted);margin-bottom:.75rem;">Students scan the QR <em>or</em> enter the code:</p>
    <div style="display:flex;align-items:center;justify-content:center;gap:10px;margin-bottom:.75rem;">
      <div id="session-code-display"
           style="font-family:'DM Mono',monospace;font-size:2rem;letter-spacing:8px;font-weight:700;
                  background:#f5f5f0;border-radius:10px;padding:10px 22px;color:var(--ink);min-width:140px;">——</div>
      <button onclick="copySessionCode()" title="Copy code"
              style="background:none;border:1px solid var(--border);border-radius:8px;padding:8px 12px;cursor:pointer;font-size:16px;">📋</button>
    </div>
    <p style="font-size:.72rem;color:var(--muted);margin-bottom:1.25rem;">
      Valid 30 min · QR refreshes in <strong id="qr-secs" style="font-family:monospace;">30</strong>s
    </p>
    <button class="btn btn-ghost" onclick="closeQR()">Close</button>
  </div>
</div>

<script>
  /* Server data injected at JSP parse time */
  var CURRENT_COURSE_ID  = '${selectedCourseId}';
  var CURRENT_SESSION_ID = '${selectedSessionId}';

  /*
   * window.load fires AFTER footer.jsp loads attendance.js,
   * so everything we assign to window.* here wins permanently.
   */
  window.addEventListener('load', function () {

    var ACTIVE = { present:'active-P', absent:'active-A', late:'active-L', excused:'active-E' };
    var selected = new Set();
    var pieChart = null;

    /* ── STATUS BUTTONS (event delegation) ── */
    document.getElementById('student-list').addEventListener('click', function (e) {
      var btn = e.target.closest('.status-btn');
      if (!btn) return;
      var sid = btn.dataset.sid, st = btn.dataset.status;
      if (sid && st) _set(sid, st);
    });

    function _set(sid, status, skipStats) {
      sid = String(sid);
      var c = document.getElementById('btns-' + sid);
      if (!c) return;
      c.querySelectorAll('.status-btn').forEach(function (b) { b.className = 'status-btn'; });
      var t = c.querySelector('[data-status="' + status + '"]');
      if (t) t.className = 'status-btn ' + ACTIVE[status];
      var h = document.getElementById('status-' + sid);
      if (h) h.value = status;
      if (!skipStats) updateStats();
    }

    /* ── MARK ALL PRESENT ── */
    window.markAllPresent = function () {
      var rows = document.querySelectorAll('#student-list .student-row');
      if (!rows.length) { showToast('⚠️ Select a course first'); return; }
      rows.forEach(function (r) { if (r.dataset.id) _set(r.dataset.id, 'present', true); });
      updateStats();
      showToast('✅ All ' + rows.length + ' students marked present');
    };

    /* ── STATS ── */
    function updateStats() {
      var c = { present:0, absent:0, late:0, excused:0 };
      document.querySelectorAll('.status-val').forEach(function (el) {
        if (c[el.value] !== undefined) c[el.value]++;
      });
      ['present','absent','late','excused'].forEach(function (s) {
        var el = document.getElementById('cnt-' + s);
        if (el) el.textContent = c[s];
      });
      buildPie(c.present, c.absent, c.late, c.excused);
    }

    /* ── SELECTION / BULK ── */
    window.toggleRow = function (id, checked) {
      checked ? selected.add(String(id)) : selected.delete(String(id));
      _bulkBar();
    };
    window.bulkSet = function (status) {
      selected.forEach(function (id) { _set(id, status, true); });
      updateStats();
      showToast((status === 'present' ? '✅' : '🚫') + ' Marked as ' + status);
      window.clearSelection();
    };
    window.clearSelection = function () {
      selected.clear();
      document.querySelectorAll('.row-cb').forEach(function (cb) { cb.checked = false; });
      _bulkBar();
    };
    function _bulkBar() {
      var bar = document.getElementById('bulkBar'); if (!bar) return;
      var n = selected.size;
      bar.style.display = n > 0 ? 'flex' : 'none';
      var txt = document.getElementById('bulkText');
      if (txt) txt.textContent = n + ' student' + (n !== 1 ? 's' : '') + ' selected';
    }

    /* ── SEARCH ── */
    window.filterStudents = function (q) {
      var term = q.trim().toLowerCase();
      document.querySelectorAll('#student-list .student-row').forEach(function (row) {
        if (!term) { row.style.display = ''; return; }
        var name = (row.getAttribute('data-name') || '').toLowerCase();
        var code = (row.getAttribute('data-code') || '').toLowerCase();
        if (!name) { var ne = row.querySelector('.student-name'); if (ne) name = ne.textContent.toLowerCase(); }
        if (!code) { var ce = row.querySelector('.student-code'); if (ce) code = ce.textContent.toLowerCase(); }
        row.style.display = (name.indexOf(term) !== -1 || code.indexOf(term) !== -1) ? '' : 'none';
      });
    };

    /* ── SAVE ── */
    window.saveAttendance = function () {
      if (!CURRENT_COURSE_ID) { showToast('⚠️ Please select a course first'); return; }
      var records = [];
      document.querySelectorAll('#student-list .student-row').forEach(function (row) {
        var sid = row.dataset.id;
        var se = document.getElementById('status-' + sid);
        var ne = row.querySelector('.note-field-inline');
        records.push({ studentId: sid, status: se ? se.value : 'present', note: ne ? ne.value : '' });
      });

      // Always use today's date — server will stamp the real current time
      var payload = {
        sessionId: CURRENT_SESSION_ID || 0,
        courseId:  CURRENT_COURSE_ID,
        date:      new Date().toISOString().slice(0, 10),
        records:   records
      };

      var btn = document.getElementById('save-btn');
      if (btn) { btn.disabled = true; btn.textContent = '⏳ Saving…'; }

      fetch('/attendance/save', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
      })
      .then(function (r) { return r.json(); })
      .then(function (data) {
        if (data.success) {
          CURRENT_SESSION_ID = data.sessionId;
          showToast('💾 Saved! Session ' + (data.timeSlot || '') + ' ✓');
        } else {
          showToast('❌ ' + (data.error || 'Save failed'));
        }
        if (btn) { btn.disabled = false; btn.textContent = '💾 Save Session'; }
      })
      .catch(function () {
        showToast('❌ Network error');
        if (btn) { btn.disabled = false; btn.textContent = '💾 Save Session'; }
      });
    };

    /* ── NEW SESSION — creates fresh session with current time, resets all to Present ── */
    window.startNewSession = function () {
      if (!CURRENT_COURSE_ID) { showToast('⚠️ Select a course first'); return; }

      var confirmed = window.confirm(
        'Start a NEW session right now?\n\nThis will:\n• Create a new session stamped with the current time\n• Reset all students back to Present\n\nThe previous session is already saved separately.'
      );
      if (!confirmed) return;

      var btn = document.getElementById('new-session-btn');
      if (btn) { btn.disabled = true; btn.textContent = '⏳ Creating…'; }

      fetch('/attendance/new-session', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ courseId: CURRENT_COURSE_ID })
      })
      .then(function (r) { return r.json(); })
      .then(function (data) {
        if (data.success) {
          CURRENT_SESSION_ID = data.sessionId;
          // Reset ALL students to Present
          document.querySelectorAll('#student-list .student-row').forEach(function (row) {
            if (row.dataset.id) _set(row.dataset.id, 'present', true);
          });
          // Clear all notes
          document.querySelectorAll('.note-field-inline').forEach(function (n) { n.value = ''; });
          updateStats();
          showToast('✅ New session started at ' + data.timeSlot + ' — all students reset to Present');
        } else {
          showToast('❌ ' + (data.error || 'Failed to create session'));
        }
        if (btn) { btn.disabled = false; btn.textContent = '➕ New Session'; }
      })
      .catch(function () {
        showToast('❌ Network error');
        if (btn) { btn.disabled = false; btn.textContent = '➕ New Session'; }
      });
    };

    /* ── NAVIGATION ── */
    window.changeCourse = function () {
      var cid = document.getElementById('courseSelect').value;
      var grp = document.getElementById('groupSelect') ? document.getElementById('groupSelect').value : '';
      if (!cid) return;
      window.location.href = '/dashboard?courseId=' + encodeURIComponent(cid) + (grp ? '&group=' + encodeURIComponent(grp) : '');
    };
    window.changeGroup = function () {
      var cid = document.getElementById('courseSelect').value;
      var grp = document.getElementById('groupSelect').value;
      var p = [];
      if (cid) p.push('courseId=' + encodeURIComponent(cid));
      if (grp) p.push('group=' + encodeURIComponent(grp));
      window.location.href = '/dashboard' + (p.length ? '?' + p.join('&') : '');
    };
    window.changeSession = function () {
      var cid = document.getElementById('courseSelect').value;
      var sid = document.getElementById('sessionSelect').value;
      var grp = document.getElementById('groupSelect') ? document.getElementById('groupSelect').value : '';
      if (!cid || !sid) return;
      window.location.href = '/dashboard?courseId=' + encodeURIComponent(cid) + '&sessionId=' + encodeURIComponent(sid) + (grp ? '&group=' + encodeURIComponent(grp) : '');
    };

    /* ── QR + Session Code ── */
    function _drawQR() {
      var ts = Math.floor(Date.now() / 1000);
      var qrDiv = document.getElementById('qrCanvas');
      qrDiv.innerHTML = '';
      new QRCode(qrDiv, { text: 'presencia:' + CURRENT_SESSION_ID + ':' + ts + ':33.799732:2.849006', width:200, height:200 });
      // reset countdown
      if (document.getElementById('qr-secs')) document.getElementById('qr-secs').textContent = '30';
    }

    window.openQR = function () {
      if (!CURRENT_SESSION_ID) { showToast('⚠️ Save session first'); return; }

      // Stop any previous timers before starting fresh
      if (window._qrInterval)  { clearInterval(window._qrInterval);  window._qrInterval  = null; }
      if (window._qrCountdown) { clearInterval(window._qrCountdown); window._qrCountdown = null; }

      _drawQR();
      document.getElementById('qr-modal').style.display = 'flex';

      // Generate and register session code
      var code = generateCode();
      window._currentCode = code;
      document.getElementById('session-code-display').textContent = code;
      fetch('/api/session-code/register', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ sessionId: CURRENT_SESSION_ID, code: code })
      });

      // Countdown display
      var secs = 30;
      window._qrCountdown = setInterval(function() {
        secs--;
        var el = document.getElementById('qr-secs');
        if (el) el.textContent = secs;
        if (secs <= 0) secs = 30;
      }, 1000);

      // Regenerate QR every 30 seconds (single non-recursive interval)
      window._qrInterval = setInterval(function() {
        if (document.getElementById('qr-modal').style.display === 'flex') {
          secs = 30;
          _drawQR();
          // Also refresh code
          var newCode = generateCode();
          window._currentCode = newCode;
          document.getElementById('session-code-display').textContent = newCode;
          fetch('/api/session-code/register', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ sessionId: CURRENT_SESSION_ID, code: newCode })
          });
        }
      }, 30000);
    };

    window.closeQR = function() {
      document.getElementById('qr-modal').style.display = 'none';
      if (window._qrInterval)  { clearInterval(window._qrInterval);  window._qrInterval  = null; }
      if (window._qrCountdown) { clearInterval(window._qrCountdown); window._qrCountdown = null; }
    };

    /* ── DELETE SESSION ── */
    window.deleteSession = function() {
      if (!CURRENT_SESSION_ID) { showToast('⚠️ No active session to delete'); return; }
      var confirmed = window.confirm(
        'Delete this session?\n\nThis will permanently remove the session and ALL attendance records for it.\nThis cannot be undone.'
      );
      if (!confirmed) return;

      var btn = document.getElementById('delete-session-btn');
      if (btn) { btn.disabled = true; btn.textContent = '⏳ Deleting…'; }

      fetch('/attendance/delete-session', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ sessionId: CURRENT_SESSION_ID })
      })
      .then(function(r) { return r.json(); })
      .then(function(data) {
        if (data.success) {
          showToast('🗑️ Session deleted.');
          CURRENT_SESSION_ID = '';
          // Reload page to refresh session list
          setTimeout(function() {
            var cid = document.getElementById('courseSelect').value;
            window.location.href = '/dashboard' + (cid ? '?courseId=' + encodeURIComponent(cid) : '');
          }, 800);
        } else {
          showToast('❌ ' + (data.error || 'Delete failed'));
          if (btn) { btn.disabled = false; btn.textContent = '🗑️ Delete Session'; }
        }
      })
      .catch(function() {
        showToast('❌ Network error');
        if (btn) { btn.disabled = false; btn.textContent = '🗑️ Delete Session'; }
      });
    };

    function generateCode() {
      var chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
      var code = '';
      for (var i = 0; i < 4; i++) code += chars[Math.floor(Math.random() * chars.length)];
      return code;
    }

    window.copySessionCode = function() {
      var code = window._currentCode || '';
      if (!code) return;
      navigator.clipboard.writeText(code).then(function() { showToast('✅ Code copied: ' + code); });
    };

    /* ── PIE CHART ── */
    function buildPie(p, a, l, e) {
      var canvas = document.getElementById('sessionPie'); if (!canvas) return;
      if (pieChart) { pieChart.destroy(); pieChart = null; }
      var total = (p + a + l + e) || 1;
      pieChart = new Chart(canvas.getContext('2d'), {
        type: 'doughnut',
        data: { labels:['Present','Absent','Late','Excused'],
          datasets:[{ data:[p,a,l,e], backgroundColor:['#2d7a4a','#c93a3a','#c97a1e','#2a5bc4'], borderWidth:2, borderColor:'#fff' }] },
        options: { responsive:true, cutout:'62%',
          plugins:{ legend:{display:false}, tooltip:{ callbacks:{ label:function(ctx){ return ctx.label+': '+ctx.parsed+' ('+Math.round(ctx.parsed/total*100)+'%)'; } } } } }
      });
    }

    /* ── TOAST ── */
    function showToast(msg) {
      var c = document.getElementById('toastContainer'); if (!c) return;
      var t = document.createElement('div');
      t.style.cssText = 'background:var(--navy);color:#fff;padding:.6rem 1rem;border-radius:10px;font-size:.85rem;box-shadow:0 4px 16px rgba(0,0,0,.2);';
      t.textContent = msg; c.appendChild(t);
      setTimeout(function () { t.style.opacity='0'; t.style.transition='opacity .4s'; setTimeout(function(){t.remove();},400); }, 2800);
    }
    window.showToast = showToast;

    /* ── INIT ── */
    updateStats();

  }); // end window.load
</script>
<%@ include file="../layout/footer.jsp" %>
