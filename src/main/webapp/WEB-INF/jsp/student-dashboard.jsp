<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Presencia — My Attendance</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600&family=DM+Serif+Display&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
    <link href="<c:url value='/static/css/style.css'/>" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jsqr@1.4.0/dist/jsQR.js"></script>
    <style>
        body { background: var(--paper); font-family: 'DM Sans', sans-serif; }
        .student-layout { max-width: 900px; margin: 0 auto; padding: 32px 16px; }
        .top-bar { display: flex; align-items: center; justify-content: space-between; margin-bottom: 32px; }
        .brand-mark { font-family: 'DM Serif Display', serif; font-size: 24px; }
        .brand-mark span { color: var(--gold); }
        .student-name { font-size: 14px; color: var(--muted); }
        .card-section { background: white; border-radius: 14px; border: 1px solid var(--border); padding: 24px; margin-bottom: 20px; }
        .section-title { font-family: 'DM Serif Display', serif; font-size: 17px; margin-bottom: 18px; }
        .stat-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; }
        .stat-box { padding: 16px; border-radius: 10px; text-align: center; }
        .stat-box .num { font-family: 'DM Serif Display', serif; font-size: 28px; font-weight: 600; }
        .stat-box .lbl { font-size: 11px; text-transform: uppercase; letter-spacing: 1px; color: var(--muted); font-family: 'DM Mono', monospace; margin-top: 4px; }
        .s-present { background: rgba(61,122,90,0.08); color: var(--present); }
        .s-absent  { background: rgba(200,75,49,0.08);  color: var(--absent);  }
        .s-late    { background: rgba(198,138,32,0.08); color: var(--late);    }
        .s-excused { background: rgba(74,111,165,0.08); color: var(--excused); }
        .pie-wrap { display: flex; align-items: center; justify-content: center; gap: 32px; flex-wrap: wrap; }
        .pie-wrap canvas { max-width: 220px; max-height: 220px; }
        .legend-item { display: flex; align-items: center; gap: 8px; font-size: 13px; margin-bottom: 8px; }
        .legend-dot  { width: 12px; height: 12px; border-radius: 50%; flex-shrink: 0; }
        /* Tab buttons */
        .tab-btns { display: flex; gap: 8px; margin-bottom: 18px; flex-wrap: wrap; }
        .tab-btn  { padding: 8px 18px; border-radius: 8px; border: 1px solid var(--border); background: white; font-size: 13px; cursor: pointer; transition: all .15s; }
        .tab-btn.active { background: var(--ink); color: white; border-color: var(--ink); }

        /* ── QR Scanner ── */
        .qr-permission-box {
            background: #f5f9ff;
            border: 1.5px solid #b8d0f0;
            border-radius: 12px;
            padding: 16px 18px;
            font-size: 13px;
            color: #2a4a7f;
            text-align: left;
            margin-bottom: 16px;
            line-height: 1.7;
        }
        .qr-permission-box strong { color: #1a3060; }
        #qr-video {
            width: 100%;
            max-width: 420px;
            min-height: 260px;
            border-radius: 12px;
            border: 2px solid var(--border);
            background: #111;
            display: block;
            margin: 0 auto 10px;
            object-fit: cover;
        }
        #qr-start-btn {
            background: var(--ink);
            color: white;
            border: none;
            border-radius: 10px;
            padding: 13px 32px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            display: block;
            margin: 0 auto 12px;
            letter-spacing: .2px;
            transition: opacity .15s;
        }
        #qr-start-btn:disabled { opacity: .6; cursor: not-allowed; }
        #qr-status-text { font-size: 13px; color: var(--muted); text-align: center; margin-bottom: 8px; min-height: 20px; }
        .qr-error-box {
            background: #fff2f2;
            border: 1px solid #f5c0c0;
            border-radius: 10px;
            padding: 14px 16px;
            font-size: 13px;
            color: #8b1a1a;
            margin: 10px auto;
            max-width: 420px;
            line-height: 1.6;
        }
        .qr-success-box {
            background: #f2faf5;
            border: 1px solid #a8d9bb;
            border-radius: 10px;
            padding: 14px 16px;
            font-size: 13px;
            color: #1a6635;
            margin: 10px auto;
            max-width: 420px;
            line-height: 1.6;
        }
        /* Scanning overlay line */
        .qr-wrap { position: relative; display: inline-block; width: 100%; max-width: 420px; }
        .scan-line {
            display: none;
            position: absolute;
            left: 8px; right: 8px;
            height: 2px;
            background: linear-gradient(90deg, transparent, #3d7a5a, transparent);
            animation: scanMove 2s linear infinite;
            border-radius: 2px;
            z-index: 2;
        }
        @keyframes scanMove {
            0%   { top: 12%; }
            50%  { top: 82%; }
            100% { top: 12%; }
        }
        .scan-line.active { display: block; }

        /* Code-entry tab */
        .code-entry-wrap  { display: flex; flex-direction: column; align-items: center; gap: 18px; padding: 10px 0 6px; }
        .code-input-row   { display: flex; gap: 12px; align-items: center; flex-wrap: wrap; justify-content: center; }
        .code-input-row input[type=text] {
            font-family: 'DM Mono', monospace; font-size: 28px; letter-spacing: 6px;
            text-align: center; width: 180px; padding: 14px 10px;
            border: 2px solid var(--border); border-radius: 12px; background: #fafafa; transition: border-color .2s;
        }
        .code-input-row input[type=text]:focus { border-color: var(--ink); outline: none; background: white; }
        .code-hint { font-size: 13px; color: var(--muted); text-align: center; max-width: 380px; line-height: 1.6; }
        /* Manual form */
        .manual-form { display: flex; gap: 12px; flex-wrap: wrap; align-items: flex-end; }
        .manual-form select, .manual-form input { flex: 1; min-width: 150px; padding: 10px 14px; border: 1px solid var(--border); border-radius: 8px; font-size: 14px; background: white; }
        @media (max-width: 600px) { .stat-grid { grid-template-columns: repeat(2,1fr); } }
    </style>
</head>
<body>
<div class="student-layout">

    <!-- Top bar -->
    <div class="top-bar">
        <div class="brand-mark">Pres<span>encia</span></div>
        <div style="display:flex; align-items:center; gap:14px;">
            <div class="student-name">👤 ${student.fullName} &nbsp;·&nbsp; <span style="font-family:'DM Mono',monospace; font-size:12px;">${student.studentCode}</span></div>
            <form method="post" action="<c:url value='/student-logout'/>">
                <button class="btn btn-ghost" type="submit" style="font-size:13px; padding:6px 14px;">Logout</button>
            </form>
        </div>
    </div>

    <c:if test="${message != null}">
        <div class="alert ${messageType == 'success' ? 'alert-success' : 'alert-danger'} mb-3" style="border-radius:10px; font-size:13px;">${message}</div>
    </c:if>
    <c:if test="${param.msg == 'present'}">
        <div class="alert alert-success mb-3" style="border-radius:10px; font-size:13px;">✅ Attendance marked as present!</div>
    </c:if>
    <c:if test="${param.error == 'location'}">
        <div class="alert alert-danger mb-3" style="border-radius:10px; font-size:13px;">📍 You are not on campus. Attendance was not recorded.</div>
    </c:if>
    <c:if test="${param.error == 'invalid_code'}">
        <div class="alert alert-danger mb-3" style="border-radius:10px; font-size:13px;">❌ Invalid session code. Please check and try again.</div>
    </c:if>
    <c:if test="${param.error == 'expired_code'}">
        <div class="alert alert-danger mb-3" style="border-radius:10px; font-size:13px;">⏱️ Session code has expired. Ask your teacher for a new one.</div>
    </c:if>

    <!-- Stats -->
    <div class="card-section">
        <div class="section-title">📊 My Attendance Overview</div>
        <div class="stat-grid">
            <div class="stat-box s-present"><div class="num" id="cnt-present">${stats.present != null ? stats.present : 0}</div><div class="lbl">Present</div></div>
            <div class="stat-box s-absent"> <div class="num" id="cnt-absent">${stats.absent   != null ? stats.absent  : 0}</div><div class="lbl">Absent</div></div>
            <div class="stat-box s-late">   <div class="num" id="cnt-late">${stats.late      != null ? stats.late    : 0}</div><div class="lbl">Late</div></div>
            <div class="stat-box s-excused"><div class="num" id="cnt-excused">${stats.excused != null ? stats.excused : 0}</div><div class="lbl">Excused</div></div>
        </div>
    </div>

    <!-- Pie Chart -->
    <div class="card-section">
        <div class="section-title">🥧 Attendance Chart</div>
        <div class="pie-wrap">
            <canvas id="attendancePie"></canvas>
            <div>
                <div class="legend-item"><div class="legend-dot" style="background:#3d7a5a"></div> Present: <b id="leg-present">0</b></div>
                <div class="legend-item"><div class="legend-dot" style="background:#c84b31"></div> Absent: <b  id="leg-absent">0</b></div>
                <div class="legend-item"><div class="legend-dot" style="background:#c68a20"></div> Late: <b    id="leg-late">0</b></div>
                <div class="legend-item"><div class="legend-dot" style="background:#4a6fa5"></div> Excused: <b id="leg-excused">0</b></div>
                <div style="margin-top:14px; font-size:13px; color:var(--muted);">Overall rate:</div>
                <div style="font-family:'DM Serif Display',serif; font-size:26px; color:var(--ink);" id="overall-rate">—%</div>
            </div>
        </div>
    </div>

    <!-- Mark Attendance -->
    <div class="card-section">
        <div class="section-title">✅ Mark My Attendance</div>
        <div class="tab-btns">
            <button class="tab-btn active" onclick="switchTab('qr')"     id="btn-qr">📷 Scan QR</button>
            <button class="tab-btn"        onclick="switchTab('code')"   id="btn-code">🔑 Session Code</button>
            <button class="tab-btn"        onclick="switchTab('manual')" id="btn-manual">✍️ Manual</button>
        </div>

        <!-- ── QR Camera Tab ── -->
        <div id="tab-qr" style="text-align:center;">

            <!-- Permission hint shown before camera starts -->
            <div class="qr-permission-box" id="qr-hint-box">
                <strong>📷 Camera permission needed</strong><br>
                When you tap <em>Start Camera</em>, your browser will ask to use your camera.<br>
                Tap <strong>Allow</strong> (or <em>Permitir / السماح</em>) when prompted.<br>
                <span style="font-size:12px; color:#4a6fa5;">
                    Having trouble? Make sure this page is on <strong>HTTPS</strong> and camera is allowed
                    in your phone settings: <em>Settings → Browser → Camera → Allow</em>.
                </span>
            </div>

            <div class="qr-wrap" id="qr-wrap">
                <video id="qr-video" autoplay muted playsinline webkit-playsinline></video>
                <canvas id="qr-canvas" style="display:none;"></canvas>
                <div class="scan-line" id="scan-line"></div>
            </div>

            <div id="qr-status-text">Tap the button below to open your camera.</div>
            <div id="qr-result-area"></div>

            <button id="qr-start-btn" onclick="startQRCamera()">📷 Start Camera</button>
        </div>

        <!-- ── Session Code Tab ── -->
        <div id="tab-code" style="display:none;">
            <div class="code-entry-wrap">
                <p class="code-hint">
                    Ask your teacher for today's <strong>session code</strong> and enter it below.<br>
                    No camera required.
                </p>
                <form method="post" action="<c:url value='/student/mark-present-code'/>">
                    <div class="code-input-row">
                        <input type="text" name="sessionCode" id="sessionCodeInput" maxlength="10"
                               placeholder="_ _ _ _" autocomplete="off" required
                               oninput="this.value=this.value.toUpperCase().replace(/[^A-Z0-9]/g,'')">
                        <button type="submit" class="btn"
                                style="background:var(--ink);color:white;border:none;border-radius:10px;padding:14px 28px;font-size:15px;font-weight:600;white-space:nowrap;">
                            ✅ Mark Present
                        </button>
                    </div>
                </form>
                <div style="font-size:12px; color:var(--muted); margin-top:4px;">
                    Session codes are valid for <strong>30 minutes</strong>.
                </div>
            </div>
        </div>

        <!-- ── Manual Absence Tab ── -->
        <div id="tab-manual" style="display:none;">
            <p style="font-size:13px; color:var(--muted); margin-bottom:14px;">Manually report yourself absent for a session.</p>
            <form method="post" action="<c:url value='/student/mark-absence'/>">
                <div class="manual-form">
                    <div style="flex:1; min-width:180px;">
                        <label style="font-size:11px;font-weight:600;letter-spacing:.9px;text-transform:uppercase;color:var(--muted);font-family:'DM Mono',monospace;display:block;margin-bottom:6px;">Course</label>
                        <select name="courseId" required>
                            <option value="">— Select Course —</option>
                            <c:forEach var="course" items="${courses}">
                                <option value="${course.id}">${course.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div style="flex:1; min-width:180px;">
                        <label style="font-size:11px;font-weight:600;letter-spacing:.9px;text-transform:uppercase;color:var(--muted);font-family:'DM Mono',monospace;display:block;margin-bottom:6px;">Session Date</label>
                        <input type="date" name="sessionDate" required>
                    </div>
                    <div style="flex:2; min-width:200px;">
                        <label style="font-size:11px;font-weight:600;letter-spacing:.9px;text-transform:uppercase;color:var(--muted);font-family:'DM Mono',monospace;display:block;margin-bottom:6px;">Reason</label>
                        <input type="text" name="reason" placeholder="Briefly explain your absence..." required>
                    </div>
                    <button type="submit" class="btn" style="background:var(--absent);color:white;border:none;border-radius:8px;padding:10px 20px;font-size:14px;white-space:nowrap;">
                        Submit Absence
                    </button>
                </div>
            </form>
        </div>
    </div>
</div><!-- end student-layout -->

<script>
// ── Stats & Chart ──
const statsData = {
    present: parseInt(document.getElementById('cnt-present').textContent) || 0,
    absent:  parseInt(document.getElementById('cnt-absent').textContent)  || 0,
    late:    parseInt(document.getElementById('cnt-late').textContent)    || 0,
    excused: parseInt(document.getElementById('cnt-excused').textContent) || 0
};
document.getElementById('leg-present').textContent = statsData.present;
document.getElementById('leg-absent').textContent  = statsData.absent;
document.getElementById('leg-late').textContent    = statsData.late;
document.getElementById('leg-excused').textContent = statsData.excused;

const total = statsData.present + statsData.absent + statsData.late + statsData.excused;
if (total > 0) {
    const rate = Math.round(((statsData.present + statsData.late) / total) * 100);
    document.getElementById('overall-rate').textContent = rate + '%';
    document.getElementById('overall-rate').style.color = rate >= 75 ? '#3d7a5a' : '#c84b31';
}

const ctx = document.getElementById('attendancePie').getContext('2d');
new Chart(ctx, {
    type: 'doughnut',
    data: {
        labels: ['Present','Absent','Late','Excused'],
        datasets: [{ data:[statsData.present,statsData.absent,statsData.late,statsData.excused],
            backgroundColor:['#3d7a5a','#c84b31','#c68a20','#4a6fa5'], borderWidth:2, borderColor:'#fff' }]
    },
    options: { responsive:true, plugins:{ legend:{display:false} }, cutout:'65%' }
});

// ── Tab switching ──
let activeStream = null;

function switchTab(tab) {
    ['qr','code','manual'].forEach(function(t) {
        document.getElementById('tab-'+t).style.display = tab === t ? '' : 'none';
        document.getElementById('btn-'+t).className = 'tab-btn' + (tab === t ? ' active' : '');
    });
    // Stop camera if leaving QR tab
    if (tab !== 'qr' && activeStream) {
        activeStream.getTracks().forEach(function(t){ t.stop(); });
        activeStream = null;
        document.getElementById('qr-video').srcObject = null;
        document.getElementById('scan-line').classList.remove('active');
        scanning = false;
    }
    if (tab === 'code') document.getElementById('sessionCodeInput').focus();
}

// ── QR Camera Scanner ──
let scanning = false;

function setStatus(msg) { document.getElementById('qr-status-text').textContent = msg; }

function showError(html) {
    document.getElementById('qr-result-area').innerHTML =
        '<div class="qr-error-box">' + html + '</div>';
}

function showSuccess(html) {
    document.getElementById('qr-result-area').innerHTML =
        '<div class="qr-success-box">' + html + '</div>';
}

async function startQRCamera() {
    const btn = document.getElementById('qr-start-btn');
    const hintBox = document.getElementById('qr-hint-box');

    // ── Step 1: Check API available (requires HTTPS) ──
    if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
        showError(
            '<strong>⚠️ Camera not available.</strong><br><br>' +
            'This feature requires <strong>HTTPS</strong>. If you see this on HTTP, ask your admin to enable secure connections.<br><br>' +
            'Alternatively use the <strong>🔑 Session Code</strong> tab instead.'
        );
        setStatus('❌ Camera API unavailable.');
        return;
    }

    btn.disabled = true;
    btn.textContent = '⏳ Requesting camera…';
    setStatus('Waiting for camera permission…');
    document.getElementById('qr-result-area').innerHTML = '';

    // ── Step 2: Request camera — try rear first, fall back to any ──
    let stream = null;
    try {
        // ideal: 'environment' asks for rear camera but doesn't fail if unavailable
        stream = await navigator.mediaDevices.getUserMedia({
            video: { facingMode: { ideal: 'environment' }, width: { ideal: 1280 }, height: { ideal: 720 } }
        });
    } catch (err1) {
        try {
            // Fallback: any camera at all
            stream = await navigator.mediaDevices.getUserMedia({ video: true });
        } catch (err2) {
            btn.disabled = false;
            btn.textContent = '📷 Start Camera';
            const n = err2.name || '';
            let msg = '<strong>❌ Camera access failed.</strong><br><br>';
            if (n === 'NotAllowedError' || n === 'PermissionDeniedError') {
                msg +=
                    'You denied camera permission.<br><br>' +
                    '<strong>Android Chrome:</strong> Tap 🔒 in the address bar → Permissions → Camera → Allow, then refresh this page.<br><br>' +
                    '<strong>iOS Safari:</strong> Go to Settings → Safari → Camera → Allow.<br><br>' +
                    '💡 Or use the <strong>🔑 Session Code</strong> tab — no camera needed.';
            } else if (n === 'NotFoundError' || n === 'DevicesNotFoundError') {
                msg += 'No camera was found on this device. Use the <strong>🔑 Session Code</strong> tab instead.';
            } else if (n === 'NotReadableError' || n === 'TrackStartError') {
                msg += 'Your camera is in use by another app. Close other apps and try again.';
            } else if (n === 'SecurityError') {
                msg += 'Blocked for security reasons. This page must be on <strong>HTTPS</strong>.';
            } else {
                msg += 'Error: ' + (err2.message || n || 'Unknown') + '<br>Make sure the page is on HTTPS and camera is allowed.';
            }
            showError(msg);
            setStatus('❌ Camera unavailable.');
            return;
        }
    }

    // ── Step 3: Success — attach stream to video ──
    activeStream = stream;
    hintBox.style.display = 'none'; // hide the hint once camera is live
    btn.style.display = 'none';

    const video = document.getElementById('qr-video');
    video.srcObject = stream;
    try { await video.play(); } catch(_) {}

    scanning = true;
    document.getElementById('scan-line').classList.add('active');
    setStatus('🔍 Scanning… point your camera at the QR code.');
    scanLoop(video);
}

function scanLoop(video) {
    if (!scanning) return;
    if (video.readyState === video.HAVE_ENOUGH_DATA) {
        const canvas = document.getElementById('qr-canvas');
        canvas.width  = video.videoWidth;
        canvas.height = video.videoHeight;
        const ctx2 = canvas.getContext('2d');
        ctx2.drawImage(video, 0, 0);
        const imgData = ctx2.getImageData(0, 0, canvas.width, canvas.height);
        const code = jsQR(imgData.data, imgData.width, imgData.height, { inversionAttempts: 'dontInvert' });
        if (code) {
            handleQRDetected(code.data);
            return;
        }
    }
    requestAnimationFrame(function(){ scanLoop(video); });
}

function handleQRDetected(data) {
    scanning = false;
    document.getElementById('scan-line').classList.remove('active');

    // Stop camera
    if (activeStream) { activeStream.getTracks().forEach(function(t){ t.stop(); }); activeStream = null; }
    document.getElementById('qr-video').srcObject = null;

    setStatus('✅ QR detected! Verifying…');

    // Parse: presencia:sessionId:timestamp:lat:lng
    const parts = data.split(':');
    if (parts[0] !== 'presencia' || parts.length < 5) {
        showError('❌ Invalid QR code. Make sure you are scanning the right code from your teacher.');
        resetScanButton();
        return;
    }

    const sessionId  = parts[1];
    const qrTime     = parseInt(parts[2]);
    const now        = Math.floor(Date.now() / 1000);

    if (now - qrTime > 35) { // 35s grace (30s QR + 5s network)
        showError('⏱️ QR code has expired (30-second limit). Ask your teacher to show the QR again.');
        resetScanButton();
        return;
    }

    // ── GPS check ──
    setStatus('📍 Verifying your location…');
    showSuccess('⏳ Getting your GPS location, please wait…');

    if (!navigator.geolocation) {
        showError('📍 GPS not available on this device/browser.');
        resetScanButton();
        return;
    }

    navigator.geolocation.getCurrentPosition(
        function(pos) {
            const UNIV_LAT = 33.799732, UNIV_LNG = 2.849006, MAX_M = 300;
            const dist = getDistance(pos.coords.latitude, pos.coords.longitude, UNIV_LAT, UNIV_LNG);
            if (dist > MAX_M) {
                showError(
                    '📍 You are not on campus (' + Math.round(dist) + 'm away).<br>' +
                    'You must be at Université Amar Telidji, Laghouat to mark attendance.'
                );
                setStatus('❌ Location check failed.');
                resetScanButton();
                return;
            }
            // Submit form
            setStatus('✅ On campus! Marking attendance…');
            showSuccess('✅ Location verified! Submitting attendance…');
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '<c:url value="/student/mark-present-qr"/>';
            [['sessionId', sessionId], ['lat', pos.coords.latitude], ['lng', pos.coords.longitude]].forEach(function(p){
                const inp = document.createElement('input');
                inp.type = 'hidden'; inp.name = p[0]; inp.value = p[1];
                form.appendChild(inp);
            });
            document.body.appendChild(form);
            form.submit();
        },
        function(err) {
            let msg = '📍 Could not get your location.<br>';
            if (err.code === 1) msg += 'Permission denied — allow Location in your browser settings, then try again.';
            else if (err.code === 2) msg += 'GPS unavailable. Move to an open area and try again.';
            else if (err.code === 3) msg += 'Location timed out. Enable GPS on your device and try again.';
            showError(msg);
            setStatus('❌ Location failed.');
            resetScanButton();
        },
        { enableHighAccuracy: true, timeout: 20000, maximumAge: 0 }
    );
}

function resetScanButton() {
    const btn = document.getElementById('qr-start-btn');
    btn.style.display = 'block';
    btn.disabled = false;
    btn.textContent = '📷 Try Again';
    document.getElementById('qr-hint-box').style.display = '';
}

function getDistance(lat1, lon1, lat2, lon2) {
    const R = 6371000, φ1 = lat1*Math.PI/180, φ2 = lat2*Math.PI/180;
    const Δφ = (lat2-lat1)*Math.PI/180, Δλ = (lon2-lon1)*Math.PI/180;
    const a = Math.sin(Δφ/2)**2 + Math.cos(φ1)*Math.cos(φ2)*Math.sin(Δλ/2)**2;
    return R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
}
</script>
</body>
</html>
