<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Check if user is already logged in
    if (session.getAttribute("user") != null) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
        return;
    }
    
    String error = (String) request.getAttribute("error");
    String msg = request.getParameter("msg");
    String demo = request.getParameter("demo");

    // Remember Me Cookie extraction (Module 3)
    String savedUser = "";
    boolean rememberChecked = false;
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie c : cookies) {
            if ("devmatrix_user".equals(c.getName())) {
                savedUser = c.getValue();
                rememberChecked = true;
                break;
            }
        }
    }
    if (demo != null && !demo.trim().isEmpty()) {
        savedUser = demo.trim();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Access — DevMatrix</title>
    <link rel="stylesheet" href="css/style.css">
    <script>
        function fillPersona(username, password) {
            document.getElementById('usernameOrEmail').value = username;
            document.getElementById('password').value = password;
        }
    </script>
</head>
<body>

    <nav class="navbar">
        <a href="index.html" class="nav-brand">
            <div class="brand-icon">&lt;/&gt;</div>
            <span>DEV<span style="background: var(--brand-gradient); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">MATRIX</span></span>
        </a>
        <ul class="nav-links">
            <li><a href="index.html">Home</a></li>
            <li><a href="register.jsp">Register</a></li>
            <li><a href="admin-login.jsp" style="color: var(--text-muted); font-size: 0.82rem;">Evaluator Portal</a></li>
        </ul>
    </nav>

    <div class="container-narrow">
        <div class="card" style="box-shadow: 0 12px 40px -10px rgba(0,0,0,0.6); border-color: rgba(99, 102, 241, 0.3);">
            <div class="card-header" style="text-align: center; display: block; border-bottom: none; margin-bottom: 0.75rem;">
                <div style="width: 48px; height: 48px; margin: 0 auto 0.75rem; border-radius: 12px; background: var(--brand-gradient); display: flex; align-items: center; justify-content: center; font-size: 1.4rem; color: #fff; box-shadow: 0 4px 18px rgba(99,102,241,0.4);">
                    ⚡
                </div>
                <h2 class="card-title" style="font-size: 1.65rem;">Cadet Authentication</h2>
                <p style="color: var(--text-secondary); font-size: 0.9rem; margin-top: 0.25rem;">
                    Sign in to enter the combat arena and advance your engineering tier.
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
                    <div>Session securely invalidated. You have signed out.</div>
                </div>
            <% } else if ("registered".equals(msg)) { %>
                <div class="alert alert-success">
                    <span>✅</span>
                    <div>Cadet enlistment verified! Please authenticate with your credentials.</div>
                </div>
            <% } %>

            <form action="login" method="POST">
                <div class="form-group">
                    <label class="form-label" for="usernameOrEmail">Cadet Handle or Email</label>
                    <input type="text" id="usernameOrEmail" name="usernameOrEmail" class="form-control" 
                           value="<%= savedUser %>" placeholder="e.g. ananya" required autocomplete="username">
                </div>

                <div class="form-group">
                    <label class="form-label" for="password">Access Key (Password)</label>
                    <input type="password" id="password" name="password" class="form-control" 
                           placeholder="Enter your password" required autocomplete="current-password">
                </div>

                <!-- Remember-Me Checkbox (Module 3) -->
                <div class="form-group">
                    <label class="form-check">
                        <input type="checkbox" name="remember" value="true" <%= rememberChecked ? "checked" : "" %>>
                        <span>Remember my handle on this workstation (30-day cookie)</span>
                    </label>
                </div>

                <button type="submit" class="btn btn-primary btn-block" style="padding: 0.85rem; font-size: 1rem;">
                    Engage Matrix Session →
                </button>
            </form>

            <!-- 1-Click Viva Test Persona Auto-Fill (100% Female Handles) -->
            <div style="background: rgba(99, 102, 241, 0.08); border: 1px solid rgba(99, 102, 241, 0.25); border-radius: var(--radius-md); padding: 1.15rem; margin-top: 1.75rem;">
                <div style="font-size: 0.8rem; font-weight: 800; color: #c7d2fe; letter-spacing: 0.5px; margin-bottom: 0.65rem;">
                    💡 QUICK TEST AUTO-FILL (VIVA EVALUATION):
                </div>
                <div style="display: flex; gap: 0.5rem; flex-wrap: wrap;">
                    <button type="button" class="quick-chip" onclick="fillPersona('ananya', 'Ananya123@')">
                        👑 ananya (Lvl 3)
                    </button>
                    <button type="button" class="quick-chip" onclick="fillPersona('sravani', 'Sravani123@')">
                        ⚡ sravani (Lvl 2)
                    </button>
                    <button type="button" class="quick-chip" onclick="fillPersona('kavya', 'Kavya123@')">
                        🗄️ kavya (Lvl 2)
                    </button>
                    <button type="button" class="quick-chip" onclick="fillPersona('meghana', 'Meghana123@')">
                        🐛 meghana (Lvl 1)
                    </button>
                </div>
                <div style="font-size: 0.75rem; color: var(--text-muted); margin-top: 0.6rem;">
                    Clicking a chip fills verified demo credentials for quick faculty testing.
                </div>
            </div>

            <div style="text-align: center; margin-top: 1.5rem; font-size: 0.88rem; color: var(--text-secondary);">
                New cadet? <a href="register.jsp" style="color: var(--brand-primary); font-weight: 700; text-decoration: none;">Register Here →</a>
            </div>
        </div>
    </div>

    <footer class="footer">
        <p>&copy; 2026 DevMatrix Engineering Arena &bull; Pure Jakarta EE 10 MVC Architecture</p>
    </footer>

</body>
</html>