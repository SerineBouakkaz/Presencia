<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="<c:url value='/static/js/attendance.js'/>"></script>
<script>
/* ── Mobile sidebar ── defined on window so onclick="openSidebar()" works anywhere ── */
window.openSidebar = function() {
  var sb  = document.querySelector('.sidebar');
  var ov  = document.getElementById('sidebarOverlay');
  if (sb) sb.classList.add('open');
  if (ov) ov.classList.add('visible');
  document.body.style.overflow = 'hidden';
};

window.closeSidebar = function() {
  var sb  = document.querySelector('.sidebar');
  var ov  = document.getElementById('sidebarOverlay');
  if (sb) sb.classList.remove('open');
  if (ov) ov.classList.remove('visible');
  document.body.style.overflow = '';
};

/* Inject overlay after functions are defined */
(function() {
  if (!document.getElementById('sidebarOverlay')) {
    var ov       = document.createElement('div');
    ov.id        = 'sidebarOverlay';
    ov.className = 'sidebar-overlay';
    ov.addEventListener('click', window.closeSidebar);
    document.body.appendChild(ov);
  }

  /* Close when a nav link is tapped on mobile */
  document.querySelectorAll('.nav-item').forEach(function(link) {
    link.addEventListener('click', function() {
      if (window.innerWidth <= 900) window.closeSidebar();
    });
  });

  /* Close on Escape */
  document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') window.closeSidebar();
  });
})();
</script>
</body>
</html>
