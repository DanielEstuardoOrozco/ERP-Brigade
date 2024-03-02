--Dumb base datos
CREATE DATABASE `Development` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;


CREATE TABLE `DIM_DATE` (
  `SK_DATE` int NOT NULL AUTO_INCREMENT,
  `ID_DATE` int NOT NULL,
  `FRECUENCY` int NOT NULL,
  `YEAR` int NOT NULL,
  `DATE` date NOT NULL,
  `DATETIME` datetime NOT NULL,
  PRIMARY KEY (`SK_DATE`)
) ENGINE=InnoDB AUTO_INCREMENT=732 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `FACT_CONDITION` (
  `SK_CONDITION` int NOT NULL AUTO_INCREMENT,
  `ID_USER` int NOT NULL,
  `ID_DATE` int NOT NULL,
  `RECORD` decimal(10,2) DEFAULT NULL,
  `RUN` decimal(10,2) DEFAULT NULL,
  `HEART_RATE` decimal(10,2) DEFAULT NULL,
  `STRESS_LEVEL` decimal(10,2) DEFAULT NULL,
  `STEPS` decimal(10,2) DEFAULT NULL,
  `FLOORS` decimal(10,2) DEFAULT NULL,
  `CALORIES` decimal(10,2) DEFAULT NULL,
  `SLEEP_SCORE_AVG` decimal(10,2) DEFAULT NULL,
  `SLEEP_SCORE_TIME` decimal(10,2) DEFAULT NULL,
  `RESPIRATION` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`SK_CONDITION`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `FACT_HEALTH` (
  `SK_HEALTH` int NOT NULL AUTO_INCREMENT,
  `ID_USER` int NOT NULL,
  `ID_DATE` int NOT NULL,
  `WEIGHT` decimal(10,2) DEFAULT NULL,
  `SUBCUTANEOUS_FAT` decimal(10,2) DEFAULT NULL,
  `VICERAL_FAT` decimal(10,2) DEFAULT NULL,
  `BODY_WATER` decimal(10,2) DEFAULT NULL,
  `SKELETAL_MUSCLE` decimal(10,2) DEFAULT NULL,
  `MUSCLE_MASS` decimal(10,2) DEFAULT NULL,
  `BONE_MASS` decimal(10,2) DEFAULT NULL,
  `PROTEIN` decimal(10,2) DEFAULT NULL,
  `BMR` decimal(10,2) DEFAULT NULL,
  `METABOLIC_AGE` int DEFAULT NULL,
  PRIMARY KEY (`SK_HEALTH`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `FACT_SLEEP` (
  `SK_SLEEP` int NOT NULL AUTO_INCREMENT,
  `ID_USER` int NOT NULL,
  `ID_DATE` int NOT NULL,
  `AVG_SCORE` decimal(10,2) DEFAULT NULL,
  `AVG_RESTING_HEART_RATE` decimal(10,2) DEFAULT NULL,
  `AVG_BODY_BATTERY_CHANGE` decimal(10,2) DEFAULT NULL,
  `AVG_SPO2` decimal(10,2) DEFAULT NULL,
  `AVG_RESPIRATION` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`SK_SLEEP`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `Roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role_name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `role_name` (`role_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `scans` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `data` text,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `scans_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `Tbl_Condition` (
  `ID_Condition` int NOT NULL AUTO_INCREMENT,
  `ID_User` varchar(10) DEFAULT NULL,
  `Last_Modification_Date` date DEFAULT NULL,
  `Update_Date` date DEFAULT NULL,
  `Delete_Date` date DEFAULT NULL,
  `Active` bit(1) DEFAULT NULL,
  `Record` varchar(100) DEFAULT NULL,
  `Run` varchar(100) DEFAULT NULL,
  `Heart_Rate` varchar(100) DEFAULT NULL,
  `Stress_Level` varchar(100) DEFAULT NULL,
  `Steps` varchar(100) DEFAULT NULL,
  `Floors` varchar(100) DEFAULT NULL,
  `Calories` varchar(100) DEFAULT NULL,
  `Sleep_Score` varchar(100) DEFAULT NULL,
  `Respiration` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ID_Condition`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `Tbl_Diet` (
  `ID_Diet` int NOT NULL AUTO_INCREMENT,
  `ID_User` int DEFAULT NULL,
  `Last_Modification_Date` date DEFAULT NULL,
  `Update_Date` date DEFAULT NULL,
  `Delete_Date` date DEFAULT NULL,
  `Active` bit(1) DEFAULT NULL,
  PRIMARY KEY (`ID_Diet`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `Tbl_Equipment` (
  `ID_Equipment` int NOT NULL AUTO_INCREMENT,
  `ID_User` int DEFAULT NULL,
  `Last_Modification_Date` date DEFAULT NULL,
  `Update_Date` date DEFAULT NULL,
  `Delete_Date` date DEFAULT NULL,
  `Active` bit(1) DEFAULT NULL,
  PRIMARY KEY (`ID_Equipment`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `Tbl_Health` (
  `ID_Healt` int NOT NULL AUTO_INCREMENT,
  `ID_User` varchar(10) DEFAULT NULL,
  `Last_Modification_Date` date DEFAULT NULL,
  `Update_Date` date DEFAULT NULL,
  `Delete_Date` date DEFAULT NULL,
  `Active` bit(1) DEFAULT NULL,
  `Weight` double DEFAULT NULL,
  `Subcutaneous_Fat` double DEFAULT NULL,
  `Vicelar_Fat` double DEFAULT NULL,
  `Body_Water` double DEFAULT NULL,
  `Skeletal_Muscle` double DEFAULT NULL,
  `Muscle_Mass` double DEFAULT NULL,
  `Bone_Mass` double DEFAULT NULL,
  `Protein` double DEFAULT NULL,
  `BMR` double DEFAULT NULL,
  `Metabolic_Age` double DEFAULT NULL,
  PRIMARY KEY (`ID_Healt`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `Tbl_Profile` (
  `ID_Profile` int NOT NULL AUTO_INCREMENT,
  `ID_User` int DEFAULT NULL,
  `Last_Modification_Date` date DEFAULT NULL,
  `Update_Date` date DEFAULT NULL,
  `Delete_Date` date DEFAULT NULL,
  `Active` bit(1) DEFAULT NULL,
  `ID_Health` int DEFAULT NULL,
  `ID_Condition` int DEFAULT NULL,
  `ID_Sleep` int DEFAULT NULL,
  `ID_Assignment` int DEFAULT NULL,
  `ID_Diet` int DEFAULT NULL,
  `ID_Role` int DEFAULT NULL,
  `ID_Schedule` varchar(45) DEFAULT NULL,
  `Overall_Performance` double DEFAULT NULL,
  `First_Name` varchar(50) DEFAULT NULL,
  `Second_Name` varchar(50) DEFAULT NULL,
  `Last_Name` varchar(100) DEFAULT NULL,
  `Status` varchar(45) DEFAULT NULL,
  `Picture` blob,
  PRIMARY KEY (`ID_Profile`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `Tbl_Sleep` (
  `ID_Sleep` int NOT NULL AUTO_INCREMENT,
  `ID_User` varchar(10) DEFAULT NULL,
  `Last_Modification_Date` date DEFAULT NULL,
  `Update_Date` date DEFAULT NULL,
  `Delete_Date` date DEFAULT NULL,
  `Active` bit(1) DEFAULT NULL,
  `Avg_Score` varchar(100) DEFAULT NULL,
  `Avg_Resting_Heart_Rate` varchar(100) DEFAULT NULL,
  `Avg_Body_Battery_Change` varchar(100) DEFAULT NULL,
  `Avg_SPO2` varchar(100) DEFAULT NULL,
  `Avg_Respiration` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ID_Sleep`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `Tbl_Users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(100) DEFAULT NULL,
  `second_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `weight` decimal(5,2) DEFAULT NULL,
  `weight_unit` enum('kg','lbs') DEFAULT NULL,
  `height` decimal(5,2) DEFAULT NULL,
  `height_unit` enum('cm','inches') DEFAULT NULL,
  `physical_condition_scale` int DEFAULT NULL,
  `sleep_hours_per_day` decimal(3,1) DEFAULT NULL,
  `overall_exercise_per_week` decimal(3,1) DEFAULT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `Active` int DEFAULT NULL,
  `Picture` blob,
  `Picture_URL` varchar(500) DEFAULT NULL,
  `username` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `UserRoles` (
  `user_id` int NOT NULL,
  `role_id` int NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `userroles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `userroles_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `Roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
