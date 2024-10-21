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
) ENGINE=InnoDB AUTO_INCREMENT=190 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `component_packages`
--

LOCK TABLES `component_packages` WRITE;
/*!40000 ALTER TABLE `component_packages` DISABLE KEYS */;
INSERT INTO `component_packages` VALUES (90,6,2),(91,6,12),(92,6,7),(93,6,17),(94,13,2),(95,13,18),(96,13,3),(97,13,7),(98,13,15),(115,9,15),(116,8,2),(117,8,3),(118,8,15),(119,14,15),(120,2,2),(121,2,5),(122,2,3),(123,2,7),(124,3,7),(125,3,15),(131,15,2),(132,7,11),(133,7,7),(134,7,15),(135,7,17),(140,12,7),(141,12,15),(147,4,2),(148,4,5),(149,4,8),(150,4,3),(151,4,7),(152,4,15),(160,10,1),(161,10,3),(162,10,7),(163,10,15),(164,5,1),(165,5,6),(166,5,10),(167,5,11),(168,5,7),(169,5,15),(170,5,17),(171,1,1),(172,1,19),(173,1,4),(174,1,14),(175,1,13),(176,1,16),(177,1,6),(178,1,9),(179,1,10),(184,16,1),(185,16,4),(186,16,6),(187,16,9),(188,11,7),(189,11,15);
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

-- Dump completed on 2024-10-20 23:12:21
