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
-- Table structure for table `aliases`
--

DROP TABLE IF EXISTS `aliases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `aliases` (
  `id` int NOT NULL AUTO_INCREMENT,
  `component_id` int NOT NULL,
  `alias_chip_number` varchar(32) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `component_idx` (`component_id`),
  CONSTRAINT `aliases_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `components` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aliases`
--

LOCK TABLES `aliases` WRITE;
/*!40000 ALTER TABLE `aliases` DISABLE KEYS */;
INSERT INTO `aliases` VALUES (2,258,'54HC4046A'),(3,258,'74HC4046A'),(4,258,'54HCT4046A'),(5,258,'74HCT4046A'),(7,20,'TL062'),(8,20,'TL072'),(16,246,'CD4051'),(18,61,'LM111'),(19,66,'AS6C4008'),(20,248,'UCN5800L'),(23,259,'P28F512'),(24,251,'SN74H87'),(26,245,'CD4053'),(28,90,'ATmega16'),(29,109,'LM158'),(30,109,'LM258'),(31,109,'LM2904'),(32,110,'PIC18F14K50'),(33,112,'ATmega164P'),(34,112,'ATmega324P'),(35,112,'ATmega1284P'),(39,125,'TL061'),(40,125,'TL071'),(41,134,'LM148'),(42,134,'LM248'),(43,140,'4N25M'),(44,140,'4N26M'),(45,140,'4N27M'),(46,140,'4N35'),(47,140,'4N36M'),(48,140,'4N37M'),(49,140,'H11A1M'),(50,140,'H11A2M'),(51,140,'H11A3M'),(52,140,'H11A4M'),(53,140,'H11A5M'),(54,254,'SN54LS382'),(55,254,'SN74LS382'),(56,147,'ATtiny4313'),(57,149,'LM101A'),(58,149,'LM201A'),(59,153,'7441'),(60,153,'K155ID1'),(64,253,'SN54LS381A'),(65,253,'SN54S381'),(66,253,'SN74LS381A'),(67,253,'SN74S381'),(68,166,'LM124'),(69,166,'LM224'),(70,256,'MC74HC4078'),(71,257,'SN54S182'),(72,257,'SN74S182'),(73,247,'CD4052'),(75,175,'LM193'),(76,175,'LM293'),(79,184,'ATTiny12V-1'),(80,184,'ATTiny12L-4'),(81,184,'ATTiny12-8'),(82,188,'ATtiny25'),(83,188,'ATtiny45'),(84,191,'HCPL2601'),(85,191,'HCPL2611'),(86,192,'LF147'),(88,202,'TL064'),(89,202,'TL074'),(94,6,'74LS138'),(95,6,'74AC138'),(103,212,'74LS32'),(104,212,'74HC32'),(118,52,'74HC245'),(119,178,'HM62256BLP'),(120,69,'74LS21'),(122,266,'54AS885'),(123,35,'SN5410'),(124,35,'SN54LS10'),(125,35,'SN54S10'),(126,35,'SN7410'),(127,35,'SN74LS10'),(128,35,'SN74S10'),(139,267,'54LS10'),(140,267,'54S10'),(142,159,'CDP1802A'),(143,159,'CDP1802AC'),(144,159,'CDP1802BC'),(147,116,'W65C22'),(148,181,'68A09E'),(149,181,'68B09E'),(150,2,'82C54'),(151,171,'82C55A'),(152,210,'TLC7528'),(153,87,'ADC0809'),(154,217,'Z84C20'),(155,124,'68A21'),(156,124,'68B21'),(157,255,'DS8921A'),(158,255,'DS8921AT'),(159,7,'YM2149'),(160,208,'SID'),(161,56,'MAX1044'),(162,197,'PCF8574P'),(163,84,'SN75469'),(164,68,'TMS9929A'),(165,204,'ULN2002'),(166,204,'ULN2004'),(175,25,'24AA256'),(176,25,'24FC256'),(177,80,'16C550'),(178,59,'74LS04'),(180,99,'74HC373'),(182,286,'SMJ2532'),(183,292,'29FTC520'),(184,302,'28C256'),(185,302,'28HC256'),(198,31,'ATmega48'),(199,31,'ATmega88'),(200,31,'ATmega328P');
/*!40000 ALTER TABLE `aliases` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-27  2:24:50
