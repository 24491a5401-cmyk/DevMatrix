-- DevMatrix Database Setup Script
-- Compatible with MySQL 8.0+

CREATE DATABASE IF NOT EXISTS devmatrix_db;
USE devmatrix_db;

-- 1. Student Users Table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    xp INT DEFAULT 0,
    level INT DEFAULT 1,
    level_title VARCHAR(50) DEFAULT 'Code Novice',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Administrators Table
CREATE TABLE IF NOT EXISTS admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Unified Arena Challenges Repository
CREATE TABLE IF NOT EXISTS challenges (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    category VARCHAR(50) NOT NULL, -- BugHunt, AlgoDrift, QueryCraft, PlacementArena
    company_tag VARCHAR(50) DEFAULT 'General', -- TCS, Infosys, Amazon, Google, General
    difficulty VARCHAR(20) NOT NULL, -- Easy, Medium, Hard
    description TEXT NOT NULL,
    code_snippet TEXT,
    option_a TEXT NOT NULL,
    option_b TEXT NOT NULL,
    option_c TEXT NOT NULL,
    option_d TEXT NOT NULL,
    correct_option CHAR(1) NOT NULL, -- A, B, C, D
    xp_reward INT DEFAULT 50,
    explanation TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Challenge Submissions & Attempt Log (Enforcing One Attempt Rule)
CREATE TABLE IF NOT EXISTS submissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    challenge_id INT NOT NULL,
    selected_option CHAR(1) NOT NULL,
    is_correct BOOLEAN NOT NULL,
    xp_earned INT DEFAULT 0,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (challenge_id) REFERENCES challenges(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_challenge (user_id, challenge_id)
);

-- ========================================================
-- SEED DATA: Administrator Accounts (Faculty Evaluators)
-- ========================================================
INSERT INTO admins (username, email, password, full_name)
VALUES 
('admin', 'admin@devmatrix.local', 'admin123', 'Prof. Sunitha Rao'),
('evaluator_admin', 'faculty@devmatrix.local', 'MatrixRoot@2026', 'Dr. Ananya Sharma')
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), password = VALUES(password);

-- ========================================================
-- SEED DATA: Student Accounts for Live Leaderboard
-- ========================================================
INSERT INTO users (username, email, password, xp, level, level_title)
VALUES 
('ananya', 'ananya@devmatrix.local', 'Ananya123@', 950, 4, 'Lead Engineer'),
('sravani', 'sravani@devmatrix.local', 'Sravani123@', 650, 3, 'System Architect'),
('kavya', 'kavya@devmatrix.local', 'Kavya123@', 350, 2, 'Syntax Hunter'),
('meghana', 'meghana@devmatrix.local', 'Meghana123@', 150, 2, 'Syntax Hunter'),
('deepika', 'deepika@devmatrix.local', 'Deepika123@', 0, 1, 'Code Novice')
ON DUPLICATE KEY UPDATE xp = VALUES(xp), level = VALUES(level), level_title = VALUES(level_title);

-- ========================================================
-- SEED DATA: 16 Multi-Track Challenges
-- ========================================================

-- Track 1: BugHunt (Debugging & Security Arena)
INSERT INTO challenges (title, category, company_tag, difficulty, description, code_snippet, option_a, option_b, option_c, option_d, correct_option, xp_reward, explanation)
VALUES
(
    'Null Pointer Trap in Java Equality',
    'BugHunt',
    'General',
    'Easy',
    'Identify why the following snippet throws a NullPointerException when input string s is null, and choose the correct defensive fix.',
    'public boolean isStatusActive(String s) {\n    return s.equals("ACTIVE");\n}',
    'Change return to: "ACTIVE".equals(s);',
    'Change return to: s == "ACTIVE";',
    'Change return to: s.equalsIgnoreCase(null);',
    'Wrap in while (s != null) { ... }',
    'A',
    50,
    'Invoking .equals() on a null reference triggers java.lang.NullPointerException. Using "ACTIVE".equals(s) leverages string literal safety which safely returns false when s is null.'
),
(
    'SQL Injection in Authentication Query',
    'BugHunt',
    'General',
    'Medium',
    'The login authentication code below allows attackers to bypass credentials using "admin'' --". What is the critical vulnerability fix?',
    'String sql = "SELECT * FROM users WHERE user = ''" + user + "'' AND pass = ''" + pass + "''";\nStatement stmt = conn.createStatement();\nResultSet rs = stmt.executeQuery(sql);',
    'Add an MD5 hash check on user input before concatenation',
    'Use PreparedStatement with parameterized place-holders (?): SELECT * FROM users WHERE user = ? AND pass = ?',
    'Replace executeQuery with executeUpdate',
    'Filter out whitespace characters from user and pass strings',
    'B',
    75,
    'Direct string concatenation in SQL queries creates SQL Injection vulnerabilities. Parameterized PreparedStatement ensures user inputs are treated strictly as data literals rather than executable SQL commands.'
),
(
    'C++ Dynamic Memory Leak Trap',
    'BugHunt',
    'General',
    'Medium',
    'The following C++ buffer allocation function causes a persistent heap memory leak. Identify the correct fix.',
    'void processData(int size) {\n    int* buffer = new int[size];\n    if (size <= 0) return;\n    // perform processing...\n    delete buffer;\n}',
    'Change delete buffer to delete[] buffer, and release memory before the early return',
    'Replace new int[size] with malloc(size)',
    'Change int* buffer to static int buffer[size]',
    'Do not delete buffer; OS garbage collector cleans it automatically',
    'A',
    80,
    'Arrays allocated with new[] must be deallocated using delete[]. Furthermore, returning early when size <= 0 leaks memory because delete is skipped.'
),
(
    'Python Mutable Default Argument Pitfall',
    'BugHunt',
    'General',
    'Hard',
    'Calling append_item(10) followed by append_item(20) returns [10, 20] instead of [20]. Why does this occur and how is it resolved?',
    'def append_item(item, target_list=[]):\n    target_list.append(item)\n    return target_list',
    'Default arguments are evaluated once at function definition time; use target_list=None and initialize inside with target_list = [] if target_list is None',
    'Change target_list.append(item) to target_list += [item]',
    'Define target_list as global target_list inside the function',
    'Pass item as a tuple instead of an integer',
    'A',
    100,
    'In Python, default arguments are evaluated only once when the function is defined. A mutable default like a list is shared across all function calls that do not provide an explicit argument.'
),

-- Track 2: AlgoDrift (DSA & Complexity Arena)
(
    'Recursive Binary Search Space Complexity',
    'AlgoDrift',
    'General',
    'Easy',
    'What is the worst-case auxiliary space complexity of Recursive Binary Search on a sorted array of N elements?',
    'int binarySearch(int[] arr, int low, int high, int key) {\n    if (low > high) return -1;\n    int mid = low + (high - low) / 2;\n    if (arr[mid] == key) return mid;\n    if (arr[mid] > key) return binarySearch(arr, low, mid - 1, key);\n    return binarySearch(arr, mid + 1, high, key);\n}',
    'O(1) auxiliary space',
    'O(log N) auxiliary space due to the call stack depth',
    'O(N) auxiliary space',
    'O(N log N) auxiliary space',
    'B',
    50,
    'With each recursive call, the search space halves. Thus the maximum recursion stack depth is log2(N), consuming O(log N) auxiliary call stack space.'
),
(
    'Optimizing Two Sum: Nested Loops vs Hash Map',
    'AlgoDrift',
    'General',
    'Medium',
    'Given an unsorted array of N elements, what is the most efficient Time and Space complexity to find two indices whose values sum to a Target?',
    '// Goal: Find indices i, j such that nums[i] + nums[j] == target in single pass',
    'Time: O(N^2), Space: O(1)',
    'Time: O(N log N), Space: O(1)',
    'Time: O(N), Space: O(N) using a Hash Map lookup',
    'Time: O(1), Space: O(N^2)',
    'C',
    75,
    'By storing visited elements and their indices in a Hash Map, each complement check (target - num) executes in O(1) average time, giving O(N) total time and O(N) space.'
),
(
    'Depth-First Search (DFS) Tree Traversal Stack',
    'AlgoDrift',
    'General',
    'Medium',
    'What is the worst-case Auxiliary Space complexity of DFS traversal on a degenerate (skewed) binary tree with N nodes?',
    'void dfs(TreeNode root) {\n    if (root == null) return;\n    visit(root);\n    dfs(root.left);\n    dfs(root.right);\n}',
    'O(1)',
    'O(log N)',
    'O(N)',
    'O(N^2)',
    'C',
    80,
    'For a skewed binary tree (linked list structure), the recursion tree depth is N. The call stack holds all N activation frames simultaneously, consuming O(N) auxiliary memory.'
),
(
    'Circular Queue Index Wrapping Formula',
    'AlgoDrift',
    'General',
    'Hard',
    'In an array-based Circular Queue of capacity C, what is the correct formula to advance the rear index when enqueueing an item?',
    '// circular queue enqueue logic: advance rear pointer',
    'rear = (rear + 1) % C;',
    'rear = rear + 1;',
    'rear = (rear - 1) % C;',
    'rear = (rear * 2) % C;',
    'A',
    100,
    'The modulo operator % C wraps the index back to 0 once rear reaches capacity - 1, preventing out-of-bounds errors in circular buffers.'
),

-- Track 3: QueryCraft (Interactive Database & SQL Lab)
(
    'INNER JOIN vs LEFT JOIN Null Filtering',
    'QueryCraft',
    'General',
    'Easy',
    'Which SQL query retrieves all departments along with employee names, including departments that currently have NO employees assigned?',
    '-- departments (dept_id, dept_name)\n-- employees (emp_id, emp_name, dept_id)',
    'SELECT d.dept_name, e.emp_name FROM departments d INNER JOIN employees e ON d.dept_id = e.dept_id;',
    'SELECT d.dept_name, e.emp_name FROM departments d LEFT JOIN employees e ON d.dept_id = e.dept_id;',
    'SELECT d.dept_name, e.emp_name FROM departments d RIGHT JOIN employees e ON d.dept_id = e.dept_id;',
    'SELECT d.dept_name, e.emp_name FROM departments d CROSS JOIN employees e;',
    'B',
    50,
    'A LEFT OUTER JOIN preserves all rows from the left table (departments), filling missing matches from the right table (employees) with NULL values.'
),
(
    'ACID Isolation: Phantom Read Phenomenon',
    'QueryCraft',
    'General',
    'Medium',
    'Under ANSI SQL standard transaction isolation levels, which level is strictly required to prevent Phantom Reads?',
    '-- Transaction 1 runs: SELECT * FROM orders WHERE amount > 1000;\n-- Transaction 2 concurrently INSERTS new order with amount = 1500;\n-- Transaction 1 re-runs same query and sees a new phantom row!',
    'READ UNCOMMITTED',
    'READ COMMITTED',
    'REPEATABLE READ',
    'SERIALIZABLE',
    'D',
    75,
    'SERIALIZABLE is the highest isolation level and provides complete range locking or predicate locking, eliminating dirty reads, non-repeatable reads, and phantom reads.'
),
(
    'Second Highest Salary Query Optimization',
    'QueryCraft',
    'General',
    'Medium',
    'Which SQL statement reliably selects the distinct second highest salary from an Employee table without failing on duplicate salaries?',
    '-- Table: Employee (id INT, salary INT)',
    'SELECT salary FROM Employee ORDER BY salary DESC LIMIT 1 OFFSET 1;',
    'SELECT MAX(salary) FROM Employee WHERE salary < (SELECT MAX(salary) FROM Employee);',
    'SELECT MIN(salary) FROM (SELECT salary FROM Employee ORDER BY salary DESC LIMIT 2) AS T;',
    'SELECT DISTINCT salary FROM Employee ORDER BY salary ASC LIMIT 2;',
    'B',
    80,
    'The subquery (SELECT MAX(salary) FROM Employee) finds the absolute maximum; filtering for salary < maximum and applying MAX() safely extracts the second highest value, properly handling ties and nulls.'
),
(
    'Relational Normalization: 3NF vs BCNF',
    'QueryCraft',
    'General',
    'Hard',
    'A relation R(A, B, C) has functional dependencies: AB -> C and C -> B. Candidate keys are AB and AC. In which normal form is relation R?',
    '-- FD1: AB -> C (AB is candidate key)\n-- FD2: C -> B (C is NOT superkey, B is prime attribute)',
    '1NF only',
    '2NF only',
    '3NF but NOT in BCNF',
    'BCNF',
    'C',
    100,
    'For 3NF, every non-trivial FD X -> Y must have either X as a superkey or Y as a prime attribute. In C -> B, B is prime (part of key AB), satisfying 3NF. But C is not a superkey, violating BCNF.'
),

-- Track 4: PlacementArena (Campus Placement Simulator)
(
    'TCS NQT: Bitwise Single Non-Repeating Element',
    'PlacementArena',
    'TCS',
    'Easy',
    'In an integer array where every number appears twice except for one single unique element, which bitwise operator finds the unique element in O(N) time and O(1) space?',
    '// Input: [4, 1, 2, 1, 2]\n// Output: 4',
    'Bitwise AND (&)',
    'Bitwise OR (|)',
    'Bitwise XOR (^)',
    'Bitwise NOT (~)',
    'C',
    50,
    'XOR has properties: a ^ a = 0 and a ^ 0 = a. Cumulative XOR cancels all paired numbers, leaving only the single unique number.'
),
(
    'Infosys DSE: Floyd Cycle Detection Algorithm',
    'PlacementArena',
    'Infosys',
    'Medium',
    'In Floyd''s Tortoise and Hare algorithm to detect a loop in a Singly Linked List, how should the two pointers advance?',
    'boolean hasCycle(ListNode head) { ... }',
    'Slow moves 1 step, Fast moves 1 step',
    'Slow moves 1 step, Fast moves 2 steps',
    'Slow moves 2 steps, Fast moves 3 steps',
    'Slow remains at head, Fast traverses to end',
    'B',
    75,
    'Advancing slow by 1 step and fast by 2 steps reduces the distance between them by 1 in each cycle iteration, guaranteeing they collide in O(N) time if a loop exists.'
),
(
    'Cognizant GenC: CPU Preemptive SJF Scheduling',
    'PlacementArena',
    'Cognizant',
    'Medium',
    'In Operating Systems, what is another standard name for Preemptive Shortest Job First (SJF) process scheduling?',
    '// Scheduler preempts running process if incoming process has shorter remaining burst',
    'Round Robin (RR)',
    'Shortest Remaining Time First (SRTF)',
    'First Come First Served (FCFS)',
    'Priority Inversion Scheduling',
    'B',
    80,
    'Preemptive SJF is standardly known as Shortest Remaining Time First (SRTF), where the CPU is reallocated whenever a process with a shorter remaining burst arrives.'
),
(
    'Amazon Technical: LRU Cache Implementation Structure',
    'PlacementArena',
    'Amazon',
    'Hard',
    'To implement a Least Recently Used (LRU) Cache with O(1) get(key) and O(1) put(key, value) operations, which combination of data structures is required?',
    '// Requirements: O(1) lookup + O(1) removal/insertion at head & tail',
    'Array and Binary Search Tree',
    'Hash Map and Doubly Linked List',
    'Queue and Stack',
    'Min Heap and Array',
    'B',
    100,
    'Hash Map provides O(1) key lookup and node pointer access; Doubly Linked List enables O(1) node detachment and re-insertion at the most recently used head position.'
);

-- Seed some submissions for sample leaderboard users
INSERT INTO submissions (user_id, challenge_id, selected_option, is_correct, xp_earned)
VALUES
(2, 1, 'A', TRUE, 50),
(2, 2, 'B', TRUE, 75),
(2, 5, 'B', TRUE, 50),
(2, 9, 'B', TRUE, 50),
(2, 13, 'C', TRUE, 50),
(3, 1, 'A', TRUE, 50),
(3, 5, 'B', TRUE, 50),
(3, 9, 'B', TRUE, 50),
(4, 1, 'A', TRUE, 50),
(4, 13, 'C', TRUE, 50),
(5, 1, 'A', TRUE, 50)
ON DUPLICATE KEY UPDATE is_correct = VALUES(is_correct);
