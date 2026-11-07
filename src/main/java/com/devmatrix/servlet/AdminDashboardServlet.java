package com.devmatrix.servlet;

import com.devmatrix.model.Admin;
import com.devmatrix.util.DBConnection;

import jakarta.servlet.ServletContext;
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
 * Renders the Admin Operations Center with application-wide metrics and track distribution.
 * Meets Faculty Module 4 requirements.
 */
@WebServlet("/admin-dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
            return;
        }

        Admin admin = (Admin) session.getAttribute("admin");
        Connection con = null;
        PreparedStatement uStmt = null, cStmt = null, sStmt = null, recStmt = null;
        ResultSet uRs = null, cRs = null, sRs = null, recRs = null;

        int totalUsers = 0;
        int totalChallenges = 0;
        int totalSubmissions = 0;
        int correctSubmissions = 0;
        Map<String, Integer> trackCounts = new HashMap<>();
        List<Map<String, Object>> recentSubmissions = new ArrayList<>();

        try {
            con = DBConnection.getConnection();

            // 1. Total Users
            uStmt = con.prepareStatement("SELECT COUNT(*) FROM users");
            uRs = uStmt.executeQuery();
            if (uRs.next()) totalUsers = uRs.getInt(1);

            // 2. Total Challenges and per-track count
            cStmt = con.prepareStatement("SELECT category, COUNT(*) FROM challenges GROUP BY category");
            cRs = cStmt.executeQuery();
            while (cRs.next()) {
                String cat = cRs.getString(1);
                int cnt = cRs.getInt(2);
                trackCounts.put(cat, cnt);
                totalChallenges += cnt;
            }

            // Update ServletContext application attribute (Module 4)
            ServletContext context = getServletContext();
            context.setAttribute("platformTotalChallenges", totalChallenges);
            context.setAttribute("platformTotalStudents", totalUsers);

            // 3. Submissions and accuracy
            sStmt = con.prepareStatement("SELECT COUNT(*), SUM(CASE WHEN is_correct = TRUE THEN 1 ELSE 0 END) FROM submissions");
            sRs = sStmt.executeQuery();
            if (sRs.next()) {
                totalSubmissions = sRs.getInt(1);
                correctSubmissions = sRs.getInt(2);
            }

            // 4. Platform-wide recent submissions
            String recSql = "SELECT s.id, u.username, c.title, c.category, s.selected_option, s.is_correct, s.xp_earned, s.submitted_at " +
                            "FROM submissions s " +
                            "JOIN users u ON s.user_id = u.id " +
                            "JOIN challenges c ON s.challenge_id = c.id " +
                            "ORDER BY s.submitted_at DESC LIMIT 10";
            recStmt = con.prepareStatement(recSql);
            recRs = recStmt.executeQuery();
            while (recRs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("username", recRs.getString("username"));
                map.put("title", recRs.getString("title"));
                map.put("category", recRs.getString("category"));
                map.put("selectedOption", recRs.getString("selected_option"));
                map.put("correct", recRs.getBoolean("is_correct"));
                map.put("xpEarned", recRs.getInt("xp_earned"));
                map.put("submittedAt", recRs.getTimestamp("submitted_at"));
                recentSubmissions.add(map);
            }

            int accuracyRate = totalSubmissions > 0 ? (int) Math.round(((double) correctSubmissions / totalSubmissions) * 100) : 0;

            request.setAttribute("admin", admin);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalChallenges", totalChallenges);
            request.setAttribute("totalSubmissions", totalSubmissions);
            request.setAttribute("accuracyRate", accuracyRate);
            request.setAttribute("trackCounts", trackCounts);
            request.setAttribute("recentSubmissions", recentSubmissions);

            request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error loading admin dashboard: " + e.getMessage());
            request.getRequestDispatcher("/admin-login.jsp").forward(request, response);
        } finally {
            DBConnection.closeQuietly(uRs, cRs, sRs, recRs, uStmt, cStmt, sStmt, recStmt, con);
        }
    }
}
