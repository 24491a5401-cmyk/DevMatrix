package com.devmatrix.servlet;

import com.devmatrix.model.TrackStats;
import com.devmatrix.model.User;
import com.devmatrix.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Prepares and renders the Student Command Dashboard with XP metrics,
 * track completion rates, and next-tier progression.
 * Meets Faculty Module 8 requirements.
 */
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User sessionUser = (User) session.getAttribute("user");
        Connection con = null;
        PreparedStatement uStmt = null;
        PreparedStatement tStmt = null;
        PreparedStatement sStmt = null;
        ResultSet uRs = null;
        ResultSet tRs = null;
        ResultSet sRs = null;

        try {
            con = DBConnection.getConnection();

            // 1. Fetch refreshed User status
            String userSql = "SELECT id, username, email, xp, level, level_title, created_at FROM users WHERE id = ?";
            uStmt = con.prepareStatement(userSql);
            uStmt.setInt(1, sessionUser.getId());
            uRs = uStmt.executeQuery();

            User user = sessionUser;
            if (uRs.next()) {
                user = new User(
                    uRs.getInt("id"),
                    uRs.getString("username"),
                    uRs.getString("email"),
                    "",
                    uRs.getInt("xp"),
                    uRs.getInt("level"),
                    uRs.getString("level_title"),
                    uRs.getTimestamp("created_at")
                );
                // Update session object
                session.setAttribute("user", user);
            }

            // 2. Fetch track statistics (BugHunt, AlgoDrift, QueryCraft, PlacementArena)
            String[] tracks = {"BugHunt", "AlgoDrift", "QueryCraft", "PlacementArena"};
            List<TrackStats> trackStatsList = new ArrayList<>();
            int totalPlatformChallenges = 0;
            int totalSolvedChallenges = 0;

            for (String track : tracks) {
                // Total challenges in track
                String catSql = "SELECT COUNT(*) FROM challenges WHERE category = ?";
                PreparedStatement catStmt = con.prepareStatement(catSql);
                catStmt.setString(1, track);
                ResultSet catRs = catStmt.executeQuery();
                int trackTotal = 0;
                if (catRs.next()) {
                    trackTotal = catRs.getInt(1);
                }
                catRs.close();
                catStmt.close();

                // Solved by user in this track
                String solvedSql = "SELECT COUNT(*), COALESCE(SUM(s.xp_earned), 0) " +
                                  "FROM submissions s " +
                                  "JOIN challenges c ON s.challenge_id = c.id " +
                                  "WHERE s.user_id = ? AND c.category = ? AND s.is_correct = TRUE";
                PreparedStatement solStmt = con.prepareStatement(solvedSql);
                solStmt.setInt(1, user.getId());
                solStmt.setString(2, track);
                ResultSet solRs = solStmt.executeQuery();
                int trackSolved = 0;
                int trackXp = 0;
                if (solRs.next()) {
                    trackSolved = solRs.getInt(1);
                    trackXp = solRs.getInt(2);
                }
                solRs.close();
                solStmt.close();

                totalPlatformChallenges += trackTotal;
                totalSolvedChallenges += trackSolved;

                trackStatsList.add(new TrackStats(track, trackTotal, trackSolved, trackXp));
            }

            // 3. Compute Progress Bar Percentage to Next Level
            int currentXp = user.getXp();
            int currentLevel = user.getLevel();
            int progressPercent = 0;
            int nextLevelThreshold = User.getNextLevelThreshold(currentLevel);

            if (currentLevel >= 5) {
                progressPercent = 100;
            } else if (currentLevel == 1) {
                progressPercent = Math.min(100, (int) Math.round(((double) currentXp / 150.0) * 100));
            } else if (currentLevel == 2) {
                progressPercent = Math.min(100, (int) Math.round(((double) (currentXp - 150) / (400.0 - 150.0)) * 100));
            } else if (currentLevel == 3) {
                progressPercent = Math.min(100, (int) Math.round(((double) (currentXp - 400) / (750.0 - 400.0)) * 100));
            } else if (currentLevel == 4) {
                progressPercent = Math.min(100, (int) Math.round(((double) (currentXp - 750) / (1200.0 - 750.0)) * 100));
            }

            // 4. Fetch recent submission activity for this user
            String recSql = "SELECT s.id, c.title, c.category, c.difficulty, s.selected_option, s.is_correct, s.xp_earned, s.submitted_at " +
                            "FROM submissions s " +
                            "JOIN challenges c ON s.challenge_id = c.id " +
                            "WHERE s.user_id = ? " +
                            "ORDER BY s.submitted_at DESC LIMIT 5";
            sStmt = con.prepareStatement(recSql);
            sStmt.setInt(1, user.getId());
            sRs = sStmt.executeQuery();

            List<Map<String, Object>> recentList = new ArrayList<>();
            while (sRs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("title", sRs.getString("title"));
                map.put("category", sRs.getString("category"));
                map.put("difficulty", sRs.getString("difficulty"));
                map.put("selectedOption", sRs.getString("selected_option"));
                map.put("correct", sRs.getBoolean("is_correct"));
                map.put("xpEarned", sRs.getInt("xp_earned"));
                map.put("submittedAt", sRs.getTimestamp("submitted_at"));
                recentList.add(map);
            }

            // Pass attributes to JSP
            request.setAttribute("user", user);
            request.setAttribute("trackStatsList", trackStatsList);
            request.setAttribute("totalPlatformChallenges", totalPlatformChallenges);
            request.setAttribute("totalSolvedChallenges", totalSolvedChallenges);
            request.setAttribute("progressPercent", progressPercent);
            request.setAttribute("nextLevelThreshold", nextLevelThreshold);
            request.setAttribute("recentList", recentList);

            request.getRequestDispatcher("/dashboard.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } finally {
            DBConnection.closeQuietly(uRs, tRs, sRs, uStmt, tStmt, sStmt, con);
        }
    }
}
