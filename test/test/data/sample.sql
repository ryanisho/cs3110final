-- Create a table
CREATE TABLE customers (
  id INT PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100)
);

-- Insert data into the table
INSERT INTO customers (id, name, email)
VALUES (1, 'John Doe', 'john.doe@example.com'),
       (2, 'Jane Smith', 'jane.smith@example.com');

-- Select all records from the table
SELECT * FROM customers;
