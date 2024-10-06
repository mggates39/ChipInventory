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
-- Temporary view structure for view `chip_aliases`
--

DROP TABLE IF EXISTS `chip_aliases`;
/*!50001 DROP VIEW IF EXISTS `chip_aliases`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `chip_aliases` AS SELECT 
 1 AS `id`,
 1 AS `chip_number`,
 1 AS `family`,
 1 AS `component`,
 1 AS `package`,
 1 AS `pin_count`,
 1 AS `description`,
 1 AS `on_hand`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `chip_aliases`
--

/*!50001 DROP VIEW IF EXISTS `chip_aliases`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`mggates`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `chip_aliases` AS select `c`.`id` AS `id`,`cmp`.`name` AS `chip_number`,`c`.`family` AS `family`,`ct`.`description` AS `component`,`pt`.`name` AS `package`,`c`.`pin_count` AS `pin_count`,`cmp`.`description` AS `description`,(select sum(`i`.`quantity`) from `inventory` `i` where (`i`.`chip_id` = `c`.`id`)) AS `on_hand` from (((`components` `cmp` join `chips` `c` on((`c`.`id` = `cmp`.`id`))) join `package_types` `pt` on((`pt`.`id` = `cmp`.`package_type_id`))) join `component_types` `ct` on((`ct`.`id` = `cmp`.`component_type_id`))) union all select `a`.`chip_id` AS `id`,`a`.`alias_chip_number` AS `chip_number`,`c`.`family` AS `family`,`ct`.`description` AS `component`,`pt`.`name` AS `package`,`c`.`pin_count` AS `pin_count`,concat('See <a href=\'/chips/',`a`.`chip_id`,'\'>',`cmp`.`name`,'</a>') AS `description`,'' AS `on_hand` from ((((`aliases` `a` join `components` `cmp` on((`cmp`.`id` = `a`.`chip_id`))) join `chips` `c` on((`c`.`id` = `cmp`.`id`))) join `package_types` `pt` on((`pt`.`id` = `cmp`.`package_type_id`))) join `component_types` `ct` on((`ct`.`id` = `cmp`.`component_type_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-05 20:48:21
