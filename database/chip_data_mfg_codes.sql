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
-- Table structure for table `mfg_codes`
--

DROP TABLE IF EXISTS `mfg_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mfg_codes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `manufacturer_id` int NOT NULL,
  `mfg_code` varchar(16) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `mfg_idx` (`manufacturer_id`),
  CONSTRAINT `mfg_codes_ibfk_1` FOREIGN KEY (`manufacturer_id`) REFERENCES `manufacturer` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=481 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mfg_codes`
--

LOCK TABLES `mfg_codes` WRITE;
/*!40000 ALTER TABLE `mfg_codes` DISABLE KEYS */;
INSERT INTO `mfg_codes` VALUES (1,2,'AM'),(2,3,'AMSREF'),(3,4,'OM'),(4,4,'PCD'),(5,4,'PCF'),(6,4,'SAA'),(7,4,'SAB'),(8,4,'SAF'),(9,4,'SCB'),(10,4,'SCN'),(11,4,'TAA'),(12,4,'TBA'),(13,4,'TCA'),(14,4,'TEA'),(15,5,'A'),(16,5,'STR'),(17,5,'UCN'),(18,5,'UDN'),(19,5,'UDS'),(20,5,'UGN'),(21,6,'EP'),(22,6,'EPM'),(23,6,'PL'),(24,7,'A'),(25,7,'Am'),(26,7,'AMPAL'),(27,7,'PAL'),(28,8,'OM'),(29,8,'PCD'),(30,8,'PCF'),(31,8,'SAA'),(32,8,'SAB'),(33,8,'SAF'),(34,8,'SCB'),(35,8,'SCN'),(36,8,'TAA'),(37,8,'TBA'),(38,8,'TCA'),(39,8,'TEA'),(40,9,'V'),(41,10,'AD'),(42,10,'ADEL'),(43,10,'ADG'),(44,10,'ADLH'),(45,10,'ADM'),(46,10,'ADVFC'),(47,10,'AMP'),(48,10,'BUF'),(49,10,'CAV'),(50,10,'CMP'),(51,10,'DAC'),(52,10,'HAS'),(53,10,'HDM'),(54,10,'MUX'),(55,10,'OP'),(56,10,'PM'),(57,10,'REF'),(58,10,'SSM'),(59,10,'SW'),(60,11,'MA'),(61,12,'PA'),(62,13,'AT'),(63,13,'ATV'),(64,14,'BQ'),(65,15,'BT'),(66,16,'ADS'),(67,16,'ALD'),(68,16,'BUF'),(69,16,'DAC'),(70,16,'DCP'),(71,16,'INA'),(72,16,'IS'),(73,16,'ISO'),(74,16,'IVC'),(75,16,'MPC'),(76,16,'MPY'),(77,16,'OPA'),(78,16,'OPT'),(79,16,'PCM'),(80,16,'PGA'),(81,16,'PWR'),(82,16,'RCV'),(83,16,'REF'),(84,16,'REG'),(85,16,'SHC'),(86,16,'UAF'),(87,16,'VCA'),(88,16,'VFC'),(89,16,'XTR'),(90,17,'G'),(91,18,'CLC'),(92,19,'CY'),(93,19,'PALCE'),(94,20,'DS'),(95,21,'AM'),(96,22,'RD'),(97,22,'RF'),(98,22,'RM'),(99,22,'RT'),(100,22,'RU'),(101,23,'EL'),(102,24,'RTC'),(103,25,'PBL'),(104,26,'SFC'),(105,27,'XR'),(106,28,'A'),(107,28,'DM'),(108,28,'F'),(109,28,'L'),(110,28,'MM'),(111,28,'NM'),(112,28,'NMC'),(113,28,'UNX'),(114,29,'FSS'),(115,29,'ZLD'),(116,29,'ZN'),(117,30,'MB'),(118,30,'MBL8'),(119,30,'MBM'),(120,31,'GA'),(121,32,'GEL'),(122,33,'MVA'),(123,33,'ZN'),(124,34,'ACF'),(125,34,'AY'),(126,34,'GIC'),(127,34,'GP'),(128,34,'SPR'),(129,35,'GL'),(130,35,'GM'),(131,35,'GMM'),(132,36,'AD'),(133,36,'CA'),(134,36,'CD'),(135,36,'CDP'),(136,36,'CP'),(137,36,'H'),(138,36,'HA'),(139,36,'HFA'),(140,36,'HI'),(141,36,'HIN'),(142,36,'HIP'),(143,36,'HV'),(144,36,'ICH'),(145,36,'ICL'),(146,36,'ICM'),(147,36,'IM'),(148,37,'CS'),(149,38,'DG'),(150,39,'HCPL'),(151,39,'HCTL'),(152,39,'HPM'),(153,40,'HA'),(154,40,'HD'),(155,40,'HG'),(156,40,'HL'),(157,40,'HM'),(158,40,'HN'),(159,41,'HT'),(160,42,'HAD'),(161,42,'HDAC'),(162,42,'SS'),(163,43,'HY'),(164,44,'W'),(165,45,'PEEL'),(166,46,'ISD'),(167,47,'IMS'),(168,48,'IDT'),(169,49,'IS'),(170,50,'C'),(171,50,'i'),(172,50,'I'),(173,50,'N'),(174,50,'P'),(175,50,'PA'),(176,51,'IR'),(177,52,'ITT'),(178,53,'GAL'),(179,53,'ISPLSI'),(180,54,'LT'),(181,54,'LTC'),(182,54,'LTZ'),(183,55,'LS'),(184,56,'ATT'),(185,57,'MSK'),(186,58,'MX'),(187,59,'MA'),(188,60,'MAX'),(189,60,'MX'),(190,60,'SI'),(191,61,'MC'),(192,62,'MIC'),(193,63,'ML'),(194,64,'MN'),(195,65,'MP'),(196,66,'PIC'),(197,67,'MSC'),(198,68,'MIL'),(199,69,'MT'),(200,70,'M'),(201,70,'MSL8'),(202,71,'CMP'),(203,71,'MAT'),(204,71,'OP'),(205,71,'SSS'),(206,72,'MCS'),(207,73,'MK'),(208,74,'HEP'),(209,74,'LF'),(210,74,'MC'),(211,74,'MCC'),(212,74,'MCCS'),(213,74,'MCM'),(214,74,'MCT'),(215,74,'MEC'),(216,74,'MM'),(217,74,'MPF'),(218,74,'MPQ'),(219,74,'MPS'),(220,74,'MPSA'),(221,74,'MWM'),(222,74,'SG'),(223,74,'SN'),(224,74,'TDA'),(225,74,'TL'),(226,74,'UA'),(227,74,'UAA'),(228,74,'UC'),(229,74,'ULN'),(230,74,'XC'),(231,75,'A'),(232,75,'ADC'),(233,75,'CLC'),(234,75,'COP'),(235,75,'DAC'),(236,75,'DM'),(237,75,'DP'),(238,75,'DS'),(239,75,'F'),(240,75,'L'),(241,75,'LF'),(242,75,'LFT'),(243,75,'LH'),(244,75,'LM'),(245,75,'LMC'),(246,75,'LMD'),(247,75,'LMF'),(248,75,'LMX'),(249,75,'LPC'),(250,75,'LPC'),(251,75,'MF'),(252,75,'MM'),(253,75,'NH'),(254,75,'UNX'),(255,76,'PB'),(256,76,'PC'),(257,76,'PD'),(258,76,'UPD'),(259,76,'UPD8'),(260,77,'NJM'),(261,78,'NSC'),(262,79,'SM'),(263,80,'NC'),(264,81,'MM'),(265,81,'MSM'),(266,82,'MC'),(267,83,'EF'),(268,83,'ET'),(269,83,'GSD'),(270,83,'HCF'),(271,83,'L'),(272,83,'LM'),(273,83,'LS'),(274,83,'M'),(275,83,'MC'),(276,83,'MK'),(277,83,'OM'),(278,83,'PCD'),(279,83,'PCF'),(280,83,'SAA'),(281,83,'SAB'),(282,83,'SAF'),(283,83,'SCB'),(284,83,'SCN'),(285,83,'SFC'),(286,83,'SG'),(287,83,'ST'),(288,83,'TAA'),(289,83,'TBA'),(290,83,'TCA'),(291,83,'TD'),(292,83,'TDA'),(293,83,'TDF'),(294,83,'TEA'),(295,83,'TL'),(296,83,'TS'),(297,83,'TSH'),(298,83,'UC'),(299,83,'ULN'),(300,84,'AVS'),(301,85,'OHN'),(302,86,'AH'),(303,87,'AN'),(304,88,'PDM'),(305,89,'P'),(306,90,'HEF'),(307,90,'MAB'),(308,90,'N'),(309,90,'NE'),(310,90,'OM'),(311,90,'PC'),(312,90,'PCD'),(313,90,'PCF'),(314,90,'PLC'),(315,90,'PLS'),(316,90,'PZ'),(317,90,'S'),(318,90,'SA'),(319,90,'SAA'),(320,90,'SAB'),(321,90,'SAF'),(322,90,'SC'),(323,90,'SCB'),(324,90,'SCC'),(325,90,'SCN'),(326,90,'SE'),(327,90,'SP'),(328,90,'TAA'),(329,90,'TBA'),(330,90,'TCA'),(331,90,'TDA'),(332,90,'TEA'),(333,90,'UA'),(334,90,'UMA'),(335,91,'MN'),(336,91,'SL'),(337,91,'SP'),(338,91,'TAB'),(339,92,'BUF'),(340,93,'QS'),(341,94,'R'),(342,94,'Ray'),(343,94,'RC'),(344,94,'RM'),(345,95,'R'),(346,96,'KA'),(347,96,'KM'),(348,96,'KMM'),(349,97,'LA'),(350,97,'LC'),(351,98,'NQ'),(352,98,'PQ'),(353,99,'RTC'),(354,100,'IR'),(355,101,'OM'),(356,101,'PCD'),(357,101,'PCF'),(358,101,'SAA'),(359,101,'SAB'),(360,101,'SABE'),(361,101,'SAF'),(362,101,'SCB'),(363,101,'SCN'),(364,101,'TAA'),(365,101,'TBA'),(366,101,'TCA'),(367,101,'TEA'),(368,102,'SG'),(369,103,'PH'),(370,104,'DF'),(371,104,'L'),(372,104,'LD'),(373,105,'D'),(374,106,'L'),(375,106,'LD'),(376,107,'BX'),(377,107,'CXK'),(378,108,'CX'),(379,109,'TPQ'),(380,109,'UCS'),(381,110,'COM'),(382,110,'KR'),(383,111,'ST'),(384,112,'CM'),(385,113,'SYD'),(386,113,'SYS'),(387,114,'TMC'),(388,115,'TC'),(389,115,'TCM'),(390,116,'TP'),(391,117,'TSC'),(392,118,'OM'),(393,118,'PCD'),(394,118,'PCF'),(395,118,'SAA'),(396,118,'SAB'),(397,118,'SAF'),(398,118,'SCB'),(399,118,'SCN'),(400,118,'TAA'),(401,118,'TBA'),(402,118,'TCA'),(403,118,'TEA'),(404,119,'TML'),(405,120,'HM'),(406,120,'MC'),(407,120,'P'),(408,120,'S'),(409,120,'SD'),(410,120,'SI'),(411,120,'U'),(412,121,'IP'),(413,122,'MA'),(414,122,'MAA'),(415,122,'MH'),(416,122,'MHB'),(417,123,'MC'),(418,123,'NE'),(419,123,'OP'),(420,123,'RC'),(421,123,'SG'),(422,123,'SN'),(423,123,'TIBPAL'),(424,123,'TIL'),(425,123,'TIP'),(426,123,'TIPAL'),(427,123,'TIS'),(428,123,'TL'),(429,123,'TLC'),(430,123,'TLE'),(431,123,'TM'),(432,123,'TMS'),(433,123,'UA'),(434,123,'ULN'),(435,124,'T'),(436,124,'TA'),(437,124,'TC'),(438,124,'TD'),(439,124,'THM'),(440,124,'TMM'),(441,124,'TMP'),(442,124,'TMPZ'),(443,125,'TDC'),(444,126,'UM'),(445,127,'L'),(446,127,'UC'),(447,127,'UCC'),(448,128,'ULN'),(449,129,'MACH'),(450,129,'PALCE'),(451,130,'VT'),(452,131,'VA'),(453,131,'VC'),(454,132,'PSD'),(455,133,'WD'),(456,134,'X'),(457,135,'U'),(458,135,'UD'),(459,136,'ZH'),(460,136,'ZLDO'),(461,136,'ZM'),(462,136,'ZMR'),(463,136,'ZR'),(464,136,'ZRA'),(465,136,'ZRB'),(466,136,'ZREF'),(467,136,'ZRT'),(468,136,'ZSD'),(469,136,'ZSM'),(470,137,'Z'),(471,138,'S'),(472,139,'WE'),(473,140,'SPE'),(474,141,'BI'),(475,142,'KA'),(476,143,'KE'),(477,144,'TDK'),(478,145,'AT'),(479,146,'AMP'),(480,147,'OST');
/*!40000 ALTER TABLE `mfg_codes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-18 22:37:47
