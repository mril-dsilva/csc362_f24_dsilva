-- Implementing Flying Carpets Gallery Database

/* Create the database (dropping the previous version if necessary) */
DROP DATABASE IF EXISTS flying_carpets;

CREATE DATABASE flying_carpets;

/* Using our new flying_carpets database */
USE flying_carpets;

-- Create the validation tables for Countries, Styles, and Materials
CREATE TABLE Countries (
    PRIMARY KEY (country_name),
    country_name VARCHAR(50)
);

CREATE TABLE Styles (
    PRIMARY KEY (style_name),
    style_name VARCHAR(50)
);

CREATE TABLE Materials (
    PRIMARY KEY (material_name),
    material_name VARCHAR(50)
);

-- Create the Inventory table
CREATE TABLE Inventory (
    inventory_id INT AUTO_INCREMENT,
    country_name VARCHAR(50),
    style_name VARCHAR(50),
    material_name VARCHAR(50),
    inventory_width FLOAT(5,2) CHECK (inventory_width > 0),
    inventory_length FLOAT(5,2) CHECK (inventory_length > 0),
    inventory_year_made INT, --
    inventory_purchase_price FLOAT(10,2) CHECK (inventory_purchase_price >= 0),
    inventory_markup FLOAT(10,2) CHECK (inventory_markup >= 0),
    inventory_date_acquired DATE, --
    PRIMARY KEY (inventory_id), 
    FOREIGN KEY (country_name) REFERENCES Countries(country_name),
    FOREIGN KEY (style_name) REFERENCES Styles(style_name),
    FOREIGN KEY (material_name) REFERENCES Materials(material_name)
);

-- Create the Customers table
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT,
    customer_name VARCHAR(100),
    customer_address VARCHAR(256),
    customer_city VARCHAR(100),
    customer_state VARCHAR(2),
    customer_zip CHAR(10),
    customer_phone VARCHAR(15) UNIQUE,
    PRIMARY KEY (customer_id)
);

-- Create the Sales table
CREATE TABLE Sales (
    sale_id INT AUTO_INCREMENT,
    customer_id INT,
    inventory_id INT,
    sale_date DATE,
    sale_price FLOAT(10,2) CHECK (sale_price >= 0),
    PRIMARY KEY (sale_id), 
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE SET NULL,  -- (D)
    FOREIGN KEY (inventory_id) REFERENCES Inventory(inventory_id) ON DELETE RESTRICT -- (R)
);

-- Create the Returns table with a constraint to ensure the return_date is valid
CREATE TABLE Returns (
    return_id INT AUTO_INCREMENT,
    customer_id INT,
    inventory_id INT,
    sale_id INT,
    return_date DATE,
    return_price_refunded FLOAT(10,2) CHECK (return_price_refunded >= 0),
    PRIMARY KEY (return_id), 
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE SET NULL,  -- (D)
    FOREIGN KEY (inventory_id) REFERENCES Inventory(inventory_id) ON DELETE RESTRICT, -- (R)
    FOREIGN KEY (sale_id) REFERENCES Sales(sale_id) ON DELETE RESTRICT -- (R)
);

-- Create the Trials table with constraints on the trial dates
CREATE TABLE Trials (
    trial_id INT AUTO_INCREMENT,
    customer_id INT,
    inventory_id INT,
    trial_date_taken DATE,
    trial_expected_return_date DATE CHECK (trial_expected_return_date > trial_date_taken),
    trial_returned_date DATE,
    PRIMARY KEY (trial_id), 
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE SET NULL,  -- (D)
    FOREIGN KEY (inventory_id) REFERENCES Inventory(inventory_id) ON DELETE RESTRICT -- (R)
);

-- Validation table data: Countries, Styles, and Materials
INSERT INTO Countries (country_name) VALUES ('Turkey'), ('Iran'), ('India'), ('Afghanistan');
INSERT INTO Styles (style_name) VALUES ('Ushak'), ('Tabriz'), ('Agra');
INSERT INTO Materials (material_name) VALUES ('Wool'), ('Cotton'), ('Silk');

-- Insert sample data for Inventory
INSERT INTO Inventory (country_name, style_name, material_name, inventory_width, inventory_length, inventory_year_made, inventory_purchase_price, inventory_markup, inventory_date_acquired) 
VALUES ('Turkey', 'Ushak', 'Wool', 5.0, 7.0, 1925, 625.00, 100, '2017-04-06'),
       ('Iran', 'Tabriz', 'Silk', 10.0, 14.0, 1910, 28000.00, 75, '2017-04-06'),
       ('India', 'Agra', 'Wool', 8.0, 10.0, 2017, 1200.00, 100, '2017-06-15'),
       ('India', 'Agra', 'Wool', 4.0, 6.0, 2017, 450.00, 120, '2017-06-15');

-- Insert sample data for Customers
INSERT INTO Customers (customer_name, customer_address, customer_city, customer_state, customer_zip, customer_phone) 
VALUES ('Akira Ingram', '68 Country Drive', 'Roseville', 'MI', '48066', '(926) 252-6716'),
       ('Meredith Spencer', '9044 Piper Lane', 'North Royalton', 'OH', '44133', '(817) 530-5994'),
       ('Marco Page', '747 East Harrison Lane', 'Atlanta', 'GA', '30303', '(588) 799-6535'),
       ('Sandra Page', '47 East Harrison Lane', 'Atlanta', 'GA', '30303', '(997) 697-2666');

-- Insert sample data for Sales
INSERT INTO Sales (customer_id, inventory_id, sale_date, sale_price)
VALUES (1, 1, '2017-12-14', 990.00),
       (2, 2, '2017-12-24', 40000.00),
       (3, 3, '2017-12-24', 2400.00);

-- Insert sample data for Returns
INSERT INTO Returns (customer_id, inventory_id, sale_id, return_date, return_price_refunded)
VALUES (2, 2, 2, '2017-12-26', 40000.00);

-- Insert sample data for Trials
INSERT INTO Trials (customer_id, inventory_id, trial_date_taken, trial_expected_return_date, trial_returned_date)
VALUES (3, 1, '2017-12-01', '2017-12-15', '2017-12-10');

-- Queries to test input data
SELECT * FROM Countries;
SELECT * FROM Styles;
SELECT * FROM Materials;
SELECT * FROM Inventory;
SELECT * FROM Customers;
SELECT * FROM Sales;
SELECT * FROM Returns;
SELECT * FROM Trials;

/* End of file Flying Carpets Gallery Database */
