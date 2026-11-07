package com.devmatrix.servlet;

import com.devmatrix.model.User;
import com.devmatrix.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Handles student registration with input validation and duplicate checking.
 * Meets Faculty Module 2 requirements.
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Trim strings
        if (username != null) username = username.trim();
        if (email != null) email = email.trim();

        // 1. Validation: Required fields
        if (username == null || username.isEmpty() ||
            email == null || email.isEmpty() ||
            password == null || password.isEmpty() ||
            confirmPassword == null || confirmPassword.isEmpty()) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // 2. Validation: Username length and format
        if (username.length() < 3 || username.length() > 30) {
            request.setAttribute("error", "Username must be between 3 and 30 characters.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // 3. Validation: Password match and strength
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters long.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        Connection con = null;
        PreparedStatement checkStmt = null;
        PreparedStatement insertStmt = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            // 4. Duplicate Check (Username or Email already exists)
            String checkSql = "SELECT id FROM users WHERE username = ? OR email = ?";
            checkStmt = con.prepareStatement(checkSql);
            checkStmt.setString(1, username);
            checkStmt.setString(2, email);
            rs = checkStmt.executeQuery();

            if (rs.next()) {
                request.setAttribute("error", "Username or email is already registered. Please choose another or login.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            // 5. Insert new student (initial 0 XP, Level 1: Code Novice)
            String insertSql = "INSERT INTO users (username, email, password, xp, level, level_title) VALUES (?, ?, ?, 0, 1, 'Code Novice')";
            insertStmt = con.prepareStatement(insertSql);
            insertStmt.setString(1, username);
            insertStmt.setString(2, email);
            insertStmt.setString(3, password);
            int rows = insertStmt.executeUpdate();

            if (rows > 0) {
                response.sendRedirect(request.getContextPath() + "/login.jsp?msg=registered");
            } else {
                request.setAttribute("error", "Registration could not be completed. Please try again.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error during registration: " + e.getMessage());
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        } finally {
            DBConnection.closeQuietly(rs, checkStmt, insertStmt, con);
        }
    }
}
