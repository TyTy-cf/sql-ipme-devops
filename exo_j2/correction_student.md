
### Script de création de la base de données students 2.0

```sql
DROP DATABASE IF EXISTS db_school;

CREATE DATABASE db_school DEFAULT CHARACTER SET = utf8;

USE db_school;

CREATE TABLE IF NOT EXISTS city (
	id INT(8) NOT NULL AUTO_INCREMENT,
	name VARCHAR(255) NOT NULL,
	postal_code VARCHAR(5) NOT NULL,
	PRIMARY KEY (id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS address (
	id INT(8) NOT NULL AUTO_INCREMENT,
	city_id INT(8) NOT NULL,
	location VARCHAR(255) NOT NULL,
	additionnal VARCHAR(255) DEFAULT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (city_id) REFERENCES city(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS campus (
	id INT(8) NOT NULL AUTO_INCREMENT,
	address_id INT(8) NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (address_id) REFERENCES address(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS campus (
	id INT(8) NOT NULL AUTO_INCREMENT,
	address_id INT(8) NOT NULL,
	label VARCHAR(255) NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (address_id) REFERENCES address(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `class` (
	id INT(8) NOT NULL AUTO_INCREMENT,
	campus_id INT(8) NOT NULL,
	name VARCHAR(80) NOT NULL,
	description TEXT DEFAULT NULL,
	begin_year INT(4) NOT NULL,
	end_year INT(4) NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (campus_id) REFERENCES campus(id)
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS `student` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `class_id` int(8) NOT NULL,
  address_id INT(8) NOT NULL,
  `last_name` varchar(64) NOT NULL,
  `first_name` varchar(64) NOT NULL,
  `email` varchar(255) NOT NULL UNIQUE,
  `password` varchar(255) NOT NULL,
  `birth_date` date NOT NULL,
  `phone` varchar(12) DEFAULT NULL,
  `gender` enum('H','F','A') DEFAULT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (class_id) REFERENCES `class`(id),
  FOREIGN KEY (address_id) REFERENCES `address`(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS subject (
	id INT(8) NOT NULL AUTO_INCREMENT,
	label varchar(80) NOT NULL,
	PRIMARY KEY (id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `rank` (
	id INT(8) NOT NULL AUTO_INCREMENT,
	student_id INT(8) NOT NULL,
	subject_id INT(8) NOT NULL,
	`value` float NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (student_id) REFERENCES student(id),
	FOREIGN KEY (subject_id) REFERENCES subject(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS student_attend_subject (
	id INT(8) NOT NULL AUTO_INCREMENT,
	student_id INT(8) NOT NULL,
	subject_id INT(8) NOT NULL,
	begin_date DATETIME NOT NULL,
	end_date DATETIME NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (student_id) REFERENCES student(id),
	FOREIGN KEY (subject_id) REFERENCES subject(id)
) ENGINE=InnoDB;
```