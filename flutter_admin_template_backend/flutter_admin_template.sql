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

 Date: 12/08/2023 21:38:46
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
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

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
INSERT INTO `api` VALUES (17, '根据roleid修改role', '/system/role/update', 'post', '2023-07-06 13:03:48', '2023-08-08 15:23:00', 0, NULL);
INSERT INTO `api` VALUES (18, '获取部门树', '/system/dept/tree', 'get', '2023-08-08 15:22:57', '2023-08-08 15:34:36', 0, NULL);
INSERT INTO `api` VALUES (19, '根据部门id获取部门详情', '/system/dept/query', 'get', '2023-08-09 14:46:38', '2023-08-09 14:46:38', 0, NULL);
INSERT INTO `api` VALUES (20, '获取不包含id的部门树', '/system/dept/tree/without', 'get', '2023-08-09 14:54:39', '2023-08-09 14:54:39', 0, NULL);
INSERT INTO `api` VALUES (21, '创建新部门', '/system/dept/new', 'post', '2023-08-09 14:59:12', '2023-08-09 14:59:12', 0, NULL);
INSERT INTO `api` VALUES (22, '更新部门', '/system/dept/update', 'post', '2023-08-09 15:01:08', '2023-08-09 15:01:08', 0, NULL);

-- ----------------------------
-- Table structure for department
-- ----------------------------
DROP TABLE IF EXISTS `department`;
CREATE TABLE `department`  (
  `dept_id` int NOT NULL AUTO_INCREMENT,
  `parent_id` int NOT NULL DEFAULT 0,
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `order_number` int NULL DEFAULT 0,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) NULL DEFAULT 0,
  `remark` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of department
-- ----------------------------
INSERT INTO `department` VALUES (1, 0, '总部', 0, '2023-08-07 15:25:48', '2023-08-07 15:25:48', 0, NULL);
INSERT INTO `department` VALUES (2, 1, 'sub-1-1', 0, '2023-08-07 18:49:58', '2023-08-07 18:49:58', 0, NULL);
INSERT INTO `department` VALUES (3, 2, 'sub-2-1', 2, '2023-08-07 18:50:07', '2023-08-09 14:11:46', 0, NULL);
INSERT INTO `department` VALUES (4, 2, 'sub-2-2', 0, '2023-08-07 18:50:21', '2023-08-07 18:50:21', 0, NULL);
INSERT INTO `department` VALUES (5, 1, 'sub-1-1-1-1', 1, '2023-08-09 02:31:56', '2023-08-09 02:31:56', 0, '');

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role`  (
  `role_id` int NOT NULL AUTO_INCREMENT,
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `create_by` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'admin' COMMENT '创建者',
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
INSERT INTO `role_api` VALUES (1, 17);
INSERT INTO `role_api` VALUES (1, 1);
INSERT INTO `role_api` VALUES (1, 18);
INSERT INTO `role_api` VALUES (1, 19);
INSERT INTO `role_api` VALUES (1, 20);
INSERT INTO `role_api` VALUES (1, 21);
INSERT INTO `role_api` VALUES (1, 22);

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
INSERT INTO `role_router` VALUES (1, -1);

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
  `create_by` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'admin',
  `parent_id` int NOT NULL DEFAULT 0,
  PRIMARY KEY (`router_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of router
-- ----------------------------
INSERT INTO `router` VALUES (1, '登录', '/loginScreen', '2023-06-29 16:18:46', '2023-08-12 21:36:21', 0, '登录', 'admin', 0);
INSERT INTO `router` VALUES (2, 'dashboard', '/main/dashboard', '2023-06-29 16:19:19', '2023-08-12 21:36:22', 0, NULL, 'admin', 0);
INSERT INTO `router` VALUES (3, 'user', '/main/user', '2023-06-29 16:20:11', '2023-08-12 21:36:23', 0, NULL, 'admin', 0);
INSERT INTO `router` VALUES (4, 'menu', '/main/menu', '2023-06-29 16:20:26', '2023-08-12 21:36:23', 0, NULL, 'admin', 0);
INSERT INTO `router` VALUES (5, 'department', '/main/dept', '2023-06-29 16:20:40', '2023-08-12 21:36:24', 0, NULL, 'admin', 0);
INSERT INTO `router` VALUES (6, 'logs', '/main/logs', '2023-06-29 16:20:53', '2023-08-12 21:36:24', 0, NULL, 'admin', 0);
INSERT INTO `router` VALUES (7, 'operation', '/main/logs/operation', '2023-06-29 16:21:11', '2023-08-12 21:36:25', 0, NULL, 'admin', 6);
INSERT INTO `router` VALUES (8, 'signin', '/main/logs/signin', '2023-06-29 16:21:31', '2023-08-12 21:36:25', 0, NULL, 'admin', 6);
INSERT INTO `router` VALUES (9, 'role', '/main/role', '2023-07-01 10:38:12', '2023-08-12 21:36:27', 0, NULL, 'admin', 0);

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
INSERT INTO `router_api` VALUES (9, 17);
INSERT INTO `router_api` VALUES (5, 18);
INSERT INTO `router_api` VALUES (5, 19);
INSERT INTO `router_api` VALUES (5, 20);
INSERT INTO `router_api` VALUES (5, 21);
INSERT INTO `router_api` VALUES (5, 22);

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `user_id` int NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `dept_id` int NULL DEFAULT 1 COMMENT '(可为空)部门id',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码',
  `create_by` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'admin' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) NULL DEFAULT 0,
  `remark` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 1, 'admin', '123456', 'admin', '2023-06-13 02:08:38', '2023-08-12 21:37:55', 0, 'this is admin');
INSERT INTO `user` VALUES (2, 1, 'test', '123456', 'admin', '2023-06-13 03:32:35', '2023-08-12 21:37:55', 0, 'in officia');

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
) ENGINE = InnoDB AUTO_INCREMENT = 158 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

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
