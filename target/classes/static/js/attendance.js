function submitAttendance(sessionId) {
    const code = document.getElementById("code").value.trim().toUpperCase();

    if (!code) {
        alert("Enter code");
        return;
    }

    fetch("/attendance/validate", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            code: code,
            sessionId: sessionId
        })
    })
    .then(res => res.text())
    .then(data => {
        alert(data);
    })
    .catch(err => {
        console.error(err);
        alert("Error");
    });
}