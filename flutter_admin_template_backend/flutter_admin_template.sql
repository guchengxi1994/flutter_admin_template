/*
 Navicat Premium Data Transfer

 Source Server         : local
 Source Server Type    : MySQL
 Source Server Version : 80023
 Source Host           : localhost:3306
 Source Schema         : flutter_admin_template

 Target Server Type    : MySQL
 Target Server Version : 80023
 File Encoding         : 65001

 Date: 04/07/2023 15:43:14
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for api
-- ----------------------------
DROP TABLE IF EXISTS `api`;
CREATE TABLE `api`  (
  `api_id` int NOT NULL AUTO_INCREMENT,
  `api_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `api_router` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `api_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) NULL DEFAULT 0,
  `remark` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`api_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of api
-- ----------------------------
INSERT INTO `api` VALUES (1, '日志总览', '/system/log/summary', 'get', '2023-07-03 09:35:43', '2023-07-03 09:35:43', 0, NULL);
INSERT INTO `api` VALUES (2, '登录日志查询', '/system/log/signin/all', 'get', '2023-07-03 09:36:19', '2023-07-03 09:36:19', 0, NULL);
INSERT INTO `api` VALUES (3, '当前人员登录日志', '/system/log/signin/current', 'get', '2023-07-03 09:36:58', '2023-07-03 09:37:07', 0, NULL);
INSERT INTO `api` VALUES (4, '角色查询', '/system/role/all', 'get', '2023-07-03 09:38:01', '2023-07-03 09:38:01', 0, NULL);
INSERT INTO `api` VALUES (5, '当前角色信息', '/system/role/details/current', 'get', '2023-07-03 09:38:22', '2023-07-03 09:38:22', 0, NULL);
INSERT INTO `api` VALUES (6, '根据id获取角色信息', '/system/role/details', 'get', '2023-07-03 09:38:50', '2023-07-03 09:38:50', 0, NULL);
INSERT INTO `api` VALUES (7, '获取所有页面路由', '/system/router/all', 'get', '2023-07-03 09:39:27', '2023-07-03 09:39:27', 0, NULL);
INSERT INTO `api` VALUES (8, '根据user id获取页面路由', '/system/router/user', 'get', '2023-07-03 10:06:24', '2023-07-03 10:06:24', 0, NULL);
INSERT INTO `api` VALUES (9, '当前用户获取页面路由', '/system/router/current', 'get', '2023-07-03 10:06:57', '2023-07-03 10:06:57', 0, NULL);
INSERT INTO `api` VALUES (10, '根据role id获取页面路由', '/system/router/role', 'get', '2023-07-03 10:07:25', '2023-07-03 10:07:25', 0, NULL);
INSERT INTO `api` VALUES (11, '创建新用户', '/system/user/create', 'post', '2023-07-03 10:09:02', '2023-07-03 10:09:02', 0, NULL);
INSERT INTO `api` VALUES (12, '登录', '/system/user/login', 'post', '2023-07-03 10:09:41', '2023-07-03 10:09:41', 0, '都有的api路由');
INSERT INTO `api` VALUES (13, '获取用户信息', '/system/user/info', 'get', '2023-07-03 10:10:07', '2023-07-03 10:10:07', 0, NULL);
INSERT INTO `api` VALUES (14, '根据页面路由获取api路由', '/system/api/byRouter', 'get', '2023-07-03 11:34:30', '2023-07-03 11:34:30', 0, NULL);
INSERT INTO `api` VALUES (15, '根据role id获取api路由', '/system/api/byRole', 'get', '2023-07-03 16:53:27', '2023-07-03 16:53:27', 0, NULL);
INSERT INTO `api` VALUES (16, '当前用户的api', '/system/api/current', 'get', '2023-07-04 15:39:34', '2023-07-04 15:39:34', 0, NULL);

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role`  (
  `role_id` int NOT NULL AUTO_INCREMENT,
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `create_by` int NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) NULL DEFAULT 0,
  `remark` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO `role` VALUES (1, 'admin', NULL, '2023-06-29 16:16:20', '2023-06-29 16:17:23', 0, '管理员');

-- ----------------------------
-- Table structure for role_api
-- ----------------------------
DROP TABLE IF EXISTS `role_api`;
CREATE TABLE `role_api`  (
  `role_id` int NOT NULL,
  `api_id` int NOT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of role_api
-- ----------------------------
INSERT INTO `role_api` VALUES (1, 1);
INSERT INTO `role_api` VALUES (1, 2);
INSERT INTO `role_api` VALUES (1, 3);
INSERT INTO `role_api` VALUES (1, 4);
INSERT INTO `role_api` VALUES (1, 5);
INSERT INTO `role_api` VALUES (1, 6);
INSERT INTO `role_api` VALUES (1, 7);
INSERT INTO `role_api` VALUES (1, 8);
INSERT INTO `role_api` VALUES (1, 9);
INSERT INTO `role_api` VALUES (1, 10);
INSERT INTO `role_api` VALUES (1, 11);
INSERT INTO `role_api` VALUES (1, 12);
INSERT INTO `role_api` VALUES (1, 13);
INSERT INTO `role_api` VALUES (1, 14);
INSERT INTO `role_api` VALUES (1, 15);
INSERT INTO `role_api` VALUES (1, 16);

-- ----------------------------
-- Table structure for role_router
-- ----------------------------
DROP TABLE IF EXISTS `role_router`;
CREATE TABLE `role_router`  (
  `role_id` int NOT NULL,
  `router_id` int NOT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of role_router
-- ----------------------------
INSERT INTO `role_router` VALUES (1, 1);
INSERT INTO `role_router` VALUES (1, 2);
INSERT INTO `role_router` VALUES (1, 3);
INSERT INTO `role_router` VALUES (1, 4);
INSERT INTO `role_router` VALUES (1, 5);
INSERT INTO `role_router` VALUES (1, 6);
INSERT INTO `role_router` VALUES (1, 7);
INSERT INTO `role_router` VALUES (1, 8);
INSERT INTO `role_router` VALUES (1, 9);

-- ----------------------------
-- Table structure for router
-- ----------------------------
DROP TABLE IF EXISTS `router`;
CREATE TABLE `router`  (
  `router_id` int NOT NULL AUTO_INCREMENT,
  `router_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `router` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) NULL DEFAULT 0,
  `remark` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` int NULL DEFAULT 1,
  `parent_id` int NOT NULL DEFAULT 0,
  PRIMARY KEY (`router_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of router
-- ----------------------------
INSERT INTO `router` VALUES (1, '登录', '/loginScreen', '2023-06-29 16:18:46', '2023-06-29 16:22:54', 0, '登录', 1, 0);
INSERT INTO `router` VALUES (2, 'dashboard', '/main/dashboard', '2023-06-29 16:19:19', '2023-06-29 16:22:56', 0, NULL, 1, 0);
INSERT INTO `router` VALUES (3, 'user', '/main/user', '2023-06-29 16:20:11', '2023-06-29 16:22:59', 0, NULL, 1, 0);
INSERT INTO `router` VALUES (4, 'menu', '/main/menu', '2023-06-29 16:20:26', '2023-06-29 16:23:00', 0, NULL, 1, 0);
INSERT INTO `router` VALUES (5, 'department', '/main/dept', '2023-06-29 16:20:40', '2023-06-29 16:23:01', 0, NULL, 1, 0);
INSERT INTO `router` VALUES (6, 'logs', '/main/logs', '2023-06-29 16:20:53', '2023-06-29 16:23:02', 0, NULL, 1, 0);
INSERT INTO `router` VALUES (7, 'operation', '/main/logs/operation', '2023-06-29 16:21:11', '2023-06-29 16:23:06', 0, NULL, 1, 6);
INSERT INTO `router` VALUES (8, 'signin', '/main/logs/signin', '2023-06-29 16:21:31', '2023-06-29 16:23:08', 0, NULL, 1, 6);
INSERT INTO `router` VALUES (9, 'role', '/main/role', '2023-07-01 10:38:12', '2023-07-01 10:38:12', 0, NULL, 1, 0);

-- ----------------------------
-- Table structure for router_api
-- ----------------------------
DROP TABLE IF EXISTS `router_api`;
CREATE TABLE `router_api`  (
  `router_id` int NOT NULL DEFAULT 0,
  `api_id` int NOT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of router_api
-- ----------------------------
INSERT INTO `router_api` VALUES (6, 1);
INSERT INTO `router_api` VALUES (8, 2);
INSERT INTO `router_api` VALUES (8, 3);
INSERT INTO `router_api` VALUES (9, 4);
INSERT INTO `router_api` VALUES (0, 5);
INSERT INTO `router_api` VALUES (9, 6);
INSERT INTO `router_api` VALUES (4, 7);
INSERT INTO `router_api` VALUES (3, 8);
INSERT INTO `router_api` VALUES (0, 9);
INSERT INTO `router_api` VALUES (9, 10);
INSERT INTO `router_api` VALUES (3, 11);
INSERT INTO `router_api` VALUES (1, 12);
INSERT INTO `router_api` VALUES (0, 13);
INSERT INTO `router_api` VALUES (9, 14);
INSERT INTO `router_api` VALUES (9, 15);
INSERT INTO `router_api` VALUES (0, 16);

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `user_id` int NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `dept_id` int NULL DEFAULT NULL COMMENT '(可为空)部门id',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码',
  `create_by` int NULL DEFAULT 1 COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) NULL DEFAULT 0,
  `remark` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, NULL, 'admin', '123456', 1, '2023-06-13 02:08:38', '2023-06-29 16:12:22', 0, 'this is admin');
INSERT INTO `user` VALUES (2, NULL, '黎芳', 'Lorem', 1, '2023-06-13 03:32:35', '2023-06-29 16:12:22', 0, 'in officia');
INSERT INTO `user` VALUES (3, NULL, '黎芳1', 'Lorem', 1, '2023-06-14 05:33:52', '2023-06-29 16:12:24', 0, 'in officia');

-- ----------------------------
-- Table structure for user_login
-- ----------------------------
DROP TABLE IF EXISTS `user_login`;
CREATE TABLE `user_login`  (
  `login_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '登录IP',
  `login_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '登录时间',
  `login_state` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `token` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`login_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 112 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_login
-- ----------------------------
INSERT INTO `user_login` VALUES (23, 1, '127.0.0.1', '2023-06-14 07:45:33', 'success', NULL);
INSERT INTO `user_login` VALUES (24, 1, '127.0.0.1', '2023-06-14 07:46:39', 'success', NULL);
INSERT INTO `user_login` VALUES (25, 1, '127.0.0.1', '2023-06-14 08:20:55', 'no user', NULL);
INSERT INTO `user_login` VALUES (26, 1, '127.0.0.1', '2023-06-15 01:02:00', 'success', NULL);
INSERT INTO `user_login` VALUES (27, 1, '127.0.0.1', '2023-06-15 01:25:32', 'no user', NULL);
INSERT INTO `user_login` VALUES (28, 1, '127.0.0.1', '2023-06-15 03:19:20', 'success', NULL);
INSERT INTO `user_login` VALUES (29, 2, '127.0.0.1', '2023-06-15 03:38:38', 'success', NULL);
INSERT INTO `user_login` VALUES (30, 2, '127.0.0.1', '2023-06-20 02:21:17', 'success', NULL);
INSERT INTO `user_login` VALUES (35, 2, '127.0.0.1', '2023-06-20 02:56:54', 'error password', NULL);
INSERT INTO `user_login` VALUES (37, 1, '127.0.0.1', '2023-06-20 03:00:02', 'success', NULL);
INSERT INTO `user_login` VALUES (40, 1, '127.0.0.1', '2023-06-20 03:02:25', 'error password', NULL);
INSERT INTO `user_login` VALUES (41, 1, '127.0.0.1', '2023-06-20 03:03:57', 'success', NULL);
INSERT INTO `user_login` VALUES (42, 3, '127.0.0.1', '2023-06-20 03:04:17', 'success', NULL);
INSERT INTO `user_login` VALUES (43, 1, '127.0.0.1', '2023-06-20 07:32:00', 'error password', NULL);
INSERT INTO `user_login` VALUES (44, 1, '127.0.0.1', '2023-06-20 07:57:40', 'success', NULL);
INSERT INTO `user_login` VALUES (45, 3, '127.0.0.1', '2023-06-20 08:08:36', 'success', NULL);
INSERT INTO `user_login` VALUES (46, 1, '127.0.0.1', '2023-06-20 08:28:26', 'error password', NULL);
INSERT INTO `user_login` VALUES (47, 1, '127.0.0.1', '2023-06-20 08:31:05', 'success', NULL);
INSERT INTO `user_login` VALUES (48, 1, '127.0.0.1', '2023-06-20 08:34:00', 'success', NULL);
INSERT INTO `user_login` VALUES (49, 1, '127.0.0.1', '2023-06-20 08:37:42', 'success', NULL);
INSERT INTO `user_login` VALUES (50, 1, '127.0.0.1', '2023-06-20 08:38:55', 'success', NULL);
INSERT INTO `user_login` VALUES (51, 1, '127.0.0.1', '2023-06-20 08:42:50', 'success', NULL);
INSERT INTO `user_login` VALUES (52, 1, '127.0.0.1', '2023-06-20 08:52:35', 'success', NULL);
INSERT INTO `user_login` VALUES (53, 1, '127.0.0.1', '2023-06-20 08:55:56', 'success', NULL);
INSERT INTO `user_login` VALUES (54, 1, '127.0.0.1', '2023-06-20 08:57:59', 'success', NULL);
INSERT INTO `user_login` VALUES (55, 1, '127.0.0.1', '2023-06-20 09:00:04', 'success', NULL);
INSERT INTO `user_login` VALUES (56, 1, '127.0.0.1', '2023-06-20 09:04:40', 'success', NULL);
INSERT INTO `user_login` VALUES (57, 1, '127.0.0.1', '2023-06-20 09:06:53', 'no user', NULL);
INSERT INTO `user_login` VALUES (58, 1, '127.0.0.1', '2023-06-20 09:09:21', 'success', NULL);
INSERT INTO `user_login` VALUES (60, 1, '127.0.0.1', '2023-06-21 00:52:29', 'success', NULL);
INSERT INTO `user_login` VALUES (61, 1, '127.0.0.1', '2023-06-21 01:09:04', 'success', NULL);
INSERT INTO `user_login` VALUES (62, 1, '127.0.0.1', '2023-06-21 02:27:45', 'success', NULL);
INSERT INTO `user_login` VALUES (63, 1, '127.0.0.1', '2023-06-21 02:45:52', 'success', NULL);
INSERT INTO `user_login` VALUES (64, 1, '127.0.0.1', '2023-06-21 02:53:07', 'success', NULL);
INSERT INTO `user_login` VALUES (65, 1, '127.0.0.1', '2023-06-21 02:55:50', 'success', NULL);
INSERT INTO `user_login` VALUES (66, 1, '127.0.0.1', '2023-06-21 03:10:28', 'success', NULL);
INSERT INTO `user_login` VALUES (67, 1, '127.0.0.1', '2023-06-21 03:17:55', 'success', NULL);
INSERT INTO `user_login` VALUES (68, 1, '127.0.0.1', '2023-06-21 03:22:42', 'no user', NULL);
INSERT INTO `user_login` VALUES (69, 1, '127.0.0.1', '2023-06-21 03:43:56', 'success', NULL);
INSERT INTO `user_login` VALUES (70, 1, '127.0.0.1', '2023-06-21 05:03:33', 'success', NULL);
INSERT INTO `user_login` VALUES (71, 1, '127.0.0.1', '2023-06-21 05:31:56', 'success', NULL);
INSERT INTO `user_login` VALUES (72, 1, '127.0.0.1', '2023-06-21 05:45:39', 'success', NULL);
INSERT INTO `user_login` VALUES (73, 1, '127.0.0.1', '2023-06-21 05:52:32', 'success', NULL);
INSERT INTO `user_login` VALUES (74, 1, '127.0.0.1', '2023-06-21 08:42:36', 'success', NULL);
INSERT INTO `user_login` VALUES (75, 1, '127.0.0.1', '2023-06-22 00:22:34', 'no user', NULL);
INSERT INTO `user_login` VALUES (76, 1, '127.0.0.1', '2023-06-22 00:24:48', 'success', NULL);
INSERT INTO `user_login` VALUES (77, 1, '127.0.0.1', '2023-06-22 00:25:17', 'success', NULL);
INSERT INTO `user_login` VALUES (78, 1, '127.0.0.1', '2023-06-26 00:53:12', 'success', NULL);
INSERT INTO `user_login` VALUES (79, 1, '127.0.0.1', '2023-06-26 01:04:42', 'success', NULL);
INSERT INTO `user_login` VALUES (80, 1, '127.0.0.1', '2023-06-26 01:06:37', 'success', NULL);
INSERT INTO `user_login` VALUES (81, 1, '127.0.0.1', '2023-06-26 02:47:55', 'success', NULL);
INSERT INTO `user_login` VALUES (82, 1, '127.0.0.1', '2023-06-26 02:53:22', 'success', NULL);
INSERT INTO `user_login` VALUES (83, 1, '127.0.0.1', '2023-06-26 05:53:35', 'success', NULL);
INSERT INTO `user_login` VALUES (84, 1, '127.0.0.1', '2023-06-26 06:09:26', 'success', NULL);
INSERT INTO `user_login` VALUES (85, 1, '127.0.0.1', '2023-06-26 06:34:09', 'success', NULL);
INSERT INTO `user_login` VALUES (86, 1, '127.0.0.1', '2023-06-26 06:59:51', 'success', NULL);
INSERT INTO `user_login` VALUES (87, 1, '127.0.0.1', '2023-06-26 07:11:52', 'success', NULL);
INSERT INTO `user_login` VALUES (88, 1, '127.0.0.1', '2023-06-26 07:28:04', 'success', NULL);
INSERT INTO `user_login` VALUES (89, 1, '127.0.0.1', '2023-06-26 08:19:49', 'success', NULL);
INSERT INTO `user_login` VALUES (90, 1, '127.0.0.1', '2023-06-26 08:37:45', 'success', NULL);
INSERT INTO `user_login` VALUES (91, 1, '127.0.0.1', '2023-06-27 00:54:08', 'success', '8fe8b8ca2b506e52f7b814ad9f954b8eba53c2e07a2ba0846fc21d6c1629e9ca');
INSERT INTO `user_login` VALUES (92, 1, '127.0.0.1', '2023-06-27 03:39:01', 'success', 'c79c5f09a2f8b2c8574fd18162ba1873c7cb70ae73d746298bb3ade185eff035');
INSERT INTO `user_login` VALUES (93, 1, '127.0.0.1', '2023-06-27 05:18:30', 'success', '3e959b5b36c0eabccf71bca6165b3782bba254c28af2026f0e8f9e674bda76a8');
INSERT INTO `user_login` VALUES (94, 65789, '', '2023-06-30 06:10:20', '', 'admin');
INSERT INTO `user_login` VALUES (95, 1, '127.0.0.1', '2023-06-30 06:17:18', 'success', '260aa62ed89b7ba066feb31fb39209eb6a68add14d5ddac83141923568fddc38');
INSERT INTO `user_login` VALUES (98, 1, '127.0.0.1', '2023-06-30 07:18:19', 'success', '7fb634e9a3c169fb01e89df401e268515269884de5aea04d72defe0ec37a99b4');
INSERT INTO `user_login` VALUES (99, 1, '127.0.0.1', '2023-06-30 08:40:58', 'success', '236bb17c83722758545c3bb7874ca2baa7298df23c4cd73ed49f63906fd1a089');
INSERT INTO `user_login` VALUES (101, 1, '127.0.0.1', '2023-07-01 01:49:46', 'success', 'eb5524167acff38b9dc3c48efd9e4e69db92fdc999d099026246b31778d2b491');
INSERT INTO `user_login` VALUES (102, 1, '127.0.0.1', '2023-07-01 03:44:09', 'success', '0b0408155fc2a55d9b888c17eddc098134f596a44a7a7b884b1ce717ffe7a1a6');
INSERT INTO `user_login` VALUES (103, 1, '127.0.0.1', '2023-07-01 13:23:09', 'success', '0b6ad6356cc68dbbe54099da733e547f6f84a4f4459c03881c31783126fc9e5c');
INSERT INTO `user_login` VALUES (104, 1, '127.0.0.1', '2023-07-02 00:41:00', 'success', 'a06be48dbba058eefd42430bdb7554635df824a7541c6384b4d29392ebd5b4cc');
INSERT INTO `user_login` VALUES (105, 1, '127.0.0.1', '2023-07-02 10:24:43', 'success', '72fefc0c1efa25d7630b112719af5dc7d070ab3d83e1a2f3954ceeb804a419a7');
INSERT INTO `user_login` VALUES (106, 1, '127.0.0.1', '2023-07-03 00:06:24', 'success', 'ea45cbfa5bf9bdaedce6197dcd75d4ee1ae321da0b8eb1f7446ebca5ad59f132');
INSERT INTO `user_login` VALUES (107, 1, '127.0.0.1', '2023-07-03 03:02:41', 'success', 'a8dc10b5f85c4f9e85d0adb4d530e1f6b6ee618f7174d47b4eda669baf13b0b7');
INSERT INTO `user_login` VALUES (108, 1, '127.0.0.1', '2023-07-03 05:10:18', 'success', '5462249dea537fd80d00da0e1c0896dbe171331c7f2f84797a5677585791e97e');
INSERT INTO `user_login` VALUES (109, 1, '127.0.0.1', '2023-07-03 07:45:07', 'success', 'b325694bbfb6ca3b7d3e6bf69ace700384abd0494f36ce86de2e014fe3a3ce52');
INSERT INTO `user_login` VALUES (110, 1, '127.0.0.1', '2023-07-03 08:56:35', 'success', '51ceca2c4baca5cf6d71209a560871148f073e154ff5652a7dbb6fe0f8e9eae3');
INSERT INTO `user_login` VALUES (111, 1, '127.0.0.1', '2023-07-04 05:17:09', 'success', '572d46656ae602c31e3b287bc2a375e7bad2400a3553ed70b3ae383bb9d9fcb5');
INSERT INTO `user_login` VALUES (112, 1, '127.0.0.1', '2023-07-04 06:22:31', 'success', '1457484c84e2e3d310401d0666efdae6e3adb3912b13ab47a44c12872d3816b4');
INSERT INTO `user_login` VALUES (113, 1, '127.0.0.1', '2023-07-04 07:23:19', 'success', '73b1e430df0738d4c3500f94a8342d4f060e42253e1d9688904cad46375b8fea');

-- ----------------------------
-- Table structure for user_role
-- ----------------------------
DROP TABLE IF EXISTS `user_role`;
CREATE TABLE `user_role`  (
  `user_id` int NOT NULL,
  `role_id` int NOT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_role
-- ----------------------------
INSERT INTO `user_role` VALUES (1, 1);

SET FOREIGN_KEY_CHECKS = 1;
