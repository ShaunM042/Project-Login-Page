-- Additional schema updates needed for the train reservation system

-- Update users table to include role-based authentication
ALTER TABLE users ADD COLUMN Role ENUM('customer', 'admin', 'rep') DEFAULT 'customer';

-- Insert admin user
INSERT INTO users (Username, Password, Role) VALUES ('admin', 'admin123', 'admin');

-- Create train stops table for detailed stop information
CREATE TABLE IF NOT EXISTS train_stops (
    StopID INT PRIMARY KEY AUTO_INCREMENT,
    Train_Number VARCHAR(50),
    StationID INT,
    Stop_Sequence INT,
    Arrival_Time TIME,
    Departure_Time TIME,
    FOREIGN KEY (StationID) REFERENCES station(StationID)
);

-- Add sample stations if not exist
INSERT IGNORE INTO station (Name, City, State) VALUES 
('New York Penn Station', 'New York', 'NY'),
('Philadelphia 30th Street', 'Philadelphia', 'PA'),
('Washington Union Station', 'Washington', 'DC'),
('Boston South Station', 'Boston', 'MA'),
('Newark Penn Station', 'Newark', 'NJ');

-- Add sample train schedule data to match the expected format
INSERT IGNORE INTO train_schedule (Train_Number, Transit_Line_Name, Origin_Station, Destination_Station, 
    Travel_Date, Departure_Time, Number_of_Stops, Fare) VALUES
('NE101', 'Northeast Regional', 'New York Penn Station', 'Washington Union Station', '2025-07-20', '08:00:00', 3, 89.50),
('NE102', 'Northeast Regional', 'Washington Union Station', 'New York Penn Station', '2025-07-20', '10:30:00', 3, 89.50),
('AC201', 'Acela Express', 'New York Penn Station', 'Boston South Station', '2025-07-20', '09:15:00', 2, 245.00),
('AC202', 'Acela Express', 'Boston South Station', 'New York Penn Station', '2025-07-20', '14:45:00', 2, 245.00);

-- Add sample train stops data
INSERT IGNORE INTO train_stops (Train_Number, StationID, Stop_Sequence, Arrival_Time, Departure_Time) VALUES
('NE101', 1, 1, '08:00:00', '08:00:00'),  -- NY departure
('NE101', 5, 2, '08:20:00', '08:25:00'),  -- Newark
('NE101', 2, 3, '09:30:00', '09:35:00'),  -- Philadelphia
('NE101', 3, 4, '11:00:00', '11:00:00'),  -- DC arrival
('AC201', 1, 1, '09:15:00', '09:15:00'),  -- NY departure
('AC201', 4, 2, '12:30:00', '12:30:00');  -- Boston arrival

-- Update customer table to include reservation-related fields
ALTER TABLE customer ADD COLUMN Phone VARCHAR(20);
ALTER TABLE customer ADD COLUMN Date_of_Birth DATE;

-- Add discount tracking table
CREATE TABLE IF NOT EXISTS discounts (
    DiscountID INT PRIMARY KEY AUTO_INCREMENT,
    Type ENUM('child', 'senior', 'disabled') NOT NULL,
    Percentage DECIMAL(5,2) NOT NULL
);

INSERT IGNORE INTO discounts (Type, Percentage) VALUES 
('child', 50.00),
('senior', 25.00),
('disabled', 25.00);