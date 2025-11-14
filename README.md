# student-management-sql
A simple MySQL-based Student Management Database showcasing tables, relationships, sample data, and essential SQL features like joins, views, procedures, and triggers.


# Student Management SQL Project

## Quick start
1. Open MySQL client and run:
   - `mysql -u root -p < schema.sql`
   - `mysql -u root -p < sample_data.sql`

2. Test:
   - `USE student_mgmt;`
   - `SELECT * FROM students;`
   - `CALL get_transcript(1);`
   - `SELECT * FROM course_enrollment_counts;`

## To upload to GitHub
1. Initialize repo:
