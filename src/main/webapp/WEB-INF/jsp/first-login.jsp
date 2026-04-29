<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Presencia — Set Your Password</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600&family=DM+Serif+Display&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
    <link href="<c:url value='/static/css/style.css'/>" rel="stylesheet">
    <style>
        body {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            background: var(--paper);
        }
        .card-wrap { max-width: 440px; width: 100%; }
        .brand-mark { font-family: 'DM Serif Display', serif; font-size: 30px; text-align: center; margin-bottom: 4px; }
        .brand-mark span { color: var(--gold); }
        .brand-sub { font-family: 'DM Mono', monospace; font-size: 11px; text-align: center; color: var(--muted); letter-spacing: 2px; text-transform: uppercase; margin-bottom: 28px; }
        .lbl { display: block; font-size: 11px; font-weight: 600; letter-spacing: .9px; text-transform: uppercase; color: var(--muted); font-family: 'DM Mono', monospace; margin-bottom: 6px; }
        .field { background: white; border: 1px solid var(--border); border-radius: 8px; padding: 10px 14px; font-size: 14px; width: 100%; box-sizing: border-box; transition: border-color .15s; }
        .field:focus { outline: none; border-color: var(--ink); }
        .strength-bar { height: 4px; border-radius: 2px; margin-top: 6px; background: var(--border); overflow: hidden; }
        .strength-fill { height: 100%; border-radius: 2px; transition: width .3s, background .3s; width: 0%; }
        .strength-label { font-size: 11px; font-family: 'DM Mono', monospace; margin-top: 4px; }
        .welcome-banner {
            background: linear-gradient(135deg, rgba(212,168,67,0.12), rgba(26,26,46,0.06));
            border: 1px solid rgba(212,168,67,0.3);
            border-radius: 10px;
            padding: 14px 16px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .rule { display: flex; align-items: center; gap: 8px; font-size: 12px; color: var(--muted); margin-bottom: 5px; }
        .rule span { font-size: 14px; }
    </style>
</head>
<body>
<div class="card-wrap card border-0 shadow-lg" style="border-radius: 16px; padding: 40px; background: var(--paper);">
    <div class="brand-mark">Pres<span>encia</span></div>
    <div class="brand-sub">First Login — Set Your Password</div>

    <!-- Welcome banner -->
    <div class="welcome-banner">
        <div style="font-size: 28px;">👋</div>
        <div>
            <div style="font-weight: 600; font-size: 14px; color: var(--ink);">Welcome, ${professor.name}!</div>
            <div style="font-size: 12px; color: var(--muted); margin-top: 2px;">
                You're using a temporary password. Please set a personal password to continue.
            </div>
        </div>
    </div>

    <c:if test="${error != null}">
        <div class="alert alert-danger py-2 mb-3" style="font-size: 13px; border-radius: 8px;">
            ❌ ${error}
        </div>
    </c:if>

    <form method="post" action="<c:url value='/first-login'/>" onsubmit="return validateForm()">
        <div class="mb-3">
            <label class="lbl">New Password</label>
            <input type="password" name="newPassword" id="newPassword" class="field"
                   placeholder="Choose a strong password" required minlength="6"
                   oninput="checkStrength(this.value)">
            <div class="strength-bar"><div class="strength-fill" id="strengthFill"></div></div>
            <div class="strength-label" id="strengthLabel" style="color: var(--muted);">Enter a password</div>
        </div>
        <div class="mb-4">
            <label class="lbl">Confirm Password</label>
            <input type="password" name="confirmPassword" id="confirmPassword" class="field"
                   placeholder="Repeat your password" required minlength="6"
                   oninput="checkMatch()">
            <div style="font-size: 12px; margin-top: 5px; font-family: 'DM Mono', monospace;" id="matchMsg"></div>
        </div>

        <!-- Rules -->
        <div style="background: var(--cream); border-radius: 8px; padding: 12px 14px; margin-bottom: 20px;">
            <div class="rule"><span id="r1">⬜</span> At least 6 characters</div>
            <div class="rule"><span id="r2">⬜</span> Contains a number</div>
            <div class="rule"><span id="r3">⬜</span> Contains a letter</div>
        </div>

        <button type="submit" class="btn w-100"
                style="background: var(--ink); color: white; border: none; border-radius: 8px; padding: 12px; font-weight: 500; font-size: 14px;">
            Set Password &amp; Continue →
        </button>
    </form>

    <div style="text-align: center; margin-top: 16px;">
        <form method="post" action="<c:url value='/logout'/>" style="display: inline;">
            <button type="submit" style="background: none; border: none; font-size: 12px; color: var(--muted); cursor: pointer; font-family: 'DM Sans', sans-serif;">
                Sign out instead
            </button>
        </form>
    </div>
</div>

<script>
function checkStrength(val) {
    const fill = document.getElementById('strengthFill');
    const label = document.getElementById('strengthLabel');
    const r1 = document.getElementById('r1');
    const r2 = document.getElementById('r2');
    const r3 = document.getElementById('r3');

    const hasLen = val.length >= 6;
    const hasNum = /\d/.test(val);
    const hasLetter = /[a-zA-Z]/.test(val);

    r1.textContent = hasLen ? '✅' : '⬜';
    r2.textContent = hasNum ? '✅' : '⬜';
    r3.textContent = hasLetter ? '✅' : '⬜';

    let score = [hasLen, hasNum, hasLetter, val.length >= 10, /[^a-zA-Z0-9]/.test(val)].filter(Boolean).length;
    const colors = ['#c84b31','#c68a20','#c68a20','#3d7a5a','#3d7a5a'];
    const labels = ['Too short','Weak','Fair','Good','Strong'];
    const widths = ['15%','30%','55%','80%','100%'];

    if (val.length === 0) {
        fill.style.width = '0%';
        label.textContent = 'Enter a password';
        label.style.color = 'var(--muted)';
        return;
    }
    score = Math.max(0, score - 1);
    fill.style.width = widths[score];
    fill.style.background = colors[score];
    label.textContent = labels[score];
    label.style.color = colors[score];
}

function checkMatch() {
    const p1 = document.getElementById('newPassword').value;
    const p2 = document.getElementById('confirmPassword').value;
    const msg = document.getElementById('matchMsg');
    if (!p2) { msg.textContent = ''; return; }
    if (p1 === p2) {
        msg.textContent = '✅ Passwords match';
        msg.style.color = 'var(--present)';
    } else {
        msg.textContent = '❌ Passwords do not match';
        msg.style.color = 'var(--absent)';
    }
}

function validateForm() {
    const p1 = document.getElementById('newPassword').value;
    const p2 = document.getElementById('confirmPassword').value;
    if (p1 !== p2) { alert('Passwords do not match.'); return false; }
    if (p1.length < 6) { alert('Password must be at least 6 characters.'); return false; }
    return true;
}
</script>
</body>
</html>
