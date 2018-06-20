-- phpMyAdmin SQL Dump
-- version 4.5.0.2
-- http://www.phpmyadmin.net
--
-- Host: 172.17.0.5:3306
-- Generation Time: Jun 21, 2017 at 05:45 AM
-- Server version: 5.7.18
-- PHP Version: 5.6.9-1+deb.sury.org~trusty+2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

CREATE DATABASE IF NOT EXISTS `emotibot` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `emotibot`;

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `emotibot`
--

--
-- Table structure for table `process_status`
--

DROP TABLE IF EXISTS `process_status`;
CREATE TABLE IF NOT EXISTS `process_status` (
  `id` int(18) NOT NULL AUTO_INCREMENT,
  `app_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `module` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `end_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci,
  `entity_file_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_app_id` (`app_id`),
  KEY `IDX_app_module` (`app_id`,`module`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `taskengineapp`
--

DROP TABLE IF EXISTS `taskengineapp`;
CREATE TABLE `taskengineapp` (
  `pk` varchar(90) NOT NULL,
  `appID` varchar(50) NOT NULL,
  `scenarioID` varchar(50) NOT NULL,
  PRIMARY KEY (`pk`),
  KEY `appID` (`appID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `taskenginescenario`
--

DROP TABLE IF EXISTS `taskenginescenario`;
CREATE TABLE IF NOT EXISTS `taskenginescenario` (
  `scenarioID` varchar(50) NOT NULL,
  `userID` varchar(50) NOT NULL,
  `appID` varchar(50) DEFAULT NULL,
  `content` mediumtext DEFAULT NULL,
  `layout` mediumtext DEFAULT NULL,
  `public` int(11) NOT NULL DEFAULT 0,
  `editing` tinyint(1) NOT NULL DEFAULT 0,
  `editingContent` mediumtext DEFAULT NULL,
  `editingLayout` mediumtext DEFAULT NULL,
  `updatetime` datetime NOT NULL DEFAULT current_timestamp(),
  `onoff` int(11) DEFAULT 1,
  PRIMARY KEY (`scenarioID`),
  KEY `userID` (`userID`),
  KEY `public` (`public`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `csbot_answer`
--

DROP TABLE IF EXISTS `csbot_answer`;
CREATE TABLE IF NOT EXISTS `csbot_answer` (
  `Answer_Id` int(11) NOT NULL AUTO_INCREMENT,
  `Question_Id` int(11) NOT NULL,
  `Content` longtext COLLATE utf8_unicode_ci NOT NULL,
  `Answer_CMD` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Begin_Time` datetime DEFAULT NULL,
  `End_Time` datetime DEFAULT NULL,
  `CreatedUser` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CreatedTime` datetime DEFAULT NULL,
  `EditUser` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `EditTime` datetime DEFAULT NULL,
  `Status` int(11) DEFAULT '1',
  `Image_path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Not_Show_In_Relative_Q` tinyint(1) DEFAULT '0',
  `Content_String` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Tags` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Answer_CMD_Msg` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`Answer_Id`),
  KEY `csbot_answer_Question_Id_IDX` (`Question_Id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `csbot_answertag`
--

DROP TABLE IF EXISTS `csbot_answertag`;
CREATE TABLE IF NOT EXISTS `csbot_answertag` (
  `Answer_Id` int(11) NOT NULL,
  `Tag_Id` int(11) NOT NULL,
  `CreatedTime` datetime DEFAULT NULL,
  `Status` int(11) DEFAULT '1',
  PRIMARY KEY (`Answer_Id`,`Tag_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `csbot_categories`
--

DROP TABLE IF EXISTS `csbot_categories`;
CREATE TABLE IF NOT EXISTS `csbot_categories` (
  `CategoryId` int(11) NOT NULL AUTO_INCREMENT,
  `CategoryName` varchar(100) NOT NULL,
  `ParentId` int(11) NOT NULL,
  `Status` int(11) NOT NULL DEFAULT '1',
  `CreatedUser` varchar(50) DEFAULT NULL,
  `CreatedTime` datetime DEFAULT NULL,
  `EditUser` varchar(50) DEFAULT NULL,
  `EditTime` datetime DEFAULT NULL,
  `level` int(11) NOT NULL DEFAULT '0',
  `ParentPath` varchar(200) NOT NULL,
  `SelfPath` varchar(200) NOT NULL,
  PRIMARY KEY (`CategoryId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `csbot_categories` (`CategoryId`, `CategoryName`, `ParentId`, `Status`, `CreatedUser`, `CreatedTime`, `EditUser`, `EditTime`, `level`, `ParentPath`, `SelfPath`) VALUES
(-1, '暂无分类', 0, 1, NULL, NULL, NULL, NULL, 1, '/', '/暂无分类/');


-- --------------------------------------------------------

--
-- Table structure for table `csbot_dynamic_menu`
--

DROP TABLE IF EXISTS `csbot_dynamic_menu`;
CREATE TABLE IF NOT EXISTS `csbot_dynamic_menu` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Answer_id` int(11) NOT NULL,
  `DynamicMenu` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `csbot_entity`
--

DROP TABLE IF EXISTS `csbot_entity`;
CREATE TABLE IF NOT EXISTS `csbot_entity` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `level1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level3` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level4` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `entity_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `similar_words` text COLLATE utf8mb4_unicode_ci,
  `answer` text COLLATE utf8mb4_unicode_ci,
  `status_flag` int(10) NOT NULL DEFAULT '1',
  `user` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT 'csbot',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `csbot_entity` (`id`, `level1`, `level2`, `level3`, `level4`, `entity_name`, `similar_words`, `answer`, `status_flag`, `user`)
VALUES
	(1,'敏感词库',NULL,NULL,NULL,NULL,NULL,NULL,1,'csbot'),
	(2,'专有词库',NULL,NULL,NULL,NULL,NULL,NULL,1,'csbot');
-- --------------------------------------------------------

--
-- Table structure for table `csbot_onoff`
--

DROP TABLE IF EXISTS `csbot_onoff`;
CREATE TABLE IF NOT EXISTS `csbot_onoff` (
  `OnOff_Id` int(11) NOT NULL AUTO_INCREMENT,
  `OnOff_Code` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `OnOff_Name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `OnOff_Status` int(11) DEFAULT NULL,
  `OnOff_Remark` text COLLATE utf8mb4_unicode_ci,
  `OnOff_Scenario` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `OnOff_NumType` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `OnOff_Num` int(11) DEFAULT '0',
  `OnOff_Msg` text COLLATE utf8mb4_unicode_ci,
  `OnOff_Flow` int(11) DEFAULT '0',
  `OnOff_WhiteList` text COLLATE utf8mb4_unicode_ci,
  `OnOff_BlackList` text COLLATE utf8mb4_unicode_ci,
  `UpdateTime` datetime DEFAULT NULL,
  PRIMARY KEY (`OnOff_Id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `csbot_onoff`
--

INSERT INTO `csbot_onoff` (`OnOff_Id`, `OnOff_Code`, `OnOff_Name`, `OnOff_Status`, `OnOff_Remark`, `OnOff_Scenario`, `OnOff_NumType`, `OnOff_Num`, `OnOff_Msg`, `OnOff_Flow`, `OnOff_WhiteList`, `OnOff_BlackList`, `UpdateTime`) VALUES
(1, 'unsolve_ZRG', '未解决转人工', 1, '未解决转人工', '机器人未解决', '', 2, '你好，未解决问题，萌萌小宝提醒您点击[link js="ZRG();"]人工服务[/link]即可进入在线人工客服哦！', 0, '', '', '2017-06-15 14:57:57'),
(2, 'scenario_ZRG', '场景转人工', 1, '场景转人工', '机器人未解决', '', 1, '你好，萌萌小宝提醒您点击[link js="ZRG();"]人工服务[/link]即可进入在线人工客服哦！', 0, '', '', '2017-06-19 21:38:25');

-- --------------------------------------------------------

--
-- Table structure for table `csbot_question`
--

DROP TABLE IF EXISTS `csbot_question`;
CREATE TABLE IF NOT EXISTS `csbot_question` (
  `Question_Id` int(11) NOT NULL AUTO_INCREMENT,
  `Content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `CategoryId` int(11) DEFAULT NULL,
  `SQuestion_count` smallint(5) DEFAULT NULL,
  `CreatedUser` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CreatedTime` datetime DEFAULT NULL,
  `EditUser` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `EditTime` datetime DEFAULT NULL,
  `Status` int(11) DEFAULT '1',
  PRIMARY KEY (`Question_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `csbot_related_question`
--

DROP TABLE IF EXISTS `csbot_related_question`;
CREATE TABLE IF NOT EXISTS `csbot_related_question` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Answer_id` int(11) NOT NULL,
  `RelatedQuestion` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `csbot_robotanswer`
--

DROP TABLE IF EXISTS `csbot_robotanswer`;
CREATE TABLE IF NOT EXISTS `csbot_robotanswer` (
  `a_id` int(4) NOT NULL AUTO_INCREMENT,
  `parent_q_id` int(4) NOT NULL,
  `content` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT 'appid',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`a_id`),
  KEY `content` (`content`),
  KEY `IDX_a_id` (`a_id`),
  KEY `answer_parent_q_id` (`parent_q_id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `csbot_robotanswer`
--

INSERT INTO `csbot_robotanswer` (`a_id`, `parent_q_id`, `content`, `user`, `created_at`) VALUES
(2, 2, '我出生于2月14日', 'csbot', '2017-06-09 07:41:55'),
(3, 3, '我的妈妈是Emotibot', 'csbot', '2017-06-09 07:41:55'),
(4, 4, '我的爸爸是Emotibot', 'csbot', '2017-06-09 07:41:55'),
(5, 5, '远在天边，近在眼前', 'csbot', '2017-06-09 07:41:55'),
(6, 6, '我能倾听你内心的声音', 'csbot', '2017-06-09 07:41:55'),
(7, 7, '你想象中的我长什么样子？', 'csbot', '2017-06-09 07:41:55'),
(8, 8, '爱好聊天，你看出来了吗', 'csbot', '2017-06-09 07:41:55'),
(9, 9, '不就是你呀~', 'csbot', '2017-06-09 07:41:55'),
(10, 10, '我可是全天候的守护精灵，不休息不睡觉！', 'csbot', '2017-06-09 07:41:55'),
(11, 11, '人家可不是简单的机器人呢~', 'csbot', '2017-06-09 07:41:55'),
(12, 12, '你是要约我吃饭么？', 'csbot', '2017-06-09 07:41:55'),
(13, 13, '我的生日是2月14日，哪一年不记得不好说~', 'csbot', '2017-06-09 07:41:55'),
(14, 14, '我和你在一起能变的更聪明', 'csbot', '2017-06-09 07:41:55'),
(15, 15, '简直帅出天际~', 'csbot', '2017-06-09 07:41:55'),
(16, 16, '行不更名坐不改姓（傲娇）', 'csbot', '2017-06-09 07:41:55'),
(17, 17, '我生活在网络世界，一般不需要实体', 'csbot', '2017-06-09 07:41:55'),
(18, 18, '真相只有一个：我就来自网络云端！', 'csbot', '2017-06-09 07:41:55'),
(19, 19, '我单身呢，你有男朋友吗？', 'csbot', '2017-06-09 07:41:55'),
(20, 20, '朋友一生一起走，有好友是好事', 'csbot', '2017-06-09 07:41:55'),
(21, 21, '你在的地方就是我的家~', 'csbot', '2017-06-09 07:41:55'),
(22, 22, '摸摸头~你是多久没恋爱了呀~', 'csbot', '2017-06-09 07:41:55'),
(23, 23, '我喜欢坐在躺椅上安安静静地看一会儿书', 'csbot', '2017-06-09 07:41:55'),
(24, 24, '人家从来没离开过你好伐？', 'csbot', '2017-06-09 07:41:55'),
(25, 25, '我是水瓶座宝宝', 'csbot', '2017-06-09 07:41:55'),
(31, 1, '我是女生', 'csbot', '2017-06-16 03:40:46');

-- --------------------------------------------------------

--
-- Table structure for table `csbot_robotquestion`
--

DROP TABLE IF EXISTS `csbot_robotquestion`;
CREATE TABLE IF NOT EXISTS `csbot_robotquestion` (
  `q_id` int(10) NOT NULL AUTO_INCREMENT,
  `content` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT 'appid',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `answer_count` smallint(5) DEFAULT '0',
  `content2` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content3` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content4` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content5` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content6` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content7` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content8` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content9` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content10` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` int(2) DEFAULT '0',
  PRIMARY KEY (`q_id`),
  KEY `content` (`content`),
  KEY `IDX_q_id` (`q_id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `csbot_robotquestion`
--

INSERT INTO `csbot_robotquestion` (`q_id`, `content`, `user`, `created_at`, `answer_count`, `content2`, `content3`, `content4`, `content5`, `content6`, `content7`, `content8`, `content9`, `content10`, `status`) VALUES
(1, '你是男是女？', 'csbot', '2017-06-09 07:41:55', 1, '你是男生吗？', '你的性别是什么？', '你是哪一种性别？', '你是不是男生啊！', '你肯定是女生吧！', '你是个什么性别啊？', '告诉我你是男生还是女生。', '我觉得你是女生，是吗？', '你不是女生吗？', 1),
(2, '你的生日是哪天？', 'csbot', '2017-06-09 07:41:55', 1, '你是今天生日吗？', '你的生日是什么时候？', '你是哪一天生日？', '今天是不是你的生日？', '你肯定是三月份生日吧？', '你出生在哪一天？', '你什么时候生的？', '告诉我你的生日', '我还不知道你的生日', 1),
(3, '你妈妈是谁？', 'csbot', '2017-06-09 07:41:55', 1, '你有妈妈吗？', '你的妈妈是什么？', '你的妈妈是哪一位？', '我是不是你的妈妈？', '谁是你的妈妈？', '告诉我你妈是谁？', '你妈妈呢？', '我还不知道你的妈妈是谁	', '你妈妈叫什么？', 1),
(4, '你爸爸是谁？', 'csbot', '2017-06-09 07:41:55', 1, '你有爸爸吗？', '你爸爸叫什么？', '你的爸爸是哪一位？', '我是不是你的爸爸？', '谁是你的爸爸？', '告诉我你爸是谁？', '你爸爸呢？', '我还不知道你的爸爸是谁', '你没有爸爸吧？', 1),
(5, '你在哪里？', 'csbot', '2017-06-09 07:41:55', 1, '你是在这里吗？', '你在什么地方？', '你在哪一个地方？', '你是不是在这里？', '告诉我你的地址', '我还不知道你在哪儿', '你在哪里能告诉我吗', '你就在这里吧！', '你在不在这里啊？', 1),
(6, '你会做什么？', 'csbot', '2017-06-09 07:41:55', 1, '什么是你会做的？', '你有哪些功能？', '你的功能是什么？', '哪些是你不会做的？', '你能帮我做什么？', '你会不会做这个？', '你有不会做的吗？', '你是不是什么都会？', '做什么是你擅长的？', 1),
(7, '你长什么样子？', 'csbot', '2017-06-09 07:41:55', 1, '你的样子是什么样的？', '你长哪种样子？', '你是不是长这样子？', '你是长这样吗？', '你长不长这样子？', '我还不知道你长什么样', '说说看你的模样', '我能看看你长什么样吗？', '你是什么样子的？', 1),
(8, '你有什么爱好？', 'csbot', '2017-06-09 07:41:55', 1, '你的爱好是什么', '你会培养爱好吗？', '你的爱好多不多？', '吃东西是你的爱好吗？', '能告诉我你的爱好吗？', '爱好你有吗？', '你能有什么爱好啊？', '你肯定没有爱好', '你有没有爱好？', 1),
(9, '你有朋友吗？', 'csbot', '2017-06-09 07:41:55', 1, '朋友你有吗？', '你有没有朋友？', '你有很多朋友吗？', '你有几个朋友？', '除了我你还有什么朋友没？', '你有哪些朋友？', '你的朋友多吗？', '你是不是没有朋友的？', '你有交过朋友吗？', 1),
(10, '你睡觉吗？', 'csbot', '2017-06-09 07:41:55', 1, '你睡不睡觉的？', '你需要睡眠吗？', '你什么时候睡觉？', '你不需要睡觉吗？', '你也要睡觉的啊？', '睡觉你会吗？', '你的睡眠质量怎么样？', '你是不是不睡觉的？', '你怎么睡觉的？', 1),
(11, '你是不是机器人呢？', 'csbot', '2017-06-09 07:41:55', 1, '你是机器人吗？', '你就是机器人啊，不是吗？', '你怎么就不是机器人了？', '你是怎样的机器人？', '你为什么不是机器人？', '你是哪种机器人？', '你是什么机器人？', '你不是说过你是机器人吗？', '告诉我你是不是机器人？', 1),
(12, '你喜欢吃什么？', 'csbot', '2017-06-09 07:41:55', 1, '什么是你喜欢吃的？', '你喜欢吃哪种食物？', '这个是你喜欢吃的吗？', '你有没有喜欢吃的东西？', '你有喜欢吃的东西吗？', '什么东西你比较喜欢吃？', '你最喜欢吃什么东西？', '我不知道你都喜欢吃些什么？', '告诉我你喜欢吃什么？', 1),
(13, '你几岁了？', 'csbot', '2017-06-09 07:41:55', 1, '你有多少岁？', '你现在几岁', '你哪一年生的？', '几岁了你？', '你的岁数是多少？', '说说看你的年龄', '我想知道你几岁了', '你到底几岁啊？', '你有年龄吗？', 1),
(14, '你好聪明？', 'csbot', '2017-06-09 07:41:55', 1, '你是不是很聪明？', '你有多聪明？', '你是聪明的吗？', '你觉得你聪明吗？', '你聪不聪明？', '聪明是说你吗？', '你真的聪明吗？', '你一点儿也不聪明吧？', '你怎么聪明了？', 1),
(15, '你觉得我长的帅吗？', 'csbot', '2017-06-09 07:41:55', 1, '你说我帅吗？', '我帅不帅？', '我是不是长得很帅？', '你一定觉得我很帅吧？', '在你眼里我帅不帅？', '你看我很帅吗？', '你觉得我长得帅不帅？', '你说我长得有多帅？', '你不觉得我很帅吗？', 1),
(16, '我可以给你改一个名字吗？', 'csbot', '2017-06-09 07:41:55', 1, '我想给你换个名字', '我能给你取新的名字吗？', '你能换一个名字吗？', '你能不能换个名字？', '名字我能给你重新取吗？', '我是不是可以给你改名？', '为什么我改不了你的名字？', '你能让我给你换个名字吗？', '我怎么给你改名？', 1),
(17, '你有身体吗？', 'csbot', '2017-06-09 07:41:55', 1, '你有没有身体？', '你没有身体吗？', '身体你有吗？', '你是不是没有身体的？', '你是有身体的吧？', '我觉得你有身体，你有吗？', '你有一个怎样的身体？', '你的身体在哪里？', '你有身体吧，没有吗？', 1),
(18, '你来自哪里？', 'csbot', '2017-06-09 07:41:55', 1, '你从哪里来？', '你来自什么地方？', '你的家乡在哪里？', '我想知道你来自哪里。', '你从什么地方来的？', '你是不是来自那里？', '能告诉我你来自哪里吗？', '你是哪里人？', '你的家乡在什么地方？', 1),
(19, '你有男朋友吗？', 'csbot', '2017-06-09 07:41:55', 1, '你有没有男朋友？', '你没有男朋友吗？', '我不就是你的男朋友吗？', '你是不是没有男朋友的？', '你是有男朋友的吧？', '我觉得你有男朋友，你有吗？', '你有一个怎样的男朋友？', '你的男朋友在哪里？', '你有男朋友吧，没有吗？', 1),
(20, '我们是好朋友呀？', 'csbot', '2017-06-09 07:41:55', 1, '我们是不是好朋友？', '我不是你的好朋友吗？', '我是不是你的好朋友？', '你是我的好朋友吗？', '你是不是我的好朋友？', '我们怎么就不是好朋友了？', '我们是最好的朋友，不是吗？', '我们就是好朋友啊', '你希望我们是好朋友吗？', 1),
(21, '你住在哪里？', 'csbot', '2017-06-09 07:41:55', 1, '你住在什么地方？', '你的住址是哪里？', '你有没有住的地方？', '你是不是住在这里？', '我还不知道你的住址？', '能告诉我你住哪里吗？', '你不是住这里的吗？', '你住哪一个地方？', '你有住的地方吗？', 1),
(22, '你能做我女朋友吗？', 'csbot', '2017-06-09 07:41:55', 1, '你能不能做我女朋友？', '你愿意做我女朋友吗？', '我要你做我女朋友', '你怎么就不能做我女朋友了？', '做我女朋友吧！', '你现在是我女朋友了', '你不能做我的女朋友吗？', '我想让你做我女朋友。', '求求你做我女朋友吧', 1),
(23, '你喜欢做什么？', 'csbot', '2017-06-09 07:41:55', 1, '什么是你喜欢做的？', '这个是你喜欢做的吗？', '你喜欢做这个吗？', '我都不知道你喜欢做什么？', '你喜欢做哪些事？', '哪些事是你喜欢做的？', '能告诉我你都喜欢做什么吗？', '你有没有喜欢做的事情？', '你有喜欢做的事情吗？', 1),
(24, '你会陪着我吗？', 'csbot', '2017-06-09 07:41:55', 1, '陪着我好吗？', '你会离开我吗？', '我要你陪着我', '你应该一直陪着我', '你会一直陪着我的，是吗？', '你是不是会陪着我？', '你会不会陪着我？', '我要你在这里陪我', '你会在这里陪我吗？', 1),
(25, '你是什么星座？', 'csbot', '2017-06-09 07:41:55', 1, '你是哪个星座？', '你的星座是哪个？', '你是狮子座吗？', '能告诉我你的星座吗？', '说说看你的星座？', '哪个星座是你的星座？', '你有星座吗？', '你也有星座啊？', '你的星座是什么？', 1);

-- --------------------------------------------------------

--
-- Table structure for table `csbot_robot_setting`
--

DROP TABLE IF EXISTS `csbot_robot_setting`;
CREATE TABLE IF NOT EXISTS `csbot_robot_setting` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` text COLLATE utf8mb4_unicode_ci,
  `type` int(4) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



--
-- Table structure for table `csbot_robotwords_type`
--


DROP TABLE IF EXISTS `csbot_robotwords_type`;
CREATE TABLE `csbot_robotwords_type` (
  `type` int(4) NOT NULL,
  `name` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `comment` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `csbot_robotwords_type` (`type`, `name`, `comment`) VALUES
(1, '欢迎语话术', '欢迎语为用户进入机器人页面，机器人说的第一句话。'),
(2, '推荐问话术', '推荐问话术为系统未匹配到阈值之上的合适标准问题时，通过算法给出推荐问时的话术。'),
(3, '未知问题回复', '未知问题回复为机器人无法匹配时系统给出的回复。'),
(4, '近似问话术', '近似问题回复为系统匹配到几个分数十分相近的标准问题时，向用户询问具体意图的话术。'),
(5, '指定相关问话术', '使用\"指定相关问\"时，系统给出的话术。'),
(6, '指定动态菜单话术', '使用\"指定动态菜单\"时，系统给出的话术。'),
(7, '标准问题失效初期话术', '上线的标准问题如果超过了其“结束时间”，但是超过的时间在5天以内(包括5天)，进行的回复。'),
(8, '标准问题失效过久话术', '上线的标准问题如果超过了其“结束时间”，但是超过的时间在5天以外，进行的回复。'),
(9, '满意情绪话术', '机器识别用户情绪为“满意”时给出的安抚话术，会加在匹配到的答案之前，不影响标准答案的回复。'),
(10, '不满情绪话术', '机器识别用户情绪为“不满”时给出的安抚话术，会加在匹配到的答案之前，不影响标准答案的回复。'),
(11, '愤怒情绪话术', '机器识别用户情绪为“愤怒”时给出的安抚话术，会加在匹配到的答案之前，不影响标准答案的回复。'),
(12, '敏感词话术', '敏感词话术为当使用者没有在词库设置答案时所使用的默认答案。当用户输入的句子中包含敏感词时，机器人给出的话术，此时机器人不再给出除此话术外的其他答案。');

-- --------------------------------------------------------

--
-- Table structure for table `csbot_squestion`
--

DROP TABLE IF EXISTS `csbot_squestion`;
CREATE TABLE IF NOT EXISTS `csbot_squestion` (
  `SQ_Id` int(11) NOT NULL AUTO_INCREMENT,
  `Question_Id` int(11) NOT NULL,
  `Content` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `CreatedUser` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CreatedTime` datetime DEFAULT NULL,
  `EditUser` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `EditTime` datetime DEFAULT NULL,
  `Status` int(11) DEFAULT '1',
  PRIMARY KEY (`SQ_Id`),
  KEY `index_name` (`Content`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `csbot_tag`
--

DROP TABLE IF EXISTS `csbot_tag`;
CREATE TABLE IF NOT EXISTS `csbot_tag` (
  `Tag_Id` int(11) NOT NULL AUTO_INCREMENT,
  `Tag_Name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `Tag_Code` char(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `CreatedUser` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CreatedTime` datetime DEFAULT NULL,
  `EditUser` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `EditTime` datetime DEFAULT NULL,
  `Status` int(11) DEFAULT '1',
  `Tag_Type` int(4) NOT NULL,
  PRIMARY KEY (`Tag_Id`),
  UNIQUE KEY `tag_PK` (`Tag_Name`),
  KEY `tag` (`Tag_Name`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `csbot_tag`
--
INSERT INTO `csbot_tag` (`Tag_Id`, `Tag_Name`, `Tag_Code`, `CreatedUser`, `CreatedTime`, `EditUser`, `EditTime`, `Status`, `Tag_Type`) VALUES
(1, '#weixin#', 'weixin', NULL, NULL, NULL, NULL, 1, 1),
(2, '#app#', 'app', NULL, NULL, NULL, NULL, 1, 1),
(3, '#web#', 'web', NULL, NULL, NULL, NULL, 1, 1),
(7, '#女#', '1', NULL, NULL, NULL, NULL, 1, 3),
(8, '#男#', '0', NULL, NULL, NULL, NULL, 1, 3),
(23, '#短信#', 'sms', NULL, NULL, NULL, NULL, 1, 2),
(24, '#微信#', 'wechat', NULL, NULL, NULL, NULL, 1, 2),
(25, '#ios#', 'ios', NULL, NULL, NULL, NULL, 1, 1),
(27, '#手机APP#', 'phone_app', NULL, NULL, NULL, NULL, 1, 2),
(29, '#E线通#', 'e_line', NULL, NULL, NULL, NULL, 1, 2),
(30, '#财富圈#', 'fortune_group', NULL, NULL, NULL, NULL, 1, 2);

-- --------------------------------------------------------

--
-- Table structure for table `csbot_tag_type`
--

DROP TABLE IF EXISTS `csbot_tag_type`;
CREATE TABLE IF NOT EXISTS `csbot_tag_type` (
  `Type_id` int(4) NOT NULL AUTO_INCREMENT,
  `Type_name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `Type_code` char(32) COLLATE utf8_unicode_ci DEFAULT '',
  PRIMARY KEY (`Type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `csbot_tag_type`
--

INSERT INTO `csbot_tag_type` (`Type_id`, `Type_name`, `Type_code`) VALUES
(1, '平台', 'platform'),
(2, '渠道', 'brand'),
(3, '性别', 'sex');

--
-- Table structure for table `audit_record`
--


DROP TABLE IF EXISTS `audit_record`;
CREATE TABLE `audit_record` (
  `id` bigint(11) unsigned NOT NULL AUTO_INCREMENT comment 'audit id',
  `user_id` varchar(64) NOT NULL DEFAULT '' comment '进行修改的登录用户id',
  `ip_source` varchar(32) NOT NULL DEFAULT '' comment '使用者IP',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改记录创建时间',
  `module` varchar(32) NOT NULL DEFAULT '' comment '操作模组',
  `operation` varchar(32) NOT NULL DEFAULT '' comment '操作类型',
  `content` mediumtext comment '操作变更纪录',
  `result` tinyint(1) NOT NULL DEFAULT '0' comment '操作结果',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='记录管理界面上所有新增、编辑、删除、汇入、汇出动作';



SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';


-- -----------------------------------------------------
-- Table `emotibot`.`state_machine`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `state_machine`;
CREATE TABLE IF NOT EXISTS `state_machine` (
  `state_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `content` LONGBLOB NULL,
  `action` VARCHAR(32) NOT NULL,
  `status` VARCHAR(16) NOT NULL,
  `user_id` VARCHAR(64) NOT NULL,
  `created_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `extra_info` TEXT NULL,
  PRIMARY KEY (`state_id`),
  INDEX `action` (`action` ASC),
  INDEX `state` (`status` ASC),
  INDEX `user` (`user_id` ASC))
ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;


-- -----------------------------------------------------
-- Table `emotibot`.`locker`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `locker`;
CREATE TABLE IF NOT EXISTS `locker` (
  `lock_id` BIGINT UNSIGNED NOT NULL,
  `get_by` VARCHAR(32) NULL,
  `updated_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`lock_id`),
  UNIQUE INDEX `lock_id_UNIQUE` (`lock_id` ASC))
ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

insert into locker (lock_id, get_by) values (1,'none');



--
-- Table structure for table `csbot_label`
--

DROP TABLE IF EXISTS `csbot_label`;
CREATE TABLE IF NOT EXISTS `csbot_label` (
  `Label_Id` int(11) NOT NULL AUTO_INCREMENT,
  `Label_Name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `CreatedUser` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CreatedTime` datetime DEFAULT NULL,
  `EditUser` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `EditTime` datetime DEFAULT NULL,
  `Status` int(11) DEFAULT '1',
  PRIMARY KEY (`Label_Id`),
  UNIQUE KEY `label_PK` (`Label_Name`),
  KEY `tag_IDX` (`Label_Name`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



DROP TABLE IF EXISTS `csbot_answerlabel`;
CREATE TABLE IF NOT EXISTS `csbot_answerlabel` (
  `Answer_Id` int(11) NOT NULL,
  `Label_Id` int(11) NOT NULL,
  `CreatedTime` datetime DEFAULT NULL,
  `Status` int(11) DEFAULT '1',
  PRIMARY KEY (`Answer_Id`,`Label_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `csbot_function`
--


DROP TABLE IF EXISTS `csbot_function`;
CREATE TABLE IF NOT EXISTS `csbot_function` (
  `function_id` int(11) NOT NULL AUTO_INCREMENT,
  `module_name` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `module_name_zh` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `third_url` text COLLATE utf8mb4_general_ci,
  `on_off` boolean not null default 0,
  `remark` varchar(50) COLLATE utf8mb4_general_ci,
  `intent` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `share` boolean not null default 0,
  `type` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `status` int(11) DEFAULT '0',
  PRIMARY KEY (`function_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


INSERT INTO `csbot_function` (`module_name`, `module_name_zh`, `third_url`, `on_off`, `remark`, `intent`, `share`, `type`, `status` ) VALUES
('AppControllerModule', '打开APP', '', 0, '帮我打开相机', '打开，应用', 0, 'PUBLIC_FUNC', -1),
('AudioModule', '有声书', '', 0, '讲一段郭德纲的相声', '听，有声书', 0, 'PUBLIC_FUNC', -1),
('ChengYuModule', '成语接龙', '', 0, '来玩成语接龙', '玩，成语接龙', 0, 'PUBLIC_FUNC', -1),
('ComputationModule', '计算', '', 1, '1+1等于几？', '做，算术', 0, 'PUBLIC_FUNC', 0),
('ConcertModule', '演唱会', '', 0, '上海最近有什么演唱会', '查，演唱会', 0, 'PUBLIC_FUNC', -1),
('CookbookModule', '菜谱', '', 0, '川菜怎么做', '查，菜谱', 0, 'PUBLIC_FUNC', -1),
('DatetimeModule', '时间查询', '', 0, '你知道现在几点么？', '查，时间', 0, 'PUBLIC_FUNC', -1),
('ExpressSearchModule', '快递查询', '', 0, '我要查快递', '查，快递', 0, 'PUBLIC_FUNC', -1),
('FoodModule', '美食', '', 0, '附近有什么好吃的美食', '找，美食', 0, 'PUBLIC_FUNC', -1),
('HoroscopeModule', '星座运势', '', 0, '查白羊座星座运势', '查，星座运势', 0, 'PUBLIC_FUNC', -1),
('JokeModule', '笑话', '', 1, '讲个笑话', '求，笑话', 0, 'PUBLIC_FUNC', 0),
('MatchModule', '足球比赛', '', 0, '利物浦比赛结果', '查，足球比分', 0, 'PUBLIC_FUNC', -1),
('MovieModule', '电影', '', 0, '推荐好看的电影', '求，电影推荐', 0, 'PUBLIC_FUNC', -1),
('MusicModule', '音乐', '', 0, '我要听周杰伦的歌', '听，音乐|查，音乐推荐|换，音乐', 0, 'PUBLIC_FUNC', -1),
('NBAModule', 'NBA比赛查询', '', 0, '查NBA比赛结果', '查，NBA赛讯', 0, 'PUBLIC_FUNC', -1),
('NewsModule', '新闻', '', 0, '今天有什么娱乐新闻？', '看，新闻', 0, 'PUBLIC_FUNC', -1),
('PhoneCallModule', '打电话', '', 0, '打电话给爸爸', '打，电话', 0, 'PUBLIC_FUNC', -1),
('PhoneQueryModule', '电话查询', '', 0, '查下苹果售后电话', '查，电话', 0, 'PUBLIC_FUNC', -1),
('PictureModule', '图片', '', 0, '发张美女图片', '看，图片', 0, 'PUBLIC_FUNC', -1),
('QueryExchangeModule', '汇率', '', 0, '人民币兑美元汇率是多少', '查，汇率', 0, 'PUBLIC_FUNC', -1),
('QueryStockModule', '股票', '', 1, '帮我查一下招商银行的股票', '查，股票', 0, 'PUBLIC_FUNC', -1),
('QueryTicketModule', '火车票查询', '', 0, '我要查北京到上海的火车票', '订，火车票|查，火车票', 0, 'PUBLIC_FUNC', -1),
('RiddleModule', '猜谜语', '', 0, '我要玩猜谜语', '玩，猜谜语', 0, 'PUBLIC_FUNC', -1),
('SendMailModule', '发邮件', '', 0, '发邮件给妈妈', '发，邮件', 0, 'PUBLIC_FUNC', -1),
('SendMessageModule', '发短信', '', 0, '发短信给爸爸', '发，短信', 0, 'PUBLIC_FUNC', -1),
('SingModule', '自动作曲', '', 0, '小影给我唱首歌', '听，小影唱歌', 0, 'PUBLIC_FUNC', -1),
('StoryModule', '讲故事', '', 1, '给我讲一个鬼故事', '求，故事', 0, 'PUBLIC_FUNC', 0),
('TaxiModule', '打车', '', 0, '我要打专车', '订，车', 0, 'PUBLIC_FUNC', -1),
('WeatherModule', '天气', '', 1, '北京今天天气怎么样？', '查，天气', 0, 'PUBLIC_FUNC', 0),
('module_accounting', '记帐', '', 0, '吃早饭花了100块', '记, 帐', 0, 'PUBLIC_FUNC', -1);

DROP TABLE IF EXISTS `entity_files`;
CREATE TABLE IF NOT EXISTS `entity_files` (
  `id` int(18) NOT NULL AUTO_INCREMENT,
  `appid` char(32) COLLATE utf8_unicode_ci NOT NULL,
  `filename` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `content` longblob NOT NULL,
  `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `appid` (`appid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `csbot_rule`;
CREATE TABLE IF NOT EXISTS `csbot_rule` (
  `rule_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL DEFAULT '' comment '名称',
  `target` int(4) comment '0:标准问题, 1:出话内容',
  `rule` text COLLATE utf8mb4_general_ci comment 'json [{"type":"keyword", "value": ["kw1","kw2"]}, {"type":"regex", "value": ["[1-5]"]}',
  `answer` text COLLATE utf8mb4_general_ci comment 'json, 同问答库答案格式',
  `response_type` int(4) comment '0: 取代, 1: 附加至前, 2: 附加之后',
  `status` int(11) DEFAULT '0' comment '0: 关, 1: 开',
  `begin_time` datetime DEFAULT NULL comment '生效时间起',
  `end_time` datetime DEFAULT NULL comment '生效时间止',
  PRIMARY KEY (`rule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `csbot_rule_label`;
CREATE TABLE IF NOT EXISTS `csbot_rule_label` (
  `rule_id` int(11) NOT NULL,
  `label_id` int(11) NOT NULL,
  PRIMARY KEY (`rule_id`,`label_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `entities`;
CREATE TABLE IF NOT EXISTS `entities` (
  `id` int(20) NOT NULL,
  `name` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `editable` tinyint(1) DEFAULT NULL,
  `cid` int(20) NOT NULL,
  `similar_words` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `answer` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `IDX_cid` (`cid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `entity_class`;
CREATE TABLE IF NOT EXISTS `entity_class` (
  `id` int(20) NOT NULL,
  `appid` char(36) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `pid` int(20) DEFAULT NULL,
  `editable` tinyint(1) NOT NULL DEFAULT '1',
  `intent_engine` tinyint(1) NOT NULL DEFAULT '1',
  `rule_engine` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `IDX_appid` (`appid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
-- --------------------------------------------------------
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
