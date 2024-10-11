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
-- Table structure for table `inventory_dates`
--

DROP TABLE IF EXISTS `inventory_dates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_dates` (
  `id` int NOT NULL AUTO_INCREMENT,
  `inventory_id` int NOT NULL,
  `date_code` varchar(16) NOT NULL,
  `quantity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `inv_idx` (`inventory_id`),
  CONSTRAINT `inventory_dates_ibfk_1` FOREIGN KEY (`inventory_id`) REFERENCES `inventory` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=126 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_dates`
--

LOCK TABLES `inventory_dates` WRITE;
/*!40000 ALTER TABLE `inventory_dates` DISABLE KEYS */;
INSERT INTO `inventory_dates` VALUES (1,1,'92B509',3),(2,77,'M57AT',1),(3,77,'M34AF',1),(4,2,'9225',2),(5,3,'9313',1),(6,3,'9442',1),(7,4,'9248',7),(8,4,'9536',2),(9,5,'9218',3),(10,5,'9452',1),(11,6,'614DS',1),(12,7,'544DS',5),(13,7,'614DS',5),(14,8,'6803',1),(15,8,'6821',1),(16,8,'6823',3),(17,8,'6813',5),(18,9,'8815',1),(19,10,'8823',3),(21,15,'8718',1),(22,15,'8730',1),(23,16,'9509',3),(24,17,'8712',1),(25,18,'8613',1),(26,19,'9228',1),(27,20,'549BS',1),(28,21,'9030',3),(29,22,'601BT',2),(30,22,'614BS',3),(31,23,'8621',10),(32,24,'614AS',6),(33,25,'8620',2),(34,26,'9036',1),(35,27,'46AV',1),(36,28,'8617',1),(37,29,'8740',2),(38,30,'8621',1),(39,31,'8625',2),(40,32,'9503',3),(41,22,'610BS',3),(42,22,'605BT',1),(43,24,'618AS',2),(44,23,'8620',1),(45,25,'8613',2),(46,22,'535BT',1),(47,24,'549AT',2),(48,33,'9530',1),(49,34,'8536',1),(50,35,'9522',1),(51,36,'9542',1),(52,24,'601AT',1),(53,25,'6820',1),(54,37,'8525',1),(55,38,'9218',1),(56,39,'610BN',1),(57,40,'8452',1),(58,41,'8608',1),(59,42,'8613',3),(60,43,'610BT',1),(61,44,'9250',2),(62,43,'618BS',2),(63,43,'610BS',1),(64,45,'8621',8),(65,45,'8625',1),(66,46,'8449',3),(67,41,'8548',1),(68,47,'8604',1),(69,48,'9038',2),(70,49,'8610',1),(71,50,'9412',1),(72,36,'9562',1),(73,51,'9330',1),(74,52,'9505',1),(75,53,'8548',1),(76,54,'9344',1),(77,19,'9509',1),(78,47,'8624',1),(79,55,'8812',1),(80,56,'9130',1),(81,57,'535AT',1),(82,58,'9411',1),(83,59,'9530',1),(84,60,'903BS',3),(85,60,'931BS',1),(86,61,'544AP',1),(87,62,'9232',1),(88,63,'9352',1),(89,64,'9224',2),(90,65,'9318',4),(91,65,'9406',1),(92,65,'9442',6),(93,66,'9230',1),(94,67,'9352',2),(95,68,'8818',4),(96,69,'9349',1),(97,70,'8614',4),(98,71,'510C',1),(99,71,'514C',1),(100,71,'610CT',1),(101,7,'610DS',1),(102,72,'8601',3),(104,73,'8842',1),(105,74,'8818',3),(106,75,'8613',1),(107,7,'C26DS',1),(108,76,'8613',4),(109,76,'8612',3),(110,76,'8603',2),(111,76,'8623',7),(112,78,'8616',1),(113,79,'8812',2),(114,80,'605BT',3),(115,83,'8812',1),(116,84,'SU4470189',1),(117,84,'U12505P2',1),(118,85,'1649L',10),(119,86,'8817',1),(120,87,'8827',1),(121,88,'63CL44K',1),(122,89,'1918',5),(123,90,'2015',20),(124,91,'2020',20),(125,92,'2019',5);
/*!40000 ALTER TABLE `inventory_dates` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-11 18:24:46
