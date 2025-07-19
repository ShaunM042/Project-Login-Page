-- Train Reservation System Database Schema
-- Complete schema export with all tables and relationships

CREATE DATABASE IF NOT EXISTS `reservation` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `reservation`;

-- Table structure for table `users`
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `Username` varchar(50) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `Role` enum('customer','admin','rep') DEFAULT 'customer',
  PRIMARY KEY (`Username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table structure for table `station`
DROP TABLE IF EXISTS `station`;
CREATE TABLE `station` (
  `StationID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) DEFAULT NULL,
  `City` varchar(50) DEFAULT NULL,
  `State` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`StationID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table structure for table `train`
DROP TABLE IF EXISTS `train`;
CREATE TABLE `train` (
  `TrainID` int NOT NULL,
  `Transit_Line_Name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`TrainID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table structure for table `train_schedule`
DROP TABLE IF EXISTS `train_schedule`;
CREATE TABLE `train_schedule` (
  `ScheduleID` int NOT NULL AUTO_INCREMENT,
  `Train_Number` varchar(50) DEFAULT NULL,
  `Transit_Line_Name` varchar(50) DEFAULT NULL,
  `Origin_Station` varchar(50) DEFAULT NULL,
  `Destination_Station` varchar(50) DEFAULT NULL,
  `Travel_Date` date DEFAULT NULL,
  `Departure_Time` time DEFAULT NULL,
  `Number_of_Stops` int DEFAULT NULL,
  `Fare` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`ScheduleID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table structure for table `train_stops`
DROP TABLE IF EXISTS `train_stops`;
CREATE TABLE `train_stops` (
  `StopID` int NOT NULL AUTO_INCREMENT,
  `Train_Number` varchar(50) DEFAULT NULL,
  `StationID` int DEFAULT NULL,
  `Stop_Sequence` int DEFAULT NULL,
  `Arrival_Time` time DEFAULT NULL,
  `Departure_Time` time DEFAULT NULL,
  PRIMARY KEY (`StopID`),
  KEY `StationID` (`StationID`),
  CONSTRAINT `train_stops_ibfk_1` FOREIGN KEY (`StationID`) REFERENCES `station` (`StationID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table structure for table `customer`
DROP TABLE IF EXISTS `customer`;
CREATE TABLE `customer` (
  `SSN` int NOT NULL,
  `Username` varchar(50) DEFAULT NULL,
  `Name` varchar(100) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `Address` varchar(200) DEFAULT NULL,
  `Phone` varchar(20) DEFAULT NULL,
  `Date_of_Birth` date DEFAULT NULL,
  `Password` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`SSN`),
  KEY `Username` (`Username`),
  CONSTRAINT `customer_ibfk_1` FOREIGN KEY (`Username`) REFERENCES `users` (`Username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table structure for table `employee`
DROP TABLE IF EXISTS `employee`;
CREATE TABLE `employee` (
  `SSN` int NOT NULL,
  `FirstName` varchar(50) DEFAULT NULL,
  `LastName` varchar(50) DEFAULT NULL,
  `Username` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`SSN`),
  KEY `Username` (`Username`),
  CONSTRAINT `employee_ibfk_1` FOREIGN KEY (`Username`) REFERENCES `users` (`Username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table structure for table `reservation`
DROP TABLE IF EXISTS `reservation`;
CREATE TABLE `reservation` (
  `Reservation_Num` int NOT NULL,
  `Username` varchar(50) DEFAULT NULL,
  `Transit_Line_Name` varchar(50) DEFAULT NULL,
  `TrainID` varchar(50) DEFAULT NULL,
  `Origin` varchar(50) DEFAULT NULL,
  `Destination` varchar(50) DEFAULT NULL,
  `Departure` datetime DEFAULT NULL,
  `Reservation_Date` date DEFAULT NULL,
  `Passenger_Count` int DEFAULT NULL,
  `Age_Group` enum('adult','child','senior','disabled') DEFAULT NULL,
  `Round_Trip` tinyint(1) DEFAULT NULL,
  `Total_Fare` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`Reservation_Num`),
  KEY `Username` (`Username`),
  CONSTRAINT `reservation_ibfk_1` FOREIGN KEY (`Username`) REFERENCES `users` (`Username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table structure for table `questions`
DROP TABLE IF EXISTS `questions`;
CREATE TABLE `questions` (
  `QID` int NOT NULL,
  `AskedBy` varchar(50) DEFAULT NULL,
  `Question` text,
  `DateAsked` datetime DEFAULT NULL,
  PRIMARY KEY (`QID`),
  KEY `AskedBy` (`AskedBy`),
  CONSTRAINT `questions_ibfk_1` FOREIGN KEY (`AskedBy`) REFERENCES `users` (`Username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table structure for table `answers`
DROP TABLE IF EXISTS `answers`;
CREATE TABLE `answers` (
  `AID` int NOT NULL,
  `QID` int DEFAULT NULL,
  `AnsweredBy` varchar(50) DEFAULT NULL,
  `Answer` text,
  `DateAnswered` datetime DEFAULT NULL,
  PRIMARY KEY (`AID`),
  KEY `QID` (`QID`),
  KEY `AnsweredBy` (`AnsweredBy`),
  CONSTRAINT `answers_ibfk_1` FOREIGN KEY (`QID`) REFERENCES `questions` (`QID`),
  CONSTRAINT `answers_ibfk_2` FOREIGN KEY (`AnsweredBy`) REFERENCES `users` (`Username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table structure for table `discounts`
DROP TABLE IF EXISTS `discounts`;
CREATE TABLE `discounts` (
  `DiscountID` int NOT NULL AUTO_INCREMENT,
  `Type` enum('child','senior','disabled') NOT NULL,
  `Percentage` decimal(5,2) NOT NULL,
  PRIMARY KEY (`DiscountID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Insert initial data
INSERT INTO `users` (`Username`, `Password`, `Role`) VALUES 
('admin', 'admin123', 'admin');

INSERT INTO `discounts` (`Type`, `Percentage`) VALUES 
('child', 50.00),
('senior', 25.00),
('disabled', 25.00);

INSERT INTO `station` (`Name`, `City`, `State`) VALUES 
('New York Penn Station', 'New York', 'NY'),
('Philadelphia 30th Street', 'Philadelphia', 'PA'),
('Washington Union Station', 'Washington', 'DC'),
('Boston South Station', 'Boston', 'MA'),
('Newark Penn Station', 'Newark', 'NJ');

INSERT INTO `train_schedule` (`Train_Number`, `Transit_Line_Name`, `Origin_Station`, `Destination_Station`, `Travel_Date`, `Departure_Time`, `Number_of_Stops`, `Fare`) VALUES
('NE101', 'Northeast Regional', 'New York Penn Station', 'Washington Union Station', '2025-07-20', '08:00:00', 3, 89.50),
('NE102', 'Northeast Regional', 'Washington Union Station', 'New York Penn Station', '2025-07-20', '10:30:00', 3, 89.50),
('AC201', 'Acela Express', 'New York Penn Station', 'Boston South Station', '2025-07-20', '09:15:00', 2, 245.00),
('AC202', 'Acela Express', 'Boston South Station', 'New York Penn Station', '2025-07-20', '14:45:00', 2, 245.00);

INSERT INTO `train_stops` (`Train_Number`, `StationID`, `Stop_Sequence`, `Arrival_Time`, `Departure_Time`) VALUES
('NE101', 1, 1, '08:00:00', '08:00:00'),
('NE101', 5, 2, '08:20:00', '08:25:00'),
('NE101', 2, 3, '09:30:00', '09:35:00'),
('NE101', 3, 4, '11:00:00', '11:00:00'),
('AC201', 1, 1, '09:15:00', '09:15:00'),
('AC201', 4, 2, '12:30:00', '12:30:00');

INSERT INTO `employee` (`SSN`, `FirstName`, `LastName`, `Username`) VALUES 
(1001, 'Shaun', 'Mathew', 'shaun'),
(1002, 'Abin', 'Mathew', 'abin'),
(1003, 'Jason', 'Thomas', 'jason'),
(1004, 'Dan', 'Lelchitsky', 'dan');