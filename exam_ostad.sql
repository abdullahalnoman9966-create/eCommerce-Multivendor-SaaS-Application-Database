
CREATE DATABASE IF NOT EXISTS multivendor_saas;
USE multivendor_saas;


CREATE TABLE SubscriptionPlan (
    plan_id INT PRIMARY KEY AUTO_INCREMENT,
    plan_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    duration VARCHAR(50) NOT NULL, 
    features TEXT
);


CREATE TABLE Vendor (
    vendor_id INT PRIMARY KEY AUTO_INCREMENT,
    business_name VARCHAR(200) NOT NULL,
    contact_person VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    business_address TEXT,
    subscription_plan_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (subscription_plan_id) REFERENCES SubscriptionPlan(plan_id)
);


CREATE TABLE Category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    description TEXT
);


CREATE TABLE Product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    status VARCHAR(20) DEFAULT 'active',
    vendor_id INT NOT NULL,
    FOREIGN KEY (vendor_id) REFERENCES Vendor(vendor_id)
);


CREATE TABLE ProductCategory (
    product_id INT,
    category_id INT,
    assigned_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (product_id, category_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES Category(category_id) ON DELETE CASCADE
);


CREATE TABLE Customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT
);


CREATE TABLE `Order` (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    order_status VARCHAR(50) DEFAULT 'pending',
    customer_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);


CREATE TABLE OrderItem (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES `Order`(order_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);


CREATE TABLE Payment (
    payment_id VARCHAR(100) PRIMARY KEY,
    order_id INT UNIQUE NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    payment_status VARCHAR(50) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES `Order`(order_id)
);


INSERT INTO SubscriptionPlan (plan_name, price, duration, features) VALUES
('Basic', 1000.00, 'monthly', 'Basic features for small vendors'),
('Professional', 3000.00, 'monthly', 'Advanced features for growing businesses'),
('Enterprise', 8000.00, 'monthly', 'Full features for large enterprises');




INSERT INTO Vendor (business_name, contact_person, email, phone, business_address, subscription_plan_id)
VALUES ('SmartTech Ltd.', 'Rahim Khan', 'rahim@smarttech.com', '017XXXXXXXX', 'Dhaka, Bangladesh', 1);


INSERT INTO Category (category_name, description) VALUES
('Electronics', 'All electronic gadgets and devices'),
('Clothing', 'Fashion and apparel'),
('Books', 'Educational and entertainment books');


INSERT INTO Product (product_name, description, price, stock_quantity, status, vendor_id)
VALUES ('Laptop', 'High-performance laptop with latest specifications', 75000.00, 10, 'active', 1);

INSERT INTO ProductCategory (product_id, category_id) VALUES (1, 1);


INSERT INTO Vendor (business_name, contact_person, email, phone, business_address, subscription_plan_id)
VALUES ('Fashion Hub', 'Salma Ahmed', 'salma@fashionhub.com', '018XXXXXXXX', 'Chittagong, Bangladesh', 2);


INSERT INTO Product (product_name, description, price, stock_quantity, status, vendor_id) VALUES
('Smartphone', 'Latest smartphone with high-resolution camera', 25000.00, 20, 'active', 1),
('T-Shirt', 'Cotton t-shirt with unique design', 500.00, 100, 'active', 2),
('Jeans', 'Slim fit jeans for men', 1200.00, 50, 'active', 2);


INSERT INTO ProductCategory (product_id, category_id) VALUES (2, 1);

INSERT INTO ProductCategory (product_id, category_id) VALUES (3, 2), (4, 2);


INSERT INTO Customer (name, email, phone, address) VALUES
('Karim Uddin', 'karim@gmail.com', '019XXXXXXXX', 'Dhaka, Bangladesh'),
('Rina Akter', 'rina@gmail.com', '015XXXXXXXX', 'Sylhet, Bangladesh'),
('Old Customer', 'oldcustomer@gmail.com', '014XXXXXXXX', 'Khulna, Bangladesh');


INSERT INTO `Order` (order_date, total_amount, order_status, customer_id) VALUES
('2023-10-01', 75500.00, 'completed', 1),
('2023-10-05', 1200.00, 'pending', 1),
('2023-10-10', 500.00, 'completed', 2);


INSERT INTO OrderItem (order_id, product_id, quantity, unit_price, subtotal) VALUES
(1, 1, 1, 75000.00, 75000.00),
(1, 2, 1, 500.00, 500.00);  


INSERT INTO OrderItem (order_id, product_id, quantity, unit_price, subtotal) VALUES
(2, 4, 1, 1200.00, 1200.00);


INSERT INTO OrderItem (order_id, product_id, quantity, unit_price, subtotal) VALUES
(3, 3, 1, 500.00, 500.00);


INSERT INTO Payment (payment_id, order_id, payment_method, amount, payment_date, payment_status) VALUES
('pay_001', 1, 'Bkash', 75500.00, '2023-10-01', 'completed'),
('pay_002', 2, 'Cash on Delivery', 1200.00, '2023-10-05', 'pending'),
('pay_003', 3, 'Card', 500.00, '2023-10-10', 'completed');


UPDATE Product 
SET stock_quantity = 15 
WHERE product_name = 'Laptop' AND vendor_id = 1;


DELETE FROM Customer 
WHERE email = 'oldcustomer@gmail.com';


SELECT 
    v.business_name,
    v.contact_person,
    v.email,
    sp.plan_name,
    sp.price
FROM Vendor v
INNER JOIN SubscriptionPlan sp ON v.subscription_plan_id = sp.plan_id;


SELECT 
    p.product_name,
    p.price,
    p.stock_quantity
FROM Product p
INNER JOIN ProductCategory pc ON p.product_id = pc.product_id
INNER JOIN Category c ON pc.category_id = c.category_id
WHERE c.category_name = 'Electronics'
AND p.status = 'active';


SELECT 
    o.order_id,
    o.order_date,
    o.total_amount,
    o.order_status
FROM `Order` o
INNER JOIN Customer c ON o.customer_id = c.customer_id
WHERE c.name = 'Karim Uddin'
ORDER BY o.order_date DESC;


SELECT 
    payment_method,
    amount,
    payment_status
FROM Payment
WHERE order_id = 1;


SELECT 
    p.product_id,
    p.product_name,
    SUM(oi.quantity) as total_quantity_sold
FROM OrderItem oi
INNER JOIN Product p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 5;