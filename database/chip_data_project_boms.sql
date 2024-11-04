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
-- Table structure for table `project_boms`
--

DROP TABLE IF EXISTS `project_boms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `project_boms` (
  `id` int NOT NULL AUTO_INCREMENT,
  `project_id` int NOT NULL,
  `number` int NOT NULL,
  `reference` text,
  `quantity` int NOT NULL,
  `part_number` varchar(128) DEFAULT NULL,
  `processed` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `project_bom_idx` (`project_id`),
  CONSTRAINT `project_bom_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_boms`
--

LOCK TABLES `project_boms` WRITE;
/*!40000 ALTER TABLE `project_boms` DISABLE KEYS */;
INSERT INTO `project_boms` VALUES (1,1,1,'',1,'100uF',1),(2,1,11,'',1,'Data Bus',1),(3,1,12,'',1,'PIA 2 Ports A and B',1),(4,1,3,'',2,'22pF',1),(5,1,2,'C2, C3, C4, C5, C6, C7, C8, C9, C10, C17, C18, C19, C20, C21, C22, C23',16,'0.1uF',1),(6,1,4,'',4,'10 uF',1),(7,1,5,'D1',1,'LED',1),(8,1,8,'J2',1,'DB9_Female',0),(9,1,6,'H1, H2, H3, H4',4,'MountingHole',0),(10,1,7,'J1',1,'USB3076-30-A',0),(11,1,9,'',1,'Ports A and E',1),(12,1,10,'',1,'PIA 1 Ports A and B',1),(13,1,13,'',1,'Address Bus',1),(14,1,14,'JP4',1,'BootSel',1),(15,1,15,'R1',1,'330',1),(16,1,16,'R2',1,'10M',1),(17,1,17,'RN1',1,'4.7 k',1),(18,1,18,'SW1',1,'Reset',0),(19,1,19,'U1',1,'MC68HC11A1CC-PLLC',1),(20,1,20,'U2, U17',2,'MC68B21',1),(21,1,21,'U3',1,'74HC373',1),(22,1,22,'U4',1,'74HC245',1),(23,1,23,'U5, U11',2,'74LS138',1),(24,1,24,'U6, U7, U16',3,'27C64',1),(25,1,25,'U8',1,'HM62256BLP',1),(26,1,26,'U9',1,'MAX232',1),(27,1,27,'U10',1,'MCP100-270D',1),(28,1,28,'U12',1,'74LS21',1),(29,1,29,'U13, U14',2,'74LS32',1),(30,1,30,'U15',1,'74LS04',1),(31,1,31,'Y1',1,'8.0 MHz',1);
/*!40000 ALTER TABLE `project_boms` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-03 22:10:29
