package com.devmatrix.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * User Model representing Student participants in DevMatrix.
 */
public class User implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String username;
    private String email;
    private String password;
    private int xp;
    private int level;
    private String levelTitle;
    private Timestamp createdAt;

    public User() {
    }

    public User(int id, String username, String email, String password, int xp, int level, String levelTitle, Timestamp createdAt) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.password = password;
        this.xp = xp;
        this.level = level;
        this.levelTitle = levelTitle;
        this.createdAt = createdAt;
    }

    /**
     * Compute current level from XP.
     */
    public static int calculateLevel(int xp) {
        if (xp >= 1200) return 5;
        if (xp >= 750) return 4;
        if (xp >= 400) return 3;
        if (xp >= 150) return 2;
        return 1;
    }

    /**
     * Compute 5-Tier Level Title based on DevXP balance.
     */
    public static String calculateLevelTitle(int xp) {
        if (xp >= 1200) return "Principal Architect";
        if (xp >= 750) return "Lead Engineer";
        if (xp >= 400) return "System Architect";
        if (xp >= 150) return "Syntax Hunter";
        return "Code Novice";
    }

    /**
     * Compute 5-Tier Level Title based on level.
     */
    public static String calculateTitle(int level) {
        switch (level) {
            case 5: return "Principal Architect";
            case 4: return "Lead Engineer";
            case 3: return "System Architect";
            case 2: return "Syntax Hunter";
            default: return "Code Novice";
        }
    }

    /**
     * XP threshold for the current level.
     */
    public static int getPreviousLevelThreshold(int level) {
        switch (level) {
            case 2: return 150;
            case 3: return 400;
            case 4: return 750;
            case 5: return 1200;
            default: return 0;
        }
    }

    /**
     * XP required to reach the next tier.
     */
    public static int getNextLevelThreshold(int level) {
        switch (level) {
            case 1: return 150;
            case 2: return 400;
            case 3: return 750;
            case 4: return 1200;
            default: return 1200;
        }
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public int getXp() { return xp; }
    public void setXp(int xp) { this.xp = xp; }

    public int getLevel() { return level; }
    public void setLevel(int level) { this.level = level; }

    public String getLevelTitle() { return levelTitle; }
    public void setLevelTitle(String levelTitle) { this.levelTitle = levelTitle; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
