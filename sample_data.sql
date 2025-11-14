-- sample_data.sql
USE student_mgmt;

-- Students
INSERT INTO students(first_name, last_name, email, date_of_birth) VALUES
('Amit','Kumar','amit.kumar@example.com','2000-05-12'),
('Priya','Sharma','priya.sharma@example.com','2001-03-22'),
('Rahul','Das','rahul.das@example.com','1999-11-02');

-- Instructors
INSERT INTO instructors(name, email, hired_on) VALUES
('Dr. S. Patel','spatel@example.com','2018-08-01'),
('Ms. N. Verma','nverma@example.com','2020-01-15');

-- Courses
INSERT INTO courses(course_code, course_name, credits) VALUES
('CS101','Introduction to Programming',4),
('CS201','Data Structures',3),
('DB101','Database Systems',3);

-- Assign instructors
INSERT INTO course_instructor(course_id, instructor_id) VALUES
(1,1),(2,1),(3,2);

-- Enrollments & grades
INSERT INTO enrollments(student_id, course_id, enrolled_on, grade) VALUES
(1,1,'2025-07-01','A'),
(1,2,'2025-07-01','B+'),
(2,1,'2025-07-02','A-'),
(3,3,'2025-07-03',NULL);
