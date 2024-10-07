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
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `component_packages`
--

LOCK TABLES `component_packages` WRITE;
/*!40000 ALTER TABLE `component_packages` DISABLE KEYS */;
INSERT INTO `component_packages` VALUES (9,2,2),(10,2,3),(11,2,5),(12,2,7),(14,4,2),(15,4,3),(16,4,7),(17,4,8),(19,6,2),(20,6,7),(21,6,12),(23,7,7),(24,7,11),(25,7,15),(26,8,15),(27,9,15),(28,10,12),(29,10,15),(30,11,12),(31,11,15),(32,12,11),(33,12,15),(34,13,18),(35,14,15),(36,3,6),(37,5,6),(38,1,1),(39,1,19),(40,1,4),(41,1,14),(42,1,13),(43,1,16),(44,1,9),(45,1,10),(49,6,17),(50,7,17);
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

-- Dump completed on 2024-10-06 23:50:56
