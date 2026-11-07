<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.devmatrix.model.User, com.devmatrix.model.Challenge, com.devmatrix.model.Submission" %>
<%
    User user = (User) request.getAttribute("user");
    if (user == null) {
        user = (User) session.getAttribute("user");
    }
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Challenge challenge = (Challenge) request.getAttribute("challenge");
    if (challenge == null) {
        response.sendRedirect(request.getContextPath() + "/challenges");
        return;
    }

    Submission existingSubmission = (Submission) request.getAttribute("existingSubmission");
    Boolean isCorrect = (Boolean) request.getAttribute("isCorrect");
    Integer xpEarned = (Integer) request.getAttribute("xpEarned");
    String feedback = (String) request.getAttribute("feedback");

    boolean alreadySubmitted = (existingSubmission != null);
    boolean hasResult = (isCorrect != null);

    String cat = challenge.getCategory();
    String badgeClass = "badge-algodrift";
    if ("BugHunt".equalsIgnoreCase(cat)) badgeClass = "badge-bughunt";
    else if ("QueryCraft".equalsIgnoreCase(cat)) badgeClass = "badge-querycraft";
    else if ("PlacementArena".equalsIgnoreCase(cat)) badgeClass = "badge-placement";

    String diffClass = "badge-easy";
    if ("Medium".equalsIgnoreCase(challenge.getDifficulty())) diffClass = "badge-medium";
    else if ("Hard".equalsIgnoreCase(challenge.getDifficulty())) diffClass = "badge-hard";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= challenge.getTitle() %> — DevMatrix</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .option-label {
            display: flex;
            align-items: flex-start;
            gap: 1rem;
            padding: 1.15rem;
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-md);
            margin-bottom: 0.85rem;
            cursor: pointer;
            transition: all var(--transition-fast);
        }
        .option-label:hover {
            background: rgba(99, 102, 241, 0.06);
            border-color: rgba(99, 102, 241, 0.4);
            transform: translateY(-2px);
        }
        .option-label input[type="radio"] {
            margin-top: 0.25rem;
            accent-color: var(--brand-primary);
            transform: scale(1.15);
        }
        .option-text {
            color: #e2e8f0;
            font-size: 0.95rem;
            line-height: 1.5;
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

        <!-- Breadcrumb Navigation -->
        <div style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 1.5rem; font-size: 0.88rem; color: var(--text-secondary);">
            <a href="challenges" style="color: var(--text-muted); text-decoration: none;">Combat Arena</a>
            <span>/</span>
            <span style="color: var(--text-muted);"><%= challenge.getCategory() %></span>
            <span>/</span>
            <span style="color: #ffffff; font-weight: 700;">Mission #<%= challenge.getId() %></span>
        </div>

        <!-- Result / Feedback Flash Banner -->
        <% if (hasResult) { %>
            <% if (isCorrect) { %>
                <div class="alert alert-success" style="margin-bottom: 2rem; box-shadow: 0 4px 20px rgba(16,185,129,0.25);">
                    <span style="font-size: 1.5rem;">🎉</span>
                    <div>
                        <div style="font-size: 1.1rem; font-weight: 800; color: #fff;">Mission Accomplished!</div>
                        <div style="margin-top: 0.2rem;"><%= feedback %></div>
                        <div style="margin-top: 0.4rem; font-weight: 800; color: #a7f3d0;">+<%= xpEarned %> DevXP Awarded</div>
                    </div>
                </div>
            <% } else { %>
                <div class="alert alert-error" style="margin-bottom: 2rem; box-shadow: 0 4px 20px rgba(244,63,94,0.25);">
                    <span style="font-size: 1.5rem;">⚠️</span>
                    <div>
                        <div style="font-size: 1.1rem; font-weight: 800; color: #fff;">Evaluation Failed</div>
                        <div style="margin-top: 0.2rem;"><%= feedback %></div>
                        <div style="margin-top: 0.4rem; color: #fecdd3;">Review the technical explanation below to master this concept.</div>
                    </div>
                </div>
            <% } %>
        <% } else if (alreadySubmitted) { %>
            <div class="alert alert-info" style="margin-bottom: 2rem;">
                <span style="font-size: 1.3rem;">ℹ️</span>
                <div>
                    <strong>Attempt Finalized:</strong> You previously submitted Option <%= existingSubmission.getSelectedOption() %>. 
                    <%= existingSubmission.isCorrect() ? "Status: Passed (+ " + existingSubmission.getXpEarned() + " XP)" : "Status: Failed (0 XP)" %>. 
                    Single-attempt restriction is locked.
                </div>
            </div>
        <% } %>

        <!-- Two Column Mission Layout -->
        <div class="grid-2" style="gap: 2rem; align-items: start;">

            <!-- Left Column: Problem & Code Details -->
            <div>
                <div class="card" style="margin-bottom: 1.5rem;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.25rem;">
                        <span class="badge <%= badgeClass %>"><%= challenge.getCategory() %></span>
                        <div style="display: flex; gap: 0.5rem;">
                            <span class="badge <%= diffClass %>"><%= challenge.getDifficulty() %></span>
                            <span class="badge badge-xp">+<%= challenge.getXp() %> XP</span>
                        </div>
                    </div>

                    <h2 style="font-size: 1.65rem; font-weight: 800; color: #fff; margin-bottom: 1rem; line-height: 1.3;">
                        <%= challenge.getTitle() %>
                    </h2>

                    <div style="color: var(--text-secondary); font-size: 1rem; line-height: 1.6; margin-bottom: 1.5rem;">
                        <%= challenge.getDescription() %>
                    </div>

                    <% if (challenge.getCodeSnippet() != null && !challenge.getCodeSnippet().trim().isEmpty()) { %>
                        <div style="margin-bottom: 1.25rem;">
                            <div style="font-size: 0.78rem; font-weight: 800; color: var(--text-muted); letter-spacing: 0.5px; margin-bottom: 0.5rem;">
                                ARCHITECTURAL CODE ARTIFACT:
                            </div>
                            <pre style="background: rgba(0,0,0,0.45); border: 1px solid var(--border-subtle); border-radius: var(--radius-md); padding: 1.25rem; overflow-x: auto; font-family: var(--font-mono); font-size: 0.88rem; color: #a5f3fc; line-height: 1.5;"><code><%= challenge.getCodeSnippet() %></code></pre>
                        </div>
                    <% } %>
                </div>

                <!-- Technical Explanation Card (Shown if already submitted or after result) -->
                <% if (alreadySubmitted || hasResult) { %>
                    <div class="card" style="border-color: rgba(99, 102, 241, 0.4); background: linear-gradient(180deg, rgba(15,23,42,0.85) 0%, rgba(10,14,26,0.95) 100%);">
                        <h4 style="font-size: 1.15rem; font-weight: 800; color: var(--brand-primary); margin-bottom: 0.75rem; display: flex; align-items: center; gap: 0.5rem;">
                            <span>📖</span> Engineering Post-Mortem &amp; Explanation
                        </h4>
                        <div style="color: #cbd5e1; font-size: 0.92rem; line-height: 1.6;">
                            <%= challenge.getExplanation() != null ? challenge.getExplanation() : "No technical notes published for this mission." %>
                        </div>
                    </div>
                <% } %>
            </div>

            <!-- Right Column: Submission Console -->
            <div>
                <div class="card" style="box-shadow: 0 12px 40px -10px rgba(0,0,0,0.5); border-color: rgba(99, 102, 241, 0.3);">
                    <div class="card-header" style="border-bottom: 1px solid var(--border-subtle); padding-bottom: 1rem; margin-bottom: 1.25rem;">
                        <h3 class="card-title" style="font-size: 1.25rem;">Submit Solution</h3>
                        <span style="font-size: 0.8rem; color: var(--text-muted);">Single-Attempt Lockdown</span>
                    </div>

                    <% if (alreadySubmitted && !hasResult) { %>
                        <div style="padding: 1.5rem 0;">
                            <p style="color: var(--text-secondary); margin-bottom: 1.5rem;">
                                Your answer has already been recorded in the devmatrix transaction log.
                            </p>
                            <a href="challenges" class="btn btn-secondary btn-block">← Return to Combat Arena</a>
                        </div>
                    <% } else if (hasResult) { %>
                        <div style="padding: 1rem 0;">
                            <p style="color: var(--text-secondary); margin-bottom: 1.5rem;">
                                Mission evaluation completed. Continue to the next challenge or review leaderboard standings.
                            </p>
                            <div style="display: flex; flex-direction: column; gap: 0.75rem;">
                                <a href="challenges" class="btn btn-primary btn-block">Next Combat Mission →</a>
                                <a href="dashboard" class="btn btn-secondary btn-block">Command Center</a>
                            </div>
                        </div>
                    <% } else { %>
                        <form action="submit-answer" method="POST">
                            <input type="hidden" name="challengeId" value="<%= challenge.getId() %>">

                            <div style="margin-bottom: 1.5rem;">
                                <label class="option-label">
                                    <input type="radio" name="selectedOption" value="A" required>
                                    <div class="option-text"><strong>A:</strong> <%= challenge.getOptionA() %></div>
                                </label>

                                <label class="option-label">
                                    <input type="radio" name="selectedOption" value="B" required>
                                    <div class="option-text"><strong>B:</strong> <%= challenge.getOptionB() %></div>
                                </label>

                                <label class="option-label">
                                    <input type="radio" name="selectedOption" value="C" required>
                                    <div class="option-text"><strong>C:</strong> <%= challenge.getOptionC() %></div>
                                </label>

                                <label class="option-label">
                                    <input type="radio" name="selectedOption" value="D" required>
                                    <div class="option-text"><strong>D:</strong> <%= challenge.getOptionD() %></div>
                                </label>
                            </div>

                            <button type="submit" class="btn btn-primary btn-block" style="padding: 0.85rem; font-size: 1rem;">
                                Confirm &amp; Commit Solution →
                            </button>
                            <div style="font-size: 0.78rem; color: var(--text-muted); text-align: center; margin-top: 0.85rem;">
                                ⚠️ Submission is final and evaluated via ACID atomic transaction.
                            </div>
                        </form>
                    <% } %>
                </div>
            </div>

        </div>

    </main>

    <footer class="footer">
        <p>&copy; 2026 DevMatrix Engineering Arena &bull; Pure Jakarta EE 10 MVC Architecture</p>
    </footer>

</body>
</html>