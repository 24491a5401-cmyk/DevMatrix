package com.devmatrix.servlet;

import com.devmatrix.model.LeaderboardEntry;
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
import java.util.List;

/**
 * Renders the global competitive leaderboard with podium badges and tier rankings.
 * Meets Faculty Module 11 requirements.
 */
@WebServlet("/leaderboard")
public class LeaderboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        int currentUserId = -1;
        User u = null;
        if (session != null && session.getAttribute("user") != null) {
            u = (User) session.getAttribute("user");
            currentUserId = u.getId();
        }

        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<LeaderboardEntry> leaderboard = new ArrayList<>();

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT u.id, u.username, u.xp, u.level, u.level_title, " +
                         "COUNT(s.id) AS solved_count " +
                         "FROM users u " +
                         "LEFT JOIN submissions s ON u.id = s.user_id AND s.is_correct = TRUE " +
                         "GROUP BY u.id, u.username, u.xp, u.level, u.level_title " +
                         "ORDER BY u.xp DESC, u.id ASC";
            stmt = con.prepareStatement(sql);
            rs = stmt.executeQuery();

            int rank = 1;
            while (rs.next()) {
                LeaderboardEntry entry = new LeaderboardEntry(
                    rank++,
                    rs.getInt("id"),
                    rs.getString("username"),
                    rs.getInt("xp"),
                    rs.getInt("level"),
                    rs.getString("level_title"),
                    rs.getInt("solved_count")
                );
                leaderboard.add(entry);
            }

            if (u != null) {
                request.setAttribute("user", u);
            }
            request.setAttribute("leaderboard", leaderboard);
            request.setAttribute("currentUserId", currentUserId);

            request.getRequestDispatcher("/leaderboard.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error loading leaderboard: " + e.getMessage());
            request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
        } finally {
            DBConnection.closeQuietly(rs, stmt, con);
        }
    }
}
