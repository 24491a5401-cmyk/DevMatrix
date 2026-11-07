package com.devmatrix.servlet;

import com.devmatrix.model.Challenge;
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
import java.util.List;

/**
 * Lists all challenges for administrative inspection and management.
 * Meets Faculty Module 6 & 7 requirements.
 */
@WebServlet("/view-challenges")
public class ViewChallengesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
            return;
        }

        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Challenge> challenges = new ArrayList<>();

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM challenges ORDER BY id DESC";
            stmt = con.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Challenge c = new Challenge(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("category"),
                    rs.getString("company_tag"),
                    rs.getString("difficulty"),
                    rs.getString("description"),
                    rs.getString("code_snippet"),
                    rs.getString("option_a"),
                    rs.getString("option_b"),
                    rs.getString("option_c"),
                    rs.getString("option_d"),
                    rs.getString("correct_option"),
                    rs.getInt("xp_reward"),
                    rs.getString("explanation"),
                    rs.getTimestamp("created_at")
                );
                challenges.add(c);
            }

            request.setAttribute("challenges", challenges);
            request.getRequestDispatcher("/view-challenges.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);
        } finally {
            DBConnection.closeQuietly(rs, stmt, con);
        }
    }
}
