<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.devmatrix.model.User, com.devmatrix.model.TrackStats, java.util.Map, java.util.List" %>
<%
    User user = (User) request.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
        return;
    }

    int totalSolved = request.getAttribute("totalSolved") != null ? (Integer) request.getAttribute("totalSolved") : 0;
    int totalChallenges = request.getAttribute("totalChallenges") != null ? (Integer) request.getAttribute("totalChallenges") : 0;
    int globalRank = request.getAttribute("globalRank") != null ? (Integer) request.getAttribute("globalRank") : 1;
    
    @SuppressWarnings("unchecked")
    Map<String, TrackStats> trackStats = (Map<String, TrackStats>) request.getAttribute("trackStats");
    
    @SuppressWarnings("unchecked")
    List<Map<String, Object>> recentActivities = (List<Map<String, Object>>) request.getAttribute("recentActivities");

    // Tier Progress Calculations
    int currentLevel = user.getLevel();
    int currentXp = user.getXp();
    int prevXp = User.getPreviousLevelThreshold(currentLevel);
    int nextXp = User.getNextLevelThreshold(currentLevel);
    int xpToNext = (currentLevel >= 5) ? 0 : Math.max(0, nextXp - currentXp);
    
    int progressPercent = 100;
    if (currentLevel < 5 && nextXp > prevXp) {
        progressPercent = Math.min(100, Math.max(0, (int) Math.round(((double)(currentXp - prevXp) / (nextXp - prevXp)) * 100)));
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Combat Command — DevMatrix</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <nav class="navbar">
        <a href="dashboard" class="nav-brand">
            <div class="brand-icon">&lt;/&gt;</div>
            <span>DEV<span style="background: var(--brand-gradient); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">MATRIX</span></span>
        </a>
        <ul class="nav-links">
            <li><a href="dashboard" class="active">Command Center</a></li>
            <li><a href="challenges">Combat Arena</a></li>
            <li><a href="leaderboard">Leaderboard</a></li>
            <li class="user-badge">
                <span><%= user.getUsername() %></span>
                <span class="badge badge-xp"><%= user.getXp() %> XP</span>
            </li>
            <li><a href="logout" style="color: var(--accent-rose);">Sign Out</a></li>
        </ul>
    </nav>

    <main class="container">

        <!-- Top Profile & Tier Banner (Module 8) -->
        <div class="card" style="box-shadow: 0 12px 40px -10px rgba(0,0,0,0.5); border-color: rgba(99, 102, 241, 0.3);">
            <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1.5rem;">
                
                <div style="display: flex; align-items: center; gap: 1.25rem;">
                    <div style="width: 68px; height: 68px; border-radius: var(--radius-lg); background: var(--brand-gradient); display: flex; align-items: center; justify-content: center; font-size: 2rem; color: #fff; box-shadow: 0 6px 20px rgba(99,102,241,0.45);">
                        ⚔️
                    </div>
                    <div>
                        <div style="display: flex; align-items: center; gap: 0.75rem; flex-wrap: wrap;">
                            <h2 style="font-size: 1.6rem; font-weight: 800; color: #ffffff;"><%= user.getUsername() %></h2>
                            <span class="badge badge-algodrift">Level <%= currentLevel %></span>
                            <span class="badge badge-xp"><%= user.getLevelTitle() %></span>
                        </div>
                        <p style="color: var(--text-secondary); font-size: 0.88rem; margin-top: 0.35rem;">
                            Cadet ID: <%= user.getEmail() %> &bull; Enlisted on <%= user.getCreatedAt() != null ? user.getCreatedAt().toString().substring(0, 10) : "N/A" %>
                        </p>
                    </div>
                </div>

                <!-- Stats summary badges -->
                <div style="display: flex; gap: 1rem; flex-wrap: wrap;">
                    <div style="background: rgba(255,255,255,0.04); padding: 0.85rem 1.4rem; border-radius: var(--radius-md); border: 1px solid var(--border-subtle); text-align: center; min-width: 120px;">
                        <div style="font-size: 0.75rem; color: var(--text-muted); font-weight: 800; letter-spacing: 0.5px;">TOTAL DEVXP</div>
                        <div style="font-size: 1.5rem; font-weight: 800; color: var(--brand-primary); font-family: var(--font-mono); margin-top: 0.2rem;"><%= user.getXp() %></div>
                    </div>
                    <div style="background: rgba(255,255,255,0.04); padding: 0.85rem 1.4rem; border-radius: var(--radius-md); border: 1px solid var(--border-subtle); text-align: center; min-width: 120px;">
                        <div style="font-size: 0.75rem; color: var(--text-muted); font-weight: 800; letter-spacing: 0.5px;">GLOBAL RANK</div>
                        <div style="font-size: 1.5rem; font-weight: 800; color: #fbbf24; font-family: var(--font-mono); margin-top: 0.2rem;">#<%= globalRank %></div>
                    </div>
                    <div style="background: rgba(255,255,255,0.04); padding: 0.85rem 1.4rem; border-radius: var(--radius-md); border: 1px solid var(--border-subtle); text-align: center; min-width: 120px;">
                        <div style="font-size: 0.75rem; color: var(--text-muted); font-weight: 800; letter-spacing: 0.5px;">SOLVED MISSIONS</div>
                        <div style="font-size: 1.5rem; font-weight: 800; color: var(--accent-emerald); font-family: var(--font-mono); margin-top: 0.2rem;"><%= totalSolved %> / <%= totalChallenges %></div>
                    </div>
                </div>

            </div>

            <!-- Level Tier Progress Bar -->
            <div style="margin-top: 1.75rem; padding-top: 1.25rem; border-top: 1px solid var(--border-subtle);">
                <div style="display: flex; justify-content: space-between; font-size: 0.88rem; margin-bottom: 0.55rem; color: var(--text-secondary);">
                    <span>
                        Tier Advancement: <strong style="color: #ffffff;">Level <%= currentLevel %> (<%= user.getLevelTitle() %>)</strong>
                    </span>
                    <span>
                        <% if (currentLevel < 5) { %>
                            <strong style="color: var(--brand-primary);"><%= xpToNext %> XP</strong> remaining to Level <%= currentLevel + 1 %>
                        <% } else { %>
                            <strong style="color: #fbbf24;">★ MAXIMUM TIER ACHIEVED (Principal Architect)</strong>
                        <% } %>
                    </span>
                </div>
                <div class="progress-container">
                    <div class="progress-bar" style="width: <%= progressPercent %>%;"></div>
                </div>
            </div>
        </div>

        <!-- Four Combat Domains Status Grid -->
        <div style="margin-bottom: 1.25rem; display: flex; justify-content: space-between; align-items: center;">
            <h3 style="font-size: 1.35rem; font-weight: 800; letter-spacing: -0.4px;">Combat Discipline Progress</h3>
            <span style="font-size: 0.85rem; color: var(--text-secondary);">4 Assessment Tracks Active</span>
        </div>
        
        <div class="grid-4" style="margin-bottom: 2.5rem;">
            
            <!-- BugHunt Stats -->
            <%
                TrackStats bh = trackStats != null ? trackStats.get("BugHunt") : null;
                int bhSolved = bh != null ? bh.getSolvedCount() : 0;
                int bhTotal = bh != null ? bh.getTotalCount() : 0;
                int bhPct = bh != null ? bh.getCompletionPercentage() : 0;
            %>
            <div class="track-card track-bughunt">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.75rem;">
                    <span class="badge badge-bughunt">BugHunt</span>
                    <span style="font-size: 0.85rem; font-weight: 700; color: var(--text-secondary);"><%= bhSolved %>/<%= bhTotal %></span>
                </div>
                <h4 style="font-size: 1.15rem; font-weight: 800; margin-bottom: 0.75rem; color: #fff;">Security &amp; Logic</h4>
                <div class="progress-container" style="height: 8px; margin-bottom: 0.6rem;">
                    <div class="progress-bar" style="width: <%= bhPct %>%; background: var(--track-bughunt);"></div>
                </div>
                <div style="font-size: 0.82rem; color: var(--text-muted);"><%= bhPct %>% Completed</div>
            </div>

            <!-- AlgoDrift Stats -->
            <%
                TrackStats ad = trackStats != null ? trackStats.get("AlgoDrift") : null;
                int adSolved = ad != null ? ad.getSolvedCount() : 0;
                int adTotal = ad != null ? ad.getTotalCount() : 0;
                int adPct = ad != null ? ad.getCompletionPercentage() : 0;
            %>
            <div class="track-card track-algodrift">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.75rem;">
                    <span class="badge badge-algodrift">AlgoDrift</span>
                    <span style="font-size: 0.85rem; font-weight: 700; color: var(--text-secondary);"><%= adSolved %>/<%= adTotal %></span>
                </div>
                <h4 style="font-size: 1.15rem; font-weight: 800; margin-bottom: 0.75rem; color: #fff;">DSA &amp; Big-O</h4>
                <div class="progress-container" style="height: 8px; margin-bottom: 0.6rem;">
                    <div class="progress-bar" style="width: <%= adPct %>%; background: var(--track-algodrift);"></div>
                </div>
                <div style="font-size: 0.82rem; color: var(--text-muted);"><%= adPct %>% Completed</div>
            </div>

            <!-- QueryCraft Stats -->
            <%
                TrackStats qc = trackStats != null ? trackStats.get("QueryCraft") : null;
                int qcSolved = qc != null ? qc.getSolvedCount() : 0;
                int qcTotal = qc != null ? qc.getTotalCount() : 0;
                int qcPct = qc != null ? qc.getCompletionPercentage() : 0;
            %>
            <div class="track-card track-querycraft">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.75rem;">
                    <span class="badge badge-querycraft">QueryCraft</span>
                    <span style="font-size: 0.85rem; font-weight: 700; color: var(--text-secondary);"><%= qcSolved %>/<%= qcTotal %></span>
                </div>
                <h4 style="font-size: 1.15rem; font-weight: 800; margin-bottom: 0.75rem; color: #fff;">SQL &amp; ACID Engines</h4>
                <div class="progress-container" style="height: 8px; margin-bottom: 0.6rem;">
                    <div class="progress-bar" style="width: <%= qcPct %>%; background: var(--track-querycraft);"></div>
                </div>
                <div style="font-size: 0.82rem; color: var(--text-muted);"><%= qcPct %>% Completed</div>
            </div>

            <!-- PlacementArena Stats -->
            <%
                TrackStats pa = trackStats != null ? trackStats.get("PlacementArena") : null;
                int paSolved = pa != null ? pa.getSolvedCount() : 0;
                int paTotal = pa != null ? pa.getTotalCount() : 0;
                int paPct = pa != null ? pa.getCompletionPercentage() : 0;
            %>
            <div class="track-card track-placement">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.75rem;">
                    <span class="badge badge-placement">PlacementArena</span>
                    <span style="font-size: 0.85rem; font-weight: 700; color: var(--text-secondary);"><%= paSolved %>/<%= paTotal %></span>
                </div>
                <h4 style="font-size: 1.15rem; font-weight: 800; margin-bottom: 0.75rem; color: #fff;">MNC Interview Simulator</h4>
                <div class="progress-container" style="height: 8px; margin-bottom: 0.6rem;">
                    <div class="progress-bar" style="width: <%= paPct %>%; background: var(--track-placement);"></div>
                </div>
                <div style="font-size: 0.82rem; color: var(--text-muted);"><%= paPct %>% Completed</div>
            </div>

        </div>

        <!-- Quick Launch CTA & Recent Attempts -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.25rem;">
            <h3 style="font-size: 1.35rem; font-weight: 800; letter-spacing: -0.4px;">Recent Combat Engagements</h3>
            <div style="display: flex; gap: 0.75rem;">
                <a href="challenges" class="btn btn-primary" style="padding: 0.55rem 1.2rem; font-size: 0.9rem;">Enter Combat Arena →</a>
                <a href="leaderboard" class="btn btn-secondary" style="padding: 0.55rem 1.1rem; font-size: 0.9rem;">Global Ranks</a>
            </div>
        </div>

        <div class="card" style="padding: 0; overflow: hidden;">
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Mission / Challenge</th>
                            <th>Discipline</th>
                            <th>Selected Option</th>
                            <th>Evaluation</th>
                            <th>DevXP Earned</th>
                            <th>Timestamp</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (recentActivities == null || recentActivities.isEmpty()) { %>
                            <tr>
                                <td colspan="7" style="text-align: center; color: var(--text-muted); padding: 3rem;">
                                    No missions attempted yet. Deploy into the combat arena to register submissions!
                                </td>
                            </tr>
                        <% } else { %>
                            <% for (Map<String, Object> act : recentActivities) { 
                                boolean correct = (Boolean) act.get("correct");
                                String cat = (String) act.get("category");
                                String catBadgeClass = "badge-algodrift";
                                if ("BugHunt".equalsIgnoreCase(cat)) catBadgeClass = "badge-bughunt";
                                else if ("QueryCraft".equalsIgnoreCase(cat)) catBadgeClass = "badge-querycraft";
                                else if ("PlacementArena".equalsIgnoreCase(cat)) catBadgeClass = "badge-placement";
                            %>
                                <tr>
                                    <td style="font-weight: 700; color: #fff;">
                                        <%= act.get("title") %>
                                    </td>
                                    <td>
                                        <span class="badge <%= catBadgeClass %>"><%= cat %></span>
                                    </td>
                                    <td>
                                        <code style="background: rgba(255,255,255,0.06); padding: 0.25rem 0.6rem; border-radius: var(--radius-sm); font-weight: 700;">
                                            Option <%= act.get("selectedOption") %>
                                        </code>
                                    </td>
                                    <td>
                                        <% if (correct) { %>
                                            <span style="color: var(--accent-emerald); font-weight: 700; display: inline-flex; align-items: center; gap: 0.35rem;">
                                                <span>✔</span> Passed
                                            </span>
                                        <% } else { %>
                                            <span style="color: var(--accent-rose); font-weight: 700; display: inline-flex; align-items: center; gap: 0.35rem;">
                                                <span>✕</span> Failed
                                            </span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <% if (correct) { %>
                                            <span class="badge badge-xp">+<%= act.get("xpEarned") %> XP</span>
                                        <% } else { %>
                                            <span style="color: var(--text-muted); font-size: 0.85rem;">0 XP</span>
                                        <% } %>
                                    </td>
                                    <td style="color: var(--text-secondary); font-size: 0.85rem;">
                                        <%= act.get("submittedAt") != null ? act.get("submittedAt").toString().substring(0, 16) : "N/A" %>
                                    </td>
                                    <td>
                                        <a href="challenge-detail?id=<%= act.get("challengeId") %>" class="btn btn-secondary" style="padding: 0.35rem 0.85rem; font-size: 0.82rem;">
                                            Review →
                                        </a>
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