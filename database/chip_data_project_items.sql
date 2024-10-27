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
-- Table structure for table `project_items`
--

DROP TABLE IF EXISTS `project_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `project_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `project_id` int NOT NULL,
  `number` int NOT NULL,
  `component_id` int NOT NULL,
  `qty_needed` int NOT NULL,
  `inventory_id` int DEFAULT NULL,
  `qty_available` int DEFAULT NULL,
  `qty_to_order` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `project_idx` (`project_id`),
  KEY `prjct_itm_comp_idx` (`component_id`),
  KEY `prjct_itm_invp_idx` (`inventory_id`),
  CONSTRAINT `prjct_itm_comp_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `components` (`id`),
  CONSTRAINT `prjct_itm_inv_ibfk_1` FOREIGN KEY (`inventory_id`) REFERENCES `inventory` (`id`),
  CONSTRAINT `project_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_items`
--

LOCK TABLES `project_items` WRITE;
/*!40000 ALTER TABLE `project_items` DISABLE KEYS */;
INSERT INTO `project_items` VALUES (4,1,1,281,1,94,1,0),(5,1,3,283,2,96,2,0),(6,1,4,282,4,95,4,0),(7,1,9,293,1,108,1,0),(8,1,10,293,1,108,1,0),(9,1,11,294,1,109,1,0),(10,1,13,293,1,108,1,0),(11,1,12,293,1,108,1,0),(12,1,15,274,1,90,1,0),(13,1,16,276,1,91,1,0),(14,1,17,277,1,92,1,0),(15,1,20,124,2,110,2,0),(16,1,21,99,1,99,1,0),(17,1,22,52,1,58,1,0),(18,1,24,261,3,85,3,0),(19,1,25,178,1,111,1,0),(20,1,26,3,1,114,1,0),(21,1,23,6,2,117,2,0),(22,1,28,69,1,115,1,0),(23,1,29,212,2,116,2,0),(24,1,30,59,1,97,1,0),(25,1,31,268,1,89,1,0),(26,1,2,280,16,93,16,0),(27,1,5,296,1,118,1,0),(28,1,19,297,1,119,1,0),(29,1,32,289,4,104,4,0),(30,1,33,285,4,100,4,0),(31,1,34,288,2,103,2,0),(32,1,14,301,1,120,1,0);
/*!40000 ALTER TABLE `project_items` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-27  2:24:52
