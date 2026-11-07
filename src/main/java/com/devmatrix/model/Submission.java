package com.devmatrix.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Submission Model recording user challenge answers and XP awards.
 */
public class Submission implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int userId;
    private int challengeId;
    private String selectedOption;
    private boolean correct;
    private int xpEarned;
    private Timestamp submittedAt;

    public Submission() {
    }

    public Submission(int id, int userId, int challengeId, String selectedOption, boolean correct, int xpEarned, Timestamp submittedAt) {
        this.id = id;
        this.userId = userId;
        this.challengeId = challengeId;
        this.selectedOption = selectedOption;
        this.correct = correct;
        this.xpEarned = xpEarned;
        this.submittedAt = submittedAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getChallengeId() { return challengeId; }
    public void setChallengeId(int challengeId) { this.challengeId = challengeId; }

    public String getSelectedOption() { return selectedOption; }
    public void setSelectedOption(String selectedOption) { this.selectedOption = selectedOption; }

    public boolean isCorrect() { return correct; }
    public void setCorrect(boolean correct) { this.correct = correct; }

    public int getXpEarned() { return xpEarned; }
    public void setXpEarned(int xpEarned) { this.xpEarned = xpEarned; }

    public Timestamp getSubmittedAt() { return submittedAt; }
    public void setSubmittedAt(Timestamp submittedAt) { this.submittedAt = submittedAt; }
}
