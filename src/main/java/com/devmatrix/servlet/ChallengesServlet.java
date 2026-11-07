package com.devmatrix.servlet;

import com.devmatrix.model.Challenge;
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
 * Renders the multi-track challenges catalog with track and difficulty filtering.
 * Securely hides correct answer keys from client views.
 * Meets Faculty Module 9 requirements.
 */
@WebServlet("/challenges")
public class ChallengesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String track = request.getParameter("track");
        String difficulty = request.getParameter("difficulty");

        Connection con = null;
        PreparedStatement stmt = null;
        PreparedStatement subStmt = null;
        ResultSet rs = null;
        ResultSet subRs = null;

        try {
            con = DBConnection.getConnection();

            // 1. Fetch user's existing submissions to track completed states
            Map<Integer, Boolean> userSubmissions = new HashMap<>();
            String subSql = "SELECT challenge_id, is_correct FROM submissions WHERE user_id = ?";
            subStmt = con.prepareStatement(subSql);
            subStmt.setInt(1, user.getId());
            subRs = subStmt.executeQuery();
            while (subRs.next()) {
                userSubmissions.put(subRs.getInt("challenge_id"), subRs.getBoolean("is_correct"));
            }

            // 2. Build filtered challenge query
            StringBuilder sql = new StringBuilder(
                "SELECT id, title, category, company_tag, difficulty, description, code_snippet, " +
                "option_a, option_b, option_c, option_d, xp_reward, created_at " +
                "FROM challenges WHERE 1=1 "
            );
            List<Object> params = new ArrayList<>();

            if (track != null && !track.trim().isEmpty() && !"All".equalsIgnoreCase(track)) {
                sql.append("AND category = ? ");
                params.add(track.trim());
            }

            if (difficulty != null && !difficulty.trim().isEmpty() && !"All".equalsIgnoreCase(difficulty)) {
                sql.append("AND difficulty = ? ");
                params.add(difficulty.trim());
            }

            sql.append("ORDER BY id ASC");

            stmt = con.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            rs = stmt.executeQuery();
            List<Challenge> challenges = new ArrayList<>();

            while (rs.next()) {
                Challenge c = new Challenge();
                c.setId(rs.getInt("id"));
                c.setTitle(rs.getString("title"));
                c.setCategory(rs.getString("category"));
                c.setCompanyTag(rs.getString("company_tag"));
                c.setDifficulty(rs.getString("difficulty"));
                c.setDescription(rs.getString("description"));
                c.setCodeSnippet(rs.getString("code_snippet"));
                c.setOptionA(rs.getString("option_a"));
                c.setOptionB(rs.getString("option_b"));
                c.setOptionC(rs.getString("option_c"));
                c.setOptionD(rs.getString("option_d"));
                c.setXpReward(rs.getInt("xp_reward"));
                c.setCreatedAt(rs.getTimestamp("created_at"));

                // NOTE: correctOption and explanation are intentionally left NULL here
                // to completely eliminate client-side answer sniffing in catalog view.

                if (userSubmissions.containsKey(c.getId())) {
                    c.setCompleted(true);
                    c.setSolvedCorrectly(userSubmissions.get(c.getId()));
                } else {
                    c.setCompleted(false);
                }

                challenges.add(c);
            }

            request.setAttribute("user", user);
            request.setAttribute("challenges", challenges);
            request.setAttribute("selectedTrack", (track != null && !track.isEmpty()) ? track : "All");
            request.setAttribute("selectedDifficulty", (difficulty != null && !difficulty.isEmpty()) ? difficulty : "All");

            request.getRequestDispatcher("/challenges.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error loading challenges: " + e.getMessage());
            request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
        } finally {
            DBConnection.closeQuietly(rs, subRs, stmt, subStmt, con);
        }
    }
}
