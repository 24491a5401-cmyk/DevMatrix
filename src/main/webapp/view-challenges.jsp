<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.devmatrix.model.Admin, com.devmatrix.model.Challenge, java.util.List" %>
<%
    Admin admin = (Admin) request.getAttribute("admin");
    if (admin == null) {
        admin = (Admin) session.getAttribute("admin");
    }
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
        return;
    }

    @SuppressWarnings("unchecked")
    List<Challenge> challenges = (List<Challenge>) request.getAttribute("challenges");
    String message = request.getParameter("message");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Challenge Repository — DevMatrix Evaluator</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <nav class="navbar">
        <a href="admin-dashboard" class="nav-brand">
            <div class="brand-icon" style="background: linear-gradient(135deg, #f43f5e 0%, #d946ef 100%);">⚡</div>
            <span>DEV<span style="background: var(--brand-gradient); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">MATRIX</span> <span style="font-size: 0.75rem; color: var(--accent-rose); font-weight: 800; border: 1px solid rgba(244,63,94,0.3); padding: 0.2rem 0.5rem; border-radius: var(--radius-sm); margin-left: 0.5rem;">EVALUATOR</span></span>
        </a>
        <ul class="nav-links">
            <li><a href="admin-dashboard">Telemetry Deck</a></li>
            <li><a href="view-challenges" class="active">Manage Challenges</a></li>
            <li><a href="add-challenge.jsp">Create Challenge</a></li>
            <li class="user-badge" style="border-color: rgba(244,63,94,0.3);">
                <span><%= admin.getFullName() %></span>
                <span class="badge badge-bughunt"><%= admin.getRole() %></span>
            </li>
            <li><a href="admin-logout" style="color: var(--accent-rose);">Sign Out</a></li>
        </ul>
    </nav>

    <main class="container">

        <!-- Top Header & Action -->
        <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 2rem; flex-wrap: wrap; gap: 1rem;">
            <div>
                <div class="hero-tag" style="border-color: rgba(244,63,94,0.3); background: rgba(244,63,94,0.06); color: #fda4af;">
                    <span style="display:inline-block; width:7px; height:7px; border-radius:50%; background:#f43f5e; box-shadow:0 0 8px #f43f5e;"></span>
                    MISSION CATALOGUE MANAGEMENT
                </div>
                <h1 style="font-size: 2.25rem; font-weight: 800; letter-spacing: -0.8px; margin-top: 0.5rem;">
                    Active Challenge Repository
                </h1>
                <p style="color: var(--text-secondary); font-size: 0.95rem; margin-top: 0.25rem;">
                    Total published challenges: <strong><%= challenges != null ? challenges.size() : 0 %></strong>
                </p>
            </div>
            <a href="add-challenge.jsp" class="btn btn-primary" style="padding: 0.65rem 1.35rem;">+ Create New Mission</a>
        </div>

        <% if (message != null && !message.trim().isEmpty()) { %>
            <div class="alert alert-success" style="margin-bottom: 1.5rem;">
                <span>✔</span>
                <div><%= message %></div>
            </div>
        <% } %>

        <% if (error != null && !error.trim().isEmpty()) { %>
            <div class="alert alert-error" style="margin-bottom: 1.5rem;">
                <span>⚠️</span>
                <div><%= error %></div>
            </div>
        <% } %>

        <!-- Challenges Table Card -->
        <div class="card" style="padding: 0; overflow: hidden;">
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th style="width: 60px;">ID</th>
                            <th>Mission Title</th>
                            <th>Arena Discipline</th>
                            <th>Difficulty</th>
                            <th>DevXP Value</th>
                            <th>Correct Key</th>
                            <th style="text-align: right;">Management</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (challenges == null || challenges.isEmpty()) { %>
                            <tr>
                                <td colspan="7" style="text-align: center; color: var(--text-muted); padding: 3rem;">
                                    No challenges exist in the database. Click "+ Create New Mission" to publish one.
                                </td>
                            </tr>
                        <% } else { %>
                            <% for (Challenge c : challenges) { 
                                String cat = c.getCategory();
                                String badgeClass = "badge-algodrift";
                                if ("BugHunt".equalsIgnoreCase(cat)) badgeClass = "badge-bughunt";
                                else if ("QueryCraft".equalsIgnoreCase(cat)) badgeClass = "badge-querycraft";
                                else if ("PlacementArena".equalsIgnoreCase(cat)) badgeClass = "badge-placement";

                                String diffClass = "badge-easy";
                                if ("Medium".equalsIgnoreCase(c.getDifficulty())) diffClass = "badge-medium";
                                else if ("Hard".equalsIgnoreCase(c.getDifficulty())) diffClass = "badge-hard";
                            %>
                                <tr>
                                    <td style="font-family: var(--font-mono); color: var(--text-muted);">#<%= c.getId() %></td>
                                    <td>
                                        <div style="font-weight: 700; color: #fff;"><%= c.getTitle() %></div>
                                        <div style="font-size: 0.8rem; color: var(--text-secondary); margin-top: 0.2rem;">
                                            <%= c.getDescription().length() > 80 ? c.getDescription().substring(0, 80) + "..." : c.getDescription() %>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="badge <%= badgeClass %>"><%= cat %></span>
                                    </td>
                                    <td>
                                        <span class="badge <%= diffClass %>"><%= c.getDifficulty() %></span>
                                    </td>
                                    <td>
                                        <span class="badge badge-xp">+<%= c.getXp() %> XP</span>
                                    </td>
                                    <td>
                                        <code style="background: rgba(255,255,255,0.06); padding: 0.2rem 0.5rem; border-radius: var(--radius-sm); font-weight: 800; color: var(--accent-emerald);">
                                            <%= c.getCorrectOption() %>
                                        </code>
                                    </td>
                                    <td style="text-align: right;">
                                        <form action="delete-challenge" method="POST" style="display: inline;" onsubmit="return confirm('Confirm deletion of Mission #<%= c.getId() %>: <%= c.getTitle().replace("'", "\\'") %>?');">
                                            <input type="hidden" name="id" value="<%= c.getId() %>">
                                            <button type="submit" class="btn" style="background: rgba(244, 63, 94, 0.15); color: #fda4af; border: 1px solid rgba(244, 63, 94, 0.3); padding: 0.35rem 0.75rem; font-size: 0.8rem; border-radius: var(--radius-sm);">
                                                Delete
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            <% } %>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

    </main>

    <footer class="footer">
        <p>&copy; 2026 DevMatrix Engineering Arena &bull; Pure Jakarta EE 10 MVC Architecture</p>
    </footer>

</body>
</html>