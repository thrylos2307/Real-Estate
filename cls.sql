-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: dbms_project
-- ------------------------------------------------------
-- Server version	8.0.19

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
-- Table structure for table `address`
--

DROP TABLE IF EXISTS `address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `address` (
  `reg_num` int NOT NULL,
  `house_no` varchar(20) DEFAULT NULL,
  `locality` varchar(50) DEFAULT NULL,
  `city` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`reg_num`),
  CONSTRAINT `address_ibfk_1` FOREIGN KEY (`reg_num`) REFERENCES `listing` (`reg_num`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `address`
--

LOCK TABLES `address` WRITE;
/*!40000 ALTER TABLE `address` DISABLE KEYS */;
/*!40000 ALTER TABLE `address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `username` varchar(20) DEFAULT NULL,
  `password` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES ('tushar',123456);
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `agent`
--

DROP TABLE IF EXISTS `agent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agent` (
  `agentid` int NOT NULL AUTO_INCREMENT,
  `name` varchar(30) DEFAULT NULL,
  `phone` bigint DEFAULT NULL,
  `firmid` int NOT NULL,
  `date_list` datetime DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`agentid`),
  KEY `firmid` (`firmid`),
  CONSTRAINT `agent_ibfk_1` FOREIGN KEY (`firmid`) REFERENCES `firm` (`firmid`)
) ENGINE=InnoDB AUTO_INCREMENT=50006 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agent`
--

LOCK TABLES `agent` WRITE;
/*!40000 ALTER TABLE `agent` DISABLE KEYS */;
INSERT INTO `agent` VALUES (1,'panda',9854565,102,'2020-01-05 00:00:00','42515'),(11,'rocky',12345,102,'2010-02-12 00:00:00','123'),(12,'puneet',12346,105,'2012-05-14 00:00:00','1234'),(13,'rishab',12347,109,'2005-05-05 00:00:00',NULL),(14,'sameer',12348,103,'2002-04-03 00:00:00',NULL),(15,'raj',12349,102,'2003-06-08 00:00:00',NULL),(16,'sanju',12350,101,'2008-09-07 00:00:00',NULL),(18,'Istbul',12376,101,'2018-09-08 00:00:00',NULL),(19,'raghu',12345678,102,'2020-05-21 00:00:00','1234'),(20,'retejf',12345678,102,'2020-05-21 00:00:00','2345'),(50000,'ram',75698422,105,'2020-05-27 00:00:00','12345'),(50001,'lion',4564654,102,'2020-05-27 00:00:00','12345'),(50002,'hgfhggh',24242,103,'2020-04-27 15:29:38','hgfhggh103'),(50004,'fhjshfj',4654654,102,'2020-04-28 15:18:40','sjlfnsjkf'),(50005,'tiger',46513164,104,'2020-04-28 16:44:04','tiger104');
/*!40000 ALTER TABLE `agent` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `agent_AFTER_INSERT` AFTER INSERT ON `agent` FOR EACH ROW BEGIN
    delete from new_agent where new_agent.firmid in (select new.firmid from agent);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `apartment`
--

DROP TABLE IF EXISTS `apartment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apartment` (
  `agentid` int DEFAULT NULL,
  `reg_num` int NOT NULL,
  `ownername` varchar(30) DEFAULT NULL,
  `price` int DEFAULT NULL,
  `type` varchar(30) DEFAULT NULL,
  `size` int DEFAULT NULL,
  `bathrooms` int DEFAULT NULL,
  `bedrooms` int DEFAULT NULL,
  PRIMARY KEY (`reg_num`),
  CONSTRAINT `apartment_ibfk_1` FOREIGN KEY (`reg_num`) REFERENCES `property` (`reg_num`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apartment`
--

LOCK TABLES `apartment` WRITE;
/*!40000 ALTER TABLE `apartment` DISABLE KEYS */;
INSERT INTO `apartment` VALUES (12,515,'ABHISHEK RAUT',12000,'rent',200,2,3),(14,516,'ADITYA ARUN SHARMA',24000,'rent',100,1,3),(15,517,'ADUDODLA ANKITH REDDY',11500,'rent',400,1,4),(12,52215,'jkadkladk',35455,'rent',41564,12,12);
/*!40000 ALTER TABLE `apartment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `buyer`
--

DROP TABLE IF EXISTS `buyer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `buyer` (
  `buyerid` int NOT NULL AUTO_INCREMENT,
  `name` varchar(30) DEFAULT NULL,
  `phone` bigint DEFAULT NULL,
  `propertyType` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`buyerid`)
) ENGINE=InnoDB AUTO_INCREMENT=18019 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buyer`
--

LOCK TABLES `buyer` WRITE;
/*!40000 ALTER TABLE `buyer` DISABLE KEYS */;
INSERT INTO `buyer` VALUES (10000,'SAMARTH',46548484,'buy'),(10005,'NSDFJKSDNFK',12412,'buy'),(10006,'HJGHJGHG',5435434,'buy'),(10007,'SLKMVKLSMV',132423432,'buy'),(10008,'NFLDFNKNV',124141,'buy'),(10009,'KKLGKGKLS',1414234,'buy'),(10010,'RISAHVARAJA',6541654165,'buy'),(10011,'RAJARAJA',654654,'buy'),(10012,'RISHAV_NEW',65465465,'buy'),(10013,'REF',12541,'buy'),(10014,'laxman',123213,'buy'),(10015,'KNSDFKLSDNFKL',351321321,'buy'),(10016,'mahabara',231321,'buy'),(18011,'bhanumati',1203456781,'house '),(18012,'rehman',1203456782,'business'),(18013,'alka',1203456783,'businnes'),(18014,'anupam',1203456784,'house '),(18015,'hemlata',1203456785,'house '),(18016,'geeta',1203456786,'business'),(18017,'indu',1203456787,'house '),(18018,'arijit',1203456788,'business');
/*!40000 ALTER TABLE `buyer` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `buyer_AFTER_INSERT` AFTER INSERT ON `buyer` FOR EACH ROW BEGIN
    delete from new_buyer where name in (select new.name from buyer) and phone in (select new.phone from buyer);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `firm`
--

DROP TABLE IF EXISTS `firm`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `firm` (
  `firmid` int NOT NULL,
  `name` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`firmid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `firm`
--

LOCK TABLES `firm` WRITE;
/*!40000 ALTER TABLE `firm` DISABLE KEYS */;
INSERT INTO `firm` VALUES (101,'salman '),(102,'hritik'),(103,'srk'),(104,'johny'),(105,'robert '),(106,'kenu'),(107,'firefox'),(108,'tom'),(109,'brad'),(110,'rock'),(123,'hrithikaea'),(4654,'berlij');
/*!40000 ALTER TABLE `firm` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `house`
--

DROP TABLE IF EXISTS `house`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `house` (
  `reg_num` int NOT NULL,
  `agentid` int DEFAULT NULL,
  `ownername` varchar(30) DEFAULT NULL,
  `price` int DEFAULT NULL,
  `bedrooms` int DEFAULT NULL,
  `bathrooms` int DEFAULT NULL,
  `size` int DEFAULT NULL,
  PRIMARY KEY (`reg_num`),
  CONSTRAINT `house_ibfk_1` FOREIGN KEY (`reg_num`) REFERENCES `property` (`reg_num`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `house`
--

LOCK TABLES `house` WRITE;
/*!40000 ALTER TABLE `house` DISABLE KEYS */;
INSERT INTO `house` VALUES (511,11,'AASHISH',11000,2,3,210),(512,12,'AAYUSH MAURYA',24000,1,1,320),(514,13,'ABHINANDAN KUMAR',50000,2,2,540),(600,11,'puneet sharma',100000,12,4,NULL);
/*!40000 ALTER TABLE `house` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `listing`
--

DROP TABLE IF EXISTS `listing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `listing` (
  `agentid` int DEFAULT NULL,
  `reg_num` int NOT NULL,
  `datelisted` datetime DEFAULT NULL,
  `sellingDate` datetime DEFAULT NULL,
  `available` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`reg_num`),
  KEY `agentid` (`agentid`),
  CONSTRAINT `listing_ibfk_1` FOREIGN KEY (`agentid`) REFERENCES `agent` (`agentid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `listing`
--

LOCK TABLES `listing` WRITE;
/*!40000 ALTER TABLE `listing` DISABLE KEYS */;
INSERT INTO `listing` VALUES (11,511,'2018-07-01 00:00:00','2020-04-28 19:09:47','sold'),(12,512,'2013-06-02 00:00:00','2019-11-02 00:00:00','sold'),(13,514,'2010-08-05 00:00:00','2012-05-06 00:00:00','sold'),(12,515,'2010-04-06 00:00:00','2011-02-19 00:00:00','sold'),(14,516,'2013-01-04 00:00:00','2019-10-19 00:00:00','sold'),(15,517,'2013-01-19 00:00:00','2020-04-28 19:45:15','sold'),(11,600,'2015-02-23 00:00:00','2020-01-12 00:00:00','available'),(12,52215,'2020-04-28 16:41:20','0000-00-00 00:00:00','available'),(12,100000,'2020-04-28 16:07:31','0000-00-00 00:00:00','available');
/*!40000 ALTER TABLE `listing` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `new_agent`
--

DROP TABLE IF EXISTS `new_agent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `new_agent` (
  `name` varchar(20) DEFAULT NULL,
  `email` varchar(350) NOT NULL,
  `phone` bigint DEFAULT NULL,
  `firmid` int DEFAULT NULL,
  PRIMARY KEY (`email`),
  KEY `firmid` (`firmid`),
  CONSTRAINT `new_agent_ibfk_1` FOREIGN KEY (`firmid`) REFERENCES `firm` (`firmid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `new_agent`
--

LOCK TABLES `new_agent` WRITE;
/*!40000 ALTER TABLE `new_agent` DISABLE KEYS */;
/*!40000 ALTER TABLE `new_agent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `new_buyer`
--

DROP TABLE IF EXISTS `new_buyer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `new_buyer` (
  `email` varchar(30) NOT NULL,
  `phone` bigint DEFAULT NULL,
  `name` varchar(40) DEFAULT NULL,
  `reg_num` int NOT NULL,
  PRIMARY KEY (`email`,`reg_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `new_buyer`
--

LOCK TABLES `new_buyer` WRITE;
/*!40000 ALTER TABLE `new_buyer` DISABLE KEYS */;
INSERT INTO `new_buyer` VALUES ('rana@dsfff',12323213,'ravan',511);
/*!40000 ALTER TABLE `new_buyer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `property`
--

DROP TABLE IF EXISTS `property`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `property` (
  `reg_num` int NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `ownername` varchar(30) DEFAULT NULL,
  `price` int DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  `bathrooms` int DEFAULT NULL,
  `bedroooms` int DEFAULT NULL,
  `size` int DEFAULT NULL,
  `agentid` int DEFAULT NULL,
  PRIMARY KEY (`reg_num`),
  CONSTRAINT `property_ibfk_1` FOREIGN KEY (`reg_num`) REFERENCES `listing` (`reg_num`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=100006 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `property`
--

LOCK TABLES `property` WRITE;
/*!40000 ALTER TABLE `property` DISABLE KEYS */;
INSERT INTO `property` VALUES (511,'21/a, bongra,guwahati','AASHISH',11000,'buy',3,2,210,11),(512,'13,jalukbari,guwahati','AAYUSH MAURYA',24000,'buy',1,1,320,12),(514,'22/c,vip,guwahati','ABHINANDAN KUMAR',50000,'buy',2,2,540,13),(515,'45/a,jalukbari,guwahati','ABHISHEK RAUT',12000,'rent',2,3,200,12),(516,'124,GSroad,guwahati','ADITYA ARUN SHARMA',24000,'rent',1,3,100,14),(517,'1,IT park ,bongra,guwahati','ADUDODLA ANKITH REDDY',11500,'rent',1,4,400,15),(600,'21B,citypalace adabari,ghy','puneet sharma',100000,'buy',4,12,NULL,11),(52215,'ajdkajdklajd','jkadkladk',35455,'rent',12,12,41564,12);
/*!40000 ALTER TABLE `property` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `property_AFTER_INSERT` AFTER INSERT ON `property` FOR EACH ROW BEGIN
if(new.type='buy')
then
 insert into house values(new.reg_num,new.agentid,new.ownername,new.price,new.bedroooms,new.bathrooms,new.size);
 
elseif(new.type='rent')
 then
 insert into apartment values(new.agentid,new.reg_num, new.ownername,new.price,'rent',new.size,new.bathrooms,new.bedroooms);
 end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `work_with`
--

DROP TABLE IF EXISTS `work_with`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_with` (
  `buyerid` int DEFAULT NULL,
  `agentid` int DEFAULT NULL,
  KEY `buyerid` (`buyerid`),
  KEY `agentid` (`agentid`),
  CONSTRAINT `work_with_ibfk_1` FOREIGN KEY (`agentid`) REFERENCES `agent` (`agentid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `work_with`
--

LOCK TABLES `work_with` WRITE;
/*!40000 ALTER TABLE `work_with` DISABLE KEYS */;
INSERT INTO `work_with` VALUES (18011,11),(18012,12),(18013,11),(18014,13),(18015,12),(18016,14),(18017,15),(18018,16),(10016,11);
/*!40000 ALTER TABLE `work_with` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-04-28 20:08:42
