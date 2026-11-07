package com.devmatrix.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Singleton Database Connection Manager for DevMatrix Arena.
 * Pure JDBC implementation ensuring thread-safe, centralized connection pooling.
 */
public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/devmatrix_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "swapna11";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("[DevMatrix DBConnection] MySQL Driver not found: " + e.getMessage());
        }
    }

    private DBConnection() {
        // Enforce Singleton: private constructor prevents instantiation
    }

    /**
     * Obtains a new active connection to devmatrix_db.
     * @return Connection instance
     * @throws SQLException on database connectivity failure
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    /**
     * Utility method to safely close JDBC resources without throwing checked exceptions.
     */
    public static void closeQuietly(AutoCloseable... closeables) {
        if (closeables == null) return;
        for (AutoCloseable c : closeables) {
            if (c != null) {
                try {
                    c.close();
                } catch (Exception ignored) {
                }
            }
        }
    }
}
