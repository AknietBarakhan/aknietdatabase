-- Task 1.1: 
CREATE DATABASE university_main 
	OWNER = postgres 
	ENCODING 'UTF8' 
	TEMPLATE template0;

CREATE DATABASE university_archive
	CONNECTION LIMIT=50
	TEMPLATE=template0;

CREATE DATABASE university_test
	TEMPLATE=template0
	IS_TEMPLATE=true
	CONNECTION LIMIT=10;

-- Task 1.2:
CREATE TABLESPACE student_data
	LOCATION 'C:\\tables\\students';

CREATE TABLESPACE courses_data
	OWNER postgres
	LOCATION 'C:\\tables\\courses';

CREATE DATABASE university_distributed
    TABLESPACE = student_data
    ENCODING = 'LATIN9';

-- Task 2.1:
CREATE TABLE students(
	student_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	email VARCHAR(100),
	phone CHAR(15),
	date_of_birth DATE,
	enrollment_date DATE,
	gpa NUMERIC(4,2),
	is_active BOOLEAN,
	graduation_year SMALLINT
);


CREATE TABLE professors(
	professor_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	email VARCHAR(100),
	office_number VARCHAR(20),
	hire_date DATE,
	salary NUMERIC(12,2),
	is_tenured BOOLEAN,
	years_experience INT
);

CREATE TABLE courses(
	course_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	course_code CHAR(8),
	course_title VARCHAR(100),
	description TEXT,
	credits SMALLINT,
	max_enrollment INT,
	course_fee NUMERIC(10,2),
	is_online BOOLEAN,
	created_at TIMESTAMP WITHOUT TIME ZONE
);

-- Task 2.2
CREATE TABLE class_schedule(
	schedule_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	course_id INT,
	professor_id INT,
	classroom VARCHAR(20),
	class_date DATE,
	start_time TIMESTAMP WITHOUT TIME ZONE,
	end_time TIMESTAMP WITHOUT TIME ZONE,
	duration INTERVAL
);

CREATE TABLE student_records(
	record_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	student_id INT,
	course_id INT,
	semester VARCHAR(20),
	year INT,
	grade CHAR(2),
	attendance_percentage NUMERIC(4,1),
	submission_timestamp TIMESTAMP WITH TIME ZONE,
	last_updated TIMESTAMP WITH TIME ZONE
);

-- Task 3.1:
ALTER TABLE students
ADD COLUMN middle_name VARCHAR(30),
ADD COLUMN student_status VARCHAR(20) DEFAULT 'ACTIVE';

ALTER TABLE students
ALTER COLUMN phone TYPE VARCHAR(20);

ALTER TABLE students
ALTER COLUMN gpa SET DEFAULT 0.00;

ALTER TABLE professors
ADD COLUMN research_area TEXT,
ADD COLUMN last_promotion_date DATE;

ALTER TABLE professors
ALTER COLUMN years_experience TYPE SMALLINT;

ALTER TABLE professors
ALTER COLUMN is_tenured SET DEFAULT false;

ALTER TABLE courses
ADD COLUMN prerequisite_course_id INT,
ADD COLUMN difficulty_level SMALLINT,
ADD COLUMN lab_required BOOLEAN DEFAULT false;

ALTER TABLE courses
ALTER COLUMN course_code TYPE VARCHAR(10);

ALTER TABLE courses
ALTER COLUMN credits SET DEFAULT 3;

-- Task 3.2:
ALTER TABLE class_schedule
ADD COLUMN room_capacity INT,
DROP COLUMN duration,
ADD COLUMN session_type VARCHAR(15),
ADD COLUMN equipment_needed TEXT;

ALTER TABLE class_schedule
ALTER COLUMN classroom TYPE VARCHAR(30);

ALTER TABLE student_records
ADD COLUMN extra_credit_points DECIMAL(5,1) DEFAULT 0.0,
ADD COLUMN final_exam_date DATE,
DROP COLUMN last_updated;

ALTER TABLE student_records
ALTER COLUMN grade TYPE VARCHAR(5);

-- Task 4.1:
CREATE TABLE departments(
	department_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	department_name VARCHAR(100),
	department_code CHAR(5),
	building VARCHAR(50),
	phone VARCHAR(15),
	budget DECIMAL(15,2),
	established_year INT
);

CREATE TABLE library_books(
	book_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	isbn CHAR(13),
	title VARCHAR(200),
	author VARCHAR(100),
	publisher VARCHAR(100),
	publication_date DATE,
	price DECIMAL(10,2),
	is_available BOOLEAN,
	asquisition_timestamp TIMESTAMP WITHOUT TIME ZONE

);

CREATE TABLE student_book_loans(
	loan_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	student_id INT,
	book_id INT,
	loan_date DATE,
	due_date DATE,
	return_date DATE,
	fine_amount DECIMAL(10,2),
	loan_status VARCHAR(20)
);

-- Task 4.2:
ALTER TABLE professors
ADD COLUMN department_id INTEGER;

ALTER TABLE students
ADD COLUMN advisor_id INTEGER;

ALTER TABLE courses
ADD COLUMN  department_id INTEGER;

CREATE TABLE grade_scale(
	grade_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	letter_grade CHAR(2),
	min_percentage DECIMAL(5,1),
	max_percentage DECIMAL(5,1),
	gpa DECIMAL(4,2)
);

CREATE TABLE semester_calendar(
	semester_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	semester_name VARCHAR(20),
	academic_year INT,
	start_date DATE,
	end_date DATE,
	registration_deadline TIMESTAMP WITHOUT TIME ZONE,
	is_current BOOLEAN
);

-- Task 5.1:
DROP TABLE IF EXISTS student_book_loans;

DROP TABLE IF EXISTS library_books;

DROP TABLE IF EXISTS grade_scale;

CREATE TABLE grade_scale (
    grade_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    letter_grade CHAR(2) NOT NULL,
    min_percentage DECIMAL(5,1) NOT NULL,
    max_percentage DECIMAL(5,1) NOT NULL,
    gpa DECIMAL(4,2) NOT NULL,
    description TEXT
);

DROP TABLE IF EXISTS semester_calendar CASCADE;

CREATE TABLE semester_calendar(
    semester_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    semester_name VARCHAR(20),
    academic_year INT,
    start_date DATE,
    end_date DATE,
    registration_deadline TIMESTAMP WITHOUT TIME ZONE,
    is_current BOOLEAN
);

-- Task 5.1:
DROP DATABASE IF EXISTS university_test;

DROP DATABASE IF EXISTS university_distributed;

CREATE DATABASE university_backup TEMPLATE university_main;

