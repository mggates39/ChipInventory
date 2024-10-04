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
-- Table structure for table `notes`
--

DROP TABLE IF EXISTS `notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `chip_id` int NOT NULL,
  `note` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `chip_idx` (`chip_id`),
  CONSTRAINT `notes_ibfk_1` FOREIGN KEY (`chip_id`) REFERENCES `chips` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=262 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notes`
--

LOCK TABLES `notes` WRITE;
/*!40000 ALTER TABLE `notes` DISABLE KEYS */;
INSERT INTO `notes` VALUES (1,1,'A 10 k&Omega; potentiometer connected to pins 1 and 5 can be used to null any offset voltage.'),(2,2,'Register 00: counter 0 value'),(3,2,'Register 01: counter 1 value'),(4,2,'Register 10: counter 2 value'),(5,2,'Register 11: control word'),(6,2,'Control word: <table> <tr><td>Bit 0</td><td>0=binary (16 bits), 1=BCD (4 decades)</td></tr> <tr><td>Bits 1-3</td><td>mode select</td></tr> <tr><td>Bits 4-5</td><td>read/write mode</td></tr> <tr><td>Bits 6-7</td><td>select counter/read-back mode</td></tr> </table><br/>'),(7,2,'Mode 0: interrupt on terminal count'),(8,2,'Mode 1: hardware retriggerable one-shot'),(9,2,'Mode 2: rate generator'),(10,2,'Mode 3: square wave'),(11,2,'Mode 4: software triggered strobe'),(12,2,'Mode 5: hardware triggered strobe (retriggerable)'),(13,3,'Use five capacitors; C1 between pins 1 and 3, C2 between pins 4 and 5, C3 between pin 2 and +5v, C4 between ground and pin 6, and C5 between +5V and ground. See datasheet for schematic.'),(14,3,'C1 through C5 should be 1.0 &micro;F electrolytic capacitors.'),(15,4,'Also available as one-channel (MCP3201), two-channel (MCP3202) and eight-channel (MCP3208) version'),(16,5,'A lithium battery with 48 mAh or greater will back up the DS1307 for more than 10 years.'),(17,5,'Square wave output can be 1Hz, 4.096kHz, 8.192kHz, or 32.768kHz.'),(18,5,'Reads/writes are inhibited when Vcc falls below 1.25 x V__BAT.'),(19,7,'Chip is only active when ~A9 is low, A8 is high, and address bits DA7-DA4 are low.'),(20,7,'Address bits DA3-DA0 select one of the 16 control registers.'),(21,7,'For YM2149, connecting pin 26 to ground divides CLOCK by 2.'),(22,7,'BDIR=0, BC2=0, BC1=0: inactive, DA7-DA0 high impedance'),(23,7,'BDIR=0, BC2=0, BC1=1: latch address, DA7-DA0 are inputs'),(24,7,'BDIR=0, BC2=1, BC1=0: inactive, DA7-DA0 high impedance'),(25,7,'BDIR=0, BC2=1, BC1=1: read, DA7-DA0 are outputs'),(26,7,'BDIR=1, BC2=0, BC1=0: latch address, DA7-DA0 are inputs'),(27,7,'BDIR=1, BC2=0, BC1=1: inactive, DA7-DA0 high impedance'),(28,7,'BDIR=1, BC2=1, BC1=0: write, DA7-DA0 are inputs'),(29,7,'BDIR=1, BC2=1, BC1=1: latch address, DA7-DA0 are inputs'),(30,7,'Control registers: <table> <tr><td>$00</td><td>tone generator A frequency, low 8 bits</td></tr> <tr><td>$01</td><td>tone generator A frequency, high 4 bits</td></tr> <tr><td>$02</td><td>tone generator B frequency, low 8 bits</td></tr> <tr><td>$03</td><td>tone generator B frequency, high 4 bits</td></tr> <tr><td>$04</td><td>tone generator C frequency, low 8 bits</td></tr> <tr><td>$05</td><td>tone generator C frequency, high 4 bits</td></tr> <tr><td>$06</td><td>noise generator frequency, low 5 bits</td></tr> <tr><td>$07</td><td>I/O port and mixer control</td></tr> <tr><td>$08</td><td>channel A amplitude/envelope enable</td></tr> <tr><td>$09</td><td>channel B amplitude/envelope enable</td></tr> <tr><td>$0A</td><td>channel C amplitude/envelope enable</td></tr> <tr><td>$0B</td><td>envelope frequency, low 8 bits</td></tr> <tr><td>$0C</td><td>envelope frequency, high 8 bits</td></tr> <tr><td>$0D</td><td>envelope shape</td></tr> <tr><td>$0E</td><td>I/O port A data</td></tr> <tr><td>$0F</td><td>I/O port B data</td></tr> </table>'),(31,8,'Setting 1~OE or 2~OE high causes the outputs to assume a high-impedance off state.'),(32,9,'~OE does not affect internal operations of the flip-flops. Old data can be retained or new data can be entered while the outputs are in the high-impedance state'),(33,9,'released april 1982, revised november 1999'),(34,12,'18-pin Flash/EEPROM 8-bit Microcontroller'),(35,15,'Setting ~OE~__1 or ~OE~__2 high causes the outputs to assume a high-impedance off state.'),(36,18,'In monostable mode, pulse width &asymp; 1.1RC'),(37,18,'In astable mode, frequency = 1/(0.693*C*(R1+2*R2))'),(38,18,'In astable mode, pulse high time = 0.693*(R1+R2)*C'),(39,18,'In astable mode, pulse low time = 0.693*R2*C'),(40,20,'The TL06x series are low-power versions of the TL08x series.'),(41,20,'The TL07x series are low-noise versions of the TL08x series.'),(42,23,'The 4518 counts from 0 to 9. The 4520 is identical but counts from 0 to 15.'),(43,23,'Either nCP0 or n~CP~1 may be used as the clock input; the other can be used as a clock enable input.'),(44,23,'If n~CP~1 is high, the counter advances on a low-to-high transition of nCP0.'),(45,23,'If nCP0 is low, the counter advances on a high-to-low transition of n~CP~1.'),(46,26,'When two or more inputs are simultaneously active, the input with the highest priority is represented on the output.'),(47,26,'Input 7 has the highest priority.'),(48,26,'When all eight data inputs are high, all three outputs are high.'),(49,26,'Multiple 74148s can be cascaded by connecting EO of the high priority chip to EI of the low priority chip (see datasheet).'),(50,28,'The 4520 counts from 0 to 15. The 4518 is identical but counts from 0 to 9.'),(51,28,'Either nCP0 or n~CP~1 may be used as the clock input; the other can be used as a clock enable input.'),(52,28,'If n~CP~1 is high, the counter advances on a low-to-high transition of nCP0.'),(53,28,'If nCP0 is low, the counter advances on a high-to-low transition of n~CP~1.'),(54,33,'Less than a 30% variation in detection threshold can be expected over the entire operating temperature range.'),(55,38,'Outputs are mutually exclusive active high.'),(56,38,'When ~E is high, all outputs are low.'),(57,40,'Data is written when ~CE~__1 is low, ~WE is low, and CE__2 is high.'),(58,40,'Data is read whem ~CE~__1 is low, ~OE is low, and CE__2 is high.'),(59,40,'The input/output pins assume a high-impedance state if the chip is not selected and/or ~OE is low.'),(60,41,'The low-to-high transition of ~CE should only take place while CP is high for predictable operation.'),(61,41,'A low on ~MR overrides all other inputs and clears the register asynchronously, forcing all bit positions to a low stage.'),(62,43,'The device contains four bidirectional analog switches.'),(63,43,'The analog inputs/outputs can swing between V__CC and V__EE.'),(64,43,'When E is high, all switches are in a high-impedance off state.'),(65,48,'When ~OE~A and OEB are low, An are inputs.'),(66,48,'When ~OE~A and OEB are high, Bn are inputs.'),(67,48,'Otherwise, An and Bn are in a high-impedance off state.'),(68,52,'When DIR is high, An are inputs.'),(69,52,'When DIR is low, Bn are inputs.'),(70,52,'When ~OE is high, An and Bn are in a high-impedance off state.'),(71,54,'The least significant (or only) comparator in a chain should have I__A&lt;B and I__A&gt;B tied low and I__A=B tied high.'),(72,54,'To compare more than 4 bits, connect the outputs to the expansion inputs of the next significant comparator.'),(73,56,'Basic negative voltage converter: 10&micro;F capacitor across pins 2 and 4; 10&micro;F capacitor across pin 5 (negative lead) and ground (positive lead).'),(74,60,'Also available with 1 channel (MCP3201), 4 channels (MCP3204) and 8 channels (MCP3208)'),(75,64,'It\'s pretty handy for connecting stuff.'),(76,64,'Resistance is usually pretty low.'),(77,64,'It bends!'),(78,66,'Data is written when ~CS is low and ~WE is low.'),(79,66,'Data is read when ~CS is low, ~OE is low, and ~WE is high.'),(80,66,'The input/output pins assume a high-impedance state if ~CS is high.'),(81,68,'See <a href=\'TMS9918A\'>TMS9918A</a>'),(82,68,'TMS9928A outputs 60Hz video, TMS9929A outputs 50Hz video'),(83,72,'Setting ~OE~__1 or ~OE~__2 high causes the outputs to assume a high-impedance off state.'),(84,76,'Outputs are active high.'),(85,76,'All outputs are low for BCD inputs greater than 9.'),(86,77,'The 556 contains two 555 timers.'),(87,80,'Register 000: receive buffer (read), transmit holding register (write)'),(88,80,'Register 001: interrupt enable'),(89,80,'Register 010: interrupt identification (read), FIFO control (write)'),(90,80,'Register 011: line control'),(91,80,'Register 100: modem control'),(92,80,'Register 101: line status'),(93,80,'Register 110: modem status'),(94,80,'Register 111: scratch register'),(95,80,'When bit 7 in the Line Control Register is set, the baud rate divisor latch is enabled. (register 000=LSB, register 001=MSB)'),(96,84,'SN75468 is designed for use with 5V TTL/CMOS devices.'),(97,84,'SN75469 is designed for use with 6V-15V CMOS/PMOS devices.'),(98,85,'Each multiplexer/demultiplexer contains two bidirectional analog switches.'),(99,85,'The analog inputs/outputs can swing between V__CC and V__EE.'),(100,85,'When E is high, all switches are in a high-impedance off state.'),(101,87,'The ADC0808 is a more accurate version of the ADC0809.'),(102,88,'Setting ~OE~__1 or ~OE~__2 high causes the outputs to assume a high-impedance off state.'),(103,95,'Connect a timing capacitor C__EXT between nCEXT and nREXT/CEXT.'),(104,95,'Connect a resistor R__EXT between nREXT/CEXT and Vcc.'),(105,95,'A high-to-low transition on n~A when nB is low causes a pulse on nQ and n~Q.'),(106,95,'A low-to-high transition on nB when n~A is high causes a pulse on nQ and n~Q.'),(107,95,'Setting n~CD low inhibits pulses.'),(108,95,'Output pulse width = R__EXT &times; C__EXT.'),(109,95,'(74HC4538) Output pulse width = 0.7 &times; R__EXT &times; C__EXT.'),(110,98,'When one or both ~OE~__n inputs are high, the outputs are forced to a high-impedance off state.'),(111,100,'When 1~OE or 2~OE is high, the outputs are forced to a high-impedance off state.'),(112,102,'When counting up, ~TC goes low when the count is 15.'),(113,102,'When counting down, ~TC goes low when the count is 0.'),(114,102,'~TC is always high when ~CE is high (counting is disabled).'),(115,106,'The least significant (or only) comparator in a chain should have I__A=B and I__A&gt;B tied high and I__A&lt;B tied low.'),(116,106,'To compare more than 4 bits, connect Q__A&lt;B and Q__A=B to the inputs of the next significant comparator. I__A&gt;B of the next significant comparator should be tied high.'),(117,108,'Connect a timing capacitor C__EXT between nCEXT and nREXT/CEXT.'),(118,108,'Connect a resistor R__EXT between nREXT/CEXT and Vcc.'),(119,108,'A high-to-low transition on n~A when nB is low causes a pulse on nQ and n~Q.'),(120,108,'A low-to-high transition on nB when n~A is high causes a pulse on nQ and n~Q.'),(121,108,'Setting n~CD low inhibits pulses.'),(122,108,'(CD4528) For C__EXT > 0.01 &micro;F and Vcc = 5V, output pulse width = 0.2 &times; R__EXT &times; C__EXT.'),(123,108,'(HEF4528) For C__EXT > 0.01 &micro;F and Vcc = 5V, output pulse width = 0.42 &times; R__EXT &times; C__EXT.'),(124,110,'High Performance PIC18 Core, USB v2.0 compliant interface'),(125,111,'The device contains eight bidirectional analog switches.'),(126,111,'The analog inputs/outputs can swing between V__CC and V__EE.'),(127,111,'When ~E is high, all switches are in a high-impedance off state.'),(128,112,'ICP3, OC3A, OC3B present on ATmega1284P only'),(129,115,'When ~CP~1 is low, the counter advances on a low-to-high transition of CP0.'),(130,115,'When CP0 is high, the counter advances on a high-to-low transition of ~CP~1.'),(131,115,'TC goes high when the count is 0, CF is high, and PL is low.'),(132,115,'For a single-stage divide-by-n circuit, connect the TC output to PL and set the P0-P3 inputs to n.'),(133,116,'In older chips, ~IRQ was an open drain output. In the W65C22S, it is fully driven.'),(134,116,'Registers: <table> <tr><td>$00</td><td>Output register B (write), input register B (read)</td></tr> <tr><td>$01</td><td>Output register A (write), input register A (read)</td></tr> <tr><td>$02</td><td>Data direction register B</td></tr> <tr><td>$03</td><td>Data direction register A</td></tr> <tr><td>$04</td><td>Timer 1 latch LSB (write), timer 1 counter LSB (read)</td></tr> <tr><td>$05</td><td>Timer 1 counter MSB</td></tr> <tr><td>$06</td><td>Timer 1 latch LSB</td></tr> <tr><td>$07</td><td>Timer 1 latch MSB</td></tr> <tr><td>$08</td><td>Timer 2 latch LSB (write), timer 2 counter LSB (read)</td></tr> <tr><td>$09</td><td>Timer 2 counter MSB</td></tr> <tr><td>$0A</td><td>Shift register</td></tr> <tr><td>$0B</td><td>Auxiliary control register</td></tr> <tr><td>$0C</td><td>Peripheral control register</td></tr> <tr><td>$0D</td><td>Interrupt flag register</td></tr> <tr><td>$0E</td><td>Interrupt enable register</td></tr> <tr><td>$0F</td><td>Same as register $01, but with no effect on handshake</td></tr> </table>'),(135,116,'Timer 1 can operate in one-shot mode or free-running mode (square wave).'),(136,116,'Timer 2 can operate in one-shot mode or pulse-counting mode (counts negative pulses on PB6).'),(137,116,'Counters for timers in one-shot or free-running mode decrement at the &empty;2 clock rate.'),(138,116,'The shift register is 8 bits wide, can shift in or out, and can generate its own clock or shift under the control of an external clock on CB1.'),(139,117,'Setting ~OE~__1 or ~OE~__2 high causes the outputs to assume a high-impedance off state.'),(140,124,'Port A is designed to drive CMOS logic to normal 30%/70% levels.'),(141,124,'Port B uses three-state NMOS buffers and requires external resistors to pull up to CMOS levels.'),(142,124,'Port B is capable of driving Darlingtons.'),(143,124,'When in output mode, a read of Port A returns the actual pin states.'),(144,124,'When in output mode, a read of Port B returns the contents of the output latch.'),(145,124,'RS=00, bit 2 of control register A=1: peripheral register A'),(146,124,'RS=00, bit 2 of control register A=0: data direction register A'),(147,124,'RS=01: control register A'),(148,124,'RS=10, bit 2 of control register B=1: peripheral register B'),(149,124,'RS=10, bit 2 of control register B=0: data direction register B'),(150,124,'RS=11: control register B'),(151,125,'The TL06x series are low-power versions of the TL08x series.'),(152,125,'The TL07x series are low-noise versions of the TL08x series.'),(153,130,'S1 and S0 are low; hold (do nothing)'),(154,130,'S1 is high and S0 is low; shift left (DSL &rarr; Q7, Q7 &rarr; Q6)'),(155,130,'S1 is low and S0 is high; shift right (DSR &rarr; Q0, Q0 &rarr; Q1)'),(156,130,'S1 and S0 are high; parallel load (I/On &rarr; Qn)'),(157,137,'Registers: <table> <tr><td>A</td><td>Accumulator</td></tr> <tr><td>F</td><td>Condition Flags</td></tr> <tr><td>B & C</td><td>General Purpose 8-bit registers (may be used together as a 16-bit register)</td></tr> <tr><td>D & E</td><td>General Purpose 8-bit registers (may be used together as a 16-bit register)</td></tr> <tr><td>H & L</td><td>High & Low bytes of 16-bit Address Pointer Register</td></tr> <tr><td>I</td><td>Interrupt Register - Holds upper 8 bits of memory address for vectored interrupt processing</td></tr> <tr><td>R</td><td>Refresh Register - Automatically incremented for Dynamic Memory Refresh (read only)</td></tr> <tr><td>IX & IY</td><td>16-bit Index Registers</td></tr> <tr><td>SP</td><td>16-bit Stack Pointer Register</td></tr> <tr><td>PC</td><td>A16-bit Program Counter Register</td></tr> <tr><td>IFF</td><td>Interrupt Flip Flop Flag</td></tr> </table>'),(158,137,'All general-purpose registers are duplicated in the prime set (A\', F\',B\', C\', D\', E\', H\', L\')'),(159,141,'For maximum count length, connect CKB to Q__A and apply input pulses to CKA.'),(160,143,'The length of the shift register is determined by the sum of the length inputs (L__1, L__2, L__4, L__8, L__16, L__32) plus one.'),(161,143,'Data is shifted in on the low-to-high transition of CP__0 when ~CP~__1 is low, or the high-to-low transition of ~CP~__1 when CP__0 is high.'),(162,143,'When A/~B is high, a clock pulse shifts in data from D__A. When low, a clock pulse shifts in data from D__B.'),(163,143,'When MR is high, the register is reset, Q is forced low, and ~Q is forced high.'),(164,146,'The RC oscillator frequency is 1/(2.3 &times; R__t &times C__t). R__S = 2R__t.'),(165,146,'An external clock signal, connected to RS, may be used instead. The timer advances on the low-to-high transition of RS.'),(166,146,'The input frequency is divided by a value determined by A1A0: 2<sup>13</sup> (LL), 2<sup>10</sup> (LH), 2<sup>8</sup> (HL), or 2<sup>16</sup> (HH).'),(167,146,'Power-on reset is enabled when ~AR and MR are low. For HEF4541, Vcc should be above 8.5V for correct power-on reset.'),(168,146,'PH specifies the state of the output after reset (high or low).'),(169,146,'When MODE is high, the output oscillates continuously.'),(170,146,'When MODE is low, the output changes only once, after a single cycle.'),(171,148,'When an EN line is low, the corresponding outputs assume a high-impedance off state.'),(172,151,'Setting 1~OE high or 2OE low causes the outputs to assume a high-impedance off state.'),(173,152,'Data is written when ~CS1 is low, CS2 is high, and ~WE is low.'),(174,152,'Data is read when ~CS1 is low, CS2 is high, ~OE is low, and ~WE is high.'),(175,152,'The input/output pins assume a high-impedance state if ~CS1 is high or CS2 is low.'),(176,153,'For binary inputs 10 through 15, behavior is manufacturer-specific. 7441s may enable one or more output. 74141s and K155ID1s will turn all outputs off, but the connected tube may not blank.'),(177,156,'The gain can be varied between 20 and 200 with a resistor in series with a capacitor across pins 1 and 8.'),(178,160,'The Low Pin-count (8) PIC&reg; Flash microcontroller products offer all of the advantages of the well recognized mid-range x14 architecture with standardized features including a wide operating voltage of 2.0-5.5 volts, on-board EEPROM Data Memory, and nanoWatt Technology. Standard analog peripherals include up to 4 channels of 10-bit A/D, an analog comparator module with a single comparator, programmable on-chip voltage reference and a Standard Capture/Compare/PWM (CCP) module.'),(179,161,'Outputs are mutually exclusive active low.'),(180,161,'When ~E is high, all outputs are high.'),(181,253,'Fully Parallel 4-Bit ALU\'s in 20-Pin Package for 0.300-Inch Row Spacing'),(182,253,'Ideally Suited for High-Density Economical Processors'),(183,162,'Internal 32MHz oscillator, 60 LCD segment drive support, Integrated Capacitive mTouch Sensing Module'),(184,167,'When MODE is low, data is loaded into display RAM. When MODE is high, data is loaded into control register.'),(185,256,'Output Drive Capability: 10 LSTTL Loads'),(186,256,'Outputs Directly Interface to CMOS, NMOS, and TTL'),(187,256,'Low Input Current: 1 &micro;A'),(188,256,'High Noise Immunity Characteristic of CMOS Devices'),(189,257,'Directly compatible for use with SN54LS181/SN74LS181, SN54LS281/SN74LS281, SN54LS381/SN74LS381, SN54LS481/SN74LS481'),(190,171,'Register 00: read/write port A'),(191,171,'Register 01: read/write port B'),(192,171,'Register 10: read/write port C'),(193,171,'Register 11: read/write control word'),(194,171,'Control word: <table> <tr><td>Bit 0</td><td>Port C lower bits; 1=input, 0=output</td></tr> <tr><td>Bit 1</td><td>Port B; 1=input, 0=output</td></tr> <tr><td>Bit 2</td><td>Group B mode selection</td></tr> <tr><td>Bit 3</td><td>Port C upper bits; 1=input, 0=output</td></tr> <tr><td>Bit 4</td><td>Port A; 1=input, 0=output</td></tr> <tr><td>Bits 5-6</td><td>Group A mode selection</td></tr> <tr><td>Bit 7</td><td>1=mode set, 0=bit set/reset</td></tr> </table><br/>'),(195,171,'When bit 7 of control word is set to 1, the rest of the bits have the following functions: <table> <tr><td>Bit 0</td><td>1=set bit, 0=clear bit</td></tr> <tr><td>Bits 1-3</td><td>specify bit to modify (0-7)</td></tr> </table>'),(196,178,'Data is written when ~CE is low and ~WE is low.'),(197,178,'Data is read when ~CE is low, ~OE is low, and ~WE is high.'),(198,178,'The input/output pins assume a high-impedance state if ~CE is high.'),(199,181,'Registers: <table> <tr><td>A, B</td><td>8-bit Accumulators (can be combined into 16-bit accumulator, D)</td></tr> <tr><td>X</td><td>16-bit Index Register</td></tr> <tr><td>Y</td><td>16-bit Index Register</td></tr> <tr><td>U</td><td>16-bit User Stack Pointer</td></tr> <tr><td>S</td><td>16-bit Hardware Stack Pointer</td></tr> <tr><td>PC</td><td>16-bit Program Counter</td></tr> <tr><td>DP</td><td>8-bit Direct Page Register</td></tr> <tr><td>CC</td><td>8-bit Condition Code Register</td></tr> </table><br/>'),(200,181,'Condition code bits: EFHINZVC <table> <tr><td>E</td><td>(bit 7)</td><td>Entire machine state was stacked</td></tr> <tr><td>F</td><td>(bit 6)</td><td>~FIRQ inhibit flag</td></tr> <tr><td>H</td><td>(bit 5)</td><td>Half-carry flag (valid only after ADC or ADD instructions)</td></tr> <tr><td>I</td><td>(bit 4)</td><td>~IRQ inhibit flag</td></tr> <tr><td>N</td><td>(bit 3)</td><td>Negative flag (most significant bit of previous result)</td></tr> <tr><td>Z</td><td>(bit 2)</td><td>Zero flag</td></tr> <tr><td>V</td><td>(bit 1)</td><td>Signed two\'s complement overflow flag</td></tr> <tr><td>C</td><td>(bit 0)</td><td>Carry flag</td></tr> </table><br/>'),(201,181,'Register stacking order: <table> <tr><td>CC</td><td>(pulled first, pushed last)</td></tr> <tr><td>A</td><td></td></tr> <tr><td>B</td><td></td></tr> <tr><td>DP</td><td></td></tr> <tr><td>X msb</td><td></td></tr> <tr><td>X lsb</td><td></td></tr> <tr><td>Y msb</td><td></td></tr> <tr><td>Y lsb</td><td></td></tr> <tr><td>U/S msb</td><td></td></tr> <tr><td>U/S lsb</td><td></td></tr> <tr><td>PC msb</td><td></td></tr> <tr><td>PC lsb</td><td>(pulled last, pushed first)</td></tr> </table><br/>'),(202,181,'Interrupt vectors: <table> <tr><td>FFFE-FFFF</td><td>~RESET</td></tr> <tr><td>FFFC-FFFD</td><td>~NMI</td></tr> <tr><td>FFFA-FFFB</td><td>SWI</td></tr> <tr><td>FFF8-FFF9</td><td>~IRQ</td></tr> <tr><td>FFF6-FFF7</td><td>~FIRQ</td></tr> <tr><td>FFF4-FFF5</td><td>SWI2</td></tr> <tr><td>FFF2-FFF3</td><td>SWI3</td></tr> <tr><td>FFF1-FFF1</td><td>Reserved</td></tr> </table>'),(203,184,'Also availablle in SOIC package (same pinout)'),(204,186,'Pinout LM358 compatible'),(205,186,'Designed for high-impedance measurement applications'),(206,193,'When two or more inputs are simultaneously active, the input with the highest priority is represented on the output.'),(207,193,'~A~__8 has the highest priority.'),(208,193,'When all nine data inputs are high, all four outputs are high. (BCD zero)'),(209,194,'Temperature excursions beyond user defined Max / Min limits will trigger T__HIGH or T__LOW outputs for application driven temperature correction.'),(210,196,'Also available with 2 channels (MCP3202), 4 channels (MCP3204) and 8 channels (MCP3208)'),(211,197,'I2C address range: 0x40-0x4e (7-bit address range: 0x20-0x27)'),(212,200,'Bit order numbering is backwards. 0 is the MSB and 7 is the LSB.'),(213,200,'Write to control register: set MODE high, write data byte, write destination register in the format 10000RRR.'),(214,200,'Write to VRAM: set MODE high, write lower address bits, write upper address bits (with highest bits set to 01), set MODE low, write data bytes. Address autoincrements.'),(215,200,'Read from status register: set MODE high, read byte.'),(216,200,'Read from VRAM: write lower address bits, write upper address bits (with highest bits set to 00), set MODE low, read data bytes. Address autoincrements.'),(217,200,'MODE determines the source or destination of a CPU read/write data transfer.'),(218,200,'Control registers: <table> <tr><td>0</td><td>VDP option control bits (mode, external VDP enable)</td></tr> <tr><td>1</td><td>VDP option control bits (4/16K RAM, BLANK, interrupt enable, mode, sprite size, magnification)</td></tr> <tr><td>2</td><td>Name table base address (0-15)</td></tr> <tr><td>3</td><td>Color table base address (0-255)</td></tr> <tr><td>4</td><td>Pattern generator base address (0-7)</td></tr> <tr><td>5</td><td>Sprite attribute table base address (0-127)</td></tr> <tr><td>6</td><td>Sprite pattern generator base address (0-7)</td></tr> <tr><td>7</td><td>Text color, backdrop color</td></tr> </table>'),(219,200,'Graphics modes: <table> <tr><td>Text mode</td><td>40x24 text positions, 6x8-pixel patterns, two colors, no sprites</td></tr> <tr><td>Graphics I mode</td><td>32x24 tile positions, 8x8-pixel patterns, 256 possible patterns with 2 colors per pattern, sprites</td></tr> <tr><td>Graphics II mode</td><td>32x24 tile positions, 8x8-pixel patterns, 768 possible patterns with 2 colors per row, sprites</td></tr> <tr><td>Multicolor mode</td><td>64x48 solid 4x4-pixel blocks of any color, sprites</td></tr> </table>'),(220,202,'The TL06x series are low-power versions of the TL08x series.'),(221,202,'The TL07x series are low-noise versions of the TL08x series.'),(222,204,'ULN2002 is designed for use with 14V to 25V PMOS devices.'),(223,204,'ULN2003 is designed for use with 5V TTL/CMOS devices.'),(224,204,'ULN2004 is designed for use with 6V to 15V CMOS devices.'),(225,208,'C1 and C2 are integrating capacitors for the filter; polystyrene capacitors are preferred.'),(226,208,'C1 and C2 should have the same value. 2200 pF gives good operation over the audio range (30Hz-12kHz).'),(227,208,'Filter cutoff frequency is approx. 2.6&times;10<sup>-5</sup>/C (where C is the value of C1 or C2).'),(228,208,'POTX and POTY pins must be connected to RC networks; the time constant RC should be 4.7&times;10<sup>-4</sup>. Recommended capacitor value is 1000 pF, recommended potentiometer value is 470 k&Omega;.'),(229,208,'Maximum audio output level is approx. 3V p-p at a 6V DC level. A 1k&Omega; resistor should be connected from AUDIO OUT to ground, and a 1-10&micro;F electrolytic capacitor should be used for AC coupling.'),(230,208,'Registers: <table> <tr><td>$00</td><td>Voice 1 frequency low byte</td></tr> <tr><td>$01</td><td>Voice 1 frequency high byte</td></tr> <tr><td>$02</td><td>Voice 1 pulse width low byte</td></tr> <tr><td>$03</td><td>Voice 1 pulse width high byte (bits 3-0)</td></tr> <tr><td>$04</td><td>Voice 1 control (gate, sync, ring mod, waveform)</td></tr> <tr><td>$05</td><td>Voice 1 attack/decay rates</td></tr> <tr><td>$06</td><td>Voice 1 sustain level/release rate</td></tr> <tr><td>$07</td><td>Voice 2 frequency low byte</td></tr> <tr><td>$08</td><td>Voice 2 frequency high byte</td></tr> <tr><td>$09</td><td>Voice 2 pulse width low byte</td></tr> <tr><td>$0A</td><td>Voice 2 pulse width high byte (bits 3-0)</td></tr> <tr><td>$0B</td><td>Voice 2 control (gate, sync, ring mod, waveform)</td></tr> <tr><td>$0C</td><td>Voice 2 attack/decay rates</td></tr> <tr><td>$0D</td><td>Voice 2 sustain level/release rate</td></tr> <tr><td>$0E</td><td>Voice 3 frequency low byte</td></tr> <tr><td>$0F</td><td>Voice 3 frequency high byte</td></tr> <tr><td>$10</td><td>Voice 3 pulse width low byte</td></tr> <tr><td>$11</td><td>Voice 3 pulse width high byte (bits 3-0)</td></tr> <tr><td>$12</td><td>Voice 3 control (gate, sync, ring mod, waveform)</td></tr> <tr><td>$13</td><td>Voice 3 attack/decay rates</td></tr> <tr><td>$14</td><td>Voice 3 sustain level/release rate</td></tr> <tr><td>$15</td><td>Filter cutoff frequency low byte</td></tr> <tr><td>$16</td><td>Filter cutoff frequency high byte (bits 2-0)</td></tr> <tr><td>$17</td><td>Filter resonance/control</td></tr> <tr><td>$18</td><td>Filter mode/volume control</td></tr> <tr><td>$19</td><td>POTX value (0-255), updated every 512 clock cycles</td></tr> <tr><td>$1A</td><td>POTY value (0-255), updated every 512 clock cycles</td></tr> <tr><td>$1B</td><td>Upper 8 bits of Oscillator 3 value (random number if noise waveform is selected)</td></tr> <tr><td>$1C</td><td>Upper 8 bits of Voice 3 envelope generator value</td></tr> </table>'),(231,208,'Oscillator frequency = (Fn &times; Fclk/16777216) Hz'),(232,208,'Pulse width = (PWn/40.95) %'),(233,209,'Either DSA or DSB can be used as an active high enable for data entry through the other input.'),(234,209,'Otherwise, Both inputs must be connected together or an unused input must be tied high.'),(235,211,'Pins for lit segments are high. The 4511 can directly drive a common cathode LED display.'),(236,211,'Display is blanked for inputs greater than 9.'),(237,215,'Outputs are mutually exclusive, active high.'),(238,215,'When n~E is high, all outputs nY are low.'),(239,217,'The Z8O Parallel I/O (PlO) Circuit is a programmable, two port device which provides a TTL compatible interface between peripheral devices and the Z80-GPU. The CPU can configure the Z8O-PIO to interface with a wide range of peripheral devices with no other external logic required, Typical peripheral devices that are fully compatible with the Z80-PIO include most keyboards, paper tape readers and punches, printers, PROM programmers, etc. The Z8O-PIO is packaged in a 40-pin DIP, or a 44-pin PLCC, or a 44-pin OFP. NMOS and CMOS versions are also available. Major features of the Z80-PlO include.'),(240,217,'One of the unique features of the Z80-PlO that separates it from other interface controllers is that all data transfer between the peripheral device and the CPU is accomplished under total interrupt control. The interrupt logic of the PIO permits full usage of the efficient interrupt capabilities of the Z80-CPU during I/0 transfers. All logic necessary to implement a fully nested interrupt structure is included in the PIO so that additional circuits are not required. Another unique feature of the PlO is that it can be programmed to interrupt the CPU on the occurrence of specified status conditions in the peripheral device. For example, the PlO can be programmed to interrupt if any specified peripheral alarm conditions should occur. This interrupt capability reduces the amount of time that the processor must spend in polling peripheral status.'),(241,221,'The device contains sixteen bidirectional analog switches.'),(242,221,'The analog inputs/outputs can swing between V__CC and GND.'),(243,221,'When ~E is high, all switches are in a high-impedance off state.'),(244,225,'Decimal points are driven independently and current-limiting resistors (typically 1k&Omega;) are required.'),(245,228,'The 74423 is identical to the 74123, except it cannot be triggered via the reset input.'),(246,234,'Q = <span class=\'neg\'>INH OR (A AND B) OR (C AND D)</span>'),(247,235,'~TCU goes low when the count is 15.'),(248,235,'~TCD goes low when the count is 0.'),(249,237,'Outputs are mutually exclusive, active low.'),(250,237,'When n~E is high, all outputs n~Y~ are high.'),(251,239,'Setting 1~OE or 2~OE high causes the outputs to assume a high-impedance off state.'),(252,240,'The low-to-high transition of input ~CE should only take place while CP is high for predictable operation.'),(253,240,'Either CP or ~CE should be high before the low-to-high transition of ~PL to prevent shifting the data when ~PL is activated.'),(254,243,'S__0 and S__1 are low; hold (do nothing)'),(255,243,'S__0 low and S__1 high; shift left'),(256,243,'S__0 high and S__1 low; shift right'),(257,243,'S__0 and S__1 high; parallel load'),(258,244,'State changes of Q__n outputs do not occur simultaneously.'),(259,244,'Setting both MR__1 and MR__2 high resets the counter to zero.'),(260,244,'For a 4-bit counter, connect Q__0 to ~CP~__1, and apply count pulses to ~CP~__0.'),(261,244,'For a 3-bit counter, apply count pulses to ~CP~__1.');
/*!40000 ALTER TABLE `notes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-04 18:39:30
