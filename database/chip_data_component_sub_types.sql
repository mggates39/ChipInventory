CREATE DATABASE  IF NOT EXISTS `chip_data` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `chip_data`;
-- MySQL dump 10.13  Distrib 8.0.36, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: chip_data
-- ------------------------------------------------------
-- Server version	8.0.39-0ubuntu0.22.04.1

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
-- Table structure for table `component_sub_types`
--

DROP TABLE IF EXISTS `component_sub_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `component_sub_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `component_type_id` int NOT NULL,
  `name` varchar(16) NOT NULL,
  `description` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `component_type_idx` (`component_type_id`),
  CONSTRAINT `component_sub_types_ibfk_1` FOREIGN KEY (`component_type_id`) REFERENCES `component_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `component_sub_types`
--

LOCK TABLES `component_sub_types` WRITE;
/*!40000 ALTER TABLE `component_sub_types` DISABLE KEYS */;
INSERT INTO `component_sub_types` VALUES (1,1,'7400','7400 series of chips'),(2,1,'5400','5400 series of chips'),(3,1,'4000','4000 series of chips'),(4,1,'Power','Power related chips'),(5,1,'Driver','Signal or bus driver chips'),(6,1,'Linear','Linear chips'),(7,1,'PIA','Peripheral Interface Adapter chips '),(8,1,'MPU','Micro Processor Unit chips'),(10,1,'Memory','Memory chips'),(11,1,'PIC','PIC Micro-controller'),(12,1,'UART','UART Support Chips'),(13,1,'MAX','Maxim Communication Line Driver Chips'),(14,1,'I2C','I2C Support chips'),(15,1,'Optical','Optical Support Chips'),(16,1,'Analog','Analog Support chips'),(17,2,'Ceramic','Ceramic Capacitor'),(18,2,'Film','Film Capacitor'),(19,2,'Tantalum','Polarized Tantalum Capacitor'),(20,2,'Polymer','Polymer Capacitor'),(21,2,'Electrolytic','Polarized Electrolytic Capacitor'),(22,2,'Super Cap','Polarized Super Capacitor'),(23,2,'Trimmer','Trimmer Capacitor'),(24,2,'Variable','Variable Capacitor'),(25,3,'Ceramic','Ceramic Capacitor'),(26,3,'Film','Thick Film Capacitor'),(27,3,'Poly','Polypropylene Capacitor'),(28,4,'Film','Film Resistor'),(29,4,'Variable','Variable Resistor'),(30,4,'Wire Wound','Wire Wound Resistor'),(31,4,'Carbon','Carbon Composite Resistor'),(32,4,'Photo','Photo Resistor'),(33,4,'Thermistor','Thermistor'),(34,5,'Carbon ','Carbon Composite Resistor'),(35,5,'Film','Film Resistor'),(36,1,'AVR','Atmel AVR MCU');
/*!40000 ALTER TABLE `component_sub_types` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-09 12:50:26