-- Part 1
-- Task 1.1
DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
  employee_id  integer PRIMARY KEY,
  first_name   text,
  last_name    text,
  age          integer CHECK (age BETWEEN 18 AND 65),
  salary       numeric CHECK (salary > 0)
);
INSERT INTO employees VALUES (1, 'Aigerim', 'K.', 25, 45000.00), (2, 'Nurzhan', 'T.', 54, 120000.50);
-- INSERT INTO employees VALUES (3, 'Zhan', 'S.', 16, 30000);
-- INSERT INTO employees VALUES (4, 'Dana', 'M.', 30, 0);

-- Task 1.2
DROP TABLE IF EXISTS products_catalog;
CREATE TABLE products_catalog (
  product_id    integer PRIMARY KEY,
  product_name  text,
  regular_price numeric,
  discount_price numeric,
  CONSTRAINT valid_discount CHECK (
    regular_price > 0
    AND discount_price > 0
    AND discount_price < regular_price
  )
);
INSERT INTO products_catalog VALUES (101, 'Wireless Mouse', 25.00, 19.99), (102, 'USB-C Cable', 10.00, 8.50);
-- INSERT INTO products_catalog VALUES (103, 'Keyboard', 30.00, 30.00);
-- INSERT INTO products_catalog VALUES (104, 'Headset', 0.00, 0.00);

-- Task 1.3
DROP TABLE IF EXISTS bookings;
CREATE TABLE bookings (
  booking_id     integer PRIMARY KEY,
  check_in_date  date,
  check_out_date date,
  num_guests     integer CHECK (num_guests BETWEEN 1 AND 10),
  CHECK (check_out_date > check_in_date)
);
INSERT INTO bookings VALUES (201, '2025-10-01', '2025-10-05', 2), (202, '2025-11-10', '2025-11-12', 4);
-- INSERT INTO bookings VALUES (203, '2025-12-01', '2025-12-03', 0);
-- INSERT INTO bookings VALUES (204, '2025-12-10', '2025-12-09', 2);

-- Part 2
-- Task 2.1
DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
  customer_id       integer NOT NULL PRIMARY KEY,
  email             text NOT NULL,
  phone             text,
  registration_date date NOT NULL
);
INSERT INTO customers VALUES (1, 'alar@mail.com', '7701-111222', '2025-01-15'), (2, 'nur@mail.com', NULL, '2025-03-10');
-- INSERT INTO customers VALUES (3, NULL, '7701-333444', '2025-05-01');
-- INSERT INTO customers VALUES (4, 'zhan@mail.com', NULL, NULL);

-- Task 2.2
DROP TABLE IF EXISTS inventory;
CREATE TABLE inventory (
  item_id      integer NOT NULL PRIMARY KEY,
  item_name    text NOT NULL,
  quantity     integer NOT NULL CHECK (quantity >= 0),
  unit_price   numeric NOT NULL CHECK (unit_price > 0),
  last_updated timestamp NOT NULL
);
INSERT INTO inventory VALUES (1001, 'Collagen Complex', 50, 2500.00, now()), (1002, 'Vitamin D', 120, 800.00, now());
-- INSERT INTO inventory VALUES (1003, 'Omega-3', -5, 1200.00, now());
-- INSERT INTO inventory VALUES (1004, 'Proline Sample', 10, 0.00, now());
-- INSERT INTO inventory VALUES (1005, NULL, 5, 500.00, now());

-- Part 3
-- Task 3.1
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  user_id    integer PRIMARY KEY,
  username   text UNIQUE,
  email      text UNIQUE,
  created_at timestamp
);
INSERT INTO users VALUES (1, 'bernar', 'bernar@example.com', now()), (2, 'aisa', 'aisa@example.com', now());
-- INSERT INTO users VALUES (3, 'bernar', 'other@example.com', now());
-- INSERT INTO users VALUES (4, 'newuser', 'aisa@example.com', now());

-- Task 3.2
DROP TABLE IF EXISTS course_enrollments;
CREATE TABLE course_enrollments (
  enrollment_id integer PRIMARY KEY,
  student_id    integer,
  course_code   text,
  semester      text,
  CONSTRAINT unique_student_course_semester UNIQUE (student_id, course_code, semester)
);
INSERT INTO course_enrollments VALUES (1, 101, 'MATH101', '2025-Fall'), (2, 102, 'CS101', '2025-Fall');
-- INSERT INTO course_enrollments VALUES (3, 101, 'MATH101', '2025-Fall');

-- Task 3.3
ALTER TABLE users DROP CONSTRAINT IF EXISTS users_username_key;
ALTER TABLE users DROP CONSTRAINT IF EXISTS users_email_key;
ALTER TABLE users
  ADD CONSTRAINT unique_username UNIQUE (username),
  ADD CONSTRAINT unique_email UNIQUE (email);
-- INSERT INTO users VALUES (5, 'aisa', 'another@example.com', now());
-- INSERT INTO users VALUES (6, 'someone', 'bernar@example.com', now());

-- Part 4
-- Task 4.1
DROP TABLE IF EXISTS departments;
CREATE TABLE departments (
  dept_id  integer PRIMARY KEY,
  dept_name text NOT NULL,
  location  text
);
INSERT INTO departments VALUES (1, 'Sales', 'Almaty'), (2, 'R&D', 'Nur-Sultan'), (3, 'HR', 'Shymkent');
-- INSERT INTO departments VALUES (1, 'Finance', 'Almaty');
-- INSERT INTO departments VALUES (NULL, 'Legal', 'Almaty');

-- Task 4.2
DROP TABLE IF EXISTS student_courses;
CREATE TABLE student_courses (
  student_id      integer,
  course_id       integer,
  enrollment_date date,
  grade           text,
  PRIMARY KEY (student_id, course_id)
);
INSERT INTO student_courses VALUES (201, 301, '2025-02-01', 'A'), (202, 302, '2025-02-05', 'B+');
-- INSERT INTO student_courses VALUES (201, 301, '2025-03-01', 'A-');

-- Part 5
-- Task 5.1
DROP TABLE IF EXISTS employees_dept;
CREATE TABLE employees_dept (
  emp_id     integer PRIMARY KEY,
  emp_name   text NOT NULL,
  dept_id    integer REFERENCES departments(dept_id),
  hire_date  date
);
INSERT INTO employees_dept VALUES (501, 'Saniya B.', 1, '2024-08-01'), (502, 'Yessen', 2, '2025-06-15');
-- INSERT INTO employees_dept VALUES (503, 'Err', 999, '2025-07-01');

-- Task 5.2
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS authors;
DROP TABLE IF EXISTS publishers;
CREATE TABLE authors (author_id integer PRIMARY KEY, author_name text NOT NULL, country text);
CREATE TABLE publishers (publisher_id integer PRIMARY KEY, publisher_name text NOT NULL, city text);
CREATE TABLE books (
  book_id integer PRIMARY KEY,
  title text NOT NULL,
  author_id integer REFERENCES authors(author_id),
  publisher_id integer REFERENCES publishers(publisher_id),
  publication_year integer,
  isbn text UNIQUE
);
INSERT INTO authors VALUES (1, 'Orhan Pamuk', 'Turkey'), (2, 'Chinua Achebe', 'Nigeria'), (3, 'Jane Austen', 'UK');
INSERT INTO publishers VALUES (10, 'Vintage', 'London'), (11, 'Penguin', 'New York'), (12, 'KazakhPub', 'Almaty');
INSERT INTO books VALUES
  (100, 'My Name Is Red', 1, 10, 1998, '9780307947894'),
  (101, 'Things Fall Apart', 2, 11, 1958, '9780141180283'),
  (102, 'Pride and Prejudice', 3, 10, 1813, '9780141439518');

-- Part 6
DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS orders_ecom;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
  customer_id integer PRIMARY KEY,
  name text NOT NULL,
  email text NOT NULL UNIQUE,
  phone text,
  registration_date date NOT NULL
);
CREATE TABLE products (
  product_id integer PRIMARY KEY,
  name text NOT NULL,
  description text,
  price numeric NOT NULL CHECK (price >= 0),
  stock_quantity integer NOT NULL CHECK (stock_quantity >= 0)
);
CREATE TABLE orders_ecom (
  order_id integer PRIMARY KEY,
  customer_id integer REFERENCES customers(customer_id) ON DELETE RESTRICT,
  order_date date NOT NULL,
  total_amount numeric NOT NULL CHECK (total_amount >= 0),
  status text NOT NULL CHECK (status IN ('pending','processing','shipped','delivered','cancelled'))
);
CREATE TABLE order_details (
  order_detail_id integer PRIMARY KEY,
  order_id integer REFERENCES orders_ecom(order_id) ON DELETE CASCADE,
  product_id integer REFERENCES products(product_id) ON DELETE RESTRICT,
  quantity integer NOT NULL CHECK (quantity > 0),
  unit_price numeric NOT NULL CHECK (unit_price >= 0)
);
INSERT INTO customers VALUES
  (10, 'Aibek', 'aibek@mail.com', '7701-555111', '2024-01-10'),
  (11, 'Madina', 'madina@mail.com', '7701-666222', '2024-02-20'),
  (12, 'Ernar', 'bernar@example.com', NULL, '2024-03-15'),
  (13, 'Alua', 'alua@mail.com', '7701-777333', '2025-01-05'),
  (14, 'Samat', 'samat@mail.com', NULL, '2025-06-08');
INSERT INTO products VALUES
  (200, 'Collagen Complex', 'Supports skin, joints, hair', 2500.00, 100),
  (201, 'Protein Bar', 'High-protein snack', 450.00, 500),
  (202, 'Vitamin D', '1000 IU', 800.00, 200),
  (203, 'Shaker Bottle', '500ml', 1200.00, 150),
  (204, 'Fitness Band', 'Resistance band', 1500.00, 50);
INSERT INTO orders_ecom VALUES
  (3000, 10, '2025-09-01', 5000.00, 'pending'),
  (3001, 11, '2025-09-02', 1200.00, 'processing'),
  (3002, 12, '2025-09-03', 3800.00, 'shipped'),
  (3003, 13, '2025-09-04', 450.00, 'delivered'),
  (3004, 14, '2025-09-05', 1500.00, 'cancelled');
INSERT INTO order_details VALUES
  (4000, 3000, 200, 2, 2500.00),
  (4001, 3001, 201, 2, 450.00),
  (4002, 3002, 202, 3, 800.00),
  (4003, 3003, 201, 1, 450.00),
  (4004, 3004, 203, 1, 1200.00);
