<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.devmatrix.model.Admin, java.util.Map, java.util.List" %>
<%
    Admin admin = (Admin) request.getAttribute("admin");
    if (admin == null) {
        admin = (Admin) session.getAttribute("admin");
    }
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
        return;
    }

    int totalUsers = request.getAttribute("totalUsers") != null ? (Integer) request.getAttribute("totalUsers") : 0;
    int totalChallenges = request.getAttribute("totalChallenges") != null ? (Integer) request.getAttribute("totalChallenges") : 0;
    int totalSubmissions = request.getAttribute("totalSubmissions") != null ? (Integer) request.getAttribute("totalSubmissions") : 0;
    int successfulSubmissions = request.getAttribute("successfulSubmissions") != null ? (Integer) request.getAttribute("successfulSubmissions") : 0;

    int successRate = (totalSubmissions > 0) ? (int) Math.round(((double) successfulSubmissions / totalSubmissions) * 100) : 0;

    @SuppressWarnings("unchecked")
    Map<String, Integer> categoryDistribution = (Map<String, Integer>) request.getAttribute("categoryDistribution");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Evaluator Telemetry Deck — DevMatrix</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <nav class="navbar">
        <a href="admin-dashboard" class="nav-brand">
            <div class="brand-icon" style="background: linear-gradient(135deg, #f43f5e 0%, #d946ef 100%);">⚡</div>
            <span>DEV<span style="background: var(--brand-gradient); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">MATRIX</span> <span style="font-size: 0.75rem; color: var(--accent-rose); font-weight: 800; border: 1px solid rgba(244,63,94,0.3); padding: 0.2rem 0.5rem; border-radius: var(--radius-sm); margin-left: 0.5rem;">EVALUATOR</span></span>
        </a>
        <ul class="nav-links">
            <li><a href="admin-dashboard" class="active">Telemetry Deck</a></li>
            <li><a href="view-challenges">Manage Challenges</a></li>
            <li><a href="add-challenge.jsp">Create Challenge</a></li>
            <li class="user-badge" style="border-color: rgba(244,63,94,0.3);">
                <span><%= admin.getFullName() %></span>
                <span class="badge badge-bughunt"><%= admin.getRole() %></span>
            </li>
            <li><a href="admin-logout" style="color: var(--accent-rose);">Sign Out</a></li>
        </ul>
    </nav>

    <main class="container">

        <!-- Evaluator Title Banner -->
        <div style="margin-bottom: 2rem; display: flex; justify-content: space-between; align-items: flex-end; flex-wrap: wrap; gap: 1rem;">
            <div>
                <div class="hero-tag" style="border-color: rgba(244,63,94,0.3); background: rgba(244,63,94,0.06); color: #fda4af;">
                    <span style="display:inline-block; width:7px; height:7px; border-radius:50%; background:#f43f5e; box-shadow:0 0 8px #f43f5e;"></span>
                    FACULTY EVALUATION &amp; TELEMETRY CONSOLE
                </div>
                <h1 style="font-size: 2.25rem; font-weight: 800; letter-spacing: -0.8px; margin-top: 0.5rem;">
                    Platform Telemetry
                </h1>
                <p style="color: var(--text-secondary); font-size: 0.95rem; margin-top: 0.25rem;">
                    Welcome back, <strong><%= admin.getFullName() %></strong> (<%= admin.getEmail() %>). Live system audit metrics across all modules.
                </p>
            </div>
            <div style="display: flex; gap: 0.75rem;">
                <a href="add-challenge.jsp" class="btn btn-primary" style="padding: 0.6rem 1.25rem;">+ Create Challenge</a>
                <a href="view-challenges" class="btn btn-secondary" style="padding: 0.6rem 1.25rem;">View Repository</a>
            </div>
        </div>

        <!-- 4 Metric KPI Cards -->
        <div class="grid-4" style="margin-bottom: 2.5rem;">
            <div class="card" style="border-left: 4px solid var(--brand-primary);">
                <div style="font-size: 0.78rem; font-weight: 800; color: var(--text-muted); letter-spacing: 0.5px;">ENLISTED CADETS</div>
                <div style="font-size: 2.25rem; font-weight: 800; color: #fff; font-family: var(--font-mono); margin: 0.4rem 0;"><%= totalUsers %></div>
                <div style="font-size: 0.8rem; color: var(--text-secondary);">Verified student profiles</div>
            </div>

            <div class="card" style="border-left: 4px solid var(--accent-cyan);">
                <div style="font-size: 0.78rem; font-weight: 800; color: var(--text-muted); letter-spacing: 0.5px;">ACTIVE MISSIONS</div>
                <div style="font-size: 2.25rem; font-weight: 800; color: #fff; font-family: var(--font-mono); margin: 0.4rem 0;"><%= totalChallenges %></div>
                <div style="font-size: 0.8rem; color: var(--text-secondary);">4 specialized arenas</div>
            </div>

            <div class="card" style="border-left: 4px solid var(--accent-purple);">
                <div style="font-size: 0.78rem; font-weight: 800; color: var(--text-muted); letter-spacing: 0.5px;">SUBMISSIONS LOGGED</div>
                <div style="font-size: 2.25rem; font-weight: 800; color: #fff; font-family: var(--font-mono); margin: 0.4rem 0;"><%= totalSubmissions %></div>
                <div style="font-size: 0.8rem; color: var(--text-secondary);">ACID evaluated transactions</div>
            </div>

            <div class="card" style="border-left: 4px solid var(--accent-emerald);">
                <div style="font-size: 0.78rem; font-weight: 800; color: var(--text-muted); letter-spacing: 0.5px;">PASS ACCURACY</div>
                <div style="font-size: 2.25rem; font-weight: 800; color: var(--accent-emerald); font-family: var(--font-mono); margin: 0.4rem 0;"><%= successRate %>%</div>
                <div style="font-size: 0.8rem; color: var(--text-secondary);"><%= successfulSubmissions %> successful attempts</div>
            </div>
        </div>

        <!-- 2 Column Analytics & Quick Actions -->
        <div class="grid-2" style="gap: 2rem; align-items: start;">
            
            <!-- Category Distribution Breakdown -->
            <div class="card">
                <div class="card-header" style="border-bottom: 1px solid var(--border-subtle); padding-bottom: 1rem; margin-bottom: 1.5rem;">
                    <h3 class="card-title">Combat Discipline Inventory</h3>
                    <span style="font-size: 0.82rem; color: var(--text-muted);">Challenges per Track</span>
                </div>

                <div style="display: flex; flex-direction: column; gap: 1.25rem;">
                    <div>
                        <div style="display: flex; justify-content: space-between; margin-bottom: 0.4rem; font-size: 0.9rem;">
                            <span style="color: #f43f5e; font-weight: 700;">BugHunt (Security &amp; Logic)</span>
                            <span style="font-weight: 700; color: #fff;"><%= categoryDistribution != null && categoryDistribution.containsKey("BugHunt") ? categoryDistribution.get("BugHunt") : 0 %> Challenges</span>
                        </div>
                        <div class="progress-container" style="height: 8px;">
                            <div class="progress-bar" style="width: <%= totalChallenges > 0 ? (int) Math.round(((double)(categoryDistribution != null && categoryDistribution.containsKey("BugHunt") ? categoryDistribution.get("BugHunt") : 0) / totalChallenges) * 100) : 0 %>%; background: var(--track-bughunt);"></div>
                        </div>
                    </div>

                    <div>
                        <div style="display: flex; justify-content: space-between; margin-bottom: 0.4rem; font-size: 0.9rem;">
                            <span style="color: #06b6d4; font-weight: 700;">AlgoDrift (DSA &amp; Big-O)</span>
                            <span style="font-weight: 700; color: #fff;"><%= categoryDistribution != null && categoryDistribution.containsKey("AlgoDrift") ? categoryDistribution.get("AlgoDrift") : 0 %> Challenges</span>
                        </div>
                        <div class="progress-container" style="height: 8px;">
                            <div class="progress-bar" style="width: <%= totalChallenges > 0 ? (int) Math.round(((double)(categoryDistribution != null && categoryDistribution.containsKey("AlgoDrift") ? categoryDistribution.get("AlgoDrift") : 0) / totalChallenges) * 100) : 0 %>%; background: var(--track-algodrift);"></div>
                        </div>
                    </div>

                    <div>
                        <div style="display: flex; justify-content: space-between; margin-bottom: 0.4rem; font-size: 0.9rem;">
                            <span style="color: #10b981; font-weight: 700;">QueryCraft (SQL Engines)</span>
                            <span style="font-weight: 700; color: #fff;"><%= categoryDistribution != null && categoryDistribution.containsKey("QueryCraft") ? categoryDistribution.get("QueryCraft") : 0 %> Challenges</span>
                        </div>
                        <div class="progress-container" style="height: 8px;">
                            <div class="progress-bar" style="width: <%= totalChallenges > 0 ? (int) Math.round(((double)(categoryDistribution != null && categoryDistribution.containsKey("QueryCraft") ? categoryDistribution.get("QueryCraft") : 0) / totalChallenges) * 100) : 0 %>%; background: var(--track-querycraft);"></div>
                        </div>
                    </div>

                    <div>
                        <div style="display: flex; justify-content: space-between; margin-bottom: 0.4rem; font-size: 0.9rem;">
                            <span style="color: #f59e0b; font-weight: 700;">PlacementArena (MNC Coding)</span>
                            <span style="font-weight: 700; color: #fff;"><%= categoryDistribution != null && categoryDistribution.containsKey("PlacementArena") ? categoryDistribution.get("PlacementArena") : 0 %> Challenges</span>
                        </div>
                        <div class="progress-container" style="height: 8px;">
                            <div class="progress-bar" style="width: <%= totalChallenges > 0 ? (int) Math.round(((double)(categoryDistribution != null && categoryDistribution.containsKey("PlacementArena") ? categoryDistribution.get("PlacementArena") : 0) / totalChallenges) * 100) : 0 %>%; background: var(--track-placement);"></div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Management Actions & System Status -->
            <div class="card">
                <div class="card-header" style="border-bottom: 1px solid var(--border-subtle); padding-bottom: 1rem; margin-bottom: 1.5rem;">
                    <h3 class="card-title">Evaluator Quick Actions</h3>
                    <span style="font-size: 0.82rem; color: var(--text-muted);">Faculty Operations</span>
                </div>

                <div style="display: flex; flex-direction: column; gap: 1rem;">
                    <a href="add-challenge.jsp" class="btn btn-primary" style="padding: 0.85rem 1.25rem; text-align: left; display: flex; justify-content: space-between; align-items: center;">
                        <div>
                            <div style="font-weight: 800; font-size: 0.95rem;">Author New Mission</div>
                            <div style="font-size: 0.78rem; opacity: 0.85;">Add coding or multiple-choice questions to any arena</div>
                        </div>
                        <span style="font-size: 1.25rem;">+</span>
                    </a>

                    <a href="view-challenges" class="btn btn-secondary" style="padding: 0.85rem 1.25rem; text-align: left; display: flex; justify-content: space-between; align-items: center;">
                        <div>
                            <div style="font-weight: 800; font-size: 0.95rem; color: #fff;">Inspect Challenge Repository</div>
                            <div style="font-size: 0.78rem; color: var(--text-muted);">Review, filter, or remove live missions</div>
                        </div>
                        <span style="font-size: 1.25rem;">→</span>
                    </a>

                    <div style="background: rgba(255,255,255,0.02); border: 1px solid var(--border-subtle); border-radius: var(--radius-md); padding: 1.15rem; margin-top: 0.5rem;">
                        <div style="font-size: 0.8rem; font-weight: 800; color: var(--accent-emerald); margin-bottom: 0.4rem; display: flex; align-items: center; gap: 0.4rem;">
                            <span>●</span> TRANSACTION INTEGRITY ENGINE
                        </div>
                        <p style="font-size: 0.82rem; color: var(--text-secondary); line-height: 1.5; margin: 0;">
                            Submission handling is locked to <code>READ_COMMITTED</code> isolation in <code>SubmitAnswerServlet</code>. 
                            Duplicate evaluation vectors are rejected atomically.
                        </p>
                    </div>
                </div>
            </div>

        </div>

    </main>

    <footer class="footer">
        <p>&copy; 2026 DevMatrix Engineering Arena &bull; Pure Jakarta EE 10 MVC Architecture</p>
    </footer>

</body>
</html>