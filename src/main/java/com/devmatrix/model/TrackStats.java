package com.devmatrix.model;

import java.io.Serializable;

/**
 * TrackStats Model for summarizing student achievements per combat domain.
 */
public class TrackStats implements Serializable {
    private static final long serialVersionUID = 1L;

    private String trackName; // BugHunt, AlgoDrift, QueryCraft, PlacementArena
    private int totalChallenges;
    private int solvedChallenges;
    private int xpEarned;

    public TrackStats() {
    }

    public TrackStats(String trackName, int totalChallenges, int solvedChallenges, int xpEarned) {
        this.trackName = trackName;
        this.totalChallenges = totalChallenges;
        this.solvedChallenges = solvedChallenges;
        this.xpEarned = xpEarned;
    }

    public String getTrackName() { return trackName; }
    public void setTrackName(String trackName) { this.trackName = trackName; }

    public int getTotalChallenges() { return totalChallenges; }
    public int getTotalCount() { return totalChallenges; }
    public void setTotalChallenges(int totalChallenges) { this.totalChallenges = totalChallenges; }

    public int getSolvedChallenges() { return solvedChallenges; }
    public int getSolvedCount() { return solvedChallenges; }
    public void setSolvedChallenges(int solvedChallenges) { this.solvedChallenges = solvedChallenges; }

    public int getXpEarned() { return xpEarned; }
    public void setXpEarned(int xpEarned) { this.xpEarned = xpEarned; }

    public int getCompletionPercentage() {
        if (totalChallenges == 0) return 0;
        return (int) Math.round(((double) solvedChallenges / totalChallenges) * 100);
    }
}
