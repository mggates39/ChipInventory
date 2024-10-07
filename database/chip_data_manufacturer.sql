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
-- Table structure for table `manufacturer`
--

DROP TABLE IF EXISTS `manufacturer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manufacturer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=139 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `manufacturer`
--

LOCK TABLES `manufacturer` WRITE;
/*!40000 ALTER TABLE `manufacturer` DISABLE KEYS */;
INSERT INTO `manufacturer` VALUES (2,'Advanced Micro Devices'),(3,'Advanced Monolithic Systems'),(4,'AEG'),(5,'Allegro Microsystems'),(6,'Altera'),(7,'AMD'),(8,'Amperex'),(9,'Amtel'),(10,'Analog Devices'),(11,'Analog Systems'),(12,'Apex'),(13,'Atmel'),(14,'Benchmarq Microelectronics Inc.'),(15,'Brooktree'),(16,'Burr-Brown'),(17,'California Micro Devices Corp.'),(18,'Comlinear'),(19,'Cypress'),(20,'Dallas Semiconductor'),(21,'Datel'),(22,'EG&G Reticon'),(23,'Elantec'),(24,'Epson'),(25,'Ericsson'),(26,'ESMF'),(27,'Exar'),(28,'Fairchild'),(29,'Ferranti'),(30,'Fujitsu'),(31,'Gazelle'),(32,'GE'),(33,'GEC-Plessey Semiconductor'),(34,'General Instrument'),(35,'Goldstar'),(36,'Harris'),(37,'Harris, Cherry Semiconductor'),(38,'Harris, Temic'),(39,'Hewlett-Packard'),(40,'Hitachi'),(41,'Holtek'),(42,'Honeywell'),(43,'Hyundai'),(44,'IC Works'),(45,'Information Chips and Technology Inc.'),(46,'Information Strorage Devices'),(47,'Inmos'),(48,'Integrated Device Technology'),(49,'Integrated Silicon Solutions Inc.'),(50,'Intel'),(51,'International Rectifier'),(52,'ITT'),(53,'Lattice'),(54,'Linear Technology Corporation'),(55,'LSI Computer Systems'),(56,'Lucent Technologies'),(57,'M. S. Kennedy'),(58,'Macronix'),(59,'Marconi'),(60,'Maxim'),(61,'Micra Hybrids'),(62,'Micrel'),(63,'Micro Linear Corp.'),(64,'Micro Networks'),(65,'Micro Power (Exar)'),(66,'Microchip'),(67,'Microcomputers Systems Components'),(68,'Microsystems International'),(69,'Mitel Semiconductor'),(70,'Mitsubishi'),(71,'Monolithics'),(72,'MOS Technology'),(73,'Mostek'),(74,'Motorola'),(75,'National Semiconductor'),(76,'NEC'),(77,'New Japanese Radio Corp.'),(78,'Newport'),(79,'Nippon Precision Circuits'),(80,'Nitron'),(81,'Oki'),(82,'ON Semiconductor'),(83,'ON Semiconductor (previously Thomson)'),(84,'ON Semiconductor (previously Thomson))'),(85,'Optek'),(86,'Optical Electronics Inc.'),(87,'Panasonic'),(88,'Paradigm'),(89,'Performance Semiconductor'),(90,'Philips'),(91,'Plessy'),(92,'Precision Monolithic'),(93,'Quality Semiconductor Inc.'),(94,'Raytheon'),(95,'Rockwell'),(96,'Samsung'),(97,'Sanyo'),(98,'Seeq'),(99,'Seiko'),(100,'Sharp'),(101,'Siemens'),(102,'Silicon General (Infinity Micro)'),(103,'Silicon Storage Technology'),(104,'Siliconix'),(105,'Siliconix, Intel'),(106,'Siltronics'),(107,'Sony'),(108,'Sony, Cyrix'),(109,'Sprague'),(110,'Standard Microsystem Corp.'),(111,'Startech'),(112,'Supertex, Temic'),(113,'Syntaq'),(114,'Taytheon'),(115,'Telcom Semiconductor'),(116,'Teledyne Philbrick'),(117,'Teledyne Semiconductor'),(118,'Telefunken'),(119,'Telmos'),(120,'Temic'),(121,'Temic, Seagate Microelectronics'),(122,'TESLA'),(123,'Texas Instruments'),(124,'Toshiba'),(125,'TRW'),(126,'United Microelectronics Corp.'),(127,'Unitrode'),(128,'US Microchip'),(129,'Vantis (AMD)'),(130,'VLSI Technology Inc.'),(131,'VTC'),(132,'Waferscale Integration inc. (WSI)'),(133,'Western Digital'),(134,'Xicor'),(135,'Zentrum Microelectronics'),(136,'Zetex'),(137,'Zilog'),(138,'Signetics Corporation (NPX)');
/*!40000 ALTER TABLE `manufacturer` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-06 23:50:57
