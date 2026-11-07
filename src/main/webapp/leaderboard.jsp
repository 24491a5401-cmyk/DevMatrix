<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.devmatrix.model.User, com.devmatrix.model.LeaderboardEntry, java.util.List" %>
<%
    User currentUser = (User) request.getAttribute("user");
    if (currentUser == null) {
        currentUser = (User) session.getAttribute("user");
    }

    @SuppressWarnings("unchecked")
    List<LeaderboardEntry> leaderboard = (List<LeaderboardEntry>) request.getAttribute("leaderboard");

    LeaderboardEntry top1 = (leaderboard != null && leaderboard.size() > 0) ? leaderboard.get(0) : null;
    LeaderboardEntry top2 = (leaderboard != null && leaderboard.size() > 1) ? leaderboard.get(1) : null;
    LeaderboardEntry top3 = (leaderboard != null && leaderboard.size() > 2) ? leaderboard.get(2) : null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hall of Champions — DevMatrix</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .podium-container {
            display: flex;
            justify-content: center;
            align-items: flex-end;
            gap: 1.5rem;
            margin: 2.5rem 0 3.5rem;
            flex-wrap: wrap;
        }
        .podium-slot {
            width: 250px;
            background: rgba(15, 23, 42, 0.7);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-lg);
            padding: 1.5rem;
            text-align: center;
            backdrop-filter: blur(12px);
            transition: all var(--transition-normal);
        }
        .podium-slot:hover {
            transform: translateY(-4px);
        }
        .podium-1 {
            order: 2;
            min-height: 310px;
            border-color: rgba(251, 191, 36, 0.5);
            background: linear-gradient(180deg, rgba(251, 191, 36, 0.12) 0%, rgba(15, 23, 42, 0.9) 100%);
            box-shadow: 0 10px 30px -10px rgba(251, 191, 36, 0.35);
        }
        .podium-2 {
            order: 1;
            min-height: 270px;
            border-color: rgba(148, 163, 184, 0.4);
            background: linear-gradient(180deg, rgba(148, 163, 184, 0.08) 0%, rgba(15, 23, 42, 0.9) 100%);
        }
        .podium-3 {
            order: 3;
            min-height: 240px;
            border-color: rgba(217, 119, 6, 0.35);
            background: linear-gradient(180deg, rgba(217, 119, 6, 0.08) 0%, rgba(15, 23, 42, 0.9) 100%);
        }
        .crown-icon {
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
            filter: drop-shadow(0 2px 8px rgba(251, 191, 36, 0.6));
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <a href="dashboard" class="nav-brand">
            <div class="brand-icon">&lt;/&gt;</div>
            <span>DEV<span style="background: var(--brand-gradient); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">MATRIX</span></span>
        </a>
        <ul class="nav-links">
            <li><a href="dashboard">Command Center</a></li>
            <li><a href="challenges">Combat Arena</a></li>
            <li><a href="leaderboard" class="active">Leaderboard</a></li>
            <% if (currentUser != null) { %>
                <li class="user-badge">
                    <span><%= currentUser.getUsername() %></span>
                    <span class="badge badge-xp"><%= currentUser.getXp() %> XP</span>
                </li>
                <li><a href="logout" style="color: var(--accent-rose);">Sign Out</a></li>
            <% } else { %>
                <li><a href="login.jsp">Sign In</a></li>
            <% } %>
        </ul>
    </nav>

    <main class="container">

        <!-- Leaderboard Header -->
        <div style="text-align: center; margin-bottom: 1rem;">
            <div class="hero-tag">
                <span style="display:inline-block; width:7px; height:7px; border-radius:50%; background:#fbbf24; box-shadow:0 0 8px #fbbf24;"></span>
                GLOBAL ARENA RANKINGS
            </div>
            <h1 style="font-size: 2.35rem; font-weight: 800; letter-spacing: -0.8px; margin-top: 0.5rem;">
                Hall of Champions
            </h1>
            <p style="color: var(--text-secondary); font-size: 1rem; margin-top: 0.35rem;">
                Live standings of top engineering cadets ranked by DevXP across all 4 disciplines.
            </p>
        </div>

        <!-- 3D Glass Podium (Top 3 Cadets) -->
        <% if (leaderboard != null && !leaderboard.isEmpty()) { %>
            <div class="podium-container">
                
                <!-- Rank 2: Silver -->
                <% if (top2 != null) { %>
                    <div class="podium-slot podium-2">
                        <div style="font-size: 1.8rem; margin-bottom: 0.25rem;">🥈</div>
                        <div style="font-size: 0.8rem; font-weight: 800; color: #94a3b8; letter-spacing: 0.5px;">RANK #2</div>
                        <h3 style="font-size: 1.25rem; font-weight: 800; color: #fff; margin-top: 0.4rem;"><%= top2.getUsername() %></h3>
                        <div style="font-size: 0.85rem; color: var(--text-secondary); margin-top: 0.2rem;"><%= top2.getLevelTitle() %></div>
                        <div style="font-size: 1.4rem; font-weight: 800; color: var(--brand-primary); font-family: var(--font-mono); margin: 0.85rem 0 0.5rem;"><%= top2.getXp() %> XP</div>
                        <div style="font-size: 0.78rem; color: var(--text-muted);"><%= top2.getSolvedCount() %> Missions Solved</div>
                    </div>
                <% } %>

                <!-- Rank 1: Gold (Center Elevated) -->
                <% if (top1 != null) { %>
                    <div class="podium-slot podium-1">
                        <div class="crown-icon">👑</div>
                        <div style="font-size: 0.8rem; font-weight: 800; color: #fbbf24; letter-spacing: 0.5px;">CHAMPION #1</div>
                        <h3 style="font-size: 1.45rem; font-weight: 800; color: #fff; margin-top: 0.4rem;"><%= top1.getUsername() %></h3>
                        <div style="font-size: 0.9rem; color: #fde68a; margin-top: 0.2rem;"><%= top1.getLevelTitle() %></div>
                        <div style="font-size: 1.7rem; font-weight: 800; color: #fbbf24; font-family: var(--font-mono); margin: 0.85rem 0 0.5rem;"><%= top1.getXp() %> XP</div>
                        <div style="font-size: 0.82rem; color: var(--text-secondary); font-weight: 600;"><%= top1.getSolvedCount() %> Missions Solved</div>
                    </div>
                <% } %>

                <!-- Rank 3: Bronze -->
                <% if (top3 != null) { %>
                    <div class="podium-slot podium-3">
                        <div style="font-size: 1.8rem; margin-bottom: 0.25rem;">🥉</div>
                        <div style="font-size: 0.8rem; font-weight: 800; color: #d97706; letter-spacing: 0.5px;">RANK #3</div>
                        <h3 style="font-size: 1.25rem; font-weight: 800; color: #fff; margin-top: 0.4rem;"><%= top3.getUsername() %></h3>
                        <div style="font-size: 0.85rem; color: var(--text-secondary); margin-top: 0.2rem;"><%= top3.getLevelTitle() %></div>
                        <div style="font-size: 1.4rem; font-weight: 800; color: var(--brand-primary); font-family: var(--font-mono); margin: 0.85rem 0 0.5rem;"><%= top3.getXp() %> XP</div>
                        <div style="font-size: 0.78rem; color: var(--text-muted);"><%= top3.getSolvedCount() %> Missions Solved</div>
                    </div>
                <% } %>

            </div>
        <% } %>

        <!-- All Cadets Ranking Table -->
        <div class="card" style="padding: 0; overflow: hidden;">
            <div class="card-header" style="padding: 1.25rem 1.5rem; margin-bottom: 0;">
                <h3 class="card-title">Overall Arena Standings</h3>
                <span style="font-size: 0.85rem; color: var(--text-muted);">Dynamically Computed from MySQL DB</span>
            </div>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th style="width: 80px;">Rank</th>
                            <th>Cadet Handle</th>
                            <th>Tier Level</th>
                            <th>Title</th>
                            <th>Missions Solved</th>
                            <th>Total DevXP</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (leaderboard == null || leaderboard.isEmpty()) { %>
                            <tr>
                                <td colspan="6" style="text-align: center; color: var(--text-muted); padding: 3rem;">
                                    No ranked cadets yet in DevMatrix database.
                                </td>
                            </tr>
                        <% } else { %>
                            <% for (LeaderboardEntry entry : leaderboard) { 
                                boolean isSelf = (currentUser != null && currentUser.getUsername().equalsIgnoreCase(entry.getUsername()));
                            %>
                                <tr style="<%= isSelf ? "background: rgba(99, 102, 241, 0.12);" : "" %>">
                                    <td>
                                        <% if (entry.getRank() == 1) { %>
                                            <span style="font-size: 1.25rem;">🥇</span>
                                        <% } else if (entry.getRank() == 2) { %>
                                            <span style="font-size: 1.25rem;">🥈</span>
                                        <% } else if (entry.getRank() == 3) { %>
                                            <span style="font-size: 1.25rem;">🥉</span>
                                        <% } else { %>
                                            <strong style="color: var(--text-secondary); font-family: var(--font-mono);">#<%= entry.getRank() %></strong>
                                        <% } %>
                                    </td>
                                    <td>
                                        <div style="display: flex; align-items: center; gap: 0.65rem;">
                                            <strong style="color: #ffffff;"><%= entry.getUsername() %></strong>
                                            <% if (isSelf) { %>
                                                <span class="badge badge-algodrift" style="font-size: 0.7rem; padding: 0.15rem 0.45rem;">YOU</span>
                                            <% } %>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="badge badge-algodrift">Level <%= entry.getLevel() %></span>
                                    </td>
                                    <td style="color: var(--text-secondary); font-size: 0.9rem;">
                                        <%= entry.getLevelTitle() %>
                                    </td>
                                    <td>
                                        <strong style="color: var(--accent-emerald); font-family: var(--font-mono);"><%= entry.getSolvedCount() %></strong>
                                    </td>
                                    <td>
                                        <strong style="color: var(--brand-primary); font-family: var(--font-mono); font-size: 1.05rem;"><%= entry.getXp() %> XP</strong>
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