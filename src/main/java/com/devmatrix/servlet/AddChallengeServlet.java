package com.devmatrix.servlet;

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
import java.sql.SQLException;

/**
 * Handles instructor challenge authoring and catalog additions.
 * Meets Faculty Module 6 & 7 requirements.
 */
@WebServlet("/add-challenge")
public class AddChallengeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
            return;
        }
        request.getRequestDispatcher("/add-challenge.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
            return;
        }

        String title = request.getParameter("title");
        String category = request.getParameter("category");
        String companyTag = request.getParameter("companyTag");
        String difficulty = request.getParameter("difficulty");
        String description = request.getParameter("description");
        String codeSnippet = request.getParameter("codeSnippet");
        String optionA = request.getParameter("optionA");
        String optionB = request.getParameter("optionB");
        String optionC = request.getParameter("optionC");
        String optionD = request.getParameter("optionD");
        String correctOption = request.getParameter("correctOption");
        String xpRewardStr = request.getParameter("xpReward");
        String explanation = request.getParameter("explanation");

        // Validation
        if (title == null || title.trim().isEmpty() ||
            category == null || category.trim().isEmpty() ||
            difficulty == null || difficulty.trim().isEmpty() ||
            description == null || description.trim().isEmpty() ||
            optionA == null || optionA.trim().isEmpty() ||
            optionB == null || optionB.trim().isEmpty() ||
            optionC == null || optionC.trim().isEmpty() ||
            optionD == null || optionD.trim().isEmpty() ||
            correctOption == null || correctOption.trim().isEmpty() ||
            xpRewardStr == null || xpRewardStr.trim().isEmpty()) {

            request.setAttribute("error", "Please fill in all mandatory fields.");
            request.getRequestDispatcher("/add-challenge.jsp").forward(request, response);
            return;
        }

        int xpReward = 50;
        try {
            xpReward = Integer.parseInt(xpRewardStr.trim());
        } catch (NumberFormatException e) {
            request.setAttribute("error", "XP Reward must be a valid integer.");
            request.getRequestDispatcher("/add-challenge.jsp").forward(request, response);
            return;
        }

        if (companyTag == null || companyTag.trim().isEmpty()) {
            companyTag = "General";
        }

        Connection con = null;
        PreparedStatement stmt = null;

        try {
            con = DBConnection.getConnection();
            String sql = "INSERT INTO challenges (title, category, company_tag, difficulty, description, " +
                         "code_snippet, option_a, option_b, option_c, option_d, correct_option, xp_reward, explanation) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            stmt = con.prepareStatement(sql);
            stmt.setString(1, title.trim());
            stmt.setString(2, category.trim());
            stmt.setString(3, companyTag.trim());
            stmt.setString(4, difficulty.trim());
            stmt.setString(5, description.trim());
            stmt.setString(6, codeSnippet != null ? codeSnippet.trim() : "");
            stmt.setString(7, optionA.trim());
            stmt.setString(8, optionB.trim());
            stmt.setString(9, optionC.trim());
            stmt.setString(10, optionD.trim());
            stmt.setString(11, correctOption.trim().toUpperCase());
            stmt.setInt(12, xpReward);
            stmt.setString(13, explanation != null ? explanation.trim() : "");

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                response.sendRedirect(request.getContextPath() + "/view-challenges?msg=created");
            } else {
                request.setAttribute("error", "Failed to add challenge to database.");
                request.getRequestDispatcher("/add-challenge.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/add-challenge.jsp").forward(request, response);
        } finally {
            DBConnection.closeQuietly(stmt, con);
        }
    }
}
