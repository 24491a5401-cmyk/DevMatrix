package com.devmatrix.model;

import java.io.Serializable;

/**
 * LeaderboardEntry Model for global and track-specific rankings.
 */
public class LeaderboardEntry implements Serializable {
    private static final long serialVersionUID = 1L;

    private int rank;
    private int userId;
    private String username;
    private int xp;
    private int level;
    private String levelTitle;
    private int completedCount;

    public LeaderboardEntry() {
    }

    public LeaderboardEntry(int rank, int userId, String username, int xp, int level, String levelTitle, int completedCount) {
        this.rank = rank;
        this.userId = userId;
        this.username = username;
        this.xp = xp;
        this.level = level;
        this.levelTitle = levelTitle;
        this.completedCount = completedCount;
    }

    public int getRank() { return rank; }
    public void setRank(int rank) { this.rank = rank; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public int getXp() { return xp; }
    public void setXp(int xp) { this.xp = xp; }

    public int getLevel() { return level; }
    public void setLevel(int level) { this.level = level; }

    public String getLevelTitle() { return levelTitle; }
    public void setLevelTitle(String levelTitle) { this.levelTitle = levelTitle; }

    public int getCompletedCount() { return completedCount; }
    public int getSolvedCount() { return completedCount; }
    public void setCompletedCount(int completedCount) { this.completedCount = completedCount; }
    public void setSolvedCount(int count) { this.completedCount = count; }
}
