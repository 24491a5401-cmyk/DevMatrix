package com.devmatrix.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Admin Model representing platform instructors/evaluators.
 */
public class Admin implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String username;
    private String email;
    private String password;
    private String fullName;
    private Timestamp createdAt;

    public Admin() {
    }

    public Admin(int id, String username, String email, String password, String fullName, Timestamp createdAt) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.password = password;
        this.fullName = fullName;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getRole() {
        if ("admin".equalsIgnoreCase(username)) {
            return "Platform Director";
        }
        return "Faculty Evaluator";
    }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
