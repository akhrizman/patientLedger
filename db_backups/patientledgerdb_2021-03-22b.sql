-- MySQL dump 10.13  Distrib 5.7.33, for Linux (x86_64)
--
-- Host: localhost    Database: patientledgerdb
-- ------------------------------------------------------
-- Server version	5.7.33-0ubuntu0.18.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `billing`
--

DROP TABLE IF EXISTS `billing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `billing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ledger_entry_id` int(11) NOT NULL,
  `service_date` date NOT NULL,
  `billing_type_id` tinyint(4) NOT NULL,
  `category_id` tinyint(4) NOT NULL,
  `billed` tinyint(1) DEFAULT '0',
  `report_complete` tinyint(1) DEFAULT '0',
  `created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `ledger_entry_id` (`ledger_entry_id`),
  KEY `billing_type_id` (`billing_type_id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `billing_ibfk_1` FOREIGN KEY (`ledger_entry_id`) REFERENCES `ledger_entry` (`id`),
  CONSTRAINT `billing_ibfk_2` FOREIGN KEY (`billing_type_id`) REFERENCES `billing_type` (`id`),
  CONSTRAINT `billing_ibfk_3` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `billing`
--

LOCK TABLES `billing` WRITE;
/*!40000 ALTER TABLE `billing` DISABLE KEYS */;
INSERT INTO `billing` VALUES (5,4,'2021-03-16',3,3,1,1,'2021-03-19 14:10:42','2021-03-19 14:10:42'),(6,5,'2021-03-19',2,1,1,1,'2021-03-19 15:55:48','2021-03-19 15:55:48'),(7,6,'2021-03-19',2,1,1,0,'2021-03-19 15:57:04','2021-03-19 15:57:04'),(8,7,'2021-03-19',3,3,1,1,'2021-03-19 16:37:47','2021-03-19 16:37:47'),(9,8,'2021-03-19',2,1,1,1,'2021-03-19 19:26:58','2021-03-19 19:26:58'),(10,9,'2021-03-19',2,1,1,1,'2021-03-19 19:29:36','2021-03-19 19:29:36'),(11,10,'2021-03-19',2,1,1,1,'2021-03-19 19:30:04','2021-03-19 19:30:04'),(12,11,'2021-03-19',1,2,0,1,'2021-03-20 04:22:10','2021-03-20 04:22:10'),(13,11,'2021-03-20',2,2,0,1,'2021-03-22 01:29:41','2021-03-22 01:29:41');
/*!40000 ALTER TABLE `billing` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `billing_type`
--

DROP TABLE IF EXISTS `billing_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `billing_type` (
  `id` tinyint(4) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `billing_type`
--

LOCK TABLES `billing_type` WRITE;
/*!40000 ALTER TABLE `billing_type` DISABLE KEYS */;
INSERT INTO `billing_type` VALUES (1,'New Patient'),(2,'Follow-Up'),(3,'EEG'),(4,'Video EEG Day 1'),(5,'Video EEG Continuation'),(6,'Lumbar Puncture');
/*!40000 ALTER TABLE `billing_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `category` (
  `id` tinyint(4) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'Office Visit'),(2,'Hospital Visit'),(3,'Procedure');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category_billing_type`
--

DROP TABLE IF EXISTS `category_billing_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `category_billing_type` (
  `category_id` tinyint(4) NOT NULL,
  `billing_type_id` tinyint(4) NOT NULL,
  PRIMARY KEY (`category_id`,`billing_type_id`),
  KEY `billing_type_id` (`billing_type_id`),
  CONSTRAINT `category_billing_type_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`),
  CONSTRAINT `category_billing_type_ibfk_2` FOREIGN KEY (`billing_type_id`) REFERENCES `billing_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category_billing_type`
--

LOCK TABLES `category_billing_type` WRITE;
/*!40000 ALTER TABLE `category_billing_type` DISABLE KEYS */;
INSERT INTO `category_billing_type` VALUES (1,1),(2,1),(1,2),(2,2),(3,3),(3,4),(3,5),(3,6);
/*!40000 ALTER TABLE `category_billing_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ledger_entry`
--

DROP TABLE IF EXISTS `ledger_entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ledger_entry` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `age` smallint(6) NOT NULL,
  `initials` varchar(10) DEFAULT NULL,
  `start_date` date NOT NULL,
  `entry_complete` tinyint(1) DEFAULT '0',
  `created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ledger_entry`
--

LOCK TABLES `ledger_entry` WRITE;
/*!40000 ALTER TABLE `ledger_entry` DISABLE KEYS */;
INSERT INTO `ledger_entry` VALUES (4,14,'JJ','2021-03-16',1,'2021-03-19 14:10:40','2021-03-19 14:10:40'),(5,3,'DM','2021-03-19',1,'2021-03-19 15:55:48','2021-03-19 15:55:48'),(6,10,'LG','2021-03-19',0,'2021-03-19 15:57:04','2021-03-19 15:57:04'),(7,13,'GF','2021-03-19',1,'2021-03-19 16:37:47','2021-03-19 16:37:47'),(8,17,'MH','2021-03-19',1,'2021-03-19 19:26:58','2021-03-19 19:26:58'),(9,9,'LW','2021-03-19',1,'2021-03-19 19:29:36','2021-03-19 19:29:36'),(10,19,'SR','2021-03-19',1,'2021-03-19 19:30:04','2021-03-19 19:30:04'),(11,1,'JL','2021-03-19',0,'2021-03-20 04:22:10','2021-03-20 04:22:10');
/*!40000 ALTER TABLE `ledger_entry` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-03-22 21:15:53
