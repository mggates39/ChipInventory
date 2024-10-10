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
-- Table structure for table `components`
--

DROP TABLE IF EXISTS `components`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `components` (
  `id` int NOT NULL AUTO_INCREMENT,
  `component_type_id` int NOT NULL,
  `component_sub_type_id` int DEFAULT NULL,
  `package_type_id` int NOT NULL,
  `name` varchar(32) NOT NULL,
  `description` text NOT NULL,
  `pin_count` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `component_type_idx` (`component_type_id`),
  KEY `component_package_idx` (`package_type_id`),
  KEY `component_sub_type_idx` (`component_sub_type_id`),
  CONSTRAINT `components_ibfk_1` FOREIGN KEY (`component_type_id`) REFERENCES `component_types` (`id`),
  CONSTRAINT `components_ibfk_2` FOREIGN KEY (`package_type_id`) REFERENCES `package_types` (`id`),
  CONSTRAINT `components_ibfk_3` FOREIGN KEY (`component_sub_type_id`) REFERENCES `component_sub_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=268 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `components`
--

LOCK TABLES `components` WRITE;
/*!40000 ALTER TABLE `components` DISABLE KEYS */;
INSERT INTO `components` VALUES (1,1,6,1,'741','Operational amplifier',8),(2,1,7,1,'8254','Programmable interval timer',24),(3,1,5,1,'MAX232','+5V-powered multichannel RS-232 driver/receiver',16),(4,1,NULL,1,'MCP3204','4-channel 12 bit SPI A/D converter',14),(5,1,NULL,1,'DS1307','64 x 8, serial, I2C real-time clock',8),(6,1,1,1,'74138','3-to-8 line decoder/demultiplexer; inverting',16),(7,1,42,1,'AY-3-8910','Programmable sound generator',40),(8,1,1,1,'74240','Octal buffer/line driver; 3-state; inverting',20),(9,1,2,1,'54374','Octal D-type edge-triggered flip-flops with 3-state outputs',20),(10,1,6,1,'LM384','5W audio power amplifier',14),(11,1,1,1,'74573','Octal D-type transparent latch; 3-state; non-inverting',20),(12,1,11,1,'PIC16F84A','PIC16F84A Microcontroller',18),(13,1,NULL,1,'TPIC6B595','Power logic 8-bit shift register',20),(14,1,1,1,'74541','Octal buffer/line driver; 3-state; non-inverting',20),(15,1,1,1,'74366','Hex buffer/line driver; 3-state; inverting',16),(16,1,3,1,'4023','Triple 3-input NAND gate',14),(17,1,1,1,'7427','Triple 3-input NOR gate',14),(18,1,41,1,'555','Timer',8),(19,1,1,1,'74151','8-input multiplexer',16),(20,1,6,1,'TL082','Dual JFET-input operational amplifier',8),(21,1,1,1,'74273','Octal D-type flip-flop with reset; positive-edge trigger',20),(22,1,1,1,'74158','Quad 2-input multiplexer; inverting',16),(23,1,3,1,'4518','Dual synchronous BCD counter',16),(24,1,1,1,'74377','Octal D-type flip-flop with data enable; positive-edge trigger',20),(25,1,10,1,'24LC256','256K I2C CMOS serial EEPROM',8),(26,1,1,1,'74148','8-to-3 line priority encoder',16),(27,1,3,1,'4082','Dual 4-input AND gate',14),(28,1,3,1,'4520','Dual 4-bit synchronous binary counter',16),(29,1,3,1,'4011','Quad 2-input NAND gate',14),(30,1,NULL,1,'A6279','Serial-input constant-current latched LED driver (16 outputs)',24),(31,1,36,1,'ATMEGA168','8-bit AVR&reg; microcontroller',28),(32,1,3,1,'4081','Quad 2-input AND gate',14),(33,1,NULL,1,'HSN-1000','Nuclear event detector',14),(34,1,NULL,1,'MCP23017','16-Bit I/O Expander with Serial Interface',28),(35,1,1,1,'7410','Triple 3-input NAND gate',14),(36,1,3,1,'4050','Hex non-inverting buffer',16),(37,1,1,1,'7402','Quad 2-input NOR gate',14),(38,1,3,1,'4514','1-of-16 decoder/demultiplexer with input latches',24),(39,1,15,1,'PS2501','4-channel optoisolator',16),(40,1,10,1,'6264','8K x 8 static RAM',28),(41,1,1,1,'74166','8-bit parallel-in/serial-out shift register',16),(42,1,6,1,'LF412','Low-offset, low-drift dual JFET-input operational amplifier',8),(43,1,3,1,'4052','Dual 4-channel analog multiplexer/demultiplexer',16),(44,1,1,1,'74195','Universal 4-Bit Shift Register',16),(45,1,1,1,'7430','8-input NAND gate',14),(46,1,3,1,'4049','Hex inverting buffer',16),(47,1,3,1,'4014','8-bit static shift register',16),(48,1,1,1,'74243','Quad bus transceiver; 3-state',14),(49,1,1,1,'74257','Quad 2-input multiplexer; 3-state',16),(50,1,1,1,'74259','8-bit addressable latch',16),(51,1,3,1,'4013','Dual D-type flip-flop with set and clear',14),(52,1,1,1,'74245','Octal bus transceiver; 3-state',20),(53,1,1,1,'74540','Octal buffer/line driver; 3-state; inverting',20),(54,1,1,1,'7485','4-bit magnitude comparator',16),(55,1,3,1,'4070','Quad 2-input XOR gate',14),(56,1,NULL,1,'ICL7660','Switched-capacitor voltage converter',8),(57,1,3,1,'40106','Hex inverting Schmitt trigger',14),(58,1,1,1,'74640','Octal bus transceiver; 3-state; inverting',20),(59,1,1,1,'7404','Hex inverter',14),(60,1,NULL,1,'MCP3202','12-Bit 2-Channel SPI interface A/D Converter',8),(61,1,6,1,'LM311','Voltage comparator',8),(62,1,1,1,'74374','Octal D-type flip-flop; positive-edge trigger; 3-state',20),(63,1,1,1,'7442','BCD to decimal decoder (1-of-10)',16),(64,1,NULL,1,'WIRE','A piece of wire',2),(65,1,1,1,'7458','Dual AND-OR gate',14),(66,1,10,1,'628512','512K x 8 static RAM',32),(67,1,1,1,'74126','Quad buffer/line driver with active high output enable; 3-state',14),(68,1,NULL,1,'TMS9928A','Video Display Processor (component output)',40),(69,1,1,1,'7421','Dual 4-input AND gate',14),(70,1,6,1,'LF353','Wide bandwidth dual JFET-input operational amplifier',8),(71,1,1,1,'74646','Octal bus transceiver/register; 3-state',24),(72,1,1,1,'74367','Hex buffer/line driver; 3-state; non-inverting',16),(73,1,1,1,'74174','Hex D-type flip-flop with reset; positive-edge trigger',16),(74,1,1,1,'74163','Presettable synchronous 4-bit binary counter; synchronous reset',16),(75,1,3,1,'4046','Phase-locked loop',16),(76,1,3,1,'4028','BCD to decimal decoder',16),(77,1,41,1,'556','Dual timer',14),(78,1,1,1,'74109','Dual J-K flip-flop with set and reset; positive-edge trigger',16),(79,1,NULL,1,'MCP3002','Dual channel 10-bit ADC with SPI interface',8),(80,1,5,1,'16550','Universal asynchronous receiver-transmitter with FIFOs',40),(81,1,NULL,1,'MAX1771','High-efficiency, low IQ, step-up DC-DC controller',8),(82,1,1,1,'74594','8-bit shift register with output register',16),(83,1,NULL,1,'A6278','Serial-input constant-current latched LED driver (8 outputs)',16),(84,1,NULL,1,'SN75468','Seven darlington array',16),(85,1,3,1,'4053','Triple 2-channel analog multiplexer/demultiplexer (triple SPDT analog switch)',16),(86,1,3,1,'4077','Quad 2-input XNOR gate',14),(87,1,16,1,'ADC0808','8-bit A/D converter with 8-channel multiplexer',28),(88,1,1,1,'74368','Hex buffer/line driver; 3-state; inverting',16),(89,1,1,1,'74390','Dual decade ripple counter',16),(90,1,36,1,'ATMEGA32','8-bit AVR&reg; microcontroller',40),(91,1,3,1,'4024','7-stage binary ripple counter',14),(92,1,1,1,'74258','Quad 2-input multiplexer; 3-state; inverting',16),(93,1,1,1,'74393','Dual 4-bit binary ripple counter',14),(94,1,1,1,'74574','Octal D-type flip-flop; positive-edge trigger; 3-state; non-inverting',20),(95,1,3,1,'4538','Dual retriggerable precision monostable multivibrator with reset',16),(96,1,1,1,'74251','8-input multiplexer; 3-state',16),(97,1,1,1,'74237','3-to-8 line decoder/demultiplexer with address latches; non-inverting',16),(98,1,1,1,'74173','Quad D-type flip-flop; positive-edge trigger; 3-state',16),(99,1,1,1,'74373','Octal D-type transparent latch; 3-state',20),(100,1,1,1,'74253','Dual 4-input multiplexer; 3-state',16),(101,1,1,1,'74597','8-bit shift register with input flip-flops',16),(102,1,3,1,'4516','4-bit binary up/down counter',16),(103,1,3,1,'4075','Triple 3-input OR gate',14),(104,1,3,1,'4066','Quad bilateral switch',14),(105,1,3,1,'4040','12-stage binary ripple counter',16),(106,1,3,1,'4585','4-bit magnitude comparator',16),(107,1,3,1,'4029','Synchronous 4-bit up/down binary/decade counter',16),(108,1,3,1,'4528','Dual retriggerable monostable multivibrator with reset',16),(109,1,6,1,'LM358','Low power dual operational amplifier',8),(110,1,11,1,'PIC18F13K50','20-Pin USB Flash Microcontrollers with nanoWatt XLP&trade; Technology',20),(111,1,3,1,'4051','8-channel analog multiplexer/demultiplexer',16),(112,1,36,1,'ATMEGA644P','8-bit AVR&reg; microcontroller',40),(113,1,1,1,'74112','Dual J-K flip-flop with set and reset; negative-edge trigger',16),(114,1,11,1,'PIC18F4550','PIC18F4550',40),(115,1,3,1,'4526','Programmable 4-bit binary down counter',16),(116,1,7,1,'6522','Versatile Interface Adapter',40),(117,1,1,1,'74365','Hex buffer/line driver; 3-state; non-inverting',16),(118,1,1,1,'7473','Dual J-K flip-flop with reset; negative-edge trigger',14),(119,1,1,1,'74823','9-Bit D-Type Flip-Flop',24),(120,1,3,1,'4017','Decade counter/divider with 10 decoded outputs',16),(121,1,1,1,'7408','Quad 2-input AND gate',14),(122,1,1,1,'74595','8-bit serial-in, serial or parallel-out shift register with output latches; 3-state',16),(123,1,1,1,'74125','Quad buffer/line driver with active low output enable; 3-state',14),(124,1,7,1,'6821','Peripheral interface adapter',40),(125,1,6,1,'TL081','JFET-input operational amplifier',8),(126,1,1,1,'7400','Quad 2-input NAND gate',14),(127,1,4,1,'MC34063','Step up/down inverting switching regulator',8),(128,1,1,1,'74160','Presettable synchronous BCD decade counter; asynchronous reset',16),(129,1,3,1,'4572','Hex gate (four inverters, one 2-input NOR gate, one 2-input NAND gate)',16),(130,1,1,1,'74299','8-bit universal shift register; 3-state',20),(131,1,10,1,'27C512','512K (64K x 8) CMOS EPROM',28),(132,1,1,1,'7475','Quad bistable transparent latch',16),(133,1,1,1,'7414','Hex inverting Schmitt trigger',14),(134,1,6,1,'LM348','Quad 741 operational amplifier',14),(135,1,3,1,'4030','Quad 2-input XOR gate',14),(136,1,1,1,'7486','Quad 2-input XOR gate',14),(137,1,8,1,'Z80','Z-80 Microprocessor',40),(138,1,3,1,'4015','Dual 4-bit serial-in/parallel-out shift register',16),(139,1,3,1,'4068','8-input NAND gate',14),(140,1,15,1,'4N35M','Phototransistor output optocoupler',6),(141,1,1,1,'7490','4-bit decade counter',14),(142,1,1,1,'74154','4-to-16 line decoder/demultiplexer',24),(143,1,3,1,'4557','1-to-64 bit variable length shift register',16),(144,1,1,1,'74123','Dual retriggerable monostable multivibrator with reset',16),(145,1,1,1,'74132','Quad 2-input NAND Schmitt trigger',14),(146,1,3,1,'4541','Programmable timer',14),(147,1,36,1,'ATTINY2313','8-bit AVR&reg; microcontroller',20),(148,1,NULL,1,'SN754410','Quadruple half-H driver',16),(149,1,6,1,'LM301A','Operational amplifier',8),(150,1,1,1,'74161','Presettable synchronous 4-bit binary counter; asynchronous reset',16),(151,1,1,1,'74241','Octal buffer/line driver; 3-state; non-inverting',20),(152,1,10,1,'628128','128K x 8 static RAM',32),(153,1,1,1,'74141','BCD-to-decimal decoder/Nixie tube driver',16),(154,1,1,1,'74590','8-bit binary counter with output register; 3-state',16),(155,1,NULL,1,'ULN2803','Eight darlington array',18),(156,1,6,1,'LM386','Low voltage audio power amplifier',8),(157,1,1,1,'74153','Dual 4-input multiplexer',16),(158,1,1,1,'74193','Presettable synchronous 4-bit binary up/down counter; separate up/down clocks',16),(159,1,8,1,'1802','CDP1802 CMOS 8-bit microprocessor',40),(160,1,11,1,'PIC12F683','8-Pin Flash-Based, 8-Bit CMOS Microcontrollers with nanoWatt Technology',8),(161,1,3,1,'4515','1-of-16 decoder/demultiplexer with input latches; inverting',24),(162,1,11,1,'PIC16F1936','8-Bit CMOS Microcontrollers with LCD Driver with nano Watt XLPTM Technology',28),(163,1,10,1,'28C64','8K x 8 parallel EEPROM',28),(164,1,3,1,'4002','Dual 4-input NOR gate',14),(165,1,3,1,'4060','14-stage ripple-carry binary counter/divider and oscillator',16),(166,1,6,1,'LM324','Low power quad operational amplifier',14),(167,1,NULL,1,'ICM7228B','8-digit LED display decoder/driver, common cathode',28),(168,1,3,1,'4099','8-bit addressable latch',16),(169,1,6,1,'LM339','Low-power, low-offset quad comparator',14),(170,1,NULL,1,'NE5532','Dual operational amplifier',8),(171,1,7,1,'8255A','Programmable peripheral interface',40),(172,1,3,1,'4071','Quad 2-input OR gate',14),(173,1,1,1,'7420','Dual 4-input NAND gate',14),(174,10,38,1,'DS32KHZ','32.768kHz temperature-compensated crystal oscillator',14),(175,1,6,1,'LM393','Low-power, low-offset dual comparator',8),(176,1,1,1,'74221','Dual non-retriggerable monostable multivibrator with reset',16),(177,1,1,1,'7411','Triple 3-input AND gate',14),(178,1,10,1,'62256','32K x 8 static RAM',28),(179,1,3,1,'4047','Monostable/astable multivibrator',14),(180,1,3,1,'4093','Quad 2-input NAND Schmitt trigger',14),(181,1,8,1,'6809E','8-bit microprocessor',40),(182,1,1,1,'74564','Octal D-type flip-flop; positive-edge trigger; 3-state; inverting',20),(183,1,3,1,'4094','8-stage shift-and-store bus register',16),(184,1,36,1,'ATTINY12','8-Bit AVR&reg; microcontroller with 1 kb In-system programmable flash memory',8),(185,1,1,1,'74280','9-bit odd/even parity generator/checker',14),(186,1,NULL,1,'TLC272','Precision JFET-input low-offset dual operation amplifier',8),(187,1,16,1,'AD7805','+3.3V to +5V quad 10-bit DAC',28),(188,1,36,1,'ATTINY85','8-bit AVR&reg; microcontroller',8),(189,1,3,1,'4020','14-stage binary counter',16),(190,1,1,1,'74688','8-bit magnitude comparator',20),(191,1,15,1,'6N137','10 MBit/s single-channel high speed logic gate output optocoupler',8),(192,1,6,1,'LF347','Wide bandwidth quad JFET-input operational amplifier',14),(193,1,1,1,'74147','10-to-4 line priority encoder',16),(194,1,NULL,1,'DS1620','Digital Thermometer and Thermostat',8),(195,1,1,1,'74283','4-bit binary full adder with fast carry',16),(196,1,NULL,1,'MCP3201','12-Bit A/D SPI interface A/D Converter',8),(197,1,NULL,1,'PCF8574','Remote 8-bit I/O expander for I2C bus',16),(198,1,3,1,'4073','Triple 3-input AND gate',14),(199,1,1,1,'7474','Dual D-type flip-flop with set and reset; positive-edge trigger',14),(200,1,NULL,1,'TMS9918A','Video Display Processor (composite output)',40),(201,1,1,1,'74652','Octal bus transceiver/register; 3-state',24),(202,1,6,1,'TL084','Quad JFET-input operational amplifier',14),(203,1,1,1,'74137','3-to-8 line decoder/demultiplexer with address latches; inverting',16),(204,1,NULL,1,'ULN2003','Seven darlington array',16),(205,1,1,1,'74175','Quad D-type flip-flop with reset; positive-edge trigger',16),(206,1,6,1,'LF444','Quad low-power JFET-input operational amplifier',14),(207,1,3,1,'4021','8-bit static shift register',16),(208,1,42,1,'6581','Sound Interface Device (SID)',28),(209,1,1,1,'74164','8-bit serial-in/parallel-out shift register',14),(210,1,16,1,'AD7528','CMOS dual 8-bit buffered multiplying DAC',20),(211,1,3,1,'4511','BCD to 7-segment latch/decoder/driver',16),(212,1,1,1,'7432','Quad 2-input OR gate',14),(213,1,36,1,'ATTINY13','8-bit AVR&reg; microcontroller',8),(214,1,3,1,'4069','Hex inverter',14),(215,1,3,1,'4555','Dual 1-of-4 decoder/demultiplexer',16),(216,1,3,1,'4027','Dual J-K flip-flop with set and clear',16),(217,1,7,1,'Z8420','Z80-PIO Parallel Input / Output',40),(218,1,10,1,'27C128','128K (16kb x 8) 200ns CMOS EPROM',28),(219,1,1,1,'74563','Octal D-type transparent latch; 3-state; inverting',20),(220,1,3,1,'4001','Quad 2-input NOR gate',14),(221,1,3,1,'4067','16-channel analog multiplexer/demultiplexer',24),(222,1,1,1,'74670','4 by 4 register file; 3-state',16),(223,1,1,1,'74238','3-to-8 line decoder/demultiplexer; non-inverting',16),(224,1,1,1,'74821','10-Bit D-Type Flip-Flop with 3-STATE Outputs',24),(225,1,NULL,1,'TIL311','Hexadecimal display with logic',14),(226,1,1,1,'74107','Dual J-K flip-flop with reset; negative-edge trigger',14),(227,1,3,1,'4072','Dual 4-input OR gate',14),(228,1,1,1,'74423','Dual retriggerable monostable multivibrator with reset',16),(229,1,1,1,'74139','Dual 2-to-4 line decoder/demultiplexer',16),(230,1,3,1,'4025','Triple 3-input NOR gate',14),(231,1,6,1,'LF411','Low-offset, low-drift JFET-input operational amplifier',8),(232,1,36,1,'ATMEGA8','8-bit AVR&reg; microcontroller',28),(233,1,1,1,'74157','Quad 2-input multiplexer',16),(234,1,3,1,'4085','Dual 2-wide 2-input AND-OR-INVERT gate',14),(235,1,3,1,'40193','4-bit up/down binary counter',16),(236,1,6,1,'LM380','2.5W audio power amplifier',14),(237,1,3,1,'4556','Dual 1-of-4 decoder/demultiplexer; inverting',16),(238,1,1,1,'74191','Presettable synchronous 4-bit binary up/down counter',16),(239,1,1,1,'74244','Octal buffer/line driver; 3-state; non-inverting',20),(240,1,1,1,'74165','8-bit parallel-in/serial-out shift register',16),(241,1,6,1,'LM319','High speed dual comparator',14),(242,1,NULL,1,'TC649','PWM fan speed controller',8),(243,1,1,1,'74194','4-bit bidirectional universal shift register',16),(244,1,1,1,'7493','4-bit binary ripple counter',14),(245,1,4,1,'MC14053B','Multiplexer Switch ICs 3-18V Triple SPDT Switch',16),(246,1,4,1,'MC14051B','Multiplexer Switch ICs 3-18V SP8T Switch',16),(247,1,4,1,'MC14052B','Multiplexer Switch ICs 3-18V DP4T Switch',16),(248,1,4,1,'UCN5800A','BiMOS II LATCHED DRIVERS',14),(251,1,1,1,'7487','4-Bit True/Complement, Zero/One Elements',14),(252,1,1,1,'7417','Hex Buffers with High Voltage Open-Collector Outputs',14),(253,1,1,1,'74381','4-bit arithmetic logic unit/function generator',20),(254,1,1,1,'74382','4-bit arithmetic logic unit/function generator, ripple carry and overflow outputs',20),(255,1,5,1,'DS8921','Differential Line Driver and Receiver Pair',8),(256,1,1,1,'744078','8 -Input NOR/OR Gate',14),(257,1,1,1,'74182','Look-Ahead Carry Generator',16),(258,1,1,1,'744046','High-Speed CMOS Logic Phase-Locked Loop with VCO',16),(259,1,10,1,'28F512','512K-Bit (8 X 64) CMOS Flash Memory',32),(260,1,7,1,'MC68B21','Peripheral Interface Adapter',40),(261,1,10,1,'27C64','64K (8K x 8) CMOS EPROM',28),(262,1,8,1,'6502','8 Bit Microprocessor',40),(264,1,NULL,1,'MC34051','Dual EIA-423 Transceiver (Unbalanced line)',16),(265,1,1,1,'MC14174B','Hex Type D Flip-Flop',16),(266,1,1,1,'74AS885','8-BIT MAGNITUDE COMPARATORS',24),(267,1,2,4,'5410','Triple 3-Input Positive-NAND Gates',20);
/*!40000 ALTER TABLE `components` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-09 22:43:56
