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
-- Table structure for table `list_entries`
--

DROP TABLE IF EXISTS `list_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `list_entries` (
  `id` int NOT NULL AUTO_INCREMENT,
  `list_id` int NOT NULL,
  `sequence` int NOT NULL,
  `name` varchar(16) NOT NULL,
  `description` varchar(32) NOT NULL,
  `modifier_value` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `list_idx` (`list_id`),
  CONSTRAINT `list_ibfk_1` FOREIGN KEY (`list_id`) REFERENCES `lists` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `list_entries`
--

LOCK TABLES `list_entries` WRITE;
/*!40000 ALTER TABLE `list_entries` DISABLE KEYS */;
INSERT INTO `list_entries` VALUES (1,1,1,'pF','pico-farad',-12),(2,1,2,'nF','nano-farad',-9),(3,1,3,'&micro;F','micro-farad',-6),(4,1,4,'mF','milli-farad',-3),(5,1,5,'F','farad',0),(6,2,1,'&Omega;','Ohm',0),(7,2,2,'k&Omega;','Kilo-Ohm',3),(8,2,2,'M&Omega;','Mega-Ohm',6);
/*!40000 ALTER TABLE `list_entries` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-18 22:37:46
