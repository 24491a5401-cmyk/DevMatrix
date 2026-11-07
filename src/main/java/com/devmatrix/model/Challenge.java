package com.devmatrix.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Challenge Model representing multi-track combat missions.
 */
public class Challenge implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String title;
    private String category; // BugHunt, AlgoDrift, QueryCraft, PlacementArena
    private String companyTag; // General, TCS, Infosys, Amazon, etc.
    private String difficulty; // Easy, Medium, Hard
    private String description;
    private String codeSnippet;
    private String optionA;
    private String optionB;
    private String optionC;
    private String optionD;
    private String correctOption; // A, B, C, D (Redacted from student views)
    private int xpReward;
    private String explanation;
    private Timestamp createdAt;

    // Transient helper fields for student challenge state
    private boolean completed;
    private boolean solvedCorrectly;

    public Challenge() {
    }

    public Challenge(int id, String title, String category, String companyTag, String difficulty,
                     String description, String codeSnippet, String optionA, String optionB,
                     String optionC, String optionD, String correctOption, int xpReward,
                     String explanation, Timestamp createdAt) {
        this.id = id;
        this.title = title;
        this.category = category;
        this.companyTag = companyTag;
        this.difficulty = difficulty;
        this.description = description;
        this.codeSnippet = codeSnippet;
        this.optionA = optionA;
        this.optionB = optionB;
        this.optionC = optionC;
        this.optionD = optionD;
        this.correctOption = correctOption;
        this.xpReward = xpReward;
        this.explanation = explanation;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getCompanyTag() { return companyTag; }
    public void setCompanyTag(String companyTag) { this.companyTag = companyTag; }

    public String getDifficulty() { return difficulty; }
    public void setDifficulty(String difficulty) { this.difficulty = difficulty; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getCodeSnippet() { return codeSnippet; }
    public void setCodeSnippet(String codeSnippet) { this.codeSnippet = codeSnippet; }

    public String getOptionA() { return optionA; }
    public void setOptionA(String optionA) { this.optionA = optionA; }

    public String getOptionB() { return optionB; }
    public void setOptionB(String optionB) { this.optionB = optionB; }

    public String getOptionC() { return optionC; }
    public void setOptionC(String optionC) { this.optionC = optionC; }

    public String getOptionD() { return optionD; }
    public void setOptionD(String optionD) { this.optionD = optionD; }

    public String getCorrectOption() { return correctOption; }
    public void setCorrectOption(String correctOption) { this.correctOption = correctOption; }

    public int getXpReward() { return xpReward; }
    public void setXpReward(int xpReward) { this.xpReward = xpReward; }

    public String getExplanation() { return explanation; }
    public void setExplanation(String explanation) { this.explanation = explanation; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public boolean isCompleted() { return completed; }
    public void setCompleted(boolean completed) { this.completed = completed; }

    public boolean isAttempted() { return completed; }
    public void setAttempted(boolean attempted) { this.completed = attempted; }

    public boolean isSolvedCorrectly() { return solvedCorrectly; }
    public void setSolvedCorrectly(boolean solvedCorrectly) { this.solvedCorrectly = solvedCorrectly; }

    public boolean isUserCorrect() { return solvedCorrectly; }
    public void setUserCorrect(boolean userCorrect) { this.solvedCorrectly = userCorrect; }
}
