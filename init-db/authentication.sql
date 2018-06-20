-- phpMyAdmin SQL Dump
-- version 4.7.8
-- https://www.phpmyadmin.net/
--
-- 主機: 172.17.0.1
-- 產生時間： 2018 年 05 月 21 日 03:34
-- 伺服器版本: 5.7.20
-- PHP 版本： 7.2.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 資料庫： `authentication`
--
CREATE DATABASE IF NOT EXISTS `authentication` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `authentication`;

-- --------------------------------------------------------

--
-- 資料表結構 `apps`
--

DROP TABLE IF EXISTS `apps`;
CREATE TABLE IF NOT EXISTS `apps` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uuid` char(36) NOT NULL,
  `name` char(64) NOT NULL DEFAULT '',
  `start` timestamp NULL DEFAULT NULL,
  `end` timestamp NULL DEFAULT NULL,
  `count` bigint(20) DEFAULT NULL,
  `enterprise` char(36) NOT NULL DEFAULT '',
  `created_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uuid` (`uuid`),
  KEY `enterprise of app` (`enterprise`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

--
-- 資料表的匯出資料 `apps`
--

INSERT INTO `apps` (`id`, `uuid`, `name`, `start`, `end`, `count`, `enterprise`, `created_time`, `status`) VALUES
(1, 'csbot', 'csbot', NULL, NULL, NULL, 'bb3e3925-f0ad-11e7-bd86-0242ac120003', '2018-04-05 15:21:02', 1);

-- --------------------------------------------------------

--
-- 資料表結構 `enterprises`
--

DROP TABLE IF EXISTS `enterprises`;
CREATE TABLE IF NOT EXISTS `enterprises` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uuid` char(36) NOT NULL,
  `name` varchar(64) NOT NULL DEFAULT '',
  `admin_user` char(36) NOT NULL DEFAULT '',
  `created_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uuid` (`uuid`),
  KEY `admin of enterprise` (`admin_user`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

--
-- 資料表的匯出資料 `enterprises`
--

INSERT INTO `enterprises` (`id`, `uuid`, `name`, `admin_user`, `created_time`) VALUES
(1, 'bb3e3925-f0ad-11e7-bd86-0242ac120003', 'emotibot', '4b21158a-3953-11e8-8a71-0242ac110003', '2018-04-05 15:21:02');

-- --------------------------------------------------------

--
-- 資料表結構 `modules`
--

DROP TABLE IF EXISTS `modules`;
CREATE TABLE IF NOT EXISTS `modules` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `code` char(36) NOT NULL DEFAULT '',
  `name` varchar(36) NOT NULL DEFAULT '',
  `enterprise` char(36) NOT NULL DEFAULT '',
  `cmd_list` char(64) NOT NULL,
  `discription` varchar(200) NOT NULL DEFAULT '',
  `created_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4;

--
-- 資料表的匯出資料 `modules`
--

INSERT INTO `modules` (`id`, `code`, `name`, `enterprise`, `cmd_list`, `discription`, `created_time`, `status`) VALUES
(1, 'statistic_dash', '', '', 'view', '', '2018-05-20 16:22:16', 1),
(2, 'statistic_analysis', '', '', 'view,export', '', '2018-05-20 16:22:16', 1),
(3, 'statistic_daily', '', '', 'view,export', '', '2018-05-20 16:22:16', 1),
(4, 'statistic_audit', '', '', 'view,export', '', '2018-05-20 16:22:16', 1),
(5, 'qalist', '', '', 'view,edit,create,delete,export,import', '', '2018-05-20 16:22:16', 1),
(6, 'qa_greeting', '', '', 'view', '', '2018-05-20 16:22:16', 1),
(7, 'qatest', '', '', 'view', '', '2018-05-20 16:22:16', 1),
(8, 'qa_chat_skill', '', '', 'view,edit', '', '2018-05-20 16:22:16', 1),
(9, 'qa_label', '', '', 'view,edit', '', '2018-05-20 16:22:16', 1),
(10, 'qa_rule', '', '', 'view,edit', '', '2018-05-20 16:22:16', 1),
(11, 'robot_function', '', '', 'view,edit', '', '2018-05-20 16:22:16', 1),
(12, 'robot_profile', '', '', 'view,edit', '', '2018-05-20 16:22:16', 1),
(13, 'wordbank', '', '', 'view,edit,create,delete,export,import', '', '2018-05-20 16:22:16', 1),
(14, 'task_engine', '', '', 'view', '', '2018-05-20 16:22:16', 1),
(15, 'management', '', '', 'edit', '', '2018-05-20 16:22:16', 1);

-- --------------------------------------------------------

--
-- 資料表結構 `privileges`
--

DROP TABLE IF EXISTS `privileges`;
CREATE TABLE IF NOT EXISTS `privileges` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `role` bigint(20) NOT NULL,
  `module` bigint(20) NOT NULL,
  `cmd_list` char(64) NOT NULL DEFAULT '',
  `created_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id of role` (`role`),
  KEY `id of module` (`module`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `roles`
--

DROP TABLE IF EXISTS `roles`;
CREATE TABLE IF NOT EXISTS `roles` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uuid` char(36) NOT NULL,
  `name` char(36) NOT NULL,
  `enterprise` char(36) NOT NULL DEFAULT '',
  `discription` varchar(200) NOT NULL DEFAULT '',
  `created_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `uuid` (`uuid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uuid` char(36) NOT NULL DEFAULT '',
  `display_name` varchar(64) NOT NULL DEFAULT '',
  `user_name` char(32) NOT NULL DEFAULT '',
  `email` char(255) NOT NULL DEFAULT '',
  `enterprise` char(36) NOT NULL DEFAULT '',
  `type` tinyint(1) UNSIGNED NOT NULL DEFAULT '2',
  `password` char(32) NOT NULL DEFAULT '',
  `role` char(36) NOT NULL DEFAULT '',
  `created_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uuid` (`uuid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

--
-- 資料表的匯出資料 `users`
--

INSERT INTO `users` (`id`, `uuid`, `display_name`, `user_name`, `email`, `enterprise`, `type`, `password`, `role`, `created_time`, `status`) VALUES
(1, '4b21158a-3953-11e8-8a71-0242ac110003', 'CSBOT', 'csbotadmin', 'csbotadmin@emotibot.com', 'bb3e3925-f0ad-11e7-bd86-0242ac120003', 1, 'ac04367d3155bb651df2e4220bdb8303', '', '2018-04-05 15:21:54', 1);

-- --------------------------------------------------------

--
-- 資料表結構 `user_column`
--

DROP TABLE IF EXISTS `user_column`;
CREATE TABLE IF NOT EXISTS `user_column` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `column` char(32) NOT NULL DEFAULT '',
  `display_name` varchar(64) NOT NULL DEFAULT '',
  `enterprise` char(36) NOT NULL DEFAULT '',
  `note` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `enterprise of custom column` (`enterprise`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

--
-- 資料表的匯出資料 `user_column`
--

INSERT INTO `user_column` (`id`, `column`, `display_name`, `enterprise`, `note`) VALUES
(1, 'organization', '机构', 'bb3e3925-f0ad-11e7-bd86-0242ac120003', '民生专用');

-- --------------------------------------------------------

--
-- 資料表結構 `user_info`
--

DROP TABLE IF EXISTS `user_info`;
CREATE TABLE IF NOT EXISTS `user_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` char(36) NOT NULL DEFAULT '',
  `column_id` bigint(64) NOT NULL,
  `value` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user of info` (`user_id`),
  KEY `column of info` (`column_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

--
-- 資料表的匯出資料 `user_info`
--

INSERT INTO `user_info` (`id`, `user_id`, `column_id`, `value`) VALUES
(1, '4b21158a-3953-11e8-8a71-0242ac110003', 1, 'custom_value1');


--
-- 資料表結構 `organization`
--

DROP TABLE IF EXISTS `organization`;
CREATE TABLE IF NOT EXISTS `organization` (
  `id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `syb_category` varchar(20) NOT NULL,
  `valid_date` varchar(20) NOT NULL,
  `parent_id` varchar(20) NOT NULL,
  `invalid_date` varchar(20) NOT NULL,
  `level` varchar(20) NOT NULL,
  `status` varchar(11) NOT NULL,
  `syb_branch` varchar(20) NOT NULL,
  `name` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- 已匯出資料表的限制(Constraint)
--

--
-- 資料表的 Constraints `apps`
--
ALTER TABLE `apps`
  ADD CONSTRAINT `enterprise of app` FOREIGN KEY (`enterprise`) REFERENCES `enterprises` (`uuid`);

--
-- 資料表的 Constraints `enterprises`
--
ALTER TABLE `enterprises`
  ADD CONSTRAINT `admin of enterprise` FOREIGN KEY (`admin_user`) REFERENCES `users` (`uuid`);

--
-- 資料表的 Constraints `privileges`
--
ALTER TABLE `privileges`
  ADD CONSTRAINT `id of module` FOREIGN KEY (`module`) REFERENCES `modules` (`id`),
  ADD CONSTRAINT `id of role` FOREIGN KEY (`role`) REFERENCES `roles` (`id`);

--
-- 資料表的 Constraints `user_column`
--
ALTER TABLE `user_column`
  ADD CONSTRAINT `enterprise of custom column` FOREIGN KEY (`enterprise`) REFERENCES `enterprises` (`uuid`);

--
-- 資料表的 Constraints `user_info`
--
ALTER TABLE `user_info`
  ADD CONSTRAINT `column of info` FOREIGN KEY (`column_id`) REFERENCES `user_column` (`id`),
  ADD CONSTRAINT `user of info` FOREIGN KEY (`user_id`) REFERENCES `users` (`uuid`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
