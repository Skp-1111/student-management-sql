-- schema.sql
DROP DATABASE IF EXISTS student_mgmt;
CREATE DATABASE student_mgmt;
USE student_mgmt;

-- Students
CREATE TABLE students (
  student_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  date_of_birth DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Instructors
CREATE TABLE instructors (
  instructor_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE,
  hired_on DATE
) ENGINE=InnoDB;

-- Courses
CREATE TABLE courses (
  course_id INT AUTO_INCREMENT PRIMARY KEY,
  course_code VARCHAR(10) NOT NULL UNIQUE,
  course_name VARCHAR(100) NOT NULL,
  credits INT DEFAULT 3
) ENGINE=InnoDB;

-- Enrollments (junction table)
CREATE TABLE enrollments (
  enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,
  course_id INT NOT NULL,
  enrolled_on DATE DEFAULT CURRENT_DATE,
  grade VARCHAR(5),
  CONSTRAINT fk_enroll_student FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
  CONSTRAINT fk_enroll_course FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Course assignment to instructor
CREATE TABLE course_instructor (
  id INT AUTO_INCREMENT PRIMARY KEY,
  course_id INT NOT NULL,
  instructor_id INT NOT NULL,
  CONSTRAINT fk_ci_course FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
  CONSTRAINT fk_ci_instructor FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Audit log for enrollment changes
CREATE TABLE audit_logs (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  action VARCHAR(50),
  details TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Indexes to improve lookup
CREATE INDEX idx_student_name ON students(last_name, first_name);
CREATE INDEX idx_course_code ON courses(course_code);

-- View: course enrollment counts
CREATE VIEW course_enrollment_counts AS
SELECT c.course_id, c.course_code, c.course_name, COUNT(e.enrollment_id) AS enrolled_students
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_code, c.course_name;

-- Stored procedure: student transcript
DELIMITER $$
CREATE PROCEDURE get_transcript(IN sid INT)
BEGIN
  SELECT s.student_id, CONCAT(s.first_name,' ',s.last_name) AS student_name,
         c.course_code, c.course_name, e.grade
  FROM students s
  JOIN enrollments e ON s.student_id = e.student_id
  JOIN courses c ON e.course_id = c.course_id
  WHERE s.student_id = sid;
END $$
DELIMITER ;

-- Trigger: log new enrollments
DELIMITER $$
CREATE TRIGGER trg_after_enroll
AFTER INSERT ON enrollments
FOR EACH ROW
BEGIN
  INSERT INTO audit_logs(action, details) VALUES(
    'ENROLLMENT_INSERT',
    CONCAT('Student ', NEW.student_id, ' enrolled in Course ', NEW.course_id, ' on ', NEW.enrolled_on)
  );
END $$
DELIMITER ;
