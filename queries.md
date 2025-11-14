# Useful queries

-- 1. Get a student's transcript
CALL get_transcript(1);

-- 2. List students in a course
SELECT s.student_id, CONCAT(s.first_name,' ',s.last_name) AS name, e.grade
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
WHERE e.course_id = 2;

-- 3. Average grade per course (simplified, if grade mapped to numbers)
-- (You would normally have grade points mapping table; here is a sample aggregator)
SELECT c.course_code, c.course_name, COUNT(e.enrollment_id) AS total_students
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id;

-- 4. Recent audit logs
SELECT * FROM audit_logs ORDER BY created_at DESC LIMIT 10;

-- 5. Update grade
UPDATE enrollments SET grade='A' WHERE enrollment_id=4;
