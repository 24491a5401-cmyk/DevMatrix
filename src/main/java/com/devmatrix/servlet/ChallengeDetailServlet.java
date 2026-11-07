package com.devmatrix.servlet;

import com.devmatrix.model.Challenge;
import com.devmatrix.model.Submission;
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

/**
 * Handles individual challenge view, question presentation, and submission state inspection.
 * Meets Faculty Module 6 & 9 requirements.
 */
@WebServlet("/challenge-detail")
public class ChallengeDetailServlet extends HttpServlet {
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
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/challenges");
            return;
        }

        int challengeId;
        try {
            challengeId = Integer.parseInt(idParam.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/challenges");
            return;
        }

        Connection con = null;
        PreparedStatement cStmt = null;
        PreparedStatement sStmt = null;
        ResultSet cRs = null;
        ResultSet sRs = null;

        try {
            con = DBConnection.getConnection();

            // 1. Fetch Challenge Details
            String cSql = "SELECT * FROM challenges WHERE id = ?";
            cStmt = con.prepareStatement(cSql);
            cStmt.setInt(1, challengeId);
            cRs = cStmt.executeQuery();

            if (!cRs.next()) {
                request.setAttribute("error", "Challenge mission not found.");
                request.getRequestDispatcher("/challenges").forward(request, response);
                return;
            }

            Challenge challenge = new Challenge();
            challenge.setId(cRs.getInt("id"));
            challenge.setTitle(cRs.getString("title"));
            challenge.setCategory(cRs.getString("category"));
            challenge.setCompanyTag(cRs.getString("company_tag"));
            challenge.setDifficulty(cRs.getString("difficulty"));
            challenge.setDescription(cRs.getString("description"));
            challenge.setCodeSnippet(cRs.getString("code_snippet"));
            challenge.setOptionA(cRs.getString("option_a"));
            challenge.setOptionB(cRs.getString("option_b"));
            challenge.setOptionC(cRs.getString("option_c"));
            challenge.setOptionD(cRs.getString("option_d"));
            challenge.setXpReward(cRs.getInt("xp_reward"));
            challenge.setCreatedAt(cRs.getTimestamp("created_at"));

            // 2. Check if user already submitted an answer for this challenge
            String sSql = "SELECT * FROM submissions WHERE user_id = ? AND challenge_id = ?";
            sStmt = con.prepareStatement(sSql);
            sStmt.setInt(1, user.getId());
            sStmt.setInt(2, challengeId);
            sRs = sStmt.executeQuery();

            Submission existingSub = null;
            if (sRs.next()) {
                existingSub = new Submission(
                    sRs.getInt("id"),
                    sRs.getInt("user_id"),
                    sRs.getInt("challenge_id"),
                    sRs.getString("selected_option"),
                    sRs.getBoolean("is_correct"),
                    sRs.getInt("xp_earned"),
                    sRs.getTimestamp("submitted_at")
                );
                // Reveal explanation and answer only because user has already attempted it
                challenge.setCorrectOption(cRs.getString("correct_option"));
                challenge.setExplanation(cRs.getString("explanation"));
                challenge.setCompleted(true);
                challenge.setSolvedCorrectly(existingSub.isCorrect());
            } else {
                // Keep answer hidden
                challenge.setCompleted(false);
            }

            request.setAttribute("user", user);
            request.setAttribute("challenge", challenge);
            request.setAttribute("submission", existingSub);

            request.getRequestDispatcher("/challenge-detail.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/challenges").forward(request, response);
        } finally {
            DBConnection.closeQuietly(cRs, sRs, cStmt, sStmt, con);
        }
    }
}
