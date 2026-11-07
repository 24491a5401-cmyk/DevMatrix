package com.devmatrix.servlet;

import com.devmatrix.model.User;
import com.devmatrix.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
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
 * Handles student authentication, session establishment, and Remember-Me cookies.
 * Meets Faculty Module 3 requirements.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String identifier = request.getParameter("identifier");
        if (identifier == null || identifier.trim().isEmpty()) {
            identifier = request.getParameter("usernameOrEmail");
        }
        if (identifier == null || identifier.trim().isEmpty()) {
            identifier = request.getParameter("username");
        }
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");
        if (rememberMe == null) {
            rememberMe = request.getParameter("remember");
        }

        if (identifier != null) identifier = identifier.trim();

        if (identifier == null || identifier.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("error", "Username/Email and Password are required.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT id, username, email, password, xp, level, level_title, created_at " +
                         "FROM users WHERE (username = ? OR email = ?) AND password = ?";
            stmt = con.prepareStatement(sql);
            stmt.setString(1, identifier);
            stmt.setString(2, identifier);
            stmt.setString(3, password);
            rs = stmt.executeQuery();

            if (rs.next()) {
                User user = new User(
                    rs.getInt("id"),
                    rs.getString("username"),
                    rs.getString("email"),
                    rs.getString("password"),
                    rs.getInt("xp"),
                    rs.getInt("level"),
                    rs.getString("level_title"),
                    rs.getTimestamp("created_at")
                );

                // Create / retrieve HttpSession
                HttpSession session = request.getSession(true);
                session.setAttribute("user", user);

                // Manage Remember-Me Cookie (Demonstrating Cookie API)
                if ("on".equalsIgnoreCase(rememberMe) || "true".equalsIgnoreCase(rememberMe)) {
                    Cookie rememberCookie = new Cookie("devmatrix_user", user.getUsername());
                    rememberCookie.setMaxAge(7 * 24 * 60 * 60); // 7 days lifespan
                    rememberCookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
                    response.addCookie(rememberCookie);
                } else {
                    // Expire existing cookie
                    Cookie rememberCookie = new Cookie("devmatrix_user", "");
                    rememberCookie.setMaxAge(0);
                    rememberCookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
                    response.addCookie(rememberCookie);
                }

                // Redirect to Student Dashboard
                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else {
                request.setAttribute("error", "Invalid credentials. Please verify your username/password.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error during authentication: " + e.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } finally {
            DBConnection.closeQuietly(rs, stmt, con);
        }
    }
}
