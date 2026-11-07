<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("admin") != null) {
        response.sendRedirect(request.getContextPath() + "/admin-dashboard");
        return;
    }
    String error = (String) request.getAttribute("error");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Faculty Evaluator Cockpit — DevMatrix</title>
    <link rel="stylesheet" href="css/style.css">
    <script>
        function fillAdmin(user, pass) {
            document.getElementById('username').value = user;
            document.getElementById('password').value = pass;
        }
    </script>
</head>
<body>

    <nav class="navbar">
        <a href="index.html" class="nav-brand">
            <div class="brand-icon" style="background: linear-gradient(135deg, #f43f5e 0%, #8b5cf6 100%);">&lt;/&gt;</div>
            <span>DEV<span style="color: #f43f5e;">COCKPIT</span></span>
        </a>
        <ul class="nav-links">
            <li><a href="index.html">Home</a></li>
            <li><a href="login.jsp">Student Access</a></li>
        </ul>
    </nav>

    <div class="container-narrow">
        <div class="card" style="box-shadow: 0 12px 40px -10px rgba(244,63,94,0.3); border-color: rgba(244, 63, 94, 0.35);">
            <div class="card-header" style="text-align: center; display: block; border-bottom: none; margin-bottom: 0.75rem;">
                <div style="width: 48px; height: 48px; margin: 0 auto 0.75rem; border-radius: 12px; background: linear-gradient(135deg, #f43f5e 0%, #8b5cf6 100%); display: flex; align-items: center; justify-content: center; font-size: 1.4rem; color: #fff; box-shadow: 0 4px 18px rgba(244,63,94,0.4);">
                    🔒
                </div>
                <h2 class="card-title" style="font-size: 1.65rem; color: #fff;">Evaluator Gateway</h2>
                <p style="color: var(--text-secondary); font-size: 0.9rem; margin-top: 0.25rem;">
                    Faculty portal governed by ServletConfig parameters and ServletContext counters.
                </p>
            </div>

            <!-- Inline Flash Banners (Module 12) -->
            <% if (error != null && !error.trim().isEmpty()) { %>
                <div class="alert alert-error">
                    <span>⚠️</span>
                    <div><%= error %></div>
                </div>
            <% } %>

            <% if ("logged_out".equals(msg)) { %>
                <div class="alert alert-info">
                    <span>ℹ️</span>
                    <div>Admin session terminated. Evaluator signed out safely.</div>
                </div>
            <% } %>

            <form action="admin-login" method="POST">
                <div class="form-group">
                    <label class="form-label" for="username">Evaluator Username</label>
                    <input type="text" id="username" name="username" class="form-control" 
                           placeholder="Enter faculty ID" required autocomplete="username">
                </div>

                <div class="form-group">
                    <label class="form-label" for="password">Master Security Key</label>
                    <input type="password" id="password" name="password" class="form-control" 
                           placeholder="Enter admin password" required autocomplete="current-password">
                </div>

                <button type="submit" class="btn btn-primary btn-block" style="background: linear-gradient(135deg, #f43f5e 0%, #8b5cf6 100%); padding: 0.85rem; font-size: 1rem; margin-top: 0.5rem; box-shadow: 0 4px 18px rgba(244,63,94,0.4);">
                    Authenticate Faculty Credentials →
                </button>
            </form>

            <!-- 1-Click Faculty Demo Credentials (Female Admins) -->
            <div style="background: rgba(244, 63, 94, 0.08); border: 1px solid rgba(244, 63, 94, 0.25); border-radius: var(--radius-md); padding: 1.15rem; margin-top: 1.75rem;">
                <div style="font-size: 0.8rem; font-weight: 800; color: #fca5a5; letter-spacing: 0.5px; margin-bottom: 0.65rem;">
                    💡 FACULTY VIVA CREDENTIALS:
                </div>
                <div style="display: flex; gap: 0.5rem; flex-wrap: wrap;">
                    <button type="button" class="quick-chip" onclick="fillAdmin('evaluator_admin', 'MatrixRoot@2026')">
                        👩‍🏫 Prof. Sunitha Rao (Evaluator)
                    </button>
                    <button type="button" class="quick-chip" onclick="fillAdmin('hod_director', 'DirectorQis@2026')">
                        🎓 Dr. Ananya Sharma (Director)
                    </button>
                </div>
                <div style="font-size: 0.75rem; color: var(--text-muted); margin-top: 0.6rem;">
                    Click a chip to fill verified faculty credentials for instant demonstration.
                </div>
            </div>

            <div style="text-align: center; margin-top: 1.5rem; font-size: 0.88rem; color: var(--text-secondary);">
                Are you a student cadet? <a href="login.jsp" style="color: var(--brand-primary); font-weight: 700; text-decoration: none;">Cadet Portal →</a>
            </div>
        </div>
    </div>

    <footer class="footer">
        <p>&copy; 2026 DevMatrix Engineering Arena &bull; Pure Jakarta EE 10 MVC Architecture</p>
    </footer>

</body>
</html>