package com.devmatrix.servlet;

import com.devmatrix.model.Admin;
import com.devmatrix.util.DBConnection;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
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
 * Handles instructor / admin authentication.
 * Demonstrates explicit usage of ServletConfig init-parameters and
 * ServletContext application-wide attributes as required by Faculty Module 4.
 */
public class AdminLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private String adminRoleTitle;
    private String adminContactEmail;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        // Module 4: ServletConfig retrieval of servlet-specific configuration
        this.adminRoleTitle = config.getInitParameter("adminRoleTitle");
        if (this.adminRoleTitle == null) {
            this.adminRoleTitle = "Platform Instructor & Lead Evaluator";
        }

        this.adminContactEmail = config.getInitParameter("adminContactEmail");
        if (this.adminContactEmail == null) {
            this.adminContactEmail = "admin@devmatrix.internal";
        }

        // Module 4: ServletContext application-wide state management
        ServletContext context = config.getServletContext();
        if (context.getAttribute("platformTotalVisits") == null) {
            context.setAttribute("platformTotalVisits", 1);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Pass ServletConfig parameters to view
        request.setAttribute("adminRoleTitle", this.adminRoleTitle);
        request.setAttribute("adminContactEmail", this.adminContactEmail);
        request.getRequestDispatcher("/admin-login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username != null) username = username.trim();

        if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("error", "Admin username and password are required.");
            request.setAttribute("adminRoleTitle", this.adminRoleTitle);
            request.setAttribute("adminContactEmail", this.adminContactEmail);
            request.getRequestDispatcher("/admin-login.jsp").forward(request, response);
            return;
        }

        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT id, username, email, password, full_name, created_at FROM admins WHERE username = ? AND password = ?";
            stmt = con.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);
            rs = stmt.executeQuery();

            if (rs.next()) {
                Admin admin = new Admin(
                    rs.getInt("id"),
                    rs.getString("username"),
                    rs.getString("email"),
                    rs.getString("password"),
                    rs.getString("full_name"),
                    rs.getTimestamp("created_at")
                );

                // Increment application-wide admin login counter in ServletContext
                ServletContext context = getServletContext();
                synchronized (context) {
                    Integer adminLogins = (Integer) context.getAttribute("totalAdminLogins");
                    if (adminLogins == null) adminLogins = 0;
                    context.setAttribute("totalAdminLogins", adminLogins + 1);
                }

                HttpSession session = request.getSession(true);
                session.setAttribute("admin", admin);

                response.sendRedirect(request.getContextPath() + "/admin-dashboard");
            } else {
                request.setAttribute("error", "Invalid admin credentials. Access Denied.");
                request.setAttribute("adminRoleTitle", this.adminRoleTitle);
                request.setAttribute("adminContactEmail", this.adminContactEmail);
                request.getRequestDispatcher("/admin-login.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.setAttribute("adminRoleTitle", this.adminRoleTitle);
            request.setAttribute("adminContactEmail", this.adminContactEmail);
            request.getRequestDispatcher("/admin-login.jsp").forward(request, response);
        } finally {
            DBConnection.closeQuietly(rs, stmt, con);
        }
    }
}
