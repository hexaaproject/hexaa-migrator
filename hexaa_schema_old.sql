-- MySQL dump 10.13  Distrib 5.5.62, for debian-linux-gnu (x86_64)
--
-- Host: 10.0.1.3    Database: hexaa
-- ------------------------------------------------------
-- Server version	5.5.5-10.0.37-MariaDB-0+deb8u1

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
-- Table structure for table `attribute_spec`
--

DROP TABLE IF EXISTS `attribute_spec`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attribute_spec` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uri` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8_unicode_ci,
  `maintainer` enum('user','manager','admin') COLLATE utf8_unicode_ci DEFAULT NULL,
  `syntax` enum('string','base64') COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_multivalue` tinyint(1) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uri` (`uri`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `attribute_value_organization`
--

DROP TABLE IF EXISTS `attribute_value_organization`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attribute_value_organization` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `organization_id` bigint(20) DEFAULT NULL,
  `attribute_spec_id` bigint(20) DEFAULT NULL,
  `value` longblob,
  `is_default` tinyint(1) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `loa` bigint(20) DEFAULT NULL,
  `loa_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_15CA3D6032C8A3DE` (`organization_id`),
  KEY `IDX_15CA3D602113FD3F` (`attribute_spec_id`),
  CONSTRAINT `FK_15CA3D602113FD3F` FOREIGN KEY (`attribute_spec_id`) REFERENCES `attribute_spec` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_15CA3D6032C8A3DE` FOREIGN KEY (`organization_id`) REFERENCES `organization` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `attribute_value_principal`
--

DROP TABLE IF EXISTS `attribute_value_principal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attribute_value_principal` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `principal_id` bigint(20) DEFAULT NULL,
  `attribute_spec_id` bigint(20) DEFAULT NULL,
  `value` longblob,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `loa` bigint(20) DEFAULT NULL,
  `loa_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_81013BFF474870EE` (`principal_id`),
  KEY `IDX_81013BFF2113FD3F` (`attribute_spec_id`),
  CONSTRAINT `FK_81013BFF2113FD3F` FOREIGN KEY (`attribute_spec_id`) REFERENCES `attribute_spec` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_81013BFF474870EE` FOREIGN KEY (`principal_id`) REFERENCES `principal` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `attributevalueorganization_service`
--

DROP TABLE IF EXISTS `attributevalueorganization_service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attributevalueorganization_service` (
  `attributevalueorganization_id` bigint(20) NOT NULL,
  `service_id` bigint(20) NOT NULL,
  PRIMARY KEY (`attributevalueorganization_id`,`service_id`),
  KEY `IDX_AB0E265326CBFBC2` (`attributevalueorganization_id`),
  KEY `IDX_AB0E2653ED5CA9E6` (`service_id`),
  CONSTRAINT `FK_AB0E265326CBFBC2` FOREIGN KEY (`attributevalueorganization_id`) REFERENCES `attribute_value_organization` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_AB0E2653ED5CA9E6` FOREIGN KEY (`service_id`) REFERENCES `service` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `consent`
--

DROP TABLE IF EXISTS `consent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `consent` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `principal_id` bigint(20) DEFAULT NULL,
  `service_id` bigint(20) DEFAULT NULL,
  `enable_entitlements` tinyint(1) DEFAULT NULL,
  `expiration` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `service_principal` (`service_id`,`principal_id`),
  KEY `IDX_63120810474870EE` (`principal_id`),
  KEY `IDX_63120810ED5CA9E6` (`service_id`),
  CONSTRAINT `FK_63120810474870EE` FOREIGN KEY (`principal_id`) REFERENCES `principal` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_63120810ED5CA9E6` FOREIGN KEY (`service_id`) REFERENCES `service` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3080 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `consent_attribute_spec`
--

DROP TABLE IF EXISTS `consent_attribute_spec`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `consent_attribute_spec` (
  `consent_id` bigint(20) NOT NULL,
  `attributespec_id` bigint(20) NOT NULL,
  PRIMARY KEY (`consent_id`,`attributespec_id`),
  KEY `IDX_BB33C22941079D63` (`consent_id`),
  KEY `IDX_BB33C229715D6D22` (`attributespec_id`),
  CONSTRAINT `FK_BB33C22941079D63` FOREIGN KEY (`consent_id`) REFERENCES `consent` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_BB33C229715D6D22` FOREIGN KEY (`attributespec_id`) REFERENCES `attribute_spec` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `entitlement`
--

DROP TABLE IF EXISTS `entitlement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `entitlement` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `service_id` bigint(20) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8_unicode_ci,
  `uri` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uri` (`uri`),
  UNIQUE KEY `name_service` (`name`,`service_id`),
  KEY `IDX_FA448021ED5CA9E6` (`service_id`),
  CONSTRAINT `FK_FA448021ED5CA9E6` FOREIGN KEY (`service_id`) REFERENCES `service` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1286 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `entitlement_pack`
--

DROP TABLE IF EXISTS `entitlement_pack`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `entitlement_pack` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `service_id` bigint(20) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8_unicode_ci,
  `type` enum('private','public') COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_service` (`name`,`service_id`),
  KEY `IDX_42C3B29CED5CA9E6` (`service_id`),
  CONSTRAINT `FK_42C3B29CED5CA9E6` FOREIGN KEY (`service_id`) REFERENCES `service` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=701 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `entitlement_pack_entitlement`
--

DROP TABLE IF EXISTS `entitlement_pack_entitlement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `entitlement_pack_entitlement` (
  `entitlementpack_id` bigint(20) NOT NULL,
  `entitlement_id` bigint(20) NOT NULL,
  PRIMARY KEY (`entitlementpack_id`,`entitlement_id`),
  KEY `IDX_A927A4232ACB9CAD` (`entitlementpack_id`),
  KEY `IDX_A927A42315FCF4DF` (`entitlement_id`),
  CONSTRAINT `FK_A927A42315FCF4DF` FOREIGN KEY (`entitlement_id`) REFERENCES `entitlement` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_A927A4232ACB9CAD` FOREIGN KEY (`entitlementpack_id`) REFERENCES `entitlement_pack` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hook`
--

DROP TABLE IF EXISTS `hook`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hook` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `service_id` bigint(20) DEFAULT NULL,
  `organization_id` bigint(20) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8_unicode_ci,
  `url` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `type` enum('user_added','user_removed','attribute_change') COLLATE utf8_unicode_ci DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `lastCallMessage` longtext COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_service` (`name`,`service_id`),
  UNIQUE KEY `name_organization` (`name`,`organization_id`),
  KEY `IDX_A4584355ED5CA9E6` (`service_id`),
  KEY `IDX_A458435532C8A3DE` (`organization_id`),
  CONSTRAINT `FK_A458435532C8A3DE` FOREIGN KEY (`organization_id`) REFERENCES `organization` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_A4584355ED5CA9E6` FOREIGN KEY (`service_id`) REFERENCES `service` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `invitation`
--

DROP TABLE IF EXISTS `invitation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invitation` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `role_id` bigint(20) DEFAULT NULL,
  `organization_id` bigint(20) DEFAULT NULL,
  `service_id` bigint(20) DEFAULT NULL,
  `inviter_id` bigint(20) DEFAULT NULL,
  `emails` mediumtext COLLATE utf8_unicode_ci NOT NULL COMMENT '(DC2Type:array)',
  `token` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `landing_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `do_redirect` tinyint(1) DEFAULT NULL,
  `as_manager` tinyint(1) DEFAULT NULL,
  `message` longtext COLLATE utf8_unicode_ci,
  `counter` bigint(20) DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `principal_limit` bigint(20) DEFAULT NULL,
  `reinvite_count` bigint(20) DEFAULT NULL,
  `last_reinvite_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `statuses` mediumtext COLLATE utf8_unicode_ci NOT NULL COMMENT '(DC2Type:array)',
  `display_names` mediumtext COLLATE utf8_unicode_ci NOT NULL COMMENT '(DC2Type:array)',
  `locale` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_F11D61A2D60322AC` (`role_id`),
  KEY `IDX_F11D61A232C8A3DE` (`organization_id`),
  KEY `IDX_F11D61A2ED5CA9E6` (`service_id`),
  KEY `IDX_F11D61A2B79F4F04` (`inviter_id`),
  CONSTRAINT `FK_F11D61A232C8A3DE` FOREIGN KEY (`organization_id`) REFERENCES `organization` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_F11D61A2B79F4F04` FOREIGN KEY (`inviter_id`) REFERENCES `principal` (`id`),
  CONSTRAINT `FK_F11D61A2D60322AC` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_F11D61A2ED5CA9E6` FOREIGN KEY (`service_id`) REFERENCES `service` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2010 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `linker_token`
--

DROP TABLE IF EXISTS `linker_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `linker_token` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entitlement_pack_id` bigint(20) DEFAULT NULL,
  `token` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `expiresAt` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `IDX_EB3DE73846D6DBD6` (`entitlement_pack_id`),
  CONSTRAINT `FK_EB3DE73846D6DBD6` FOREIGN KEY (`entitlement_pack_id`) REFERENCES `entitlement_pack` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=534 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `news`
--

DROP TABLE IF EXISTS `news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `news` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `principal_id` bigint(20) DEFAULT NULL,
  `service_id` bigint(20) DEFAULT NULL,
  `organization_id` bigint(20) DEFAULT NULL,
  `tag` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `message` longtext COLLATE utf8_unicode_ci,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `admin` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_1DD39950474870EE` (`principal_id`),
  KEY `IDX_1DD39950ED5CA9E6` (`service_id`),
  KEY `IDX_1DD3995032C8A3DE` (`organization_id`),
  KEY `tag_idx` (`tag`),
  CONSTRAINT `FK_1DD3995032C8A3DE` FOREIGN KEY (`organization_id`) REFERENCES `organization` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_1DD39950474870EE` FOREIGN KEY (`principal_id`) REFERENCES `principal` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_1DD39950ED5CA9E6` FOREIGN KEY (`service_id`) REFERENCES `service` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=760127 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `organization`
--

DROP TABLE IF EXISTS `organization`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organization` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8_unicode_ci,
  `default_role_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `isolate_members` tinyint(1) DEFAULT NULL,
  `isolate_role_members` tinyint(1) DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `UNIQ_C1EE637C248673E9` (`default_role_id`),
  CONSTRAINT `FK_C1EE637C248673E9` FOREIGN KEY (`default_role_id`) REFERENCES `role` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=695 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `organization_entitlement_pack`
--

DROP TABLE IF EXISTS `organization_entitlement_pack`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organization_entitlement_pack` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `organization_id` bigint(20) DEFAULT NULL,
  `entitlement_pack_id` bigint(20) DEFAULT NULL,
  `status` enum('accepted','pending') COLLATE utf8_unicode_ci DEFAULT NULL,
  `accept_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `organization_entitlement_pack` (`organization_id`,`entitlement_pack_id`),
  KEY `IDX_B4280C3732C8A3DE` (`organization_id`),
  KEY `IDX_B4280C3746D6DBD6` (`entitlement_pack_id`),
  CONSTRAINT `FK_B4280C3732C8A3DE` FOREIGN KEY (`organization_id`) REFERENCES `organization` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_B4280C3746D6DBD6` FOREIGN KEY (`entitlement_pack_id`) REFERENCES `entitlement_pack` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=773 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `organization_manager`
--

DROP TABLE IF EXISTS `organization_manager`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organization_manager` (
  `organization_id` bigint(20) NOT NULL,
  `principal_id` bigint(20) NOT NULL,
  PRIMARY KEY (`organization_id`,`principal_id`),
  KEY `IDX_37F6ADFA32C8A3DE` (`organization_id`),
  KEY `IDX_37F6ADFA474870EE` (`principal_id`),
  CONSTRAINT `FK_37F6ADFA32C8A3DE` FOREIGN KEY (`organization_id`) REFERENCES `organization` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_37F6ADFA474870EE` FOREIGN KEY (`principal_id`) REFERENCES `principal` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `organization_principal`
--

DROP TABLE IF EXISTS `organization_principal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organization_principal` (
  `organization_id` bigint(20) NOT NULL,
  `principal_id` bigint(20) NOT NULL,
  PRIMARY KEY (`organization_id`,`principal_id`),
  KEY `IDX_1897565D32C8A3DE` (`organization_id`),
  KEY `IDX_1897565D474870EE` (`principal_id`),
  CONSTRAINT `FK_1897565D32C8A3DE` FOREIGN KEY (`organization_id`) REFERENCES `organization` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_1897565D474870EE` FOREIGN KEY (`principal_id`) REFERENCES `principal` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `organization_security_domain`
--

DROP TABLE IF EXISTS `organization_security_domain`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organization_security_domain` (
  `organization_id` bigint(20) NOT NULL,
  `securitydomain_id` int(11) NOT NULL,
  PRIMARY KEY (`organization_id`,`securitydomain_id`),
  KEY `IDX_C3DE18CB32C8A3DE` (`organization_id`),
  KEY `IDX_C3DE18CB5CF4CC57` (`securitydomain_id`),
  CONSTRAINT `FK_C3DE18CB32C8A3DE` FOREIGN KEY (`organization_id`) REFERENCES `organization` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_C3DE18CB5CF4CC57` FOREIGN KEY (`securitydomain_id`) REFERENCES `security_domain` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `organization_tag`
--

DROP TABLE IF EXISTS `organization_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organization_tag` (
  `organization_id` bigint(20) NOT NULL,
  `tag_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`organization_id`,`tag_id`),
  KEY `IDX_904E86032C8A3DE` (`organization_id`),
  KEY `IDX_904E860BAD26311` (`tag_id`),
  CONSTRAINT `FK_904E86032C8A3DE` FOREIGN KEY (`organization_id`) REFERENCES `organization` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_904E860BAD26311` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`name`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `personal_token`
--

DROP TABLE IF EXISTS `personal_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `personal_token` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `token` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `masterkey_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `token_expire` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`)
) ENGINE=InnoDB AUTO_INCREMENT=10484 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `principal`
--

DROP TABLE IF EXISTS `principal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `principal` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `fedid` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `display_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `token_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fedid` (`fedid`),
  KEY `IDX_20A08C5B41DEE7B9` (`token_id`),
  CONSTRAINT `FK_20A08C5B41DEE7B9` FOREIGN KEY (`token_id`) REFERENCES `personal_token` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1040 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `organization_id` bigint(20) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8_unicode_ci,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_organization` (`name`,`organization_id`),
  KEY `IDX_57698A6A32C8A3DE` (`organization_id`),
  CONSTRAINT `FK_57698A6A32C8A3DE` FOREIGN KEY (`organization_id`) REFERENCES `organization` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1243 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `role_entitlement`
--

DROP TABLE IF EXISTS `role_entitlement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role_entitlement` (
  `role_id` bigint(20) NOT NULL,
  `entitlement_id` bigint(20) NOT NULL,
  PRIMARY KEY (`role_id`,`entitlement_id`),
  KEY `IDX_C813D8A8D60322AC` (`role_id`),
  KEY `IDX_C813D8A815FCF4DF` (`entitlement_id`),
  CONSTRAINT `FK_C813D8A815FCF4DF` FOREIGN KEY (`entitlement_id`) REFERENCES `entitlement` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_C813D8A8D60322AC` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `role_principal`
--

DROP TABLE IF EXISTS `role_principal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role_principal` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `role_id` bigint(20) DEFAULT NULL,
  `principal_id` bigint(20) DEFAULT NULL,
  `expiration` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `role_principal` (`role_id`,`principal_id`),
  KEY `IDX_71545F87D60322AC` (`role_id`),
  KEY `IDX_71545F87474870EE` (`principal_id`),
  CONSTRAINT `FK_71545F87474870EE` FOREIGN KEY (`principal_id`) REFERENCES `principal` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_71545F87D60322AC` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2814 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `security_domain`
--

DROP TABLE IF EXISTS `security_domain`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `security_domain` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8_unicode_ci,
  `scoped_key` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service`
--

DROP TABLE IF EXISTS `service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `entityid` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` longtext COLLATE utf8_unicode_ci,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `min_loa` bigint(20) DEFAULT NULL,
  `org_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `org_short_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `org_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `org_description` longtext COLLATE utf8_unicode_ci,
  `priv_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `priv_description` longtext COLLATE utf8_unicode_ci,
  `logoPath` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `privacy_policy_set_at` datetime DEFAULT NULL,
  `enable_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `enabled` tinyint(1) DEFAULT NULL,
  `hookKey` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_attribute_spec`
--

DROP TABLE IF EXISTS `service_attribute_spec`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_attribute_spec` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `attribute_spec_id` bigint(20) DEFAULT NULL,
  `service_id` bigint(20) DEFAULT NULL,
  `is_public` tinyint(1) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `service_attribute_spec` (`service_id`,`attribute_spec_id`),
  KEY `IDX_9880EE002113FD3F` (`attribute_spec_id`),
  KEY `IDX_9880EE00ED5CA9E6` (`service_id`),
  CONSTRAINT `FK_9880EE002113FD3F` FOREIGN KEY (`attribute_spec_id`) REFERENCES `attribute_spec` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_9880EE00ED5CA9E6` FOREIGN KEY (`service_id`) REFERENCES `service` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_attribute_value_principal`
--

DROP TABLE IF EXISTS `service_attribute_value_principal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_attribute_value_principal` (
  `attributevalueprincipal_id` bigint(20) NOT NULL,
  `service_id` bigint(20) NOT NULL,
  PRIMARY KEY (`attributevalueprincipal_id`,`service_id`),
  KEY `IDX_DB237D0A819C4D7D` (`attributevalueprincipal_id`),
  KEY `IDX_DB237D0AED5CA9E6` (`service_id`),
  CONSTRAINT `FK_DB237D0A819C4D7D` FOREIGN KEY (`attributevalueprincipal_id`) REFERENCES `attribute_value_principal` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_DB237D0AED5CA9E6` FOREIGN KEY (`service_id`) REFERENCES `service` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_principal`
--

DROP TABLE IF EXISTS `service_principal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_principal` (
  `service_id` bigint(20) NOT NULL,
  `principal_id` bigint(20) NOT NULL,
  PRIMARY KEY (`service_id`,`principal_id`),
  KEY `IDX_7831B611ED5CA9E6` (`service_id`),
  KEY `IDX_7831B611474870EE` (`principal_id`),
  CONSTRAINT `FK_7831B611474870EE` FOREIGN KEY (`principal_id`) REFERENCES `principal` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_7831B611ED5CA9E6` FOREIGN KEY (`service_id`) REFERENCES `service` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_security_domain`
--

DROP TABLE IF EXISTS `service_security_domain`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_security_domain` (
  `service_id` bigint(20) NOT NULL,
  `securitydomain_id` int(11) NOT NULL,
  PRIMARY KEY (`service_id`,`securitydomain_id`),
  KEY `IDX_B34798FAED5CA9E6` (`service_id`),
  KEY `IDX_B34798FA5CF4CC57` (`securitydomain_id`),
  CONSTRAINT `FK_B34798FA5CF4CC57` FOREIGN KEY (`securitydomain_id`) REFERENCES `security_domain` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_B34798FAED5CA9E6` FOREIGN KEY (`service_id`) REFERENCES `service` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_tag`
--

DROP TABLE IF EXISTS `service_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_tag` (
  `service_id` bigint(20) NOT NULL,
  `tag_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`service_id`,`tag_id`),
  KEY `IDX_21D9C4F4ED5CA9E6` (`service_id`),
  KEY `IDX_21D9C4F4BAD26311` (`tag_id`),
  CONSTRAINT `FK_21D9C4F4BAD26311` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`name`),
  CONSTRAINT `FK_21D9C4F4ED5CA9E6` FOREIGN KEY (`service_id`) REFERENCES `service` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tag`
--

DROP TABLE IF EXISTS `tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tag` (
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-03-01 14:00:24
