-- MySQL dump 10.13  Distrib 8.0.23, for Linux (x86_64)
--
-- Host: localhost    Database: patientledgerdb
-- ------------------------------------------------------
-- Server version	8.0.23-0ubuntu0.20.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
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
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `billing` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ledger_entry_id` int NOT NULL,
  `service_date` date NOT NULL,
  `billing_type_id` tinyint NOT NULL,
  `category_id` tinyint NOT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `billing`
--

LOCK TABLES `billing` WRITE;
/*!40000 ALTER TABLE `billing` DISABLE KEYS */;
INSERT INTO `billing` VALUES (5,4,'2021-03-16',3,3,1,1,'2021-03-19 14:10:42','2021-03-19 14:10:42'),(6,5,'2021-03-19',2,1,1,1,'2021-03-19 15:55:48','2021-03-19 15:55:48'),(7,6,'2021-03-19',2,1,1,0,'2021-03-19 15:57:04','2021-03-19 15:57:04'),(8,7,'2021-03-19',3,3,1,1,'2021-03-19 16:37:47','2021-03-19 16:37:47'),(9,8,'2021-03-19',2,1,1,1,'2021-03-19 19:26:58','2021-03-19 19:26:58'),(10,9,'2021-03-19',2,1,1,1,'2021-03-19 19:29:36','2021-03-19 19:29:36'),(11,10,'2021-03-19',2,1,1,1,'2021-03-19 19:30:04','2021-03-19 19:30:04'),(12,11,'2021-03-19',1,2,0,1,'2021-03-20 04:22:10','2021-03-20 04:22:10'),(13,11,'2021-03-20',2,2,0,1,'2021-03-22 01:29:41','2021-03-22 01:29:41'),(14,12,'2021-03-24',1,1,1,0,'2021-03-24 18:11:21','2021-03-24 18:11:21'),(15,13,'2021-03-24',2,1,1,0,'2021-03-24 20:04:05','2021-03-24 20:04:05'),(16,14,'2021-03-24',2,1,1,1,'2021-03-24 22:36:50','2021-03-24 22:36:50'),(17,15,'2021-03-19',2,2,1,0,'2021-03-24 22:47:04','2021-03-24 22:47:04'),(18,16,'2021-03-24',3,3,1,1,'2021-03-24 23:58:25','2021-03-24 23:58:25'),(20,18,'2021-03-25',3,3,1,1,'2021-03-26 19:45:59','2021-03-26 19:45:59'),(21,19,'2021-03-26',2,1,0,0,'2021-03-26 19:54:03','2021-03-26 19:54:03'),(22,19,'2021-03-26',3,3,1,1,'2021-03-26 19:55:04','2021-03-26 19:55:04'),(23,20,'2021-03-26',2,1,1,0,'2021-03-26 20:24:01','2021-03-26 20:24:01'),(24,21,'2021-03-26',2,1,1,0,'2021-03-26 20:24:27','2021-03-26 20:24:27'),(25,22,'2021-03-26',3,3,1,1,'2021-03-26 21:03:40','2021-03-26 21:03:40'),(26,23,'2021-03-26',1,1,1,1,'2021-03-26 22:22:30','2021-03-26 22:22:30'),(27,24,'2021-03-26',1,1,1,1,'2021-03-26 22:23:02','2021-03-26 22:23:02'),(28,25,'2021-03-30',2,1,1,0,'2021-03-30 14:38:12','2021-03-30 14:38:12'),(29,26,'2021-03-30',1,1,1,1,'2021-03-30 15:13:13','2021-03-30 15:13:13'),(30,27,'2021-03-30',2,1,1,0,'2021-03-30 15:57:54','2021-03-30 15:57:54'),(31,28,'2021-03-30',2,1,1,0,'2021-03-30 17:11:06','2021-03-30 17:11:06'),(32,29,'2021-03-30',3,3,1,1,'2021-03-30 23:02:15','2021-03-30 23:02:15'),(33,30,'2021-03-30',3,3,1,1,'2021-03-30 23:11:51','2021-03-30 23:11:51'),(34,31,'2021-03-31',1,1,1,1,'2021-03-31 14:34:52','2021-03-31 14:34:52'),(35,32,'2021-03-29',1,1,1,1,'2021-03-31 22:10:32','2021-03-31 22:10:32'),(36,33,'2021-03-29',2,1,1,0,'2021-03-31 22:11:15','2021-03-31 22:11:15'),(39,36,'2021-03-29',2,1,1,1,'2021-03-31 22:13:41','2021-03-31 22:13:41'),(40,37,'2021-03-29',2,1,1,0,'2021-03-31 22:17:00','2021-03-31 22:17:00'),(41,38,'2021-03-29',2,1,1,1,'2021-03-31 22:17:41','2021-03-31 22:17:41'),(42,39,'2021-03-31',2,1,1,1,'2021-03-31 22:46:48','2021-03-31 22:46:48'),(43,40,'2021-03-31',2,1,1,1,'2021-03-31 23:11:45','2021-03-31 23:11:45'),(44,41,'2021-03-31',2,1,1,1,'2021-03-31 23:52:29','2021-03-31 23:52:29'),(46,43,'2021-03-31',1,1,1,0,'2021-03-31 23:53:49','2021-03-31 23:53:49'),(47,44,'2021-04-02',2,1,1,0,'2021-04-02 16:20:50','2021-04-02 16:20:50'),(48,45,'2021-04-02',1,1,0,0,'2021-04-02 17:13:54','2021-04-02 17:13:54'),(49,46,'2021-04-02',2,1,0,0,'2021-04-02 17:14:17','2021-04-02 17:14:17'),(50,47,'2021-04-02',2,1,1,0,'2021-04-02 17:14:41','2021-04-02 17:14:41'),(51,48,'2021-04-02',3,3,1,1,'2021-04-02 21:41:23','2021-04-02 21:41:23'),(52,49,'2021-04-02',3,3,1,1,'2021-04-02 21:50:42','2021-04-02 21:50:42'),(53,50,'2021-04-02',1,1,1,1,'2021-04-02 22:10:07','2021-04-02 22:10:07'),(54,51,'2021-04-02',2,1,0,0,'2021-04-02 22:13:16','2021-04-02 22:13:16'),(55,52,'2021-04-05',2,1,1,1,'2021-04-05 17:07:40','2021-04-05 17:07:40'),(56,53,'2021-04-05',2,1,1,0,'2021-04-05 17:08:35','2021-04-05 17:08:35'),(57,54,'2021-04-05',2,1,1,1,'2021-04-05 17:09:59','2021-04-05 17:09:59'),(58,55,'2021-04-05',2,1,1,1,'2021-04-05 17:10:30','2021-04-05 17:10:30'),(59,56,'2021-04-05',1,1,1,1,'2021-04-05 19:21:31','2021-04-05 19:21:31'),(60,57,'2021-04-05',3,3,1,1,'2021-04-05 22:04:22','2021-04-05 22:04:22'),(62,59,'2021-04-05',2,1,1,1,'2021-04-05 22:26:21','2021-04-05 22:26:21'),(63,60,'2021-04-05',2,1,1,0,'2021-04-05 22:39:34','2021-04-05 22:39:34'),(64,61,'2021-04-07',2,1,1,0,'2021-04-07 22:14:39','2021-04-07 22:14:39'),(65,62,'2021-04-07',2,1,1,1,'2021-04-07 23:39:18','2021-04-07 23:39:18'),(66,63,'2021-04-07',2,1,1,0,'2021-04-08 00:13:24','2021-04-08 00:13:24'),(67,64,'2021-04-07',1,1,1,1,'2021-04-08 00:13:45','2021-04-08 00:13:45'),(68,65,'2021-04-07',2,1,1,0,'2021-04-08 00:14:46','2021-04-08 00:14:46'),(69,66,'2021-04-07',2,1,1,0,'2021-04-08 00:15:11','2021-04-08 00:15:11'),(70,67,'2021-04-07',2,1,1,0,'2021-04-08 00:19:49','2021-04-08 00:19:49'),(71,68,'2021-04-07',2,1,1,0,'2021-04-08 00:20:38','2021-04-08 00:20:38'),(72,69,'2021-04-06',1,1,1,1,'2021-04-09 12:32:52','2021-04-09 12:32:52'),(73,70,'2021-04-09',1,1,1,0,'2021-04-09 13:39:15','2021-04-09 13:39:15'),(74,71,'2021-04-09',2,1,1,0,'2021-04-09 14:14:42','2021-04-09 14:14:42'),(75,72,'2021-04-09',2,1,1,0,'2021-04-09 15:53:04','2021-04-09 15:53:04'),(76,73,'2021-04-09',3,3,1,1,'2021-04-09 16:27:52','2021-04-09 16:27:52');
/*!40000 ALTER TABLE `billing` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `billing_type`
--

DROP TABLE IF EXISTS `billing_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `billing_type` (
  `id` tinyint NOT NULL AUTO_INCREMENT,
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
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `id` tinyint NOT NULL AUTO_INCREMENT,
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
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category_billing_type` (
  `category_id` tinyint NOT NULL,
  `billing_type_id` tinyint NOT NULL,
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
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ledger_entry` (
  `id` int NOT NULL AUTO_INCREMENT,
  `age` smallint NOT NULL,
  `initials` varchar(10) DEFAULT NULL,
  `start_date` date NOT NULL,
  `entry_complete` tinyint(1) DEFAULT '0',
  `created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ledger_entry`
--

LOCK TABLES `ledger_entry` WRITE;
/*!40000 ALTER TABLE `ledger_entry` DISABLE KEYS */;
INSERT INTO `ledger_entry` VALUES (4,14,'JJ','2021-03-16',1,'2021-03-19 14:10:40','2021-03-19 14:10:40'),(5,3,'DM','2021-03-19',1,'2021-03-19 15:55:48','2021-03-19 15:55:48'),(6,10,'LG','2021-03-19',0,'2021-03-19 15:57:04','2021-03-19 15:57:04'),(7,13,'GF','2021-03-19',1,'2021-03-19 16:37:47','2021-03-19 16:37:47'),(8,17,'MH','2021-03-19',1,'2021-03-19 19:26:58','2021-03-19 19:26:58'),(9,9,'LW','2021-03-19',1,'2021-03-19 19:29:36','2021-03-19 19:29:36'),(10,19,'SR','2021-03-19',1,'2021-03-19 19:30:04','2021-03-19 19:30:04'),(11,1,'JL','2021-03-19',0,'2021-03-20 04:22:10','2021-03-20 04:22:10'),(12,15,'LD','2021-03-24',0,'2021-03-24 18:11:21','2021-03-24 18:11:21'),(13,15,'SM','2021-03-24',0,'2021-03-24 20:04:05','2021-03-24 20:04:05'),(14,2,'DM','2021-03-24',0,'2021-03-24 22:36:50','2021-03-24 22:36:50'),(15,20,'DH','2021-03-19',0,'2021-03-24 22:47:04','2021-03-24 22:47:04'),(16,3,'JV','2021-03-24',0,'2021-03-24 23:58:25','2021-03-24 23:58:25'),(17,5,'JJ','2021-03-25',0,'2021-03-26 03:13:21','2021-03-26 03:13:21'),(18,2,'LGM','2021-03-25',1,'2021-03-26 19:45:59','2021-03-26 19:45:59'),(19,6,'AT','2021-03-26',0,'2021-03-26 19:54:02','2021-03-26 19:54:02'),(20,12,'TJB','2021-03-26',0,'2021-03-26 20:24:01','2021-03-26 20:24:01'),(21,7,'VB','2021-03-26',0,'2021-03-26 20:24:27','2021-03-26 20:24:27'),(22,17,'DR','2021-03-26',1,'2021-03-26 21:03:40','2021-03-26 21:03:40'),(23,12,'EHC','2021-03-26',1,'2021-03-26 22:22:30','2021-03-26 22:22:30'),(24,16,'GC','2021-03-26',1,'2021-03-26 22:23:02','2021-03-26 22:23:02'),(25,6,'AK','2021-03-30',0,'2021-03-30 14:38:11','2021-03-30 14:38:11'),(26,3,'GM','2021-03-30',1,'2021-03-30 15:13:13','2021-03-30 15:13:13'),(27,2,'NW','2021-03-30',0,'2021-03-30 15:57:54','2021-03-30 15:57:54'),(28,1,'MA','2021-03-30',0,'2021-03-30 17:11:00','2021-03-30 17:11:00'),(29,20,'YD','2021-03-30',1,'2021-03-30 23:02:15','2021-03-30 23:02:15'),(30,10,'LGM','2021-03-30',0,'2021-03-30 23:11:51','2021-03-30 23:11:51'),(31,5,'KJ','2021-03-31',1,'2021-03-31 14:34:52','2021-03-31 14:34:52'),(32,5,'BH','2021-03-29',1,'2021-03-31 22:10:32','2021-03-31 22:10:32'),(33,9,'SH','2021-03-29',0,'2021-03-31 22:11:15','2021-03-31 22:11:15'),(34,16,'JS','2021-03-29',0,'2021-03-31 22:12:05','2021-03-31 22:12:05'),(35,11,'AM','2021-03-29',1,'2021-03-31 22:13:14','2021-03-31 22:13:14'),(36,11,'EH','2021-03-29',1,'2021-03-31 22:13:41','2021-03-31 22:13:41'),(37,16,'JS','2021-03-29',0,'2021-03-31 22:17:00','2021-03-31 22:17:00'),(38,11,'AM','2021-03-29',1,'2021-03-31 22:17:41','2021-03-31 22:17:41'),(39,9,'MC','2021-03-31',1,'2021-03-31 22:46:48','2021-03-31 22:46:48'),(40,5,'BR','2021-03-31',1,'2021-03-31 23:11:45','2021-03-31 23:11:45'),(41,14,'AF','2021-03-31',0,'2021-03-31 23:52:29','2021-03-31 23:52:29'),(42,13,'CB','2021-03-31',0,'2021-03-31 23:53:07','2021-03-31 23:53:07'),(43,13,'CB','2021-03-31',0,'2021-03-31 23:53:49','2021-03-31 23:53:49'),(44,13,'FR','2021-04-02',0,'2021-04-02 16:20:50','2021-04-02 16:20:50'),(45,2,'NW','2021-04-02',0,'2021-04-02 17:13:48','2021-04-02 17:13:48'),(46,6,'DGG','2021-04-02',0,'2021-04-02 17:14:17','2021-04-02 17:14:17'),(47,19,'GGU','2021-04-02',0,'2021-04-02 17:14:41','2021-04-02 17:14:41'),(48,1,'DMH','2021-04-02',1,'2021-04-02 21:41:23','2021-04-02 21:41:23'),(49,3,'GRJ','2021-04-02',1,'2021-04-02 21:50:42','2021-04-02 21:50:42'),(50,5,'CAC','2021-04-02',1,'2021-04-02 22:10:07','2021-04-02 22:10:07'),(51,5,'SR','2021-04-02',0,'2021-04-02 22:13:16','2021-04-02 22:13:16'),(52,11,'DK','2021-04-05',1,'2021-04-05 17:07:40','2021-04-05 17:07:40'),(53,7,'EH','2021-04-05',0,'2021-04-05 17:08:34','2021-04-05 17:08:34'),(54,8,'TM','2021-04-05',1,'2021-04-05 17:09:59','2021-04-05 17:09:59'),(55,12,'JS','2021-04-05',1,'2021-04-05 17:10:30','2021-04-05 17:10:30'),(56,8,'JC','2021-04-05',1,'2021-04-05 19:21:31','2021-04-05 19:21:31'),(57,9,'GF','2021-04-05',1,'2021-04-05 22:04:22','2021-04-05 22:04:22'),(58,8,'EG','2021-04-05',0,'2021-04-05 22:15:58','2021-04-05 22:15:58'),(59,8,'EG','2021-04-05',1,'2021-04-05 22:26:21','2021-04-05 22:26:21'),(60,11,'AM','2021-04-05',0,'2021-04-05 22:39:34','2021-04-05 22:39:34'),(61,6,'KK','2021-04-07',0,'2021-04-07 22:14:38','2021-04-07 22:14:38'),(62,13,'SA','2021-04-07',1,'2021-04-07 23:39:18','2021-04-07 23:39:18'),(63,9,'GF','2021-04-07',0,'2021-04-08 00:13:24','2021-04-08 00:13:24'),(64,17,'SC','2021-04-07',1,'2021-04-08 00:13:45','2021-04-08 00:13:45'),(65,17,'DS','2021-04-07',0,'2021-04-08 00:14:46','2021-04-08 00:14:46'),(66,16,'SC','2021-04-07',0,'2021-04-08 00:15:11','2021-04-08 00:15:11'),(67,14,'MD','2021-04-07',0,'2021-04-08 00:19:49','2021-04-08 00:19:49'),(68,16,'PC','2021-04-07',0,'2021-04-08 00:20:30','2021-04-08 00:20:30'),(69,0,'CP','2021-04-06',1,'2021-04-09 12:32:52','2021-04-09 12:32:52'),(70,0,'SM','2021-04-09',0,'2021-04-09 13:39:15','2021-04-09 13:39:15'),(71,6,'AG','2021-04-09',0,'2021-04-09 14:14:42','2021-04-09 14:14:42'),(72,19,'SM','2021-04-09',0,'2021-04-09 15:53:04','2021-04-09 15:53:04'),(73,10,'ARD','2021-04-09',1,'2021-04-09 16:27:52','2021-04-09 16:27:52');
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

-- Dump completed on 2021-04-09 16:04:06