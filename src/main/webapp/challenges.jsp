<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.devmatrix.model.User, com.devmatrix.model.Challenge, java.util.List, java.util.Set" %>
<%
    User user = (User) request.getAttribute("user");
    if (user == null) {
        user = (User) session.getAttribute("user");
    }
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    @SuppressWarnings("unchecked")
    List<Challenge> challenges = (List<Challenge>) request.getAttribute("challenges");
    
    @SuppressWarnings("unchecked")
    Set<Integer> solvedIds = (Set<Integer>) request.getAttribute("solvedIds");
    
    String currentCategory = (String) request.getAttribute("currentCategory");
    if (currentCategory == null) currentCategory = "All";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Combat Arena — DevMatrix</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <nav class="navbar">
        <a href="dashboard" class="nav-brand">
            <div class="brand-icon">&lt;/&gt;</div>
            <span>DEV<span style="background: var(--brand-gradient); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">MATRIX</span></span>
        </a>
        <ul class="nav-links">
            <li><a href="dashboard">Command Center</a></li>
            <li><a href="challenges" class="active">Combat Arena</a></li>
            <li><a href="leaderboard">Leaderboard</a></li>
            <li class="user-badge">
                <span><%= user.getUsername() %></span>
                <span class="badge badge-xp"><%= user.getXp() %> XP</span>
            </li>
            <li><a href="logout" style="color: var(--accent-rose);">Sign Out</a></li>
        </ul>
    </nav>

    <main class="container">

        <!-- Arena Header Banner -->
        <div style="margin-bottom: 2rem;">
            <div class="hero-tag">
                <span style="display:inline-block; width:7px; height:7px; border-radius:50%; background:#06b6d4; box-shadow:0 0 8px #06b6d4;"></span>
                ACTIVE COMBAT ARENA MISSIONS
            </div>
            <h1 style="font-size: 2.25rem; font-weight: 800; letter-spacing: -0.8px; margin-top: 0.5rem;">
                Select Your Combat Mission
            </h1>
            <p style="color: var(--text-secondary); font-size: 1rem; margin-top: 0.35rem; max-width: 800px;">
                Tackle industry-calibrated coding, bug-hunting, SQL architecture, and placement problems. 
                Single-attempt submission engine backed by ACID transaction isolation.
            </p>
        </div>

        <!-- Discipline Filter Tabs -->
        <div class="filter-bar" style="margin-bottom: 2rem;">
            <a href="challenges?category=All" class="filter-pill <%= "All".equalsIgnoreCase(currentCategory) ? "active" : "" %>">
                🌐 All Arenas (<%= challenges != null ? challenges.size() : 0 %>)
            </a>
            <a href="challenges?category=BugHunt" class="filter-pill <%= "BugHunt".equalsIgnoreCase(currentCategory) ? "active" : "" %>">
                🐛 BugHunt
            </a>
            <a href="challenges?category=AlgoDrift" class="filter-pill <%= "AlgoDrift".equalsIgnoreCase(currentCategory) ? "active" : "" %>">
                ⚡ AlgoDrift
            </a>
            <a href="challenges?category=QueryCraft" class="filter-pill <%= "QueryCraft".equalsIgnoreCase(currentCategory) ? "active" : "" %>">
                🗄️ QueryCraft
            </a>
            <a href="challenges?category=PlacementArena" class="filter-pill <%= "PlacementArena".equalsIgnoreCase(currentCategory) ? "active" : "" %>">
                🎯 PlacementArena
            </a>
        </div>

        <!-- Challenges Cards Grid -->
        <div class="grid-3" style="gap: 1.5rem;">
            <% if (challenges != null && !challenges.isEmpty()) { 
                for (Challenge c : challenges) {
                    boolean isSolved = (solvedIds != null && solvedIds.contains(c.getId()));
                    String cat = c.getCategory();
                    String cardTrackClass = "track-algodrift";
                    String badgeClass = "badge-algodrift";
                    if ("BugHunt".equalsIgnoreCase(cat)) {
                        cardTrackClass = "track-bughunt";
                        badgeClass = "badge-bughunt";
                    } else if ("QueryCraft".equalsIgnoreCase(cat)) {
                        cardTrackClass = "track-querycraft";
                        badgeClass = "badge-querycraft";
                    } else if ("PlacementArena".equalsIgnoreCase(cat)) {
                        cardTrackClass = "track-placement";
                        badgeClass = "badge-placement";
                    }

                    String diffClass = "badge-easy";
                    if ("Medium".equalsIgnoreCase(c.getDifficulty())) diffClass = "badge-medium";
                    else if ("Hard".equalsIgnoreCase(c.getDifficulty())) diffClass = "badge-hard";
            %>
                <div class="challenge-card <%= cardTrackClass %>" style="display: flex; flex-direction: column;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                        <span class="badge <%= badgeClass %>"><%= cat %></span>
                        <div style="display: flex; gap: 0.4rem; align-items: center;">
                            <span class="badge <%= diffClass %>"><%= c.getDifficulty() %></span>
                            <span class="badge badge-xp">+<%= c.getXp() %> XP</span>
                        </div>
                    </div>

                    <h3 style="font-size: 1.25rem; font-weight: 800; color: #ffffff; margin-bottom: 0.65rem; line-height: 1.35;">
                        <%= c.getTitle() %>
                    </h3>

                    <p style="color: var(--text-secondary); font-size: 0.88rem; line-height: 1.5; margin-bottom: 1.5rem; flex-grow: 1;">
                        <%= c.getDescription().length() > 140 ? c.getDescription().substring(0, 140) + "..." : c.getDescription() %>
                    </p>

                    <div style="display: flex; justify-content: space-between; align-items: center; padding-top: 1rem; border-top: 1px solid var(--border-subtle); margin-top: auto;">
                        <div>
                            <% if (isSolved) { %>
                                <span style="color: var(--accent-emerald); font-weight: 700; font-size: 0.85rem; display: inline-flex; align-items: center; gap: 0.35rem;">
                                    <span>✔</span> Solved
                                </span>
                            <% } else { %>
                                <span style="color: var(--text-muted); font-size: 0.85rem;">
                                    Unattempted
                                </span>
                            <% } %>
                        </div>
                        <a href="challenge-detail?id=<%= c.getId() %>" class="btn btn-primary" style="padding: 0.45rem 1rem; font-size: 0.85rem;">
                            <%= isSolved ? "Review Mission →" : "Engage Mission →" %>
                        </a>
                    </div>
                </div>
            <%  } 
            } else { %>
                <div class="card" style="grid-column: 1 / -1; text-align: center; padding: 4rem 2rem;">
                    <div style="font-size: 2.5rem; margin-bottom: 1rem;">🔍</div>
                    <h3 style="font-size: 1.35rem; font-weight: 800; color: #fff;">No Missions Found in this Arena</h3>
                    <p style="color: var(--text-secondary); margin-top: 0.5rem;">Select another track filter above or view all active challenges.</p>
                </div>
            <% } %>
        </div>

    </main>

    <footer class="footer">
        <p>&copy; 2026 DevMatrix Engineering Arena &bull; Pure Jakarta EE 10 MVC Architecture</p>
    </footer>

</body>
</html>