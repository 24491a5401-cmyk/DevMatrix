<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Check if user is already logged in
    if (session.getAttribute("user") != null) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
        return;
    }
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enlist Cadet — DevMatrix</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <nav class="navbar">
        <a href="index.html" class="nav-brand">
            <div class="brand-icon">&lt;/&gt;</div>
            <span>DEV<span style="background: var(--brand-gradient); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">MATRIX</span></span>
        </a>
        <ul class="nav-links">
            <li><a href="index.html">Home</a></li>
            <li><a href="login.jsp">Student Access</a></li>
        </ul>
    </nav>

    <div class="container-narrow">
        <div class="card" style="box-shadow: 0 12px 40px -10px rgba(0,0,0,0.6); border-color: rgba(99, 102, 241, 0.3);">
            <div class="card-header" style="text-align: center; display: block; border-bottom: none; margin-bottom: 0.75rem;">
                <div style="width: 48px; height: 48px; margin: 0 auto 0.75rem; border-radius: 12px; background: var(--brand-gradient); display: flex; align-items: center; justify-content: center; font-size: 1.4rem; color: #fff; box-shadow: 0 4px 18px rgba(99,102,241,0.4);">
                    🛡️
                </div>
                <h2 class="card-title" style="font-size: 1.65rem;">Cadet Enlistment</h2>
                <p style="color: var(--text-secondary); font-size: 0.9rem; margin-top: 0.25rem;">
                    Create your DevMatrix handle to enter competitive assessment rounds.
                </p>
            </div>

            <!-- Inline Error Banner (Module 12) -->
            <% if (error != null && !error.trim().isEmpty()) { %>
                <div class="alert alert-error">
                    <span>⚠️</span>
                    <div><%= error %></div>
                </div>
            <% } %>

            <form action="register" method="POST">
                <div class="form-group">
                    <label class="form-label" for="username">Handle / Username</label>
                    <input type="text" id="username" name="username" class="form-control" 
                           placeholder="e.g. sravani_dev" required autocomplete="username">
                    <small style="color: var(--text-muted); font-size: 0.75rem; margin-top: 0.25rem; display: block;">Letters, numbers, and underscores only.</small>
                </div>

                <div class="form-group">
                    <label class="form-label" for="email">Academic or Personal Email</label>
                    <input type="email" id="email" name="email" class="form-control" 
                           placeholder="student@qiscet.edu.in" required autocomplete="email">
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="password">Access Key</label>
                        <input type="password" id="password" name="password" class="form-control" 
                               placeholder="Min 6 chars" required autocomplete="new-password">
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="confirmPassword">Confirm Key</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" 
                               placeholder="Re-enter password" required autocomplete="new-password">
                    </div>
                </div>

                <button type="submit" class="btn btn-primary btn-block" style="padding: 0.85rem; font-size: 1rem; margin-top: 0.5rem;">
                    Enlist Into DevMatrix →
                </button>
            </form>

            <div style="text-align: center; margin-top: 1.5rem; font-size: 0.88rem; color: var(--text-secondary);">
                Already registered? <a href="login.jsp" style="color: var(--brand-primary); font-weight: 700; text-decoration: none;">Sign In Here →</a>
            </div>
        </div>
    </div>

    <footer class="footer">
        <p>&copy; 2026 DevMatrix Engineering Arena &bull; Pure Jakarta EE 10 MVC Architecture</p>
    </footer>

</body>
</html>