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
 * Handles deletion of challenges by platform administrators.
 */
@WebServlet("/delete-challenge")
public class DeleteChallengeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/view-challenges");
            return;
        }

        int challengeId;
        try {
            challengeId = Integer.parseInt(idStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/view-challenges");
            return;
        }

        Connection con = null;
        PreparedStatement stmt = null;

        try {
            con = DBConnection.getConnection();
            String sql = "DELETE FROM challenges WHERE id = ?";
            stmt = con.prepareStatement(sql);
            stmt.setInt(1, challengeId);
            stmt.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/view-challenges?msg=deleted");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/view-challenges?error=" + e.getMessage());
        } finally {
            DBConnection.closeQuietly(stmt, con);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }
}
