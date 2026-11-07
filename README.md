# DevMatrix — Autonomous Adaptive Engineering Arena & Assessment Platform

DevMatrix is a next-generation engineering skill assessment platform engineered for computer science undergraduates and software engineering candidates. Built on an enterprise-grade **Jakarta EE 10 / Tomcat 10.1** stack adhering strictly to the **Pure Model-View-Controller (MVC)** architectural paradigm with zero third-party UI framework dependencies.

---

## 🏛️ Architectural Overview

- **Architecture**: 100% Pure MVC (Model-View-Controller)
  - **Model**: Enterprise JavaBeans (`User`, `Admin`, `Challenge`, `Submission`, `LeaderboardEntry`, `TrackStats`) with thread-safe Singleton `DBConnection` pooling.
  - **Controller**: 14 Jakarta Servlets managing authentication, RBAC authorization, telemetry aggregation, and atomic submission transactions.
  - **View**: Modern Obsidian Glassmorphism UI engineered purely with semantic HTML5, CSS3, and standard JSP Scriptlets (`<% ... %>`, `<%= ... %>`).
- **Server Runtime**: Apache Tomcat 10.1 (Jakarta Servlet 6.0 Specification)
- **Language & JDK**: Java 17 LTS
- **Database Engine**: MySQL 8.0 with InnoDB ACID transaction isolation
- **Driver**: MySQL Connector/J 9.2.0

---

## ⚡ Core Combat Tracks

DevMatrix organizes technical capability assessment into four distinct engineering disciplines:

| Track Discipline | Focus Area | Assessment Scope |
| :--- | :--- | :--- |
| **BugHunt** | Security & Logic Flaws | SQL Injection, XSS, Thread-Safety Race Conditions, Broken JWT Validation, Memory Leaks |
| **AlgoDrift** | Data Structures & Algorithms | Big-O Optimization, Graph Algorithms, Dynamic Programming, Two Pointers, Divide & Conquer |
| **QueryCraft** | Database Systems & SQL | ACID Isolation Anomalies, Indexing Optimization, CTEs, Window Functions, Sharding Logic |
| **PlacementArena** | Tier-1 Technical Interviews | Product Architecture, Concurrency Controls, System Reliability, Low-Level Design |

---

## 🛡️ Key Features

- **Multi-Track XP Radar Engine**: Dynamic multi-axis radar computing individual competency percentages across all 4 tracks in real time.
- **Atomic Verification Pipeline**: Submissions are evaluated inside thread-safe transactions updating XP, level brackets, and historical audit logs atomically.
- **Hall of Champions (Podium Leaderboard)**: Dynamic 3D obsidian podium highlighting top rankers with tie-breaker sorting on submission timestamps.
- **Faculty / Evaluator Telemetry Deck**: Secure administrative gateway offering real-time platform KPIs, category inventories, submission distributions, and CRUD challenge publishing controls.
- **Zero Framework Bloat**: No heavy JavaScript frameworks or CSS dependencies; built purely with native web primitives for microsecond latency.

---

## 🗄️ Database Schema & Entities

The relational model (`devmatrix_db`) consists of 4 normalized relational tables:
1. `users`: Cadet accounts with track specializations, cumulative DevXP, and rank tiers.
2. `admins`: Evaluator personnel with role-based access control (`Platform Director`, `Faculty Evaluator`).
3. `challenges`: Mission repository cataloging statements, constraints, code artifacts, test options, DevXP rewards, and solution post-mortems.
4. `submissions`: Immutable append-only audit trail logging every assessment attempt, selected keys, correctness flags, XP yields, and timestamps.

---

## 🚀 Eclipse IDE Deployment Guide

### Prerequisites
- Eclipse IDE for Enterprise Java and Web Developers (2024/2026 release)
- JDK 17 or higher
- Apache Tomcat 10.1
- MySQL Server 8.0

### Setup Steps
1. Clone the repository into your local Eclipse workspace:
   ```bash
   git clone https://github.com/24491a5401-cmyk/DevMatrix.git
   ```
2. Open Eclipse IDE and navigate to **File > Import > Existing Projects into Workspace**, select the `DevMatrix` folder, and click **Finish**.
3. Import the database schema:
   ```bash
   mysql -u root -p < schema.sql
   ```
4. Verify database credentials in `src/main/java/com/devmatrix/util/DBConnection.java`.
5. Right-click the `DevMatrix` project node in Project Explorer, select **Run As > Run on Server**, and choose **Tomcat v10.1 Server at localhost**.
6. Navigate to `http://localhost:8080/DevMatrix/` in your browser.

---

## 📄 License
Academic & Educational Project License &bull; Department of Artificial Intelligence & Data Science (AI&DS).
