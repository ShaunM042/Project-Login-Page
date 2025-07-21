-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: reservation
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `answers`
--

DROP TABLE IF EXISTS `answers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `answers`
--

LOCK TABLES `answers` WRITE;
/*!40000 ALTER TABLE `answers` DISABLE KEYS */;
INSERT INTO `answers` VALUES (4613,7372,'chris1','No has to be by credit card','2025-07-20 21:35:42'),(6565,5225,'abin','you can bring 1 suitcase per ticket holder','2025-07-20 17:38:00');
/*!40000 ALTER TABLE `answers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (2,'james','James John','james@gmail.com','4 sussex lane',NULL,NULL,NULL),(3,'mathew','Mathew John','mathew@gmail.com','7 Willow Lane',NULL,NULL,NULL),(500,'jason1','Jason L.','jason@gmail.com','jason street',NULL,NULL,NULL),(2001,'chris','Chris John','chris@gmail.com','123 Main St, NY','555-1234','1990-05-15','pass123'),(5002,'mike','Michael Jackson','Michael@gmail.com','10 Willow Lane',NULL,NULL,NULL),(5003,'rdj','RDJ','rdj@gmail.com','rdj lane',NULL,NULL,NULL),(40021,'nik1','Nicholas','nick@gmail.gom','some street',NULL,NULL,NULL),(500345,'abin1','Abin Mathew','abinmathew2004@gmail.com','4 sussex lane',NULL,NULL,NULL);
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `discounts`
--

DROP TABLE IF EXISTS `discounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `discounts` (
  `DiscountID` int NOT NULL AUTO_INCREMENT,
  `Type` enum('child','senior','disabled') NOT NULL,
  `Percentage` decimal(5,2) NOT NULL,
  PRIMARY KEY (`DiscountID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discounts`
--

LOCK TABLES `discounts` WRITE;
/*!40000 ALTER TABLE `discounts` DISABLE KEYS */;
INSERT INTO `discounts` VALUES (1,'child',50.00),(2,'senior',25.00),(3,'disabled',25.00),(4,'child',50.00),(5,'senior',25.00),(6,'disabled',25.00);
/*!40000 ALTER TABLE `discounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee` (
  `SSN` int NOT NULL,
  `FirstName` varchar(50) DEFAULT NULL,
  `LastName` varchar(50) DEFAULT NULL,
  `Username` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`SSN`),
  KEY `Username` (`Username`),
  CONSTRAINT `employee_ibfk_1` FOREIGN KEY (`Username`) REFERENCES `users` (`Username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES (1001,'Shaun','Mathew','shaun'),(1002,'Abin','Mathew','abin'),(1003,'Jason','Thomas','jason'),(1004,'Dan','Lelchitsky','dan'),(400789,'Chris','Evans','chris1');
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questions`
--

DROP TABLE IF EXISTS `questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `questions` (
  `QID` int NOT NULL,
  `AskedBy` varchar(50) DEFAULT NULL,
  `Question` text,
  `DateAsked` datetime DEFAULT NULL,
  PRIMARY KEY (`QID`),
  KEY `AskedBy` (`AskedBy`),
  CONSTRAINT `questions_ibfk_1` FOREIGN KEY (`AskedBy`) REFERENCES `users` (`Username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questions`
--

LOCK TABLES `questions` WRITE;
/*!40000 ALTER TABLE `questions` DISABLE KEYS */;
INSERT INTO `questions` VALUES (2055,'abin1','Hello is anyone here?','2025-07-20 20:37:44'),(2444,'jason1','Is there a grace period for cancellation','2025-07-20 20:30:39'),(5225,'chris','Hello, How many suitcases can I bring?','2025-07-20 13:11:28'),(6414,'rdj','Can I bring my child if I only have one ticket?','2025-07-20 20:20:22'),(7372,'nik1','Hello,\r\nCan I pay the money in cash?','2025-07-20 21:30:32');
/*!40000 ALTER TABLE `questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservation`
--

DROP TABLE IF EXISTS `reservation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservation` (
  `Reservation_Num` int NOT NULL AUTO_INCREMENT,
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
) ENGINE=InnoDB AUTO_INCREMENT=936500 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservation`
--

LOCK TABLES `reservation` WRITE;
/*!40000 ALTER TABLE `reservation` DISABLE KEYS */;
INSERT INTO `reservation` VALUES (144371,'james','NE101','NE101','New York Penn Station','Washington Union Station','2025-07-20 00:00:00','2025-07-20',4,'adult',0,358.00),(177619,'james','NEC302','NEC302','New York Penn Station','Newark Penn Station','2025-07-21 00:00:00','2025-07-20',1,'senior',0,26.25),(372050,'james','NEP403','NEP403','Philadelphia 30th Street','New York Penn Station','2025-07-22 00:00:00','2025-07-20',3,'adult',1,300.00),(418941,'chris','NE101','NE101','New York Penn Station','Washington Union Station','2025-07-20 00:00:00','2025-07-20',2,'adult',0,179.00),(480425,'james','AC201','AC201','New York Penn Station','Boston South Station','2025-07-20 00:00:00','2025-07-20',2,'adult',1,980.00),(537354,'abin1','NEP401','NEP401','New York Penn Station','Philadelphia 30th Street','2025-07-22 00:00:00','2025-07-20',1,'adult',0,50.00),(601326,'jason1','NEP401','NEP401','New York Penn Station','Philadelphia 30th Street','2025-07-22 00:00:00','2025-07-20',1,'adult',1,100.00),(693408,'nik1','NE101','NE101','New York Penn Station','Washington Union Station','2025-07-20 00:00:00','2025-07-20',1,'adult',1,179.00),(718754,'james','NE101','NE101','New York Penn Station','Washington Union Station','2025-07-21 00:00:00','2025-07-20',1,'disabled',0,73.13),(903993,'chris','NE102','NE102','Washington Union Station','New York Penn Station','2025-07-23 00:00:00','2025-07-20',3,'adult',0,276.00),(934185,'rdj','NE101','NE101','New York Penn Station','Washington Union Station','2025-07-20 00:00:00','2025-07-20',1,'adult',1,179.00);
/*!40000 ALTER TABLE `reservation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `station`
--

DROP TABLE IF EXISTS `station`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `station` (
  `StationID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) DEFAULT NULL,
  `City` varchar(50) DEFAULT NULL,
  `State` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`StationID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `station`
--

LOCK TABLES `station` WRITE;
/*!40000 ALTER TABLE `station` DISABLE KEYS */;
INSERT INTO `station` VALUES (1,'New York Penn Station','New York','NY'),(2,'Philadelphia 30th Street','Philadelphia','PA'),(3,'Washington Union Station','Washington','DC'),(4,'Boston South Station','Boston','MA'),(5,'Newark Penn Station','Newark','NJ'),(6,'New York Penn Station','New York','NY'),(7,'Philadelphia 30th Street','Philadelphia','PA'),(8,'Washington Union Station','Washington','DC'),(9,'Boston South Station','Boston','MA'),(10,'Newark Penn Station','Newark','NJ');
/*!40000 ALTER TABLE `station` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `train`
--

DROP TABLE IF EXISTS `train`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `train` (
  `TrainID` int NOT NULL,
  `Transit_Line_Name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`TrainID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `train`
--

LOCK TABLES `train` WRITE;
/*!40000 ALTER TABLE `train` DISABLE KEYS */;
/*!40000 ALTER TABLE `train` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `train_schedule`
--

DROP TABLE IF EXISTS `train_schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `train_schedule` (
  `ScheduleID` int NOT NULL AUTO_INCREMENT,
  `Train_Number` varchar(50) DEFAULT NULL,
  `Transit_Line_Name` varchar(50) DEFAULT NULL,
  `Origin_Station` varchar(50) DEFAULT NULL,
  `Destination_Station` varchar(50) DEFAULT NULL,
  `Travel_Date` date DEFAULT NULL,
  `Departure_Time` time DEFAULT NULL,
  `Arrival_Time` time DEFAULT NULL,
  `Number_of_Stops` int DEFAULT NULL,
  `Fare` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`ScheduleID`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `train_schedule`
--

LOCK TABLES `train_schedule` WRITE;
/*!40000 ALTER TABLE `train_schedule` DISABLE KEYS */;
INSERT INTO `train_schedule` VALUES (1,'NE101','Northeast Regional','New York Penn Station','Washington Union Station','2025-07-20','08:00:00','12:00:00',2,99.50),(2,'NE102','Northeast Regional','Washington Union Station','New York Penn Station','2025-07-20','08:00:00','12:00:00',2,99.50),(3,'AC201','Acela Express','New York Penn Station','Boston South Station','2025-07-20','08:00:00','12:00:00',0,275.00),(4,'AC202','Acela Express','Boston South Station','New York Penn Station','2025-07-20','08:00:00','12:00:00',0,275.00),(5,'NE101','Northeast Regional','New York Penn Station','Washington Union Station','2025-07-20','16:00:00','20:00:00',2,89.50),(6,'NE102','Northeast Regional','Washington Union Station','New York Penn Station','2025-07-20','16:00:00','20:00:00',2,89.50),(7,'AC201','Acela Express','New York Penn Station','Boston South Station','2025-07-20','16:00:00','20:00:00',0,245.00),(8,'AC202','Acela Express','Boston South Station','New York Penn Station','2025-07-20','16:00:00','20:00:00',0,245.00),(9,'NE101','Northeast Regional','New York Penn Station','Washington Union Station','2025-07-21','07:45:00','11:45:00',2,97.50),(10,'NE102','Northeast Regional','Washington Union Station','New York Penn Station','2025-07-21','12:15:00','16:15:00',2,97.50),(11,'AC201','Acela Express','New York Penn Station','Boston South Station','2025-07-21','08:30:00','12:00:00',0,255.00),(12,'AC202','Acela Express','Boston South Station','New York Penn Station','2025-07-21','13:45:00','17:15:00',0,255.00),(13,'NE101','Northeast Regional','New York Penn Station','Washington Union Station','2025-07-22','08:00:00','12:00:00',2,90.00),(14,'NE102','Northeast Regional','Washington Union Station','New York Penn Station','2025-07-22','12:30:00','16:30:00',2,90.00),(15,'AC201','Acela Express','New York Penn Station','Boston South Station','2025-07-22','09:00:00','12:45:00',0,270.00),(16,'AC202','Acela Express','Boston South Station','New York Penn Station','2025-07-22','14:00:00','17:30:00',0,270.00),(17,'NE101','Northeast Regional','New York Penn Station','Washington Union Station','2025-07-23','07:00:00','11:00:00',2,92.00),(18,'NE102','Northeast Regional','Washington Union Station','New York Penn Station','2025-07-23','13:00:00','17:00:00',2,92.00),(19,'AC201','Acela Express','New York Penn Station','Boston South Station','2025-07-23','08:15:00','11:45:00',0,260.00),(20,'AC202','Acela Express','Boston South Station','New York Penn Station','2025-07-23','14:30:00','18:00:00',0,260.00),(21,'NEC301','Northeast Corridor','Newark Penn Station','New York Penn Station','2025-07-21','08:30:00','08:55:00',0,50.00),(22,'NEC301','Northeast Corridor','Newark Penn Station','New York Penn Station','2025-07-21','16:30:00','16:55:00',0,35.00),(23,'NEC302','Northeast Corridor','New York Penn Station','Newark Penn Station','2025-07-21','16:30:00','16:55:00',0,35.00),(24,'NEC302','Northeast Corridor','New York Penn Station','Newark Penn Station','2025-07-21','08:30:00','08:55:00',0,25.00),(25,'NEP401','Northeast Regional','New York Penn Station','Philadelphia 30th Street','2025-07-22','08:00:00','09:20:00',1,50.00),(26,'NEP402','Northeast Regional','New York Penn Station','Philadelphia 30th Street','2025-07-22','18:00:00','19:20:00',1,35.00),(27,'NEP403','Northeast Regional','Philadelphia 30th Street','New York Penn Station','2025-07-22','08:00:00','09:20:00',1,50.00),(28,'NEP404','Northeast Regional','Philadelphia 30th Street','New York Penn Station','2025-07-22','18:00:00','19:20:00',1,35.00),(29,'NEP404','Northeast Regional','Philadelphia 30th Street','New York Penn Station','2025-07-25','19:53:00','20:53:00',1,35.00),(30,'NEC302','Northeast Corridor	','New York Penn Station	','Newark Penn Station	','2025-07-21','20:02:00','21:02:00',2,75.00),(31,'NEP405','Northeast Regional','New York Penn Station','Philadelphia 30th Street','2025-07-22','08:00:00','09:10:00',0,60.00),(36,'NEP404','Northeast Regional','New York Penn Station','Philadelphia 30th Street','2025-07-24','20:21:00','21:21:00',0,30.00);
/*!40000 ALTER TABLE `train_schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `train_stops`
--

DROP TABLE IF EXISTS `train_stops`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `train_stops`
--

LOCK TABLES `train_stops` WRITE;
/*!40000 ALTER TABLE `train_stops` DISABLE KEYS */;
INSERT INTO `train_stops` VALUES (1,'NE101',1,1,'08:00:00','08:00:00'),(2,'NE101',5,2,'08:20:00','08:25:00'),(3,'NE101',2,3,'09:30:00','09:35:00'),(4,'NE101',3,4,'11:00:00','11:00:00'),(5,'AC201',1,1,'09:15:00','09:15:00'),(6,'AC201',4,2,'12:30:00','12:30:00'),(13,'NE102',3,1,'08:00:00','08:00:00'),(14,'NE102',5,2,'08:20:00','08:25:00'),(15,'NE102',2,3,'09:30:00','09:35:00'),(16,'NE102',1,4,'12:00:00','12:00:00'),(17,'AC202',4,1,'09:15:00','09:15:00'),(18,'AC202',1,2,'13:00:00','13:00:00'),(19,'NEC301',5,1,NULL,'08:30:00'),(20,'NEC301',1,2,'08:55:00',NULL),(21,'NEC302',1,1,NULL,'08:30:00'),(22,'NEC302',5,2,'08:55:00',NULL),(23,'NEP401',1,1,NULL,'08:00:00'),(24,'NEP401',5,2,'08:40:00','08:42:00'),(25,'NEP401',2,3,'09:20:00',NULL),(26,'NEP402',1,1,NULL,'18:00:00'),(27,'NEP402',5,2,'18:40:00','18:42:00'),(28,'NEP402',2,3,'19:20:00',NULL),(29,'NEP403',2,1,NULL,'08:00:00'),(30,'NEP403',5,2,'08:40:00','08:42:00'),(31,'NEP403',1,3,'09:20:00',NULL),(32,'NEP404',2,1,NULL,'18:00:00'),(33,'NEP404',5,2,'18:40:00','18:42:00'),(34,'NEP404',1,3,'19:20:00',NULL);
/*!40000 ALTER TABLE `train_stops` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `Username` varchar(50) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `Role` enum('customer','admin','rep') DEFAULT 'customer',
  PRIMARY KEY (`Username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('abin','password2','rep'),('abin1','pass','customer'),('admin','admin123','admin'),('chris','pass','customer'),('chris1','pass','rep'),('dan','password4','rep'),('james','pass1','customer'),('jason','password3','rep'),('jason1','pass','customer'),('mathew','pass','customer'),('mike','pass','customer'),('nik1','pass','customer'),('rdj','pass','customer'),('shaun','password1','rep');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-20 21:49:49
