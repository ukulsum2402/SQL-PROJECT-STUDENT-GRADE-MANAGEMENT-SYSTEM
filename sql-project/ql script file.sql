/* =====================================================
   STUDENT GRADE MANAGEMENT SYSTEM
   Complete SQL Script
===================================================== */

-- ===============================
-- PHASE 1: CREATE DATABASE
-- ===============================

CREATE DATABASE IF NOT EXISTS student_grade_system;
USE student_grade_system;

-- ===============================
-- PHASE 2: TABLE CREATION (DDL)
-- ===============================

-- 1. Departments Table
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100) UNIQUE NOT NULL,
    hod_name VARCHAR(100)
);

-- 2. Students Table
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    gender VARCHAR(10),
    dob DATE,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

-- 3. Subjects Table
CREATE TABLE Subjects (
    subject_id INT PRIMARY KEY,
    subject_name VARCHAR(100),
    credits INT,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

-- 4. Exams Table
CREATE TABLE Exams (
    exam_id INT PRIMARY KEY,
    exam_name VARCHAR(50),
    exam_date DATE,
    subject_id INT,
    FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id)
);

-- 5. Marks Table
CREATE TABLE Marks (
    mark_id INT PRIMARY KEY,
    student_id INT,
    exam_id INT,
    marks_obtained INT,
    max_marks INT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (exam_id) REFERENCES Exams(exam_id)
);

-- ===============================
-- PHASE 3: INSERT DATA (DML)
-- ===============================

-- Insert Departments
INSERT INTO Departments VALUES
(1, 'Computer Science', 'Dr. Anil Kumar'),
(2, 'Electronics', 'Dr. Meera Nair'),
(3, 'Mechanical', 'Dr. Rajesh Sharma'),
(4, 'Civil', 'Dr. Priya Verma');

-- Insert Students (2 with NULL department)
INSERT INTO Students VALUES
(101, 'Aisha Khan', 'aisha@gmail.com', 'Female', '2003-05-10', 1),
(102, 'Rahul Sharma', 'rahul@gmail.com', 'Male', '2002-08-15', 1),
(103, 'Priya Singh', 'priya@gmail.com', 'Female', '2003-01-20', 2),
(104, 'Karan Patel', 'karan@gmail.com', 'Male', '2002-12-01', 2),
(105, 'Sneha Reddy', 'sneha@gmail.com', 'Female', '2003-03-18', 3),
(106, 'Arjun Das', 'arjun@gmail.com', 'Male', '2002-11-22', 3),
(107, 'Meena Iyer', 'meena@gmail.com', 'Female', '2003-07-09', 4),
(108, 'Vikram Rao', 'vikram@gmail.com', 'Male', '2002-09-30', 4),
(109, 'Zoya Ali', 'zoya@gmail.com', 'Female', '2003-06-14', NULL),
(110, 'Rohan Gupta', 'rohan@gmail.com', 'Male', '2002-04-25', NULL);

-- Insert Subjects
INSERT INTO Subjects VALUES
(201, 'Data Structures', 4, 1),
(202, 'Database Systems', 4, 1),
(203, 'Digital Electronics', 3, 2),
(204, 'Microprocessors', 3, 2),
(205, 'Thermodynamics', 4, 3),
(206, 'Structural Engineering', 4, 4);

-- Insert Exams (3 per subject)
INSERT INTO Exams VALUES
(301,'Midterm','2025-03-01',201),
(302,'Internal','2025-04-01',201),
(303,'Final','2025-05-01',201),
(304,'Midterm','2025-03-02',202),
(305,'Internal','2025-04-02',202),
(306,'Final','2025-05-02',202),
(307,'Midterm','2025-03-03',203),
(308,'Internal','2025-04-03',203),
(309,'Final','2025-05-03',203),
(310,'Midterm','2025-03-04',204),
(311,'Internal','2025-04-04',204),
(312,'Final','2025-05-04',204),
(313,'Midterm','2025-03-05',205),
(314,'Internal','2025-04-05',205),
(315,'Final','2025-05-05',205),
(316,'Midterm','2025-03-06',206),
(317,'Internal','2025-04-06',206),
(318,'Final','2025-05-06',206);

-- Insert Sample Marks
INSERT INTO Marks VALUES
(1,101,301,85,100),
(2,101,302,78,100),
(3,101,303,90,100),
(4,102,301,65,100),
(5,102,302,70,100),
(6,102,303,75,100);

-- ===============================
-- VIEW CREATION
-- ===============================

CREATE VIEW student_full_report_view AS
SELECT 
    s.student_name,
    d.dept_name,
    sub.subject_name,
    e.exam_name,
    m.marks_obtained
FROM Marks m
JOIN Students s ON m.student_id = s.student_id
LEFT JOIN Departments d ON s.dept_id = d.dept_id
JOIN Exams e ON m.exam_id = e.exam_id
JOIN Subjects sub ON e.subject_id = sub.subject_id;

-- ===============================
-- STORED PROCEDURE
-- ===============================

DELIMITER //

CREATE PROCEDURE GetStudentResult(IN studentId INT)
BEGIN
    SELECT 
        s.student_name,
        SUM(m.marks_obtained) AS Total_Marks,
        AVG(m.marks_obtained) AS Average_Marks,
        CASE
            WHEN AVG(m.marks_obtained) >= 90 THEN 'A'
            WHEN AVG(m.marks_obtained) >= 75 THEN 'B'
            WHEN AVG(m.marks_obtained) >= 60 THEN 'C'
            WHEN AVG(m.marks_obtained) >= 40 THEN 'D'
            ELSE 'F'
        END AS Grade
    FROM Students s
    JOIN Marks m ON s.student_id = m.student_id
    WHERE s.student_id = studentId
    GROUP BY s.student_name;
END //

DELIMITER ;

-- ===============================
-- END OF SCRIPT
-- ===============================
