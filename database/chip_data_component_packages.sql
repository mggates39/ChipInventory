CREATE DATABASE  IF NOT EXISTS `chip_data` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `chip_data`;
-- MySQL dump 10.13  Distrib 8.0.36, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: chip_data
-- ------------------------------------------------------
-- Server version	8.0.40-0ubuntu0.24.04.1

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
-- Table structure for table `component_packages`
--

DROP TABLE IF EXISTS `component_packages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `component_packages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `component_type_id` int NOT NULL,
  `package_type_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `type_component_type_idx` (`component_type_id`),
  KEY `type_package_type_idx` (`package_type_id`),
  CONSTRAINT `component_packages_ibfk_1` FOREIGN KEY (`component_type_id`) REFERENCES `component_types` (`id`),
  CONSTRAINT `component_packages_ibfk_2` FOREIGN KEY (`package_type_id`) REFERENCES `package_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=235 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `component_packages`
--

LOCK TABLES `component_packages` WRITE;
/*!40000 ALTER TABLE `component_packages` DISABLE KEYS */;
INSERT INTO `component_packages` VALUES (94,13,2),(95,13,18),(96,13,3),(97,13,7),(98,13,15),(115,9,15),(116,8,2),(117,8,3),(118,8,15),(119,14,15),(120,2,2),(121,2,5),(122,2,3),(123,2,7),(131,15,2),(147,4,2),(148,4,5),(149,4,8),(150,4,3),(151,4,7),(152,4,15),(161,10,3),(162,10,7),(163,10,15),(165,5,6),(166,5,10),(167,5,11),(168,5,7),(169,5,15),(170,5,17),(185,16,4),(186,16,6),(187,16,9),(190,6,2),(191,6,3),(192,6,12),(193,6,7),(194,6,17),(201,11,6),(202,11,7),(203,11,15),(204,12,6),(205,12,7),(206,12,15),(211,3,6),(212,3,7),(213,3,15),(214,3,1),(215,10,1),(217,5,1),(218,16,1),(223,1,1),(224,1,19),(225,1,4),(226,1,14),(227,1,13),(228,1,16),(229,1,6),(230,1,9),(231,1,10),(232,1,17),(233,7,11),(234,7,17);
/*!40000 ALTER TABLE `component_packages` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-19 11:53:06
