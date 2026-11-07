<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.devmatrix.model.Admin" %>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
        return;
    }

    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Author Combat Mission — DevMatrix Evaluator</title>
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
            <li><a href="view-challenges">Manage Challenges</a></li>
            <li><a href="add-challenge.jsp" class="active">Create Challenge</a></li>
            <li class="user-badge" style="border-color: rgba(244,63,94,0.3);">
                <span><%= admin.getFullName() %></span>
                <span class="badge badge-bughunt"><%= admin.getRole() %></span>
            </li>
            <li><a href="admin-logout" style="color: var(--accent-rose);">Sign Out</a></li>
        </ul>
    </nav>

    <main class="container" style="max-width: 900px;">

        <!-- Header -->
        <div style="margin-bottom: 2rem;">
            <div class="hero-tag" style="border-color: rgba(244,63,94,0.3); background: rgba(244,63,94,0.06); color: #fda4af;">
                <span style="display:inline-block; width:7px; height:7px; border-radius:50%; background:#f43f5e; box-shadow:0 0 8px #f43f5e;"></span>
                MISSION AUTHORING STUDIO
            </div>
            <h1 style="font-size: 2.25rem; font-weight: 800; letter-spacing: -0.8px; margin-top: 0.5rem;">
                Create &amp; Publish Challenge
            </h1>
            <p style="color: var(--text-secondary); font-size: 0.95rem; margin-top: 0.25rem;">
                Design a new assessment mission across any of the 4 engineering disciplines.
            </p>
        </div>

        <% if (error != null && !error.trim().isEmpty()) { %>
            <div class="alert alert-error" style="margin-bottom: 2rem;">
                <span>⚠️</span>
                <div><%= error %></div>
            </div>
        <% } %>

        <div class="card" style="box-shadow: 0 12px 40px -10px rgba(0,0,0,0.5); border-color: rgba(99, 102, 241, 0.3);">
            <form action="add-challenge" method="POST">
                
                <!-- Mission Title -->
                <div class="form-group">
                    <label class="form-label" for="title">Mission Title *</label>
                    <input type="text" id="title" name="title" class="form-control" placeholder="e.g. Broken JWT Bearer Token Signature Validation" required>
                </div>

                <!-- Arena Discipline & Difficulty & XP in 3 Columns -->
                <div class="grid-3" style="gap: 1.25rem;">
                    <div class="form-group">
                        <label class="form-label" for="category">Combat Arena Discipline *</label>
                        <select id="category" name="category" class="form-control" required style="background: rgba(255,255,255,0.03); color: #fff;">
                            <option value="BugHunt" style="background: #0f172a;">BugHunt (Security & Logic)</option>
                            <option value="AlgoDrift" style="background: #0f172a;">AlgoDrift (DSA & Big-O)</option>
                            <option value="QueryCraft" style="background: #0f172a;">QueryCraft (SQL & ACID)</option>
                            <option value="PlacementArena" style="background: #0f172a;">PlacementArena (MNC Coding)</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="difficulty">Difficulty Rating *</label>
                        <select id="difficulty" name="difficulty" class="form-control" required style="background: rgba(255,255,255,0.03); color: #fff;">
                            <option value="Easy" style="background: #0f172a;">Easy</option>
                            <option value="Medium" selected style="background: #0f172a;">Medium</option>
                            <option value="Hard" style="background: #0f172a;">Hard</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="xp">DevXP Reward (10 - 250) *</label>
                        <input type="number" id="xp" name="xp" class="form-control" min="10" max="250" value="50" required>
                    </div>
                </div>

                <!-- Problem Description -->
                <div class="form-group">
                    <label class="form-label" for="description">Problem Statement &amp; Requirements *</label>
                    <textarea id="description" name="description" class="form-control" rows="3" placeholder="Provide full context, constraints, and test scenarios..." required></textarea>
                </div>

                <!-- Code Snippet -->
                <div class="form-group">
                    <label class="form-label" for="codeSnippet">Code Snippet / Architectural Artifact (Optional)</label>
                    <textarea id="codeSnippet" name="codeSnippet" class="form-control" rows="5" style="font-family: var(--font-mono); font-size: 0.88rem;" placeholder="// Paste Java, SQL, or pseudocode snippet..."></textarea>
                </div>

                <!-- Four Options with Correct Radio Selector -->
                <div style="margin: 1.75rem 0; padding: 1.25rem; background: rgba(255,255,255,0.02); border-radius: var(--radius-md); border: 1px solid var(--border-subtle);">
                    <div style="font-weight: 800; font-size: 1rem; color: #fff; margin-bottom: 0.25rem;">
                        Assessment Options &amp; Correct Answer Key
                    </div>
                    <div style="font-size: 0.82rem; color: var(--text-secondary); margin-bottom: 1.25rem;">
                        Provide 4 distinct options and mark exactly one radio button as the correct key.
                    </div>

                    <div class="form-group" style="display: flex; align-items: center; gap: 1rem;">
                        <input type="radio" name="correctOption" value="A" checked style="accent-color: var(--accent-emerald); transform: scale(1.3); cursor: pointer;" title="Select Option A as correct">
                        <input type="text" name="optionA" class="form-control" placeholder="Option A text..." required>
                    </div>

                    <div class="form-group" style="display: flex; align-items: center; gap: 1rem;">
                        <input type="radio" name="correctOption" value="B" style="accent-color: var(--accent-emerald); transform: scale(1.3); cursor: pointer;" title="Select Option B as correct">
                        <input type="text" name="optionB" class="form-control" placeholder="Option B text..." required>
                    </div>

                    <div class="form-group" style="display: flex; align-items: center; gap: 1rem;">
                        <input type="radio" name="correctOption" value="C" style="accent-color: var(--accent-emerald); transform: scale(1.3); cursor: pointer;" title="Select Option C as correct">
                        <input type="text" name="optionC" class="form-control" placeholder="Option C text..." required>
                    </div>

                    <div class="form-group" style="display: flex; align-items: center; gap: 1rem;">
                        <input type="radio" name="correctOption" value="D" style="accent-color: var(--accent-emerald); transform: scale(1.3); cursor: pointer;" title="Select Option D as correct">
                        <input type="text" name="optionD" class="form-control" placeholder="Option D text..." required>
                    </div>
                </div>

                <!-- Technical Explanation -->
                <div class="form-group">
                    <label class="form-label" for="explanation">Engineering Explanation / Solution Post-Mortem</label>
                    <textarea id="explanation" name="explanation" class="form-control" rows="3" placeholder="Explain the root cause and why the selected answer is correct (shown to cadets after submission)..."></textarea>
                </div>

                <div style="display: flex; justify-content: flex-end; gap: 1rem; margin-top: 2rem;">
                    <a href="view-challenges" class="btn btn-secondary">Cancel</a>
                    <button type="submit" class="btn btn-primary" style="padding: 0.75rem 2rem; font-size: 1rem;">
                        Publish Mission to Live Arena →
                    </button>
                </div>

            </form>
        </div>

    </main>

    <footer class="footer">
        <p>&copy; 2026 DevMatrix Engineering Arena &bull; Pure Jakarta EE 10 MVC Architecture</p>
    </footer>

</body>
</html>