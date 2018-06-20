-- phpMyAdmin SQL Dump
-- version 4.7.8
-- https://www.phpmyadmin.net/
--
-- 主機: 172.17.0.1
-- 產生時間： 2018 年 05 月 30 日 03:38
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
-- 資料庫： `backend_log`
--

CREATE DATABASE IF NOT EXISTS `backend_log` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `backend_log`;

-- --------------------------------------------------------

--
-- 資料表結構 `chat_record`
--

DROP TABLE IF EXISTS `chat_record`;
CREATE TABLE IF NOT EXISTS `chat_record` (
  `id` bigint(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'chatlog id',
  `app_id` varchar(64) NOT NULL DEFAULT '' COMMENT 'robotID',
  `user_id` varchar(64) NOT NULL DEFAULT '' COMMENT '使用者id',
  `user_q` text COMMENT '用户提问',
  `std_q` varchar(255) NOT NULL DEFAULT '' COMMENT '标准问题',
  `answer` mediumtext COMMENT 'robot 答案',
  `module` varchar(32) NOT NULL DEFAULT '' COMMENT '出话模组',
  `emotion` varchar(32) NOT NULL DEFAULT '' COMMENT '情绪',
  `emotion_score` int(11) NOT NULL DEFAULT '0' COMMENT '情绪分数',
  `intent` varchar(32) NOT NULL DEFAULT '' COMMENT '意图',
  `intent_score` int(11) NOT NULL DEFAULT '0' COMMENT '意图分数',
  `created_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `log_time` varchar(32) NOT NULL DEFAULT '' COMMENT 'RFC3339时间格式',
  `score` int(11) NOT NULL DEFAULT '0' COMMENT '分数',
  `custom_info` text COMMENT 'json 客制化资讯',
  `host` varchar(32) NOT NULL DEFAULT '' COMMENT '纪录 log 来源机器',
  `unique_id` varchar(100) NOT NULL DEFAULT '' COMMENT '纪录 log ID',
  `note` text COMMENT '保留栏位',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1587 DEFAULT CHARSET=utf8 COMMENT='暂存所有对话纪录，每个对话(单句)将存成一条row，转存进vipshop_record后将此表内同一笔作删除';

-- --------------------------------------------------------

--
-- 資料表結構 `csbot_record`
--

DROP TABLE IF EXISTS `csbot_record`;
CREATE TABLE IF NOT EXISTS `csbot_record` (
  `id` bigint(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'chatlog id',
  `app_id` varchar(64) NOT NULL DEFAULT '' COMMENT '应用ID',
  `user_id` varchar(64) NOT NULL DEFAULT '' COMMENT '使用者id',
  `user_q` text COMMENT '用户提问',
  `std_q` varchar(255) NOT NULL DEFAULT '' COMMENT '标准问题',
  `answer` mediumtext COMMENT 'robot 答案',
  `module` varchar(32) NOT NULL DEFAULT '' COMMENT '出话模组',
  `emotion` varchar(32) NOT NULL DEFAULT '' COMMENT '情绪',
  `emotion_score` int(4) NOT NULL DEFAULT '0',
  `intent` varchar(32) NOT NULL DEFAULT '',
  `intent_score` int(4) NOT NULL DEFAULT '0',
  `created_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建对话时间',
  `score` int(11) NOT NULL DEFAULT '0' COMMENT '分数',
  `host` varchar(32) NOT NULL DEFAULT '' COMMENT '纪录 log 来源机器',
  `unique_id` varchar(100) NOT NULL DEFAULT '' COMMENT '纪录 log ID',
  `path` varchar(200) NOT NULL DEFAULT '' COMMENT '标准问题之目录',
  `stats_cat` varchar(50) CHARACTER SET utf8mb4 NOT NULL COMMENT '一级分类',
  `note` text COMMENT '保留栏位',
  `platform` varchar(32) DEFAULT '' COMMENT '平台',
  `brand` varchar(32) DEFAULT '' COMMENT 'income flow',
  `sex` varchar(32) DEFAULT '' COMMENT '性别',
  PRIMARY KEY (`id`),
  KEY `catIndex` (`stats_cat`),
  KEY `created_time` (`created_time`),
  KEY `module` (`module`),
  KEY `path` (`path`),
  KEY `platform` (`platform`),
  KEY `brand` (`brand`),
  KEY `sex` (`sex`)
) ENGINE=InnoDB AUTO_INCREMENT=1514 DEFAULT CHARSET=utf8 COMMENT='存放最终所有对话纪录，每个对话(单句)将存成一条row，并将 custom_info 资讯展开后储存，以利统计查询';

-- --------------------------------------------------------

--
-- 資料表結構 `custom_statics`
--

DROP TABLE IF EXISTS `custom_statics`;
CREATE TABLE IF NOT EXISTS `custom_statics` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '统计条目id',
  `date` date NOT NULL DEFAULT '1980-01-01' COMMENT '日期',
  `session_cnt` int(11) NOT NULL COMMENT '总会话数',
  `chat_user_cnt` int(11) NOT NULL COMMENT '聊天用户量',
  `active_user_cnt` int(11) NOT NULL COMMENT '活跃用户量',
  `new_user_cnt` int(11) NOT NULL COMMENT '新增用户量',
  `chat_cnt` int(11) NOT NULL COMMENT '对话量',
  `std_ans_cnt` int(11) NOT NULL COMMENT '出话为业务类, 并给出标准答案的数量 (module = faq)',
  `pure_chat_cnt` int(11) NOT NULL COMMENT '出话为聊天类的聊天数量 (module != faq, module != backfill)',
  `backfill_cnt` int(11) NOT NULL COMMENT '无法回答的数量',
  `unsolved_cnt` int(11) NOT NULL COMMENT '业务类中标记为未解决的问答数量',
  `created_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `tag_type_id_str` varchar(100) DEFAULT NULL COMMENT '维度类型',
  `tag_id_str` varchar(100) DEFAULT NULL COMMENT '维度',
  PRIMARY KEY (`id`),
  KEY `date` (`date`)
) ENGINE=InnoDB AUTO_INCREMENT=133 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `faq_stats`
--

DROP TABLE IF EXISTS `faq_stats`;
CREATE TABLE IF NOT EXISTS `faq_stats` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `category` varchar(200) NOT NULL,
  `std_question` varchar(255) NOT NULL,
  `count` bigint(20) UNSIGNED NOT NULL DEFAULT '1',
  `app_id` varchar(64) NOT NULL,
  `type` varchar(64) NOT NULL,
  `name` varchar(64) NOT NULL,
  `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `cache_day` date NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Ind_131` (`app_id`,`cache_day`,`type`,`name`,`std_question`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `monitor_daily`
--

DROP TABLE IF EXISTS `monitor_daily`;
CREATE TABLE IF NOT EXISTS `monitor_daily` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `cache_day` date NOT NULL,
  `manually_users` bigint(20) UNSIGNED NOT NULL COMMENT '人工接入客戶量：有人工接入對話發生過的用戶總量',
  `manually_messages` bigint(20) NOT NULL COMMENT '人工接入會話量',
  `unresolved_rate` float UNSIGNED NOT NULL COMMENT '機構：？',
  `app_id` varchar(64) NOT NULL,
  `unique_users` bigint(20) UNSIGNED NOT NULL,
  `total_messages` bigint(20) UNSIGNED NOT NULL,
  `type` varchar(64) NOT NULL,
  `name` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Ind_102` (`cache_day`,`app_id`,`type`,`name`)
) ENGINE=InnoDB AUTO_INCREMENT=187 DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `monitor_hourly`
--

DROP TABLE IF EXISTS `monitor_hourly`;
CREATE TABLE IF NOT EXISTS `monitor_hourly` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `cache_hour` datetime NOT NULL,
  `manually_users` bigint(20) UNSIGNED NOT NULL,
  `manually_messages` bigint(20) UNSIGNED NOT NULL,
  `unresolved_rate` float UNSIGNED NOT NULL,
  `app_id` varchar(64) NOT NULL,
  `unique_users` bigint(20) UNSIGNED NOT NULL,
  `total_messages` bigint(20) UNSIGNED NOT NULL,
  `type` varchar(64) NOT NULL,
  `name` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Ind_105` (`app_id`,`cache_hour`,`type`,`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4465 DEFAULT CHARSET=utf8mb4 COMMENT='機構：？';

-- --------------------------------------------------------

--
-- 資料表結構 `realtime`
--

DROP TABLE IF EXISTS `realtime`;
CREATE TABLE IF NOT EXISTS `realtime` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` varchar(50) CHARACTER SET utf8mb4 NOT NULL,
  `created_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `platform` varchar(32) NOT NULL,
  `brand` varchar(32) NOT NULL,
  `sex` varchar(32) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user`)
) ENGINE=InnoDB AUTO_INCREMENT=108542 DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `robot_response_stats`
--

DROP TABLE IF EXISTS `robot_response_stats`;
CREATE TABLE IF NOT EXISTS `robot_response_stats` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `cache_day` date NOT NULL,
  `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `app_id` varchar(64) NOT NULL,
  `precision_match` bigint(20) UNSIGNED NOT NULL COMMENT '精確匹配',
  `fuzzy_match` bigint(20) UNSIGNED NOT NULL COMMENT '模糊匹配',
  `default_match` bigint(20) UNSIGNED NOT NULL COMMENT '默認回覆',
  `system_errors` bigint(20) UNSIGNED NOT NULL COMMENT '系統異常',
  `sensitive_match` bigint(20) UNSIGNED NOT NULL COMMENT '敏感詞',
  `business_default_match` bigint(20) UNSIGNED NOT NULL COMMENT '業務默認回覆',
  `chat_module` bigint(20) UNSIGNED NOT NULL COMMENT '寒暄',
  `on_list_match` bigint(20) UNSIGNED NOT NULL COMMENT '列表回覆',
  `title_match` bigint(20) UNSIGNED NOT NULL COMMENT '標題提問',
  `meaningless_responses` bigint(20) UNSIGNED NOT NULL COMMENT '無意義回覆',
  `common_responses` bigint(20) UNSIGNED NOT NULL COMMENT ' 通用句式',
  `direction_responses` bigint(20) UNSIGNED NOT NULL COMMENT '引導用句',
  `unknown_responses` bigint(20) NOT NULL COMMENT '未知回答',
  `type` smallint(5) UNSIGNED NOT NULL COMMENT '類別(1:平台,2:渠道, 3:業務)',
  `name` varchar(64) NOT NULL COMMENT '名稱',
  PRIMARY KEY (`id`),
  UNIQUE KEY `Ind_101` (`app_id`,`cache_day`,`name`,`type`)
) ENGINE=InnoDB AUTO_INCREMENT=297 DEFAULT CHARSET=utf8mb4 COMMENT='机器人回复量统计表';

-- --------------------------------------------------------

--
-- 資料表結構 `robot_traffic_stats`
--

DROP TABLE IF EXISTS `robot_traffic_stats`;
CREATE TABLE IF NOT EXISTS `robot_traffic_stats` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `app_id` varchar(64) NOT NULL,
  `cache_day` date NOT NULL COMMENT 'Cache的時間點, 以日區分',
  `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `unique_users` bigint(20) UNSIGNED NOT NULL COMMENT '接入客户量：全部有打入系统的 UserID 量',
  `effective_users` bigint(20) UNSIGNED NOT NULL COMMENT '有效处理客户量：时间内有命中过 FAQ 的用户量统计 ',
  `total_messages` bigint(20) UNSIGNED NOT NULL COMMENT '接入消息量：對話量統計',
  `resolved_messages` bigint(20) UNSIGNED NOT NULL COMMENT ' 有效處理消息量：backfill 以外的都算',
  `unresolved_messages` bigint(20) UNSIGNED NOT NULL COMMENT '轉人工量：backfill就轉人工 + intent轉人工',
  `resolved_rate` float UNSIGNED NOT NULL COMMENT '成功解決率：有效處理消息量 / 接入消息量 ',
  `type` smallint(6) NOT NULL COMMENT '類別(1:平台,2:渠道, 3:業務)',
  `name` varchar(64) NOT NULL COMMENT '名稱',
  PRIMARY KEY (`id`),
  UNIQUE KEY `robot_traffic_unique_1` (`app_id`,`cache_day`,`type`,`name`)
) ENGINE=InnoDB AUTO_INCREMENT=807 DEFAULT CHARSET=utf8mb4 COMMENT='机器人服务量统计';

-- --------------------------------------------------------

--
-- 資料表結構 `statics`
--

DROP TABLE IF EXISTS `statics`;
CREATE TABLE IF NOT EXISTS `statics` (
  `id` bigint(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '统计条目id',
  `date` date NOT NULL DEFAULT '1980-01-01' COMMENT '统计日期',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '统计类別 0:date 1:hour',
  `hour` int(11) NOT NULL DEFAULT '0' COMMENT '小时(0~23)',
  `chat_user_cnt` int(11) NOT NULL DEFAULT '0' COMMENT '聊天用户量',
  `active_user_cnt` int(11) NOT NULL DEFAULT '0' COMMENT '活跃用户量',
  `new_user_cnt` int(11) NOT NULL DEFAULT '0' COMMENT '新增用户量',
  `session_cnt` int(11) NOT NULL DEFAULT '0' COMMENT '对话session数量',
  `chat_cnt` int(11) NOT NULL DEFAULT '0' COMMENT '对话量',
  `pure_chat_cnt` int(11) NOT NULL DEFAULT '0' COMMENT '出话为聊天类的聊天数量 (module != faq, module != backfill)',
  `std_ans_cnt` int(11) NOT NULL DEFAULT '0' COMMENT '出话为业务类, 并给出标准答案的数量 (module = faq)',
  `sensitive_cnt` int(11) NOT NULL DEFAULT '0' COMMENT '用户问句命中敏感词的数量',
  `backfill_cnt` int(11) NOT NULL DEFAULT '0' COMMENT '无法回答的数量',
  `solved_cnt` int(11) NOT NULL DEFAULT '0' COMMENT '业务类中标记为解决的问答数量',
  `unsolved_cnt` int(11) NOT NULL DEFAULT '0' COMMENT '业务类中标记为未解决的问答数量',
  `top_std_q` mediumtext COMMENT '纪录top n标准问题的内容及资讯',
  `created_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `top_unmatch_q` mediumtext COMMENT '纪录top n未匹配问题的内容及资讯',
  `top_unresolved_q` mediumtext COMMENT '纪录top n未解決问题的内容及资讯',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=301 DEFAULT CHARSET=utf8 COMMENT='统计资料';

-- --------------------------------------------------------

--
-- 資料表結構 `static_record_info`
--

DROP TABLE IF EXISTS `static_record_info`;
CREATE TABLE IF NOT EXISTS `static_record_info` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  `unique_id` varchar(100) NOT NULL DEFAULT '' COMMENT 'chat_record id',
  `qa_solved` tinyint(1) NOT NULL DEFAULT '0' COMMENT '纪录被标记为解决or未解决',
  `created_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='标记对话结果为解决或未解决';

-- --------------------------------------------------------

--
-- 資料表結構 `static_user`
--

DROP TABLE IF EXISTS `static_user`;
CREATE TABLE IF NOT EXISTS `static_user` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  `user_id` varchar(64) NOT NULL DEFAULT '' COMMENT '使用者id',
  `first_chat` datetime NOT NULL DEFAULT '2000-01-01 00:00:00' COMMENT '纪录第一次使用系统时间',
  `created_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='用户使用纪录';

-- --------------------------------------------------------

--
-- 資料表結構 `user_contacts`
--

DROP TABLE IF EXISTS `user_contacts`;
CREATE TABLE IF NOT EXISTS `user_contacts` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` varchar(64) NOT NULL,
  `app_id` varchar(64) NOT NULL,
  `last_chat` datetime NOT NULL COMMENT '最後對話日期',
  `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `type` varchar(64) NOT NULL,
  `name` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Ind_107` (`app_id`,`user_id`,`name`,`type`)
) ENGINE=InnoDB AUTO_INCREMENT=1007 DEFAULT CHARSET=utf8mb4 COMMENT='使用者統計資料';
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

