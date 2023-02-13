-- phpMyAdmin SQL Dump
-- version 4.9.2
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 14-02-2023 a las 00:44:28
-- Versión del servidor: 10.4.10-MariaDB
-- Versión de PHP: 7.1.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `test`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `cursor_test1` ()  READS SQL DATA
BEGIN 
DECLARE var1 INT;
DECLARE var2 INT;
DECLARE var3 VARCHAR(255);
DECLARE done INT DEFAULT 0;
DECLARE cursor1 CURSOR FOR (SELECT salary, departmentid, name FROM turing_employee);
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
OPEN cursor1;
simple_loop:LOOP
FETCH cursor1 INTO var1, var2, var3;
IF done = 1 THEN
LEAVE simple_loop;
END IF;
SELECT var1, var2, var3;
END LOOP simple_loop;
CLOSE cursor1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `customer_sales` (IN `customer_id` VARCHAR(255))  BEGIN
DECLARE total_sales NUMERIC(8,2);
SELECT SUM(ord_amount) INTO total_sales FROM orders WHERE cust_code = customer_id;
SELECT CONCAT("total for: ", customer_id, " is: ", total_sales);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `dep_sal_perc` ()  BEGIN
DECLARE done INT DEFAULT 0;
DECLARE var1 INT;
DECLARE dep CURSOR FOR (SELECT department_id FROM employees GROUP BY department_id);
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
OPEN dep;
simple_loop:LOOP
FETCH dep INTO var1;
IF done = 1 THEN
LEAVE simple_loop;
ELSE
SELECT (((SELECT AVG(e.salary) FROM employees e WHERE department_id = var1)/(SELECT SUM(t.avg) FROM (SELECT AVG(e.salary) AS "avg" FROM employees e GROUP BY e.department_id) AS t)) * 100) AS "percentage", var1, d.department_name FROM departments d WHERE d.department_id = var1;
END IF;
END LOOP simple_loop;
CLOSE dep;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `discounted_price` (`normal_price` NUMERIC(8,2), OUT `discount_price` NUMERIC(8,2))  BEGIN
	IF (normal_price > 500) THEN
		SET discount_price = (normal_price * .8);
	ELSEIF (normal_price > 100) THEN
		SET discount_price = (normal_price * .9);
	ELSE
		SET discount_price = normal_price;
	END IF;
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getTop` ()  BEGIN
DECLARE iter INT DEFAULT 0;
WHILE iter <= (SELECT MAX(id) FROM turing_department) DO
CALL getTopThreeSal(iter);
SET iter = iter + 1;
END WHILE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getTopThreeSal` (IN `id` INT)  BEGIN
SELECT a.salary, b.name FROM turing_employee a JOIN turing_department b ON a.departmentid = b.id WHERE a.departmentid = id ORDER BY salary DESC LIMIT 3;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getTopThreeSalaries` ()  BEGIN
DECLARE iter INT DEFAULT 0;
WHILE iter <= (SELECT MAX(id) FROM turing_department) DO
CALL topSal2(iter);
SET iter = iter + 1;
END WHILE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getTopThreeSalaries2` ()  BEGIN
DECLARE iter INT DEFAULT 0;
WHILE iter <= (SELECT MAX(id) FROM turing_department) DO
(SELECT a.salary, b.name FROM turing_employee a JOIN turing_department b ON a.departmentid = b.id WHERE a.departmentid = iter
 ORDER BY a.salary DESC LIMIT 3);
SET iter = iter + 1;
END WHILE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getTopThreeSalaries3` ()  BEGIN
DECLARE iter INT DEFAULT 0;
WHILE iter <= (SELECT MAX(id) FROM turing_department) DO
SELECT a.salary, b.name FROM turing_employee a JOIN turing_department b ON a.departmentid = b.id WHERE a.departmentid = iter
 ORDER BY a.salary DESC LIMIT 3;
SET iter = iter + 1;
END WHILE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `leave_test` ()  BEGIN
	DECLARE counter INT DEFAULT 0;
	
	my_simple_loop: LOOP
		SET counter = counter + 1;
		IF counter  > 0 THEN
			LEAVE my_simple_loop;
		END IF;
	END LOOP my_simple_loop;
	
	SELECT counter;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `my_sqrt` (IN `ival` INT, OUT `oval` FLOAT, INOUT `by_ten` INT)  BEGIN SET oval = SQRT(ival);
SET by_ten = by_ten * (ival * 10);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `nested_loops_test` ()  BEGIN
	DECLARE i,j INT DEFAULT 1;
		outer_loop: LOOP
			SET j=1;
				inner_loop: LOOP
					SELECT concat(i," times ", j," is ",i*j);
					SET j=j+1;
					IF j>3 THEN
						LEAVE inner_loop;
					END IF;
				END LOOP inner_loop;
			SET i=i+1;
			IF i>3 THEN
				LEAVE outer_loop;
				END IF;
		END LOOP outer_loop;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `nested_procedure` (IN `square_n` INT, OUT `result` NUMERIC(8,2))  NO SQL
BEGIN
		DECLARE factor INT;
		SET factor = 10;
		
		CALL my_sqrt(square_n, @res, factor);
		
		SET result = @res;
	END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `new_salary` (IN `emp_id` INT, IN `new_salary` INT)  BEGIN
	IF new_salary < 5000 OR new_salary > 500000 THEN
		SELECT "error new salary must be on 5000 500K range";
	ELSE
		UPDATE employees SET salary = new_salary WHERE employee_id = emp_id;
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `new_salary_cursor` (IN `emp_id` INT, OUT `new_salary` NUMERIC(8,2))  READS SQL DATA
BEGIN
SET new_salary = (SELECT (salary * 1.15) FROM turing_employee WHERE id = emp_id);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `repeat_until_test` ()  BEGIN
	DECLARE i INT;
	SET i=0;
	loop1: REPEAT
		SET i=i+1;
		IF MOD(i,2)<>0 THEN 
			Select concat(i," is an odd number");
		END IF;
		UNTIL i >= 10
	END REPEAT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `set_income_percentage` ()  MODIFIES SQL DATA
BEGIN
UPDATE turing_employee SET income_percentage = (salary/(SELECT SUM(salary) FROM turing_employee) * 100);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `simple_loop` ()  BEGIN
	DECLARE counter INT DEFAULT 0;
	
	my_simple_loop: LOOP
		SET counter = counter + 1;
		IF counter = 10 THEN
			LEAVE my_simple_loop;
		END IF;
	END LOOP my_simple_loop;
	
	SELECT "I counted to ten yay ;D";
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `test_iterate` ()  BEGIN
DECLARE i INT;
SET i=0;
	loop1: LOOP
	SET i=i+1;
	IF i>=10 THEN 
		LEAVE loop1;
	ELSEIF MOD(i,2) = 0 THEN 
		ITERATE loop1;
	END IF;
SELECT CONCAT(i," is an odd number");
END LOOP loop1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `test_iterate2` ()  BEGIN
DECLARE i INT;
SET i=0;
	loop1: LOOP
	SET i=i+1;
	IF i>0 THEN 
		LEAVE loop1;
	END IF;
END LOOP loop1;
SELECT i;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `tfer_funds` (`from_account` INT, `to_account` INT, `tfer_amount` NUMERIC(10,2))  BEGIN
SET AUTOCOMMIT = 0;
START TRANSACTION;
UPDATE account SET balance = balance - tfer_amount WHERE user_id = from_account;
UPDATE account SET balance = balance + tfer_amount WHERE user_id = to_account;
COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `topSal2` (IN `id` INT)  BEGIN
SELECT a.salary, b.name FROM turing_employee a JOIN turing_department b ON a.departmentid = b.id WHERE a.departmentid = id ORDER BY a.salary DESC LIMIT 3;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `trig_sal_proc` ()  BEGIN
DECLARE i INT DEFAULT 18;
DECLARE json_sales JSON DEFAULT (SELECT obj FROM json_test_id WHERE id = 10);
loop1: WHILE i < JSON_LENGTH(JSON_EXTRACT(json_sales, '$.sales')) DO
INSERT INTO trig_sales VALUES (i, JSON_EXTRACT(json_sales, CONCAT('$.sales[',i,'].vendor_id.id')), JSON_EXTRACT(json_sales, CONCAT('$.sales[',i,'].product_name')), JSON_EXTRACT(json_sales, CONCAT('$.sales[',i,'].sale_amt')));
SET i = i + 1;
END WHILE loop1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `variable_demo` ()  BEGIN
DECLARE my_integer INT; 
DECLARE my_big_integer BIGINT; 
DECLARE my_currency NUMERIC(8,2); 
DECLARE my_float FLOAT DEFAULT 3.1416; 
DECLARE my_text TEXT; 
DECLARE my_dob DATE DEFAULT "1957-04-20"; 
DECLARE my_varchar VARCHAR(30) DEFAULT "Hi Universe"; 
SET my_integer = 20;
SET my_big_integer = POWER(my_integer, 3);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `while_test` ()  BEGIN
	DECLARE i INT;
	SET i=1;
	loop1: WHILE i = 0 DO
			SELECT "loop yay";
	END WHILE loop1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `while_test2` ()  BEGIN
	DECLARE i INT;
	SET i=1;
	loop1: WHILE i < 10 DO
			SELECT CONCAT(i,"loop yay");
			SET i = i + 2;
	END WHILE loop1;
END$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `getNthHighestSalary` (`off` INT) RETURNS INT(11) BEGIN
DECLARE offs INT;
DECLARE result INT;
SET offs = (off - 1);
SET result = (SELECT salary FROM turing_test ORDER BY salary DESC LIMIT 1 OFFSET offs);
RETURN result;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `account`
--

CREATE TABLE `account` (
  `user_id` int(11) DEFAULT NULL,
  `balance` decimal(10,3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `account`
--

INSERT INTO `account` (`user_id`, `balance`) VALUES
(7387438, '2000.000'),
(123456, '39000.000');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `agents`
--

CREATE TABLE `agents` (
  `agent_code` varchar(255) DEFAULT NULL,
  `agent_name` varchar(255) DEFAULT NULL,
  `working_area` varchar(255) DEFAULT NULL,
  `comission` decimal(3,2) DEFAULT NULL,
  `phone_no` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `agents`
--

INSERT INTO `agents` (`agent_code`, `agent_name`, `working_area`, `comission`, `phone_no`, `country`) VALUES
('A007', 'Ramasundar', 'Bangalore', '0.15', '077-25814763', NULL),
('A003', 'Alex', 'London', '0.13', '075-12458969', NULL),
('A008', 'Alford', 'New York', '0.12', '044-25874365', NULL),
('A011', 'Ravi Kumar', 'Bangalore', '0.15', '077-45625874', NULL),
('A010', 'Santakumar', 'Chennai', '0.14', '007-22388644', NULL),
('A012', 'Lucida', 'San Jose', '0.12', '044-52981425', NULL),
('A005', 'Anderson', 'Brisban', '0.13', '045-21447739', NULL),
('A001', 'Subbarao', 'Bangalore', '0.14', '077-12346674', NULL),
('A002', 'Mukesh', 'Mumbai', '0.11', '029-12358964', NULL),
('A006', 'McDen', 'London', '0.15', '078-22255588', NULL),
('A004', 'Ivan', 'Torento', '0.15', '008-22544166', NULL),
('A009', 'Benjamin', 'Hampshair', '0.11', '008-22536178', NULL),
('A007', 'Ramasundar', 'Bangalore', '0.15', '077-25814763', NULL),
('A003', 'Alex', 'London', '0.13', '075-12458969', NULL),
('A008', 'Alford', 'New York', '0.12', '044-25874365', NULL),
('A011', 'Ravi Kumar', 'Bangalore', '0.15', '077-45625874', NULL),
('A010', 'Santakumar', 'Chennai', '0.14', '007-22388644', NULL),
('A012', 'Lucida', 'San Jose', '0.12', '044-52981425', NULL),
('A005', 'Anderson', 'Brisban', '0.13', '045-21447739', NULL),
('A001', 'Subbarao', 'Bangalore', '0.14', '077-12346674', NULL),
('A002', 'Mukesh', 'Mumbai', '0.11', '029-12358964', NULL),
('A006', 'McDen', 'London', '0.15', '078-22255588', NULL),
('A004', 'Ivan', 'Torento', '0.15', '008-22544166', NULL),
('A009', 'Benjamin', 'Hampshair', '0.11', '008-22536178', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `company`
--

CREATE TABLE `company` (
  `company_id` int(11) DEFAULT NULL,
  `company_name` varchar(255) DEFAULT NULL,
  `company_city` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `company`
--

INSERT INTO `company` (`company_id`, `company_name`, `company_city`) VALUES
(18, 'Order All', 'Boston'),
(15, 'Jack Hill Ltd', 'London'),
(16, 'Akas Foods', 'Delhi'),
(17, 'Foodies', 'London'),
(19, 'sip-n-Bite', 'New York'),
(18, 'Order All', 'Boston'),
(15, 'Jack Hill Ltd', 'London'),
(16, 'Akas Foods', 'Delhi'),
(17, 'Foodies', 'London'),
(19, 'sip-n-Bite', 'New York');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contest`
--

CREATE TABLE `contest` (
  `c_id` int(11) DEFAULT NULL,
  `start` date DEFAULT NULL,
  `end` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `contest`
--

INSERT INTO `contest` (`c_id`, `start`, `end`) VALUES
(1, '2015-02-01', '2015-02-04'),
(2, '2015-02-02', '2015-02-05'),
(3, '2015-02-03', '2015-02-07'),
(4, '2015-02-04', '2015-02-06'),
(5, '2015-02-06', '2015-02-09'),
(6, '2015-02-08', '2015-02-10'),
(7, '2015-02-10', '2015-02-11');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `courses`
--

CREATE TABLE `courses` (
  `id` int(11) NOT NULL,
  `name` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `courses`
--

INSERT INTO `courses` (`id`, `name`) VALUES
(2, 'Physics'),
(3, 'Languages'),
(4, 'Special'),
(5, 'Arts');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `courses2`
--

CREATE TABLE `courses2` (
  `id` int(11) NOT NULL,
  `name` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `courses2`
--

INSERT INTO `courses2` (`id`, `name`) VALUES
(1, 'Maths'),
(2, 'Physics'),
(3, 'Languages'),
(4, 'Special'),
(5, 'Arts');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `customer`
--

CREATE TABLE `customer` (
  `cust_code` varchar(255) DEFAULT NULL,
  `cust_name` varchar(255) DEFAULT NULL,
  `cust_city` varchar(255) DEFAULT NULL,
  `working_area` varchar(255) DEFAULT NULL,
  `cust_country` varchar(255) DEFAULT NULL,
  `grade` int(11) DEFAULT NULL,
  `opening_amt` decimal(7,2) DEFAULT NULL,
  `receive_amt` decimal(7,2) DEFAULT NULL,
  `payment_amt` decimal(7,2) DEFAULT NULL,
  `outstanding_amt` decimal(7,2) DEFAULT NULL,
  `phone_no` varchar(255) DEFAULT NULL,
  `agent_code` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `customer`
--

INSERT INTO `customer` (`cust_code`, `cust_name`, `cust_city`, `working_area`, `cust_country`, `grade`, `opening_amt`, `receive_amt`, `payment_amt`, `outstanding_amt`, `phone_no`, `agent_code`) VALUES
('C00013', 'Holmes', 'London', 'London', 'UK', 2, '6000.00', '5000.00', '7000.00', '4000.00', 'BBBBBBB', 'A003'),
('C00001', 'Micheal', 'New York', 'New York', 'USA', 2, '3000.00', '5000.00', '2000.00', '6000.00', 'CCCCCCC', 'A008'),
('C00020', 'Albert', 'New York', 'New York', 'USA', 3, '5000.00', '7000.00', '6000.00', '6000.00', 'BBBBSBB', 'A008'),
('C00025', 'Ravindran', 'Bangalore', 'Bangalore', 'India', 2, '5000.00', '7000.00', '4000.00', '8000.00', 'AVAVAVA', 'A011'),
('C00024', 'Cook', 'London', 'London', 'UK', 2, '4000.00', '9000.00', '7000.00', '6000.00', 'FSDDSDF', 'A006 '),
('C00015', 'Stuart', 'London', 'London', 'UK', 1, '6000.00', '8000.00', '3000.00', '11000.00', 'GFSGERS', 'A003 '),
('C00002', 'Bolt', 'New York', 'New York', 'USA', 3, '5000.00', '7000.00', '9000.00', '3000.00', 'DDNRDRH', 'A008'),
('C00018', 'Fleming', 'Brisban', 'Brisban', 'Australia', 2, '7000.00', '7000.00', '9000.00', '5000.00', 'NHBGVFC', 'A005'),
('C00021', 'Jacks', 'Brisban', 'Brisban', 'Australia', 1, '7000.00', '7000.00', '7000.00', '7000.00', 'WERTGDF', 'A005'),
('C00019', 'Yearannaidu', 'Chennai', 'Chennai', 'India', 1, '8000.00', '7000.00', '7000.00', '8000.00', 'ZZZZBFV', 'A010'),
('C00005', 'Sasikant', 'Mumbai', 'Mumbai', 'India', 1, '7000.00', '11000.00', '7000.00', '11000.00', '147-25896312', 'A002'),
('C00007', 'Ramanathan', 'Chennai', 'Chennai', 'India', 1, '7000.00', '11000.00', '9000.00', '9000.00', 'GHRDWSD', 'A010'),
('C00022', 'Avinash', 'Mumbai', 'Mumbai', 'India', 2, '7000.00', '11000.00', '9000.00', '9000.00', '113-12345678', 'A002'),
('C00004', 'Winston', 'Brisban', 'Brisban', 'Australia', 1, '5000.00', '8000.00', '7000.00', '6000.00', 'AAAAAAA', 'A005'),
('C00023', 'Karl', 'London', 'London', 'UK', 0, '4000.00', '6000.00', '7000.00', '3000.00', 'AAAABAA', 'A006'),
('C00006', 'Shilton', 'Torento', 'Torento', 'Canada', 1, '10000.00', '7000.00', '6000.00', '11000.00', 'DDDDDDD', 'A004'),
('C00010', 'Charles', 'Hampshair', 'Hampshair', 'UK', 3, '6000.00', '4000.00', '5000.00', '5000.00', 'MMMMMMM', 'A009'),
('C00017', 'Srinivas', 'Bangalore', 'Bangalore', 'India', 2, '8000.00', '4000.00', '3000.00', '9000.00', 'AAAAAAB ', 'A007'),
('C00012', 'Steven', 'San Jose', 'San Jose', 'USA', 1, '5000.00', '7000.00', '9000.00', '3000.00', 'KRFYGJK', 'A012'),
('C00008', 'Karolina', 'Torento', 'Torento', 'Canada', 1, '7000.00', '7000.00', '9000.00', '5000.00', 'HJKORED', 'A004'),
('C00003', 'Martin', 'Torento', 'Torento', 'Canada', 2, '8000.00', '7000.00', '7000.00', '8000.00', 'MJYURFD', 'A004'),
('C00009', 'Ramesh', 'Mumbai', 'Mumbai', 'India', 3, '8000.00', '7000.00', '3000.00', '12000.00', 'Phone No', 'A002'),
('C00014', 'Rangarappa', 'Bangalore', 'Bangalore', 'India', 2, '8000.00', '11000.00', '7000.00', '12000.00', 'AAAATGF', 'A001'),
('C00016', 'Venkatpati', 'Bangalore', 'Bangalore', 'India', 2, '8000.00', '11000.00', '7000.00', '12000.00', 'JRTVFDD', 'A007'),
('C00011', 'Sundariya', 'Chennai', 'Chennai', 'India', 3, '7000.00', '11000.00', '7000.00', '11000.00', 'PPHGRTS', 'A010'),
('C00013', 'Holmes', 'London', 'London', 'UK', 2, '6000.00', '5000.00', '7000.00', '4000.00', 'BBBBBBB', 'A003'),
('C00001', 'Micheal', 'New York', 'New York', 'USA', 2, '3000.00', '5000.00', '2000.00', '6000.00', 'CCCCCCC', 'A008'),
('C00020', 'Albert', 'New York', 'New York', 'USA', 3, '5000.00', '7000.00', '6000.00', '6000.00', 'BBBBSBB', 'A008'),
('C00025', 'Ravindran', 'Bangalore', 'Bangalore', 'India', 2, '5000.00', '7000.00', '4000.00', '8000.00', 'AVAVAVA', 'A011'),
('C00024', 'Cook', 'London', 'London', 'UK', 2, '4000.00', '9000.00', '7000.00', '6000.00', 'FSDDSDF', 'A006 '),
('C00015', 'Stuart', 'London', 'London', 'UK', 1, '6000.00', '8000.00', '3000.00', '11000.00', 'GFSGERS', 'A003 '),
('C00002', 'Bolt', 'New York', 'New York', 'USA', 3, '5000.00', '7000.00', '9000.00', '3000.00', 'DDNRDRH', 'A008'),
('C00018', 'Fleming', 'Brisban', 'Brisban', 'Australia', 2, '7000.00', '7000.00', '9000.00', '5000.00', 'NHBGVFC', 'A005'),
('C00021', 'Jacks', 'Brisban', 'Brisban', 'Australia', 1, '7000.00', '7000.00', '7000.00', '7000.00', 'WERTGDF', 'A005'),
('C00019', 'Yearannaidu', 'Chennai', 'Chennai', 'India', 1, '8000.00', '7000.00', '7000.00', '8000.00', 'ZZZZBFV', 'A010'),
('C00005', 'Sasikant', 'Mumbai', 'Mumbai', 'India', 1, '7000.00', '11000.00', '7000.00', '11000.00', '147-25896312', 'A002'),
('C00007', 'Ramanathan', 'Chennai', 'Chennai', 'India', 1, '7000.00', '11000.00', '9000.00', '9000.00', 'GHRDWSD', 'A010'),
('C00022', 'Avinash', 'Mumbai', 'Mumbai', 'India', 2, '7000.00', '11000.00', '9000.00', '9000.00', '113-12345678', 'A002'),
('C00004', 'Winston', 'Brisban', 'Brisban', 'Australia', 1, '5000.00', '8000.00', '7000.00', '6000.00', 'AAAAAAA', 'A005'),
('C00023', 'Karl', 'London', 'London', 'UK', 0, '4000.00', '6000.00', '7000.00', '3000.00', 'AAAABAA', 'A006'),
('C00006', 'Shilton', 'Torento', 'Torento', 'Canada', 1, '10000.00', '7000.00', '6000.00', '11000.00', 'DDDDDDD', 'A004'),
('C00010', 'Charles', 'Hampshair', 'Hampshair', 'UK', 3, '6000.00', '4000.00', '5000.00', '5000.00', 'MMMMMMM', 'A009'),
('C00017', 'Srinivas', 'Bangalore', 'Bangalore', 'India', 2, '8000.00', '4000.00', '3000.00', '9000.00', 'AAAAAAB ', 'A007'),
('C00012', 'Steven', 'San Jose', 'San Jose', 'USA', 1, '5000.00', '7000.00', '9000.00', '3000.00', 'KRFYGJK', 'A012'),
('C00008', 'Karolina', 'Torento', 'Torento', 'Canada', 1, '7000.00', '7000.00', '9000.00', '5000.00', 'HJKORED', 'A004'),
('C00003', 'Martin', 'Torento', 'Torento', 'Canada', 2, '8000.00', '7000.00', '7000.00', '8000.00', 'MJYURFD', 'A004'),
('C00009', 'Ramesh', 'Mumbai', 'Mumbai', 'India', 3, '8000.00', '7000.00', '3000.00', '12000.00', 'Phone No', 'A002'),
('C00014', 'Rangarappa', 'Bangalore', 'Bangalore', 'India', 2, '8000.00', '11000.00', '7000.00', '12000.00', 'AAAATGF', 'A001'),
('C00016', 'Venkatpati', 'Bangalore', 'Bangalore', 'India', 2, '8000.00', '11000.00', '7000.00', '12000.00', 'JRTVFDD', 'A007'),
('C00011', 'Sundariya', 'Chennai', 'Chennai', 'India', 3, '7000.00', '11000.00', '7000.00', '11000.00', 'PPHGRTS', 'A010');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `customer2`
--

CREATE TABLE `customer2` (
  `customer_id` int(11) DEFAULT NULL,
  `cust_name` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `grade` int(11) DEFAULT NULL,
  `salesman_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `customer2`
--

INSERT INTO `customer2` (`customer_id`, `cust_name`, `city`, `grade`, `salesman_id`) VALUES
(3002, 'Nick Rimando', 'New York', 100, 5001),
(3007, 'Brad Davis', 'New York', 200, 5001),
(3005, 'Graham Zusi', 'California', 200, 5002),
(3008, 'Julian Green', 'London', 300, 5002),
(3004, 'Fabian Johnson', 'Paris', 300, 5006),
(3009, 'Geoff Cameron', 'Berlin', 100, 5003),
(3003, 'Jozy Altidor', 'Moscow', 200, 5007),
(3001, 'Brad Guzan', 'London', 0, 5005),
(3002, 'Nick Rimando', 'New York', 100, 5001),
(3007, 'Brad Davis', 'New York', 200, 5001),
(3005, 'Graham Zusi', 'California', 200, 5002),
(3008, 'Julian Green', 'London', 300, 5002),
(3004, 'Fabian Johnson', 'Paris', 300, 5006),
(3009, 'Geoff Cameron', 'Berlin', 100, 5003),
(3003, 'Jozy Altidor', 'Moscow', 200, 5007),
(3001, 'Brad Guzan', 'London', 0, 5005);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `departments`
--

CREATE TABLE `departments` (
  `department_id` int(11) DEFAULT NULL,
  `department_name` varchar(255) DEFAULT NULL,
  `manager_id` int(11) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `departments`
--

INSERT INTO `departments` (`department_id`, `department_name`, `manager_id`, `location_id`) VALUES
(10, 'Administration', 200, 1700),
(20, 'Marketing', 201, 1800),
(30, 'Purchasing', 114, 1700),
(40, 'Human Resources', 203, 2400),
(50, 'Shipping', 121, 1500),
(60, 'IT', 103, 1400),
(70, 'Public Relations', 204, 2700),
(80, 'Sales', 145, 2500),
(90, 'Executive', 100, 1700),
(100, 'Finance', 108, 1700),
(110, 'Accounting', 205, 1700),
(120, 'Treasury', 0, 1700),
(130, 'Corporate Tax', 0, 1700),
(140, 'Control And Credit', 0, 1700),
(150, 'Shareholder Services', 0, 1700),
(160, 'Benefits', 0, 1700),
(170, 'Manufacturing', 0, 1700),
(180, 'Construction', 0, 1700),
(190, 'Contracting', 0, 1700),
(200, 'Operations', 0, 1700),
(210, 'IT Support', 0, 1700),
(220, 'NOC', 0, 1700),
(230, 'IT Helpdesk', 0, 1700),
(240, 'Government Sales', 0, 1700),
(250, 'Retail Sales', 0, 1700),
(260, 'Recruiting', 0, 1700),
(270, 'Payroll', 0, 1700),
(10, 'Administration', 200, 1700),
(20, 'Marketing', 201, 1800),
(30, 'Purchasing', 114, 1700),
(40, 'Human Resources', 203, 2400),
(50, 'Shipping', 121, 1500),
(60, 'IT', 103, 1400),
(70, 'Public Relations', 204, 2700),
(80, 'Sales', 145, 2500),
(90, 'Executive', 100, 1700),
(100, 'Finance', 108, 1700),
(110, 'Accounting', 205, 1700),
(120, 'Treasury', 0, 1700),
(130, 'Corporate Tax', 0, 1700),
(140, 'Control And Credit', 0, 1700),
(150, 'Shareholder Services', 0, 1700),
(160, 'Benefits', 0, 1700),
(170, 'Manufacturing', 0, 1700),
(180, 'Construction', 0, 1700),
(190, 'Contracting', 0, 1700),
(200, 'Operations', 0, 1700),
(210, 'IT Support', 0, 1700),
(220, 'NOC', 0, 1700),
(230, 'IT Helpdesk', 0, 1700),
(240, 'Government Sales', 0, 1700),
(250, 'Retail Sales', 0, 1700),
(260, 'Recruiting', 0, 1700),
(270, 'Payroll', 0, 1700);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `dept_accidents_cook`
--

CREATE TABLE `dept_accidents_cook` (
  `deptno` int(11) DEFAULT NULL,
  `accident_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `dept_accidents_cook`
--

INSERT INTO `dept_accidents_cook` (`deptno`, `accident_name`) VALUES
(10, 'BROKEN FOOT'),
(10, 'FLESH WOUND'),
(20, 'FIRE'),
(20, 'FIRE'),
(20, 'FLOOD'),
(30, 'BRUISED GLUTE');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `dept_cook`
--

CREATE TABLE `dept_cook` (
  `DNAME` varchar(255) DEFAULT NULL,
  `DEPTNO` int(11) DEFAULT NULL,
  `LOC` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `dept_cook`
--

INSERT INTO `dept_cook` (`DNAME`, `DEPTNO`, `LOC`) VALUES
('ACCOUNTING', 10, 'NEW YORK'),
('RESEARCH', 20, 'DALLAS'),
('SALES', 30, 'CHICAGO'),
('OPERATIONS', 40, 'BOSTON');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `dupes_cook`
--

CREATE TABLE `dupes_cook` (
  `id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `dupes_cook`
--

INSERT INTO `dupes_cook` (`id`, `name`) VALUES
(1, 'NAPOLEON'),
(2, 'DYNAMITE'),
(4, 'SHE SELLS'),
(5, 'SEA SHELLS');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `employee`
--

CREATE TABLE `employee` (
  `emp_id` varchar(255) DEFAULT NULL,
  `emp_name` varchar(255) DEFAULT NULL,
  `dt_of_join` date DEFAULT NULL,
  `emp_supv` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `employee`
--

INSERT INTO `employee` (`emp_id`, `emp_name`, `dt_of_join`, `emp_supv`) VALUES
('127323', 'Michale Robbin', NULL, '526689'),
('526689', 'Carlos Snares', NULL, NULL),
('843795', 'Enric Dosio', NULL, '526689'),
('328717', 'Jhon Snares', NULL, '839139'),
('444527', 'Joseph Dosni', NULL, '526689'),
('659831', 'Zanifer Emily', NULL, '839139'),
('847674', 'Kuleswar Sitaraman', NULL, '526689'),
('748681', 'Henrey Gabriel', NULL, '839139'),
('555935', 'Alex Manuel', NULL, '526689'),
('539569', 'George Mardy', NULL, '839139'),
('733843', 'Mario Saule', NULL, '839139'),
('631548', 'Alan Snappy', NULL, '839139'),
('839139', 'Maria Foster', NULL, NULL),
('127323', 'Michale Robbin', NULL, '526689'),
('526689', 'Carlos Snares', NULL, NULL),
('843795', 'Enric Dosio', NULL, '526689'),
('328717', 'Jhon Snares', NULL, '839139'),
('444527', 'Joseph Dosni', NULL, '526689'),
('659831', 'Zanifer Emily', NULL, '839139'),
('847674', 'Kuleswar Sitaraman', NULL, '526689'),
('748681', 'Henrey Gabriel', NULL, '839139'),
('555935', 'Alex Manuel', NULL, '526689'),
('539569', 'George Mardy', NULL, '839139'),
('733843', 'Mario Saule', NULL, '839139'),
('631548', 'Alan Snappy', NULL, '839139'),
('839139', 'Maria Foster', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `employees`
--

CREATE TABLE `employees` (
  `employee_id` int(11) DEFAULT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone_number` varchar(255) DEFAULT NULL,
  `hire_date` varchar(255) DEFAULT NULL,
  `job_id` varchar(255) DEFAULT NULL,
  `salary` int(11) DEFAULT NULL,
  `comission_pct` decimal(3,2) DEFAULT NULL,
  `manager_id` int(11) DEFAULT NULL,
  `department_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `employees`
--

INSERT INTO `employees` (`employee_id`, `first_name`, `last_name`, `email`, `phone_number`, `hire_date`, `job_id`, `salary`, `comission_pct`, `manager_id`, `department_id`) VALUES
(100, 'Steven', 'King', 'SKING', '515.123.4567', '6/17/1987', 'AD_PRES', 450000, NULL, NULL, 90),
(101, 'Neena', 'Kochhar', 'NKOCHHAR', '515.123.4568', '6/18/1987', 'AD_VP', 17000, NULL, 100, 90),
(102, 'Lex', 'DeHaan', 'LDEHAAN', '515.123.4569', '6/19/1987', 'AD_VP', 17000, NULL, 100, 90),
(103, 'Alexander', 'Hunold', 'AHUNOLD', '590.423.4567', '6/20/1987', 'IT_PROG', 9000, NULL, 102, 60),
(104, 'Bruce', 'Ernst', 'BERNST', '590.423.4568', '6/21/1987', 'IT_PROG', 6000, NULL, 103, 60),
(105, 'David', 'Austin', 'DAUSTIN', '590.423.4569', '6/22/1987', 'IT_PROG', 4800, NULL, 103, 60),
(106, 'Valli', 'Pataballa', 'VPATABAL', '590.423.4560', '6/23/1987', 'IT_PROG', 4800, NULL, 103, 60),
(107, 'Diana', 'Lorentz', 'DLORENTZ', '590.423.5567', '6/24/1987', 'IT_PROG', 4200, NULL, 103, 60),
(108, 'Nancy', 'Greenberg', 'NGREENBE', '515.124.4569', '6/25/1987', 'FI_MGR', 12000, NULL, 101, 100),
(109, 'Daniel', 'Faviet', 'DFAVIET', '515.124.4169', '6/26/1987', 'FI_ACCOUNT', 9000, NULL, 108, 100),
(110, 'John', 'Chen', 'JCHEN', '515.124.4269', '6/27/1987', 'FI_ACCOUNT', 8200, NULL, 108, 100),
(111, 'Ismael', 'Sciarra', 'ISCIARRA', '515.124.4369', '6/28/1987', 'FI_ACCOUNT', 7700, NULL, 108, 100),
(112, 'JoseManue', 'Urman', 'JMURMAN', '515.124.4469', '6/29/1987', 'FI_ACCOUNT', 7800, NULL, 108, 100),
(113, 'Luis', 'Popp', 'LPOPP', '515.124.4567', '6/30/1987', 'FI_ACCOUNT', 6900, NULL, 108, 100),
(114, 'Den', 'Raphaely', 'DRAPHEAL', '515.127.4561', '7/1/1987', 'PU_MAN', 11000, NULL, 100, 30),
(115, 'Alexander', 'Khoo', 'AKHOO', '515.127.4562', '7/2/1987', 'PU_CLERK', 3100, NULL, 114, 30),
(116, 'Shelli', 'Baida', 'SBAIDA', '515.127.4563', '7/3/1987', 'PU_CLERK', 2900, NULL, 114, 30),
(117, 'Sigal', 'Tobias', 'STOBIAS', '515.127.4564', '7/4/1987', 'PU_CLERK', 2800, NULL, 114, 30),
(118, 'Guy', 'Himuro', 'GHIMURO', '515.127.4565', '7/5/1987', 'PU_CLERK', 2600, NULL, 114, 30),
(119, 'Karen', 'Colmenares', 'KCOLMENA', '515.127.4566', '7/6/1987', 'PU_CLERK', 2500, NULL, 114, 30),
(120, 'Matthew', 'Weiss', 'MWEISS', '650.123.1234', '7/7/1987', 'ST_MAN', 8000, NULL, 100, 50),
(121, 'Adam', 'Fripp', 'AFRIPP', '650.123.2234', '7/8/1987', 'ST_MAN', 8200, NULL, 100, 50),
(122, 'Payam', 'Kaufling', 'PKAUFLIN', '650.123.3234', '7/9/1987', 'ST_MAN', 7900, NULL, 100, 50),
(123, 'Shanta', 'Vollman', 'SVOLLMAN', '650.123.4234', '7/10/1987', 'ST_MAN', 6500, NULL, 100, 50),
(124, 'Kevin', 'Mourgos', 'KMOURGOS', '650.123.5234', '7/11/1987', 'ST_MAN', 5800, NULL, 100, 50),
(125, 'Julia', 'Nayer', 'JNAYER', '650.124.1214', '7/12/1987', 'ST_CLERK', 3200, NULL, 120, 50),
(126, 'Irene', 'Mikkilinen', 'IMIKKILI', '650.124.1224', '7/13/1987', 'ST_CLERK', 2700, NULL, 120, 50),
(127, 'James', 'Landry', 'JLANDRY', '650.124.1334', '7/14/1987', 'ST_CLERK', 2400, NULL, 120, 50),
(128, 'Steven', 'Markle', 'SMARKLE', '650.124.1434', '7/15/1987', 'ST_CLERK', 2200, NULL, 120, 50),
(129, 'Laura', 'Bissot', 'LBISSOT', '650.124.5234', '7/16/1987', 'ST_CLERK', 3300, NULL, 121, 50),
(130, 'Mozhe', 'Atkinson', 'MATKINSO', '650.124.6234', '7/17/1987', 'ST_CLERK', 2800, NULL, 121, 50),
(131, 'James', 'Marlow', 'JAMRLOW', '650.124.7234', '7/18/1987', 'ST_CLERK', 2500, NULL, 121, 50),
(132, 'TJ', 'Olson', 'TJOLSON', '650.124.8234', '7/19/1987', 'ST_CLERK', 2100, NULL, 121, 50),
(133, 'Jason', 'Mallin', 'JMALLIN', '650.127.1934', '7/20/1987', 'ST_CLERK', 3300, NULL, 122, 50),
(134, 'Michael', 'Rogers', 'MROGERS', '650.127.1834', '7/21/1987', 'ST_CLERK', 2900, NULL, 122, 50),
(135, 'Ki', 'Gee', 'KGEE', '650.127.1734', '7/22/1987', 'ST_CLERK', 2400, NULL, 122, 50),
(136, 'Hazel', 'Philtanker', 'HPHILTAN', '650.127.1634', '7/23/1987', 'ST_CLERK', 2200, NULL, 122, 50),
(137, 'Renske', 'Ladwig', 'RLADWIG', '650.121.1234', '7/24/1987', 'ST_CLERK', 3600, NULL, 123, 50),
(138, 'Stephen', 'Stiles', 'SSTILES', '650.121.2034', '7/25/1987', 'ST_CLERK', 3200, NULL, 123, 50),
(139, 'John', 'Seo', 'JSEO', '650.121.2019', '7/26/1987', 'ST_CLERK', 2700, NULL, 123, 50),
(140, 'Joshua', 'Patel', 'JPATEL', '650.121.1834', '7/27/1987', 'ST_CLERK', 2500, NULL, 123, 50),
(141, 'Trenna', 'Rajs', 'TRAJS', '650.121.8009', '7/28/1987', 'ST_CLERK', 3500, NULL, 124, 50),
(142, 'Curtis', 'Davies', 'CDAVIES', '650.121.2994', '7/29/1987', 'ST_CLERK', 3100, NULL, 124, 50),
(143, 'Randall', 'Matos', 'RMATOS', '650.121.2874', '7/30/1987', 'ST_CLERK', 2600, NULL, 124, 50),
(144, 'Peter', 'Vargas', 'PVARGAS', '650.121.2004', '7/31/1987', 'ST_CLERK', 2500, NULL, 124, 50),
(145, 'John', 'Russell', 'JRUSSEL', '011.44.1344.', '8/1/1987', 'SA_MAN', 14000, '0.40', 100, 80),
(146, 'Karen', 'Partners', 'KPARTNER', '011.44.1344.', '8/2/1987', 'SA_MAN', 13500, '0.30', 100, 80),
(147, 'Alberto', 'Errazuriz', 'AERRAZUR', '011.44.1344.', '8/3/1987', 'SA_MAN', 12000, '0.30', 100, 80),
(148, 'Gerald', 'Cambrault', 'GCAMBRAU', '011.44.1344.', '8/4/1987', 'SA_MAN', 11000, '0.30', 100, 80),
(149, 'Eleni', 'Zlotkey', 'EZLOTKEY', '011.44.1344.', '8/5/1987', 'SA_MAN', 10500, '0.20', 100, 80),
(150, 'Peter', 'Tucker', 'PTUCKER', '011.44.1344.', '8/6/1987', 'SA_REP', 10000, '0.30', 145, 80),
(151, 'David', 'Bernstein', 'DBERNSTE', '011.44.1344.', '8/7/1987', 'SA_REP', 9500, '0.25', 145, 80),
(152, 'Peter', 'Hall', 'PHALL', '011.44.1344.', '8/8/1987', 'SA_REP', 9000, '0.25', 145, 80),
(153, 'Christophe', 'Olsen', 'COLSEN', '011.44.1344.', '8/9/1987', 'SA_REP', 8000, '0.20', 145, 80),
(154, 'Nanette', 'Cambrault', 'NCAMBRAU', '011.44.1344.', '8/10/1987', 'SA_REP', 7500, '0.20', 145, 80),
(155, 'Oliver', 'Tuvault', 'OTUVAULT', '011.44.1344.', '8/11/1987', 'SA_REP', 7000, '0.15', 145, 80),
(156, 'Janette', 'King', 'JKING', '011.44.1345.', '8/12/1987', 'SA_REP', 10000, '0.35', 146, 80),
(157, 'Patrick', 'Sully', 'PSULLY', '011.44.1345.', '8/13/1987', 'SA_REP', 9500, '0.35', 146, 80),
(158, 'Allan', 'McEwen', 'AMCEWEN', '011.44.1345.', '8/14/1987', 'SA_REP', 9000, '0.35', 146, 80),
(159, 'Lindsey', 'Smith', 'LSMITH', '011.44.1345.', '8/15/1987', 'SA_REP', 8000, '0.30', 146, 80),
(160, 'Louise', 'Doran', 'LDORAN', '011.44.1345.', '8/16/1987', 'SA_REP', 7500, '0.30', 146, 80),
(161, 'Sarath', 'Sewall', 'SSEWALL', '011.44.1345.', '8/17/1987', 'SA_REP', 7000, '0.25', 146, 80),
(162, 'Clara', 'Vishney', 'CVISHNEY', '011.44.1346.', '8/18/1987', 'SA_REP', 10500, '0.25', 147, 80),
(163, 'Danielle', 'Greene', 'DGREENE', '011.44.1346.', '8/19/1987', 'SA_REP', 9500, '0.15', 147, 80),
(164, 'Mattea', 'Marvins', 'MMARVINS', '011.44.1346.', '8/20/1987', 'SA_REP', 7200, '0.10', 147, 80),
(165, 'David', 'Lee', 'DLEE', '011.44.1346.', '8/21/1987', 'SA_REP', 6800, '0.10', 147, 80),
(166, 'Sundar', 'Ande', 'SANDE', '011.44.1346.', '8/22/1987', 'SA_REP', 6400, '0.10', 147, 80),
(167, 'Amit', 'Banda', 'ABANDA', '011.44.1346.', '8/23/1987', 'SA_REP', 6200, '0.10', 147, 80),
(168, 'Lisa', 'Ozer', 'LOZER', '011.44.1343.', '8/24/1987', 'SA_REP', 11500, '0.25', 148, 80),
(169, 'Harrison', 'Bloom', 'HBLOOM', '011.44.1343.', '8/25/1987', 'SA_REP', 10000, '0.20', 148, 80),
(170, 'Tayler', 'Fox', 'TFOX', '011.44.1343.', '8/26/1987', 'SA_REP', 9600, '0.20', 148, 80),
(171, 'William', 'Smith', 'WSMITH', '011.44.1343.', '8/27/1987', 'SA_REP', 7400, '0.15', 148, 80),
(172, 'Elizabeth', 'Bates', 'EBATES', '011.44.1343.', '8/28/1987', 'SA_REP', 7300, '0.15', 148, 80),
(173, 'Sundita', 'Kumar', 'SKUMAR', '011.44.1343.', '8/29/1987', 'SA_REP', 6100, '0.10', 148, 80),
(174, 'Ellen', 'Abel', 'EABEL', '011.44.1644.', '8/30/1987', 'SA_REP', 11000, '0.30', 149, 80),
(175, 'Alyssa', 'Hutton', 'AHUTTON', '011.44.1644.', '8/31/1987', 'SA_REP', 8800, '0.25', 149, 80),
(176, 'Jonathon', 'Taylor', 'JTAYLOR', '011.44.1644.', '9/1/1987', 'SA_REP', 8600, '0.20', 149, 80),
(177, 'Jack', 'Livingston', 'JLIVINGS', '011.44.1644.', '9/2/1987', 'SA_REP', 8400, '0.20', 149, 80),
(178, 'Kimberely', 'Grant', 'KGRANT', '011.44.1644.', '9/3/1987', 'SA_REP', 7000, '0.15', 149, NULL),
(179, 'Charles', 'Johnson', 'CJOHNSON', '011.44.1644.', '9/4/1987', 'SA_REP', 6200, '0.10', 149, 80),
(180, 'Winston', 'Taylor', 'WTAYLOR', '650.507.9876', '9/5/1987', 'SH_CLERK', 3200, NULL, 120, 50),
(181, 'Jean', 'Fleaur', 'JFLEAUR', '650.507.9877', '9/6/1987', 'SH_CLERK', 3100, NULL, 120, 50),
(182, 'Martha', 'Sullivan', 'MSULLIVA', '650.507.9878', '9/7/1987', 'SH_CLERK', 2500, NULL, 120, 50),
(183, 'Girard', 'Geoni', 'GGEONI', '650.507.9879', '9/8/1987', 'SH_CLERK', 2800, NULL, 120, 50),
(184, 'Nandita', 'Sarchand', 'NSARCHAN', '650.509.1876', '9/9/1987', 'SH_CLERK', 4200, NULL, 121, 50),
(185, 'Alexis', 'Bull', 'ABULL', '650.509.2876', '9/10/1987', 'SH_CLERK', 4100, NULL, 121, 50),
(186, 'Julia', 'Dellinger', 'JDELLING', '650.509.3876', '9/11/1987', 'SH_CLERK', 3400, NULL, 121, 50),
(187, 'Anthony', 'Cabrio', 'ACABRIO', '650.509.4876', '9/12/1987', 'SH_CLERK', 3000, NULL, 121, 50),
(188, 'Kelly', 'Chung', 'KCHUNG', '650.505.1876', '9/13/1987', 'SH_CLERK', 3800, NULL, 122, 50),
(189, 'Jennifer', 'Dilly', 'JDILLY', '650.505.2876', '9/14/1987', 'SH_CLERK', 3600, NULL, 122, 50),
(190, 'Timothy', 'Gates', 'TGATES', '650.505.3876', '9/15/1987', 'SH_CLERK', 2900, NULL, 122, 50),
(191, 'Randall', 'Perkins', 'RPERKINS', '650.505.4876', '9/16/1987', 'SH_CLERK', 2500, NULL, 122, 50),
(192, 'Sarah', 'Bell', 'SBELL', '650.501.1876', '9/17/1987', 'SH_CLERK', 4000, NULL, 123, 50),
(193, 'Britney', 'Everett', 'BEVERETT', '650.501.2876', '9/18/1987', 'SH_CLERK', 3900, NULL, 123, 50),
(194, 'Samuel', 'McCain', 'SMCCAIN', '650.501.3876', '9/19/1987', 'SH_CLERK', 3200, NULL, 123, 50),
(195, 'Vance', 'Jones', 'VJONES', '650.501.4876', '9/20/1987', 'SH_CLERK', 2800, NULL, 123, 50),
(196, 'Alana', 'Walsh', 'AWALSH', '650.507.9811', '9/21/1987', 'SH_CLERK', 3100, NULL, 124, 50),
(197, 'Kevin', 'Feeney', 'KFEENEY', '650.507.9822', '9/22/1987', 'SH_CLERK', 3000, NULL, 124, 50),
(198, 'Donald', 'OConnell', 'DOCONNEL', '650.507.9833', '9/23/1987', 'SH_CLERK', 2600, NULL, 124, 50),
(199, 'Douglas', 'Grant', 'DGRANT', '650.507.9844', '9/24/1987', 'SH_CLERK', 2600, NULL, 124, 50),
(200, 'Jennifer', 'Whalen', 'JWHALEN', '515.123.4444', '9/25/1987', 'AD_ASST', 4400, NULL, 101, 10),
(201, 'Michael', 'Hartstein', 'MHARTSTE', '515.123.5555', '9/26/1987', 'MK_MAN', 13000, NULL, 100, 20),
(202, 'Pat', 'Fay', 'PFAY', '603.123.6666', '9/27/1987', 'MK_REP', 6000, NULL, 201, 20),
(203, 'Susan', 'Mavris', 'SMAVRIS', '515.123.7777', '9/28/1987', 'HR_REP', 6500, NULL, 101, 40),
(204, 'Hermann', 'Baer', 'HBAER', '515.123.8888', '9/29/1987', 'PR_REP', 10000, NULL, 101, 70),
(205, 'Shelley', 'Higgins', 'SHIGGINS', '515.123.8080', '9/30/1987', 'AC_MGR', 12000, NULL, 101, 110),
(206, 'William', 'Gietz', 'WGIETZ', '515.123.8181', '10/1/1987', 'AC_ACCOUNT', 8300, NULL, 205, 110),
(100, 'Steven', 'King', 'SKING', '515.123.4567', '6/17/1987', 'AD_PRES', 450000, NULL, NULL, 90),
(101, 'Neena', 'Kochhar', 'NKOCHHAR', '515.123.4568', '6/18/1987', 'AD_VP', 17000, NULL, 100, 90),
(102, 'Lex', 'DeHaan', 'LDEHAAN', '515.123.4569', '6/19/1987', 'AD_VP', 17000, NULL, 100, 90),
(103, 'Alexander', 'Hunold', 'AHUNOLD', '590.423.4567', '6/20/1987', 'IT_PROG', 9000, NULL, 102, 60),
(104, 'Bruce', 'Ernst', 'BERNST', '590.423.4568', '6/21/1987', 'IT_PROG', 6000, NULL, 103, 60),
(105, 'David', 'Austin', 'DAUSTIN', '590.423.4569', '6/22/1987', 'IT_PROG', 4800, NULL, 103, 60),
(106, 'Valli', 'Pataballa', 'VPATABAL', '590.423.4560', '6/23/1987', 'IT_PROG', 4800, NULL, 103, 60),
(107, 'Diana', 'Lorentz', 'DLORENTZ', '590.423.5567', '6/24/1987', 'IT_PROG', 4200, NULL, 103, 60),
(108, 'Nancy', 'Greenberg', 'NGREENBE', '515.124.4569', '6/25/1987', 'FI_MGR', 12000, NULL, 101, 100),
(109, 'Daniel', 'Faviet', 'DFAVIET', '515.124.4169', '6/26/1987', 'FI_ACCOUNT', 9000, NULL, 108, 100),
(110, 'John', 'Chen', 'JCHEN', '515.124.4269', '6/27/1987', 'FI_ACCOUNT', 8200, NULL, 108, 100),
(111, 'Ismael', 'Sciarra', 'ISCIARRA', '515.124.4369', '6/28/1987', 'FI_ACCOUNT', 7700, NULL, 108, 100),
(112, 'JoseManue', 'Urman', 'JMURMAN', '515.124.4469', '6/29/1987', 'FI_ACCOUNT', 7800, NULL, 108, 100),
(113, 'Luis', 'Popp', 'LPOPP', '515.124.4567', '6/30/1987', 'FI_ACCOUNT', 6900, NULL, 108, 100),
(114, 'Den', 'Raphaely', 'DRAPHEAL', '515.127.4561', '7/1/1987', 'PU_MAN', 11000, NULL, 100, 30),
(115, 'Alexander', 'Khoo', 'AKHOO', '515.127.4562', '7/2/1987', 'PU_CLERK', 3100, NULL, 114, 30),
(116, 'Shelli', 'Baida', 'SBAIDA', '515.127.4563', '7/3/1987', 'PU_CLERK', 2900, NULL, 114, 30),
(117, 'Sigal', 'Tobias', 'STOBIAS', '515.127.4564', '7/4/1987', 'PU_CLERK', 2800, NULL, 114, 30),
(118, 'Guy', 'Himuro', 'GHIMURO', '515.127.4565', '7/5/1987', 'PU_CLERK', 2600, NULL, 114, 30),
(119, 'Karen', 'Colmenares', 'KCOLMENA', '515.127.4566', '7/6/1987', 'PU_CLERK', 2500, NULL, 114, 30),
(120, 'Matthew', 'Weiss', 'MWEISS', '650.123.1234', '7/7/1987', 'ST_MAN', 8000, NULL, 100, 50),
(121, 'Adam', 'Fripp', 'AFRIPP', '650.123.2234', '7/8/1987', 'ST_MAN', 8200, NULL, 100, 50),
(122, 'Payam', 'Kaufling', 'PKAUFLIN', '650.123.3234', '7/9/1987', 'ST_MAN', 7900, NULL, 100, 50),
(123, 'Shanta', 'Vollman', 'SVOLLMAN', '650.123.4234', '7/10/1987', 'ST_MAN', 6500, NULL, 100, 50),
(124, 'Kevin', 'Mourgos', 'KMOURGOS', '650.123.5234', '7/11/1987', 'ST_MAN', 5800, NULL, 100, 50),
(125, 'Julia', 'Nayer', 'JNAYER', '650.124.1214', '7/12/1987', 'ST_CLERK', 3200, NULL, 120, 50),
(126, 'Irene', 'Mikkilinen', 'IMIKKILI', '650.124.1224', '7/13/1987', 'ST_CLERK', 2700, NULL, 120, 50),
(127, 'James', 'Landry', 'JLANDRY', '650.124.1334', '7/14/1987', 'ST_CLERK', 2400, NULL, 120, 50),
(128, 'Steven', 'Markle', 'SMARKLE', '650.124.1434', '7/15/1987', 'ST_CLERK', 2200, NULL, 120, 50),
(129, 'Laura', 'Bissot', 'LBISSOT', '650.124.5234', '7/16/1987', 'ST_CLERK', 3300, NULL, 121, 50),
(130, 'Mozhe', 'Atkinson', 'MATKINSO', '650.124.6234', '7/17/1987', 'ST_CLERK', 2800, NULL, 121, 50),
(131, 'James', 'Marlow', 'JAMRLOW', '650.124.7234', '7/18/1987', 'ST_CLERK', 2500, NULL, 121, 50),
(132, 'TJ', 'Olson', 'TJOLSON', '650.124.8234', '7/19/1987', 'ST_CLERK', 2100, NULL, 121, 50),
(133, 'Jason', 'Mallin', 'JMALLIN', '650.127.1934', '7/20/1987', 'ST_CLERK', 3300, NULL, 122, 50),
(134, 'Michael', 'Rogers', 'MROGERS', '650.127.1834', '7/21/1987', 'ST_CLERK', 2900, NULL, 122, 50),
(135, 'Ki', 'Gee', 'KGEE', '650.127.1734', '7/22/1987', 'ST_CLERK', 2400, NULL, 122, 50),
(136, 'Hazel', 'Philtanker', 'HPHILTAN', '650.127.1634', '7/23/1987', 'ST_CLERK', 2200, NULL, 122, 50),
(137, 'Renske', 'Ladwig', 'RLADWIG', '650.121.1234', '7/24/1987', 'ST_CLERK', 3600, NULL, 123, 50),
(138, 'Stephen', 'Stiles', 'SSTILES', '650.121.2034', '7/25/1987', 'ST_CLERK', 3200, NULL, 123, 50),
(139, 'John', 'Seo', 'JSEO', '650.121.2019', '7/26/1987', 'ST_CLERK', 2700, NULL, 123, 50),
(140, 'Joshua', 'Patel', 'JPATEL', '650.121.1834', '7/27/1987', 'ST_CLERK', 2500, NULL, 123, 50),
(141, 'Trenna', 'Rajs', 'TRAJS', '650.121.8009', '7/28/1987', 'ST_CLERK', 3500, NULL, 124, 50),
(142, 'Curtis', 'Davies', 'CDAVIES', '650.121.2994', '7/29/1987', 'ST_CLERK', 3100, NULL, 124, 50),
(143, 'Randall', 'Matos', 'RMATOS', '650.121.2874', '7/30/1987', 'ST_CLERK', 2600, NULL, 124, 50),
(144, 'Peter', 'Vargas', 'PVARGAS', '650.121.2004', '7/31/1987', 'ST_CLERK', 2500, NULL, 124, 50),
(145, 'John', 'Russell', 'JRUSSEL', '011.44.1344.', '8/1/1987', 'SA_MAN', 14000, '0.40', 100, 80),
(146, 'Karen', 'Partners', 'KPARTNER', '011.44.1344.', '8/2/1987', 'SA_MAN', 13500, '0.30', 100, 80),
(147, 'Alberto', 'Errazuriz', 'AERRAZUR', '011.44.1344.', '8/3/1987', 'SA_MAN', 12000, '0.30', 100, 80),
(148, 'Gerald', 'Cambrault', 'GCAMBRAU', '011.44.1344.', '8/4/1987', 'SA_MAN', 11000, '0.30', 100, 80),
(149, 'Eleni', 'Zlotkey', 'EZLOTKEY', '011.44.1344.', '8/5/1987', 'SA_MAN', 10500, '0.20', 100, 80),
(150, 'Peter', 'Tucker', 'PTUCKER', '011.44.1344.', '8/6/1987', 'SA_REP', 10000, '0.30', 145, 80),
(151, 'David', 'Bernstein', 'DBERNSTE', '011.44.1344.', '8/7/1987', 'SA_REP', 9500, '0.25', 145, 80),
(152, 'Peter', 'Hall', 'PHALL', '011.44.1344.', '8/8/1987', 'SA_REP', 9000, '0.25', 145, 80),
(153, 'Christophe', 'Olsen', 'COLSEN', '011.44.1344.', '8/9/1987', 'SA_REP', 8000, '0.20', 145, 80),
(154, 'Nanette', 'Cambrault', 'NCAMBRAU', '011.44.1344.', '8/10/1987', 'SA_REP', 7500, '0.20', 145, 80),
(155, 'Oliver', 'Tuvault', 'OTUVAULT', '011.44.1344.', '8/11/1987', 'SA_REP', 7000, '0.15', 145, 80),
(156, 'Janette', 'King', 'JKING', '011.44.1345.', '8/12/1987', 'SA_REP', 10000, '0.35', 146, 80),
(157, 'Patrick', 'Sully', 'PSULLY', '011.44.1345.', '8/13/1987', 'SA_REP', 9500, '0.35', 146, 80),
(158, 'Allan', 'McEwen', 'AMCEWEN', '011.44.1345.', '8/14/1987', 'SA_REP', 9000, '0.35', 146, 80),
(159, 'Lindsey', 'Smith', 'LSMITH', '011.44.1345.', '8/15/1987', 'SA_REP', 8000, '0.30', 146, 80),
(160, 'Louise', 'Doran', 'LDORAN', '011.44.1345.', '8/16/1987', 'SA_REP', 7500, '0.30', 146, 80),
(161, 'Sarath', 'Sewall', 'SSEWALL', '011.44.1345.', '8/17/1987', 'SA_REP', 7000, '0.25', 146, 80),
(162, 'Clara', 'Vishney', 'CVISHNEY', '011.44.1346.', '8/18/1987', 'SA_REP', 10500, '0.25', 147, 80),
(163, 'Danielle', 'Greene', 'DGREENE', '011.44.1346.', '8/19/1987', 'SA_REP', 9500, '0.15', 147, 80),
(164, 'Mattea', 'Marvins', 'MMARVINS', '011.44.1346.', '8/20/1987', 'SA_REP', 7200, '0.10', 147, 80),
(165, 'David', 'Lee', 'DLEE', '011.44.1346.', '8/21/1987', 'SA_REP', 6800, '0.10', 147, 80),
(166, 'Sundar', 'Ande', 'SANDE', '011.44.1346.', '8/22/1987', 'SA_REP', 6400, '0.10', 147, 80),
(167, 'Amit', 'Banda', 'ABANDA', '011.44.1346.', '8/23/1987', 'SA_REP', 6200, '0.10', 147, 80),
(168, 'Lisa', 'Ozer', 'LOZER', '011.44.1343.', '8/24/1987', 'SA_REP', 11500, '0.25', 148, 80),
(169, 'Harrison', 'Bloom', 'HBLOOM', '011.44.1343.', '8/25/1987', 'SA_REP', 10000, '0.20', 148, 80),
(170, 'Tayler', 'Fox', 'TFOX', '011.44.1343.', '8/26/1987', 'SA_REP', 9600, '0.20', 148, 80),
(171, 'William', 'Smith', 'WSMITH', '011.44.1343.', '8/27/1987', 'SA_REP', 7400, '0.15', 148, 80),
(172, 'Elizabeth', 'Bates', 'EBATES', '011.44.1343.', '8/28/1987', 'SA_REP', 7300, '0.15', 148, 80),
(173, 'Sundita', 'Kumar', 'SKUMAR', '011.44.1343.', '8/29/1987', 'SA_REP', 6100, '0.10', 148, 80),
(174, 'Ellen', 'Abel', 'EABEL', '011.44.1644.', '8/30/1987', 'SA_REP', 11000, '0.30', 149, 80),
(175, 'Alyssa', 'Hutton', 'AHUTTON', '011.44.1644.', '8/31/1987', 'SA_REP', 8800, '0.25', 149, 80),
(176, 'Jonathon', 'Taylor', 'JTAYLOR', '011.44.1644.', '9/1/1987', 'SA_REP', 8600, '0.20', 149, 80),
(177, 'Jack', 'Livingston', 'JLIVINGS', '011.44.1644.', '9/2/1987', 'SA_REP', 8400, '0.20', 149, 80),
(178, 'Kimberely', 'Grant', 'KGRANT', '011.44.1644.', '9/3/1987', 'SA_REP', 7000, '0.15', 149, NULL),
(179, 'Charles', 'Johnson', 'CJOHNSON', '011.44.1644.', '9/4/1987', 'SA_REP', 6200, '0.10', 149, 80),
(180, 'Winston', 'Taylor', 'WTAYLOR', '650.507.9876', '9/5/1987', 'SH_CLERK', 3200, NULL, 120, 50),
(181, 'Jean', 'Fleaur', 'JFLEAUR', '650.507.9877', '9/6/1987', 'SH_CLERK', 3100, NULL, 120, 50),
(182, 'Martha', 'Sullivan', 'MSULLIVA', '650.507.9878', '9/7/1987', 'SH_CLERK', 2500, NULL, 120, 50),
(183, 'Girard', 'Geoni', 'GGEONI', '650.507.9879', '9/8/1987', 'SH_CLERK', 2800, NULL, 120, 50),
(184, 'Nandita', 'Sarchand', 'NSARCHAN', '650.509.1876', '9/9/1987', 'SH_CLERK', 4200, NULL, 121, 50),
(185, 'Alexis', 'Bull', 'ABULL', '650.509.2876', '9/10/1987', 'SH_CLERK', 4100, NULL, 121, 50),
(186, 'Julia', 'Dellinger', 'JDELLING', '650.509.3876', '9/11/1987', 'SH_CLERK', 3400, NULL, 121, 50),
(187, 'Anthony', 'Cabrio', 'ACABRIO', '650.509.4876', '9/12/1987', 'SH_CLERK', 3000, NULL, 121, 50),
(188, 'Kelly', 'Chung', 'KCHUNG', '650.505.1876', '9/13/1987', 'SH_CLERK', 3800, NULL, 122, 50),
(189, 'Jennifer', 'Dilly', 'JDILLY', '650.505.2876', '9/14/1987', 'SH_CLERK', 3600, NULL, 122, 50),
(190, 'Timothy', 'Gates', 'TGATES', '650.505.3876', '9/15/1987', 'SH_CLERK', 2900, NULL, 122, 50),
(191, 'Randall', 'Perkins', 'RPERKINS', '650.505.4876', '9/16/1987', 'SH_CLERK', 2500, NULL, 122, 50),
(192, 'Sarah', 'Bell', 'SBELL', '650.501.1876', '9/17/1987', 'SH_CLERK', 4000, NULL, 123, 50),
(193, 'Britney', 'Everett', 'BEVERETT', '650.501.2876', '9/18/1987', 'SH_CLERK', 3900, NULL, 123, 50),
(194, 'Samuel', 'McCain', 'SMCCAIN', '650.501.3876', '9/19/1987', 'SH_CLERK', 3200, NULL, 123, 50),
(195, 'Vance', 'Jones', 'VJONES', '650.501.4876', '9/20/1987', 'SH_CLERK', 2800, NULL, 123, 50),
(196, 'Alana', 'Walsh', 'AWALSH', '650.507.9811', '9/21/1987', 'SH_CLERK', 3100, NULL, 124, 50),
(197, 'Kevin', 'Feeney', 'KFEENEY', '650.507.9822', '9/22/1987', 'SH_CLERK', 3000, NULL, 124, 50),
(198, 'Donald', 'OConnell', 'DOCONNEL', '650.507.9833', '9/23/1987', 'SH_CLERK', 2600, NULL, 124, 50),
(199, 'Douglas', 'Grant', 'DGRANT', '650.507.9844', '9/24/1987', 'SH_CLERK', 2600, NULL, 124, 50),
(200, 'Jennifer', 'Whalen', 'JWHALEN', '515.123.4444', '9/25/1987', 'AD_ASST', 4400, NULL, 101, 10),
(201, 'Michael', 'Hartstein', 'MHARTSTE', '515.123.5555', '9/26/1987', 'MK_MAN', 13000, NULL, 100, 20),
(202, 'Pat', 'Fay', 'PFAY', '603.123.6666', '9/27/1987', 'MK_REP', 6000, NULL, 201, 20),
(203, 'Susan', 'Mavris', 'SMAVRIS', '515.123.7777', '9/28/1987', 'HR_REP', 6500, NULL, 101, 40),
(204, 'Hermann', 'Baer', 'HBAER', '515.123.8888', '9/29/1987', 'PR_REP', 10000, NULL, 101, 70),
(205, 'Shelley', 'Higgins', 'SHIGGINS', '515.123.8080', '9/30/1987', 'AC_MGR', 12000, NULL, 101, 110),
(206, 'William', 'Gietz', 'WGIETZ', '515.123.8181', '10/1/1987', 'AC_ACCOUNT', 8300, NULL, 205, 110);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `employee_cook`
--

CREATE TABLE `employee_cook` (
  `EMPNO` int(11) DEFAULT NULL,
  `ENAME` varchar(255) DEFAULT NULL,
  `JOB` varchar(255) DEFAULT NULL,
  `MGR` int(11) DEFAULT NULL,
  `HIREDATE` date DEFAULT NULL,
  `SAL` int(11) DEFAULT NULL,
  `COMM` int(11) DEFAULT NULL,
  `DEPTNO` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `employee_cook`
--

INSERT INTO `employee_cook` (`EMPNO`, `ENAME`, `JOB`, `MGR`, `HIREDATE`, `SAL`, `COMM`, `DEPTNO`) VALUES
(7369, 'SMITH', 'CLERK', 7902, '0000-00-00', 800, NULL, 20),
(7499, 'ALLEN', 'SALESMAN', 7698, '0000-00-00', 1600, 300, 30),
(7521, 'WARD', 'SALESMAN', 7698, '0000-00-00', 1250, 500, 30),
(7566, 'JONES', 'MANAGER', 7839, '0000-00-00', 2975, NULL, 20),
(7654, 'MARTIN', 'SALESMAN', 7698, '0000-00-00', 1250, 1400, 30),
(7698, 'BLAKE', 'MANAGER', 7839, '0000-00-00', 2850, NULL, 30),
(7782, 'CLARK', 'MANAGER', 7839, '0000-00-00', 2450, NULL, 10),
(7788, 'SCOTT', 'ANALYST', 7566, '0000-00-00', 3000, NULL, 20),
(7839, 'KING', 'PRESIDENT', NULL, '0000-00-00', 5000, NULL, 10),
(7844, 'TURNER', 'SALESMAN', 7698, '0000-00-00', 1500, 0, 30),
(7876, 'ADAMS', 'CLERK', 7788, '0000-00-00', 1100, NULL, 20),
(7900, 'JAMES', 'CLERK', 7698, '0000-00-00', 950, NULL, 30),
(7902, 'FORD', 'ANALYST', 7566, '0000-00-00', 3000, NULL, 20),
(7934, 'MILLER', 'CLERK', 7782, '0000-00-00', 1300, NULL, 10);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `emp_bonus_cook`
--

CREATE TABLE `emp_bonus_cook` (
  `empno` int(11) DEFAULT NULL,
  `received` date DEFAULT NULL,
  `type` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `emp_bonus_cook`
--

INSERT INTO `emp_bonus_cook` (`empno`, `received`, `type`) VALUES
(7369, '2005-03-14', 1),
(7900, '2005-03-14', 2),
(7788, '2005-03-14', 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `emp_bonus_cook2`
--

CREATE TABLE `emp_bonus_cook2` (
  `empno` int(11) DEFAULT NULL,
  `received` date DEFAULT NULL,
  `type` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `emp_bonus_cook2`
--

INSERT INTO `emp_bonus_cook2` (`empno`, `received`, `type`) VALUES
(7934, '2005-03-17', 1),
(7934, '2005-02-15', 2),
(7839, '2005-02-15', 3),
(7782, '2005-02-15', 1),
(7934, '2005-03-17', 1),
(7934, '2005-02-15', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `emp_bonus_cook3`
--

CREATE TABLE `emp_bonus_cook3` (
  `empno` int(11) DEFAULT NULL,
  `received` date DEFAULT NULL,
  `type` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `emp_bonus_cook3`
--

INSERT INTO `emp_bonus_cook3` (`empno`, `received`, `type`) VALUES
(7934, '2005-03-17', 1),
(7934, '2005-02-15', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `emp_bonus_cook4`
--

CREATE TABLE `emp_bonus_cook4` (
  `EMPNO` int(11) DEFAULT NULL,
  `ENAME` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `emp_bonus_cook4`
--

INSERT INTO `emp_bonus_cook4` (`EMPNO`, `ENAME`) VALUES
(7369, 'SMITH'),
(7900, 'JAMES'),
(7934, 'MILLER');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `emp_cook`
--

CREATE TABLE `emp_cook` (
  `empno` decimal(4,0) NOT NULL,
  `ename` varchar(10) DEFAULT NULL,
  `job` varchar(9) DEFAULT NULL,
  `mgr` decimal(4,0) DEFAULT NULL,
  `hiredate` date DEFAULT NULL,
  `sal` decimal(7,2) DEFAULT NULL,
  `comm` decimal(7,2) DEFAULT NULL,
  `deptno` decimal(2,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `emp_cook`
--

INSERT INTO `emp_cook` (`empno`, `ename`, `job`, `mgr`, `hiredate`, `sal`, `comm`, `deptno`) VALUES
('7369', 'SMITH', 'CLERK', '7902', '1980-12-17', '800.00', NULL, '20'),
('7499', 'ALLEN', 'SALESMAN', '7698', '1981-02-20', '1600.00', '300.00', '30'),
('7521', 'WARD', 'SALESMAN', '7698', '1981-02-22', '1250.00', '500.00', '30'),
('7566', 'JONES', 'MANAGER', '7839', '1981-04-02', '2975.00', NULL, '20'),
('7654', 'MARTIN', 'SALESMAN', '7698', '1981-09-28', '1250.00', '1400.00', '30'),
('7698', 'BLAKE', 'MANAGER', '7839', '1981-05-01', '2850.00', NULL, '30'),
('7782', 'CLARK', 'MANAGER', '7839', '1981-06-09', '2450.00', NULL, '10'),
('7788', 'SCOTT', 'ANALYST', '7566', '1982-12-09', '3000.00', NULL, '20'),
('7839', 'KING', 'PRESIDENT', NULL, '1981-11-17', '5000.00', NULL, '10'),
('7844', 'TURNER', 'SALESMAN', '7698', '1981-09-08', '1500.00', '0.00', '30'),
('7876', 'ADAMS', 'CLERK', '7788', '1983-01-12', '1100.00', NULL, '20'),
('7900', 'JAMES', 'CLERK', '7698', '1981-12-03', '950.00', NULL, '30'),
('7902', 'FORD', 'ANALYST', '7566', '1981-12-03', '3000.00', NULL, '20'),
('7934', 'MILLER', 'CLERK', '7782', '1982-01-23', '1300.00', NULL, '10'),
('1111', 'YODA', 'JEDI', NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `emp_cook2`
--

CREATE TABLE `emp_cook2` (
  `empno` decimal(4,0) NOT NULL,
  `ename` varchar(10) DEFAULT NULL,
  `job` varchar(9) DEFAULT NULL,
  `mgr` decimal(4,0) DEFAULT NULL,
  `hiredate` date DEFAULT NULL,
  `sal` decimal(7,2) DEFAULT NULL,
  `comm` decimal(7,2) DEFAULT NULL,
  `deptno` decimal(2,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `emp_cook2`
--

INSERT INTO `emp_cook2` (`empno`, `ename`, `job`, `mgr`, `hiredate`, `sal`, `comm`, `deptno`) VALUES
('7499', 'ALLEN', 'SALESMAN', '7698', '1981-02-20', '1600.00', '300.00', '30'),
('7521', 'WARD', 'SALESMAN', '7698', '1981-02-22', '1250.00', '500.00', '30'),
('7654', 'MARTIN', 'SALESMAN', '7698', '1981-09-28', '1250.00', '1400.00', '30'),
('7698', 'BLAKE', 'MANAGER', '7839', '1981-05-01', '2850.00', NULL, '30'),
('7782', 'CLARK', 'MANAGER', '7839', '1981-06-09', '2450.00', NULL, '10'),
('7839', 'KING', 'PRESIDENT', NULL, '1981-11-17', '5000.00', NULL, '10'),
('7844', 'TURNER', 'SALESMAN', '7698', '1981-09-08', '1500.00', '0.00', '30'),
('7900', 'JAMES', 'CLERK', '7698', '1981-12-03', '950.00', NULL, '30'),
('7934', 'MILLER', 'CLERK', '7782', '1982-01-23', '1300.00', NULL, '10'),
('1111', 'YODA', 'JEDI', NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `emp_cook_v1`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `emp_cook_v1` (
`job` varchar(9)
,`COUNT(*)` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `emp_department`
--

CREATE TABLE `emp_department` (
  `dpt_code` int(11) DEFAULT NULL,
  `dpt_name` varchar(255) DEFAULT NULL,
  `dpt_allotment` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `emp_department`
--

INSERT INTO `emp_department` (`dpt_code`, `dpt_name`, `dpt_allotment`) VALUES
(57, 'IT', 65000),
(63, 'Finance', 15000),
(47, 'HR', 240000),
(27, 'RD', 55000),
(89, 'QC', 75000),
(57, 'IT', 65000),
(63, 'Finance', 15000),
(47, 'HR', 240000),
(27, 'RD', 55000),
(89, 'QC', 75000);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `emp_details`
--

CREATE TABLE `emp_details` (
  `emp_idno` int(11) DEFAULT NULL,
  `emp_fname` varchar(255) DEFAULT NULL,
  `emp_lname` varchar(255) DEFAULT NULL,
  `emp_dept` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `emp_details`
--

INSERT INTO `emp_details` (`emp_idno`, `emp_fname`, `emp_lname`, `emp_dept`) VALUES
(127323, 'Michale', 'Robbin', 57),
(526689, 'Carlos', 'Snares', 63),
(843795, 'Enric', 'Dosio', 57),
(328717, 'Jhon', 'Snares', 63),
(444527, 'Joseph', 'Dosni', 47),
(659831, 'Zanifer', 'Emily', 47),
(847674, 'Kuleswar', 'Sitaraman', 57),
(748681, 'Henrey', 'Gabriel', 47),
(555935, 'Alex', 'Manuel', 57),
(539569, 'George', 'Mardy', 27),
(733843, 'Mario', 'Saule', 63),
(631548, 'Alan', 'Snappy', 27),
(839139, 'Maria', 'Foster', 57),
(127323, 'Michale', 'Robbin', 57),
(526689, 'Carlos', 'Snares', 63),
(843795, 'Enric', 'Dosio', 57),
(328717, 'Jhon', 'Snares', 63),
(444527, 'Joseph', 'Dosni', 47),
(659831, 'Zanifer', 'Emily', 47),
(847674, 'Kuleswar', 'Sitaraman', 57),
(748681, 'Henrey', 'Gabriel', 47),
(555935, 'Alex', 'Manuel', 57),
(539569, 'George', 'Mardy', 27),
(733843, 'Mario', 'Saule', 63),
(631548, 'Alan', 'Snappy', 27),
(839139, 'Maria', 'Foster', 57);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `emp_project_cook`
--

CREATE TABLE `emp_project_cook` (
  `empno` int(11) DEFAULT NULL,
  `ename` varchar(255) DEFAULT NULL,
  `proj_id` int(11) DEFAULT NULL,
  `proj_start` date DEFAULT NULL,
  `proj_end` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `emp_project_cook`
--

INSERT INTO `emp_project_cook` (`empno`, `ename`, `proj_id`, `proj_start`, `proj_end`) VALUES
(7782, 'CLARK', 1, '2005-06-16', '2005-06-18'),
(7782, 'CLARK', 4, '2005-06-19', '2005-06-24'),
(7782, 'CLARK', 7, '2005-06-22', '2005-06-25'),
(7782, 'CLARK', 10, '2005-06-25', '2005-06-28'),
(7782, 'CLARK', 13, '2005-06-28', '2005-07-02'),
(7839, 'KING', 2, '2005-06-17', '2005-06-21'),
(7839, 'KING', 8, '2005-06-23', '2005-06-25'),
(7839, 'KING', 14, '2005-06-29', '2005-06-30'),
(7839, 'KING', 11, '2005-06-26', '2005-06-27'),
(7839, 'KING', 5, '2005-06-20', '2005-06-24'),
(7934, 'MILLER', 3, '2005-06-18', '2005-06-22'),
(7934, 'MILLER', 12, '2005-06-27', '2005-06-28'),
(7934, 'MILLER', 15, '2005-06-30', '2005-07-03'),
(7934, 'MILLER', 9, '2005-06-24', '2005-06-27'),
(7934, 'MILLER', 6, '2005-06-21', '2005-06-23'),
(1, '2020-01-01', 2020, NULL, NULL),
(2, '2020-01-02', 2020, NULL, NULL),
(3, '2020-01-03', 2020, NULL, NULL),
(4, '2020-01-04', 2020, NULL, NULL),
(5, '2020-01-06', 2020, NULL, NULL),
(6, '2020-01-16', 2020, NULL, NULL),
(7, '2020-01-17', 2020, NULL, NULL),
(8, '2020-01-18', 2020, NULL, NULL),
(9, '2020-01-19', 2020, NULL, NULL),
(10, '2020-01-21', 2020, NULL, NULL),
(11, '2020-01-26', 2020, NULL, NULL),
(12, '2020-01-27', 2020, NULL, NULL),
(13, '2020-01-28', 2020, NULL, NULL),
(14, '2020-01-29', 2020, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `emp_temp`
--

CREATE TABLE `emp_temp` (
  `employee_id` int(11) DEFAULT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `hire_date` varchar(255) DEFAULT NULL,
  `salary` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `foods`
--

CREATE TABLE `foods` (
  `item_id` int(11) DEFAULT NULL,
  `item_name` varchar(255) DEFAULT NULL,
  `item_unit` varchar(255) DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `foods`
--

INSERT INTO `foods` (`item_id`, `item_name`, `item_unit`, `company_id`) VALUES
(1, 'Chex Mix', 'Pcs', 16),
(6, 'Cheez-It', 'Pcs', 15),
(2, 'BN Biscuit', 'Pcs', 15),
(3, 'Mighty Munch', 'Pcs', 17),
(4, 'Pot Rice', 'Pcs', 15),
(5, 'Jaffa Cakes', 'Pcs', 18),
(7, 'Salt n Shake', 'Pcs', NULL),
(1, 'Chex Mix', 'Pcs', 16),
(6, 'Cheez-It', 'Pcs', 15),
(2, 'BN Biscuit', 'Pcs', 15),
(3, 'Mighty Munch', 'Pcs', 17),
(4, 'Pot Rice', 'Pcs', 15),
(5, 'Jaffa Cakes', 'Pcs', 18),
(7, 'Salt n Shake', 'Pcs', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `item_mast`
--

CREATE TABLE `item_mast` (
  `pro_id` int(11) DEFAULT NULL,
  `pro_name` varchar(255) DEFAULT NULL,
  `pro_price` float DEFAULT NULL,
  `pro_com` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `item_mast`
--

INSERT INTO `item_mast` (`pro_id`, `pro_name`, `pro_price`, `pro_com`) VALUES
(101, 'Mother Board', 3200, 15),
(102, 'Key Board', 450, 16),
(103, 'ZIP drive', 250, 14),
(104, 'Speaker', 550, 16),
(105, 'Monitor', 5000, 11),
(106, 'DVD drive', 900, 12),
(107, 'CD drive', 800, 12),
(108, 'Printer', 2600, 13),
(109, 'Refill cartridge', 350, 13),
(110, 'Mouse', 250, 12),
(101, 'Mother Board', 3200, 15),
(102, 'Key Board', 450, 16),
(103, 'ZIP drive', 250, 14),
(104, 'Speaker', 550, 16),
(105, 'Monitor', 5000, 11),
(106, 'DVD drive', 900, 12),
(107, 'CD drive', 800, 12),
(108, 'Printer', 2600, 13),
(109, 'Refill cartridge', 350, 13),
(110, 'Mouse', 250, 12);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `json_test_id`
--

CREATE TABLE `json_test_id` (
  `id` int(11) NOT NULL,
  `obj` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`obj`))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `json_test_id`
--

INSERT INTO `json_test_id` (`id`, `obj`) VALUES
(1, '{\"first field\": \"first_value\"}'),
(2, '{\"network\": [\"ADSL\", \"IOT\", \"HTTP\"], \"manufacturer\": \"HITACHI\", \"price\": \"430\", \"OS\": [\"vndos\", \"linux\", \"dos\"]}'),
(3, '{\"network\": [\"GSM\", \"CDMA\", \"EVDO\", \"HSPA\"]}'),
(4, '{\"network\": [\"GSM\", \"CDMA\", \"HSPA\", \"EVDO\"], \"body\": \"5.11 x 2.59 x 0.46 inches\", \"weight\": \"143 grams\", \"sim\": \"Micro-SIM\", \"display\": \"4.5 inches\", \"resolution\": \"720 x 1280 pixels\", \"os\": \"Android Jellybean v4.3\"}'),
(5, '{\"network\": [\"GSM\", \"CDMA\", \"HSPA\", \"EVDO\"]}'),
(6, '{\"screen\": \"120 inch\", \"resolution\": \"800 x 600 pixels\", \"ports\": {\"hdmi\": 1, \"usb\": 1, \"vga\": 1}, \"speakers\": {\"left\": 1, \"right\": 1, \"center\": 1, \"power\": \"20W\"}}'),
(7, '{\"screen\": \"40 inch\", \"resolution\": \"1920 x 1080 pixels\", \"ports\": {\"hdmi\": 1, \"usb\": 2, \"IDE\": 1}, \"speakers\": {\"left\": \"10 watt\", \"right\": \"10 watt\"}}'),
(8, '{\"sensor_type\": \"CMOS\", \"processor\": \"Digic DV II\", \"scanning_system\": \"progressive\", \"mount_type\": \"PL\", \"monitor_type\": \"LED\"}'),
(9, '{\"sensor_type\": \"CMOS\", \"processor\": \"Digic DV III\", \"scanning_system\": \"progressive\", \"mount_type\": \"PL\", \"monitor_type\": \"LCD\"}'),
(10, '{\"sales\":[{\"product_name\":\"product four\",\"vendor_id\":{\"id\":2},\"sale_amt\":150},{\"product_name\":\"product three\",\"vendor_id\":{\"id\":3},\"sale_amt\":2400},{\"product_name\":\"product two\",\"vendor_id\":{\"id\":1},\"sale_amt\":1600},{\"product_name\":\"product four\",\"vendor_id\":{\"id\":4},\"sale_amt\":450},{\"product_name\":\"product three\",\"vendor_id\":{\"id\":1},\"sale_amt\":600},{\"product_name\":\"product five\",\"vendor_id\":{\"id\":4},\"sale_amt\":4500},{\"product_name\":\"product four\",\"vendor_id\":{\"id\":4},\"sale_amt\":200},{\"product_name\":\"product three\",\"vendor_id\":{\"id\":5},\"sale_amt\":1500},{\"product_name\":\"product four\",\"vendor_id\":{\"id\":5},\"sale_amt\":250},{\"product_name\":\"product five\",\"vendor_id\":{\"id\":1},\"sale_amt\":5000},{\"product_name\":\"product two\",\"vendor_id\":{\"id\":3},\"sale_amt\":1800},{\"product_name\":\"product four\",\"vendor_id\":{\"id\":2},\"sale_amt\":250},{\"product_name\":\"product two\",\"vendor_id\":{\"id\":4},\"sale_amt\":1200},{\"product_name\":\"product four\",\"vendor_id\":{\"id\":1},\"sale_amt\":400},{\"product_name\":\"product five\",\"vendor_id\":{\"id\":5},\"sale_amt\":4000},{\"product_name\":\"product four\",\"vendor_id\":{\"id\":2},\"sale_amt\":250},{\"product_name\":\"product five\",\"vendor_id\":{\"id\":4},\"sale_amt\":2000},{\"product_name\":\"product three\",\"vendor_id\":{\"id\":2},\"sale_amt\":1200},{\"product_name\":\"product one\",\"vendor_id\":{\"id\":4},\"sale_amt\":2700},{\"product_name\":\"product three\",\"vendor_id\":{\"id\":3},\"sale_amt\":1800},{\"product_name\":\"product five\",\"vendor_id\":{\"id\":5},\"sale_amt\":5000},{\"product_name\":\"product five\",\"vendor_id\":{\"id\":4},\"sale_amt\":4000},{\"product_name\":\"product two\",\"vendor_id\":{\"id\":3},\"sale_amt\":1800},{\"product_name\":\"product two\",\"vendor_id\":{\"id\":5},\"sale_amt\":800},{\"product_name\":\"product two\",\"vendor_id\":{\"id\":2},\"sale_amt\":1800},{\"product_name\":\"product five\",\"vendor_id\":{\"id\":5},\"sale_amt\":4000},{\"product_name\":\"product one\",\"vendor_id\":{\"id\":4},\"sale_amt\":1800},{\"product_name\":\"product five\",\"vendor_id\":{\"id\":1},\"sale_amt\":5000},{\"product_name\":\"product three\",\"vendor_id\":{\"id\":5},\"sale_amt\":1800},{\"product_name\":\"product two\",\"vendor_id\":{\"id\":1},\"sale_amt\":400},{\"product_name\":\"product three\",\"vendor_id\":{\"id\":3},\"sale_amt\":2700},{\"product_name\":\"product two\",\"vendor_id\":{\"id\":3},\"sale_amt\":2000},{\"product_name\":\"product four\",\"vendor_id\":{\"id\":1},\"sale_amt\":100},{\"product_name\":\"product four\",\"vendor_id\":{\"id\":4},\"sale_amt\":300},{\"product_name\":\"product three\",\"vendor_id\":{\"id\":1},\"sale_amt\":1800},{\"product_name\":\"product five\",\"vendor_id\":{\"id\":2},\"sale_amt\":3000},{\"product_name\":\"product two\",\"vendor_id\":{\"id\":3},\"sale_amt\":800},{\"product_name\":\"product one\",\"vendor_id\":{\"id\":4},\"sale_amt\":2700},{\"product_name\":\"product one\",\"vendor_id\":{\"id\":4},\"sale_amt\":9000},{\"product_name\":\"product one\",\"vendor_id\":{\"id\":1},\"sale_amt\":900},{\"product_name\":\"product two\",\"vendor_id\":{\"id\":3},\"sale_amt\":1200},{\"product_name\":\"product two\",\"vendor_id\":{\"id\":2},\"sale_amt\":200},{\"product_name\":\"product four\",\"vendor_id\":{\"id\":1},\"sale_amt\":150},{\"product_name\":\"product three\",\"vendor_id\":{\"id\":1},\"sale_amt\":300},{\"product_name\":\"product one\",\"vendor_id\":{\"id\":1},\"sale_amt\":9000},{\"product_name\":\"product three\",\"vendor_id\":{\"id\":3},\"sale_amt\":1500},{\"product_name\":\"product four\",\"vendor_id\":{\"id\":4},\"sale_amt\":300},{\"product_name\":\"product four\",\"vendor_id\":{\"id\":3},\"sale_amt\":200},{\"product_name\":\"product one\",\"vendor_id\":{\"id\":5},\"sale_amt\":2700},{\"product_name\":\"product three\",\"vendor_id\":{\"id\":1},\"sale_amt\":2700},{\"product_name\":\"product three\",\"vendor_id\":{\"id\":4},\"sale_amt\":1800},{\"product_name\":\"product four\",\"vendor_id\":{\"id\":2},\"sale_amt\":500},{\"product_name\":\"product three\",\"vendor_id\":{\"id\":1},\"sale_amt\":1200},{\"product_name\":\"product three\",\"vendor_id\":{\"id\":3},\"sale_amt\":3000},{\"product_name\":\"product five\",\"vendor_id\":{\"id\":1},\"sale_amt\":3500},{\"product_name\":\"product two\",\"vendor_id\":{\"id\":3},\"sale_amt\":1400},{\"product_name\":\"product two\",\"vendor_id\":{\"id\":5},\"sale_amt\":1800},{\"product_name\":\"product four\",\"vendor_id\":{\"id\":2},\"sale_amt\":250},{\"product_name\":\"product five\",\"vendor_id\":{\"id\":1},\"sale_amt\":4500},{\"product_name\":\"product five\",\"vendor_id\":{\"id\":2},\"sale_amt\":500},{\"product_name\":\"product one\",\"vendor_id\":{\"id\":5},\"sale_amt\":5400},{\"product_name\":\"product three\",\"vendor_id\":{\"id\":3},\"sale_amt\":2400},{\"product_name\":\"product three\",\"vendor_id\":{\"id\":3},\"sale_amt\":1500},{\"product_name\":\"product five\",\"vendor_id\":{\"id\":3},\"sale_amt\":3500},{\"product_name\":\"product four\",\"vendor_id\":{\"id\":3},\"sale_amt\":100},{\"product_name\":\"product four\",\"vendor_id\":{\"id\":2},\"sale_amt\":500},{\"product_name\":\"product one\",\"vendor_id\":{\"id\":2},\"sale_amt\":4500},{\"product_name\":\"product four\",\"vendor_id\":{\"id\":1},\"sale_amt\":300},{\"product_name\":\"product four\",\"vendor_id\":{\"id\":5},\"sale_amt\":500},{\"product_name\":\"product two\",\"vendor_id\":{\"id\":5},\"sale_amt\":1000},{\"product_name\":\"product five\",\"vendor_id\":{\"id\":2},\"sale_amt\":1000},{\"product_name\":\"product two\",\"vendor_id\":{\"id\":3},\"sale_amt\":1400},{\"product_name\":\"product one\",\"vendor_id\":{\"id\":2},\"sale_amt\":2700},{\"product_name\":\"product two\",\"vendor_id\":{\"id\":5},\"sale_amt\":200},{\"product_name\":\"product two\",\"vendor_id\":{\"id\":1},\"sale_amt\":1800},{\"product_name\":\"product four\",\"vendor_id\":{\"id\":2},\"sale_amt\":50},{\"product_name\":\"product two\",\"vendor_id\":{\"id\":5},\"sale_amt\":1400},{\"product_name\":\"product four\",\"vendor_id\":{\"id\":5},\"sale_amt\":500},{\"product_name\":\"product five\",\"vendor_id\":{\"id\":4},\"sale_amt\":2000},{\"product_name\":\"product one\",\"vendor_id\":{\"id\":4},\"sale_amt\":8100},{\"product_name\":\"product five\",\"vendor_id\":{\"id\":1},\"sale_amt\":1000},{\"product_name\":\"product four\",\"vendor_id\":{\"id\":3},\"sale_amt\":200},{\"product_name\":\"product four\",\"vendor_id\":{\"id\":2},\"sale_amt\":350},{\"product_name\":\"product four\",\"vendor_id\":{\"id\":4},\"sale_amt\":200},{\"product_name\":\"product four\",\"vendor_id\":{\"id\":1},\"sale_amt\":300},{\"product_name\":\"product one\",\"vendor_id\":{\"id\":2},\"sale_amt\":2700},{\"product_name\":\"product three\",\"vendor_id\":{\"id\":1},\"sale_amt\":1800},{\"product_name\":\"product one\",\"vendor_id\":{\"id\":5},\"sale_amt\":5400},{\"product_name\":\"product five\",\"vendor_id\":{\"id\":4},\"sale_amt\":2000},{\"product_name\":\"product five\",\"vendor_id\":{\"id\":4},\"sale_amt\":4000},{\"product_name\":\"product four\",\"vendor_id\":{\"id\":2},\"sale_amt\":450},{\"product_name\":\"product four\",\"vendor_id\":{\"id\":3},\"sale_amt\":300},{\"product_name\":\"product four\",\"vendor_id\":{\"id\":1},\"sale_amt\":250},{\"product_name\":\"product five\",\"vendor_id\":{\"id\":4},\"sale_amt\":1500},{\"product_name\":\"product one\",\"vendor_id\":{\"id\":2},\"sale_amt\":9000},{\"product_name\":\"product one\",\"vendor_id\":{\"id\":2},\"sale_amt\":4500},{\"product_name\":\"product one\",\"vendor_id\":{\"id\":1},\"sale_amt\":1800},{\"product_name\":\"product three\",\"vendor_id\":{\"id\":1},\"sale_amt\":300},{\"product_name\":\"product four\",\"vendor_id\":{\"id\":4},\"sale_amt\":300},{\"product_name\":\"product four\",\"vendor_id\":{\"id\":5},\"sale_amt\":200}]}');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lag_test`
--

CREATE TABLE `lag_test` (
  `id` int(11) DEFAULT NULL,
  `seller_name` varchar(255) DEFAULT NULL,
  `sale_value` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `lag_test`
--

INSERT INTO `lag_test` (`id`, `seller_name`, `sale_value`) VALUES
(3, 'Stef', 7000),
(1, 'Alice', 12000),
(2, 'Mili', 25000),
(4, 'Jeff', 4500);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `loan_account`
--

CREATE TABLE `loan_account` (
  `user_id` int(11) DEFAULT NULL,
  `paid_amount` decimal(10,3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `loan_account`
--

INSERT INTO `loan_account` (`user_id`, `paid_amount`) VALUES
(7387438, '0.000'),
(123456, '110000.000');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `locations`
--

CREATE TABLE `locations` (
  `location_id` int(11) DEFAULT NULL,
  `street_address` varchar(255) DEFAULT NULL,
  `postal_code` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `state_province` varchar(255) DEFAULT NULL,
  `country_id` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `locations`
--

INSERT INTO `locations` (`location_id`, `street_address`, `postal_code`, `city`, `state_province`, `country_id`) VALUES
(1000, '1297 Via Cola di Rie', '989', 'Roma', NULL, 'IT'),
(1100, '93091 Calle della Testa', '10934', 'Venice', NULL, 'IT'),
(1200, '2017 Shinjuku-ku', '1689', 'Tokyo', 'Tokyo Prefecture', 'JP'),
(1300, '9450 Kamiya-cho', '6823', 'Hiroshima', NULL, 'JP'),
(1400, '2014 Jabberwocky Rd', '26192', 'Southlake', 'Texas', 'US'),
(1500, '2011 Interiors Blvd', '99236', 'South San Francisco', 'California', 'US'),
(1600, '2007 Zagora St', '50090', 'South Brunswick', 'New Jersey', 'US'),
(1700, '2004 Charade Rd', '98199', 'Seattle', 'Washington', 'US'),
(1800, '147 Spadina Ave', 'M5V 2L7', 'Toronto', 'Ontario', 'CA'),
(1900, '6092 Boxwood St', 'YSW 9T2', 'Whitehorse', 'Yukon', 'CA'),
(2000, '40-5-12 Laogianggen', '190518', 'Beijing', NULL, 'CN'),
(2100, '1298 Vileparle (E)', '490231', 'Bombay', 'Maharashtra', 'IN'),
(2200, '12-98 Victoria Street', '2901', 'Sydney', 'New South Wales', 'AU'),
(2300, '198 Clementi North', '540198', 'Singapore', NULL, 'SG'),
(2400, '8204 Arthur St', NULL, 'London', NULL, 'UK'),
(2500, 'Magdalen Centre, The Oxford Science Park', 'OX9 9ZB', 'Oxford', 'Oxford', 'UK'),
(2600, '9702 Chester Road', '9629850293', 'Stretford', 'Manchester', 'UK'),
(2700, 'Schwanthalerstr. 7031', '80925', 'Munich', 'Bavaria', 'DE'),
(2800, 'Rua Frei Caneca 1360', '01307-002', 'Sao Paulo', 'Sao Paulo', 'BR'),
(2900, '20 Rue des Corps-Saints', '1730', 'Geneva', 'Geneve', 'CH'),
(3000, 'Murtenstrasse 921', '3095', 'Bern', 'BE', 'CH'),
(3100, 'Pieter Breughelstraat 837', '3029SK', 'Utrecht', 'Utrecht', 'NL'),
(3200, 'Mariano Escobedo 9991', '11932', 'Mexico City', 'Distrito Federal', 'MX'),
(1000, '1297 Via Cola di Rie', '989', 'Roma', NULL, 'IT'),
(1100, '93091 Calle della Testa', '10934', 'Venice', NULL, 'IT'),
(1200, '2017 Shinjuku-ku', '1689', 'Tokyo', 'Tokyo Prefecture', 'JP'),
(1300, '9450 Kamiya-cho', '6823', 'Hiroshima', NULL, 'JP'),
(1400, '2014 Jabberwocky Rd', '26192', 'Southlake', 'Texas', 'US'),
(1500, '2011 Interiors Blvd', '99236', 'South San Francisco', 'California', 'US'),
(1600, '2007 Zagora St', '50090', 'South Brunswick', 'New Jersey', 'US'),
(1700, '2004 Charade Rd', '98199', 'Seattle', 'Washington', 'US'),
(1800, '147 Spadina Ave', 'M5V 2L7', 'Toronto', 'Ontario', 'CA'),
(1900, '6092 Boxwood St', 'YSW 9T2', 'Whitehorse', 'Yukon', 'CA'),
(2000, '40-5-12 Laogianggen', '190518', 'Beijing', NULL, 'CN'),
(2100, '1298 Vileparle (E)', '490231', 'Bombay', 'Maharashtra', 'IN'),
(2200, '12-98 Victoria Street', '2901', 'Sydney', 'New South Wales', 'AU'),
(2300, '198 Clementi North', '540198', 'Singapore', NULL, 'SG'),
(2400, '8204 Arthur St', NULL, 'London', NULL, 'UK'),
(2500, 'Magdalen Centre, The Oxford Science Park', 'OX9 9ZB', 'Oxford', 'Oxford', 'UK'),
(2600, '9702 Chester Road', '9629850293', 'Stretford', 'Manchester', 'UK'),
(2700, 'Schwanthalerstr. 7031', '80925', 'Munich', 'Bavaria', 'DE'),
(2800, 'Rua Frei Caneca 1360', '01307-002', 'Sao Paulo', 'Sao Paulo', 'BR'),
(2900, '20 Rue des Corps-Saints', '1730', 'Geneva', 'Geneve', 'CH'),
(3000, 'Murtenstrasse 921', '3095', 'Bern', 'BE', 'CH'),
(3100, 'Pieter Breughelstraat 837', '3029SK', 'Utrecht', 'Utrecht', 'NL'),
(3200, 'Mariano Escobedo 9991', '11932', 'Mexico City', 'Distrito Federal', 'MX');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `new1`
--

CREATE TABLE `new1` (
  `id` int(11) DEFAULT NULL,
  `col1` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `new1`
--

INSERT INTO `new1` (`id`, `col1`) VALUES
(2, 'a2'),
(5, 'a5'),
(3, 'a3'),
(1, NULL),
(4, 'a4'),
(2, 'a2'),
(5, 'a5'),
(3, 'a3'),
(1, NULL),
(4, 'a4');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `new2`
--

CREATE TABLE `new2` (
  `id` int(11) DEFAULT NULL,
  `col2` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `new2`
--

INSERT INTO `new2` (`id`, `col2`) VALUES
(5, 'b5'),
(1, 'b1'),
(3, NULL),
(6, 'b6'),
(2, 'b2'),
(5, 'c5'),
(5, 'b5'),
(1, 'b1'),
(3, NULL),
(6, 'b6'),
(2, 'b2'),
(5, 'c5');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `new_sal_cook`
--

CREATE TABLE `new_sal_cook` (
  `deptno` int(11) DEFAULT NULL,
  `sal` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `new_sal_cook`
--

INSERT INTO `new_sal_cook` (`deptno`, `sal`) VALUES
(10, 4000);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `nobel_win`
--

CREATE TABLE `nobel_win` (
  `year` int(11) DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `winner` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `category` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `nobel_win`
--

INSERT INTO `nobel_win` (`year`, `subject`, `winner`, `country`, `category`) VALUES
(1970, 'Physics', 'Hannes Alfven', 'Sweden', 'Scientist'),
(1970, 'Physics', 'Louis Neel', 'France', 'Scientist'),
(1970, 'Chemistry', 'Luis Federico Leloir', 'France', 'Scientist'),
(1970, 'Physiology', 'Ulf von Euler', 'Sweden', 'Scientist'),
(1970, 'Physiology', 'Bernard Katz', 'Germany', 'Scientist'),
(1970, 'Literature', 'Aleksandr Solzhenitsyn', 'Russia', 'Linguist'),
(1970, 'Economics', 'Paul Samuelson', 'USA', 'Economist'),
(1970, 'Physiology', 'Julius Axelrod', 'USA', 'Scientist'),
(1971, 'Physics', 'Dennis Gabor', 'Hungary', 'Scientist'),
(1971, 'Chemistry', 'Gerhard Herzberg', 'Germany', 'Scientist'),
(1971, 'Peace', 'Willy Brandt', 'Germany', 'Chancellor'),
(1971, 'Literature', 'Pablo Neruda', 'Chile', 'Linguist'),
(1971, 'Economics', 'Simon Kuznets', 'Russia', 'Economist'),
(1978, 'Peace', 'Anwar al-Sadat', 'Egypt', 'President'),
(1978, 'Peace', 'Menachem Begin', 'Israel', 'Prime Minister'),
(1987, 'Chemistry', 'Donald J. Cram', 'USA', 'Scientist'),
(1987, 'Chemistry', 'Jean-Marie Lehn', 'France', 'Scientist'),
(1987, 'Physiology', 'Susumu Tonegawa', 'Japan', 'Scientist'),
(1994, 'Economics', 'Reinhard Selten', 'Germany', 'Economist'),
(1994, 'Peace', 'Yitzhak Rabin', 'Israel', 'Prime Minister'),
(1987, 'Physics', 'Johannes Georg Bednorz', 'Germany', 'Scientist'),
(1987, 'Literature', 'Joseph Brodsky', 'Russia', 'Linguist'),
(1987, 'Economics', 'Robert Solow', 'USA', 'Economist'),
(1994, 'Literature', 'Kenzaburo Oe', 'Japan', 'Linguist'),
(1970, 'Physics', 'Hannes Alfven', 'Sweden', 'Scientist'),
(1970, 'Physics', 'Louis Neel', 'France', 'Scientist'),
(1970, 'Chemistry', 'Luis Federico Leloir', 'France', 'Scientist'),
(1970, 'Physiology', 'Ulf von Euler', 'Sweden', 'Scientist'),
(1970, 'Physiology', 'Bernard Katz', 'Germany', 'Scientist'),
(1970, 'Literature', 'Aleksandr Solzhenitsyn', 'Russia', 'Linguist'),
(1970, 'Economics', 'Paul Samuelson', 'USA', 'Economist'),
(1970, 'Physiology', 'Julius Axelrod', 'USA', 'Scientist'),
(1971, 'Physics', 'Dennis Gabor', 'Hungary', 'Scientist'),
(1971, 'Chemistry', 'Gerhard Herzberg', 'Germany', 'Scientist'),
(1971, 'Peace', 'Willy Brandt', 'Germany', 'Chancellor'),
(1971, 'Literature', 'Pablo Neruda', 'Chile', 'Linguist'),
(1971, 'Economics', 'Simon Kuznets', 'Russia', 'Economist'),
(1978, 'Peace', 'Anwar al-Sadat', 'Egypt', 'President'),
(1978, 'Peace', 'Menachem Begin', 'Israel', 'Prime Minister'),
(1987, 'Chemistry', 'Donald J. Cram', 'USA', 'Scientist'),
(1987, 'Chemistry', 'Jean-Marie Lehn', 'France', 'Scientist'),
(1987, 'Physiology', 'Susumu Tonegawa', 'Japan', 'Scientist'),
(1994, 'Economics', 'Reinhard Selten', 'Germany', 'Economist'),
(1994, 'Peace', 'Yitzhak Rabin', 'Israel', 'Prime Minister'),
(1987, 'Physics', 'Johannes Georg Bednorz', 'Germany', 'Scientist'),
(1987, 'Literature', 'Joseph Brodsky', 'Russia', 'Linguist'),
(1987, 'Economics', 'Robert Solow', 'USA', 'Economist'),
(1994, 'Literature', 'Kenzaburo Oe', 'Japan', 'Linguist');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `novel_books`
--

CREATE TABLE `novel_books` (
  `id` int(11) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `student_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `novel_books`
--

INSERT INTO `novel_books` (`id`, `name`, `student_id`) VALUES
(1, 'first novel', NULL),
(2, 'Second novel', 3),
(3, 'third novel', NULL),
(4, 'fourth novel', NULL),
(5, 'fifth novel', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `novel_students`
--

CREATE TABLE `novel_students` (
  `id` int(11) NOT NULL,
  `name` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `novel_students`
--

INSERT INTO `novel_students` (`id`, `name`) VALUES
(1, 'Anna'),
(2, 'Jeff'),
(3, 'Lili'),
(5, 'Yiyi');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `orders`
--

CREATE TABLE `orders` (
  `ord_num` int(11) DEFAULT NULL,
  `ord_amount` int(11) DEFAULT NULL,
  `advance_amount` int(11) DEFAULT NULL,
  `ord_date` varchar(255) DEFAULT NULL,
  `cust_code` varchar(255) DEFAULT NULL,
  `agent_code` varchar(255) DEFAULT NULL,
  `ord_description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `orders`
--

INSERT INTO `orders` (`ord_num`, `ord_amount`, `advance_amount`, `ord_date`, `cust_code`, `agent_code`, `ord_description`) VALUES
(200114, 3500, 2000, '15-AUG-08', 'C00002', 'A008', NULL),
(200122, 2500, 400, '16-SEP-08', 'C00003', 'A004', NULL),
(200118, 500, 100, '20-JUL-08', 'C00023', 'A006', NULL),
(200119, 4000, 700, '16-SEP-08', 'C00007', 'A010', NULL),
(200121, 1500, 600, '23-SEP-08', 'C00008', 'A004', NULL),
(200130, 2500, 400, '30-JUL-08', 'C00025', 'A011', NULL),
(200134, 4200, 1800, '25-SEP-08', 'C00004', 'A005', NULL),
(200108, 4000, 600, '15-FEB-08', 'C00008', 'A004', NULL),
(200103, 1500, 700, '15-MAY-08', 'C00021', 'A005', NULL),
(200105, 2500, 500, '18-JUL-08', 'C00025', 'A011', NULL),
(200109, 3500, 800, '30-JUL-08', 'C00011', 'A010', NULL),
(200101, 3000, 1000, '15-JUL-08', 'C00001', 'A008', NULL),
(200111, 1000, 300, '10-JUL-08', 'C00020', 'A008', NULL),
(200104, 1500, 500, '13-MAR-08', 'C00006', 'A004', NULL),
(200106, 2500, 700, '20-APR-08', 'C00005', 'A002', NULL),
(200125, 2000, 600, '10-OCT-08', 'C00018', 'A005', NULL),
(200117, 800, 200, '20-OCT-08', 'C00014', 'A001', NULL),
(200123, 500, 100, '16-SEP-08', 'C00022', 'A002', NULL),
(200120, 500, 100, '20-JUL-08', 'C00009', 'A002', NULL),
(200116, 500, 100, '13-JUL-08', 'C00010', 'A009', NULL),
(200124, 500, 100, '20-JUN-08', 'C00017', 'A007', NULL),
(200126, 500, 100, '24-JUN-08', 'C00022', 'A002', NULL),
(200129, 2500, 500, '20-JUL-08', 'C00024', 'A006', NULL),
(200127, 2500, 400, '20-JUL-08', 'C00015', 'A003', NULL),
(200128, 3500, 1500, '20-JUL-08', 'C00009', 'A002', NULL),
(200135, 2000, 800, '16-SEP-08', 'C00007', 'A010', NULL),
(200131, 900, 150, '26-AUG-08', 'C00012', 'A012', NULL),
(200133, 1200, 400, '29-JUN-08', 'C00009', 'A002', NULL),
(200100, 1000, 600, '08-JAN-08', 'C00015', 'A003', NULL),
(200110, 3000, 500, '15-APR-08', 'C00019', 'A010', NULL),
(200107, 4500, 900, '30-AUG-08', 'C00007', 'A010', NULL),
(200112, 2000, 400, '30-MAY-08', 'C00016', 'A007', NULL),
(200113, 4000, 600, '10-JUN-08', 'C00022', 'A002', NULL),
(200102, 2000, 300, '25-MAY-08', 'C00012', 'A012', NULL),
(200114, 3500, 2000, '15-AUG-08', 'C00002', 'A008', NULL),
(200122, 2500, 400, '16-SEP-08', 'C00003', 'A004', NULL),
(200118, 500, 100, '20-JUL-08', 'C00023', 'A006', NULL),
(200119, 4000, 700, '16-SEP-08', 'C00007', 'A010', NULL),
(200121, 1500, 600, '23-SEP-08', 'C00008', 'A004', NULL),
(200130, 2500, 400, '30-JUL-08', 'C00025', 'A011', NULL),
(200134, 4200, 1800, '25-SEP-08', 'C00004', 'A005', NULL),
(200108, 4000, 600, '15-FEB-08', 'C00008', 'A004', NULL),
(200103, 1500, 700, '15-MAY-08', 'C00021', 'A005', NULL),
(200105, 2500, 500, '18-JUL-08', 'C00025', 'A011', NULL),
(200109, 3500, 800, '30-JUL-08', 'C00011', 'A010', NULL),
(200101, 3000, 1000, '15-JUL-08', 'C00001', 'A008', NULL),
(200111, 1000, 300, '10-JUL-08', 'C00020', 'A008', NULL),
(200104, 1500, 500, '13-MAR-08', 'C00006', 'A004', NULL),
(200106, 2500, 700, '20-APR-08', 'C00005', 'A002', NULL),
(200125, 2000, 600, '10-OCT-08', 'C00018', 'A005', NULL),
(200117, 800, 200, '20-OCT-08', 'C00014', 'A001', NULL),
(200123, 500, 100, '16-SEP-08', 'C00022', 'A002', NULL),
(200120, 500, 100, '20-JUL-08', 'C00009', 'A002', NULL),
(200116, 500, 100, '13-JUL-08', 'C00010', 'A009', NULL),
(200124, 500, 100, '20-JUN-08', 'C00017', 'A007', NULL),
(200126, 500, 100, '24-JUN-08', 'C00022', 'A002', NULL),
(200129, 2500, 500, '20-JUL-08', 'C00024', 'A006', NULL),
(200127, 2500, 400, '20-JUL-08', 'C00015', 'A003', NULL),
(200128, 3500, 1500, '20-JUL-08', 'C00009', 'A002', NULL),
(200135, 2000, 800, '16-SEP-08', 'C00007', 'A010', NULL),
(200131, 900, 150, '26-AUG-08', 'C00012', 'A012', NULL),
(200133, 1200, 400, '29-JUN-08', 'C00009', 'A002', NULL),
(200100, 1000, 600, '08-JAN-08', 'C00015', 'A003', NULL),
(200110, 3000, 500, '15-APR-08', 'C00019', 'A010', NULL),
(200107, 4500, 900, '30-AUG-08', 'C00007', 'A010', NULL),
(200112, 2000, 400, '30-MAY-08', 'C00016', 'A007', NULL),
(200113, 4000, 600, '10-JUN-08', 'C00022', 'A002', NULL),
(200102, 2000, 300, '25-MAY-08', 'C00012', 'A012', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `orders2`
--

CREATE TABLE `orders2` (
  `ord_no` int(11) DEFAULT NULL,
  `purch_amt` float DEFAULT NULL,
  `ord_date` date DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `salesman_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `orders2`
--

INSERT INTO `orders2` (`ord_no`, `purch_amt`, `ord_date`, `customer_id`, `salesman_id`) VALUES
(70001, 150.5, '2012-10-05', 3005, 5002),
(70009, 270.65, '2012-09-10', 3001, 5005),
(70002, 65.26, '2012-10-05', 3002, 5001),
(70004, 110.5, '2012-08-17', 3009, 5003),
(70007, 948.5, '2012-09-10', 3005, 5002),
(70005, 2400.6, '2012-07-27', 3007, 5001),
(70008, 5760, '2012-09-10', 3002, 5001),
(70010, 1983.43, '2012-10-10', 3004, 5006),
(70003, 2480.4, '2012-10-10', 3009, 5003),
(70012, 250.45, '2012-06-27', 3008, 5002),
(70011, 75.29, '2012-08-17', 3003, 5007),
(70013, 3045.6, '2012-04-25', 3002, 5001),
(70001, 150.5, '2012-10-05', 3005, 5002),
(70009, 270.65, '2012-09-10', 3001, 5005),
(70002, 65.26, '2012-10-05', 3002, 5001),
(70004, 110.5, '2012-08-17', 3009, 5003),
(70007, 948.5, '2012-09-10', 3005, 5002),
(70005, 2400.6, '2012-07-27', 3007, 5001),
(70008, 5760, '2012-09-10', 3002, 5001),
(70010, 1983.43, '2012-10-10', 3004, 5006),
(70003, 2480.4, '2012-10-10', 3009, 5003),
(70012, 250.45, '2012-06-27', 3008, 5002),
(70011, 75.29, '2012-08-17', 3003, 5007),
(70013, 3045.6, '2012-04-25', 3002, 5001);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `payment`
--

CREATE TABLE `payment` (
  `payment_id` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `staff_id` int(11) DEFAULT NULL,
  `rental_id` int(11) DEFAULT NULL,
  `amount` decimal(5,2) DEFAULT NULL,
  `payment_ts` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `payment`
--

INSERT INTO `payment` (`payment_id`, `customer_id`, `staff_id`, `rental_id`, `amount`, `payment_ts`) VALUES
(16077, 279, 2, 1019, '0.99', '2020-05-31 03:05:07'),
(16078, 280, 1, 1014, '4.99', '2020-05-31 02:39:16'),
(16079, 281, 2, 650, '2.99', '2020-05-28 19:45:40'),
(16080, 281, 2, 754, '2.99', '2020-05-29 10:18:59'),
(16081, 282, 2, 48, '1.99', '2020-05-25 06:20:46');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `project_view`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `project_view` (
`proj_id` int(11)
,`proj_start` date
,`proj_end` date
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proj_cook`
--

CREATE TABLE `proj_cook` (
  `empno` int(11) DEFAULT NULL,
  `proj_start` date DEFAULT NULL,
  `proj_end` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `proj_cook`
--

INSERT INTO `proj_cook` (`empno`, `proj_start`, `proj_end`) VALUES
(1, '2020-01-01', '2020-01-02'),
(2, '2020-01-02', '2020-01-03'),
(3, '2020-01-03', '2020-01-04'),
(4, '2020-01-04', '2020-01-05'),
(5, '2020-01-06', '2020-01-07'),
(6, '2020-01-16', '2020-01-17'),
(7, '2020-01-17', '2020-01-18'),
(8, '2020-01-18', '2020-01-19'),
(9, '2020-01-19', '2020-01-20'),
(10, '2020-01-21', '2020-01-22'),
(11, '2020-01-26', '2020-01-27'),
(12, '2020-01-27', '2020-01-28'),
(13, '2020-01-28', '2020-01-29'),
(14, '2020-01-29', '2020-01-30');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rank_ex`
--

CREATE TABLE `rank_ex` (
  `id` int(11) DEFAULT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `month` int(11) DEFAULT NULL,
  `sold_products` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `rank_ex`
--

INSERT INTO `rank_ex` (`id`, `first_name`, `last_name`, `month`, `sold_products`) VALUES
(1, 'Lisa', 'Black', 5, 2300),
(2, 'Mary', 'Jacobs', 5, 2400),
(3, 'Lisa', 'Black', 6, 2700),
(4, 'Mary', 'Jacobs', 6, 2700),
(5, 'Alex', 'Smith', 6, 2900),
(6, 'Mary', 'Jacobs', 7, 1200),
(7, 'Lisa', 'Black', 7, 1200),
(8, 'Alex', 'Smith', 7, 1000);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `salesman`
--

CREATE TABLE `salesman` (
  `salesman_id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `comission` decimal(3,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `salesman`
--

INSERT INTO `salesman` (`salesman_id`, `name`, `city`, `comission`) VALUES
(5001, 'James Hoog', 'New York', '0.15'),
(5002, 'Nail Knite', 'Paris', '0.13'),
(5003, 'Lauson Hen', 'San Jose', '0.12'),
(5005, 'Pit Alex', 'London', '0.11'),
(5006, 'Mc Lyon', 'Paris', '0.14'),
(5007, 'Paul Adam', 'Rome', '0.13');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `shape_view`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `shape_view` (
`deptno` decimal(2,0)
,`count` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `single_column`
--

CREATE TABLE `single_column` (
  `column` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `single_column`
--

INSERT INTO `single_column` (`column`) VALUES
('A001/DJ-402\\44_/100/2015'),
('A001_\\DJ-402\\44_/100/2015'),
('A001_DJ-402-2014-2015'),
('A002_DJ-401-2014-2015'),
('A001/DJ_401'),
('A001/DJ_402\\44'),
('A001/DJ_402\\44\\2015'),
('A001/DJ-402%45\\2015/200'),
('A001/DJ_402\\45\\2015%100'),
('A001/DJ_402%45\\2015/300'),
('A001/DJ-402\\44'),
('A001/DJ-402\\44_/100/2015'),
('A001_\\DJ-402\\44_/100/2015'),
('A001_DJ-402-2014-2015'),
('A002_DJ-401-2014-2015'),
('A001/DJ_401'),
('A001/DJ_402\\44'),
('A001/DJ_402\\44\\2015'),
('A001/DJ-402%45\\2015/200'),
('A001/DJ_402\\45\\2015%100'),
('A001/DJ_402%45\\2015/300'),
('A001/DJ-402\\44');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `students`
--

CREATE TABLE `students` (
  `id` int(11) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `course_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `students`
--

INSERT INTO `students` (`id`, `name`, `course_id`) VALUES
(1, 'Anna', 4),
(2, 'Jeff', 3),
(3, 'Lili', 2),
(5, 'Yiyi', 5),
(6, 'New Girl', 4),
(7, 'New Lady', 4);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `students2`
--

CREATE TABLE `students2` (
  `id` int(11) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `course_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `students2`
--

INSERT INTO `students2` (`id`, `name`, `course_id`) VALUES
(1, 'Anna', 4),
(2, 'Jeff', 3),
(3, 'Lili', 2),
(4, 'Ed', 1),
(5, 'Yiyi', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `t`
--

CREATE TABLE `t` (
  `id` int(11) NOT NULL,
  `s` varchar(40) DEFAULT NULL,
  `si` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `t`
--

INSERT INTO `t` (`id`, `s`, `si`) VALUES
(1, 'first', NULL),
(8, 'eight', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `t2`
--

CREATE TABLE `t2` (
  `id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `t3`
--

CREATE TABLE `t3` (
  `id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `t10`
--

CREATE TABLE `t10` (
  `id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `t10`
--

INSERT INTO `t10` (`id`) VALUES
(1),
(2),
(3),
(4),
(5),
(6),
(7),
(8),
(9),
(10);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `table_a`
--

CREATE TABLE `table_a` (
  `a` int(11) DEFAULT NULL,
  `m` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `table_a`
--

INSERT INTO `table_a` (`a`, `m`) VALUES
(1, 'm'),
(2, 'n'),
(4, 'o'),
(1, 'm'),
(2, 'n'),
(4, 'o');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `table_b`
--

CREATE TABLE `table_b` (
  `a` int(11) DEFAULT NULL,
  `n` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `table_b`
--

INSERT INTO `table_b` (`a`, `n`) VALUES
(2, 'p'),
(3, 'q'),
(5, 'r'),
(2, 'p'),
(3, 'q'),
(5, 'r');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `test`
--

CREATE TABLE `test` (
  `str` varchar(255) DEFAULT NULL,
  `number1` int(11) DEFAULT NULL,
  `number2` int(11) DEFAULT NULL,
  `number3` int(11) DEFAULT NULL,
  `id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `test`
--

INSERT INTO `test` (`str`, `number1`, `number2`, `number3`, `id`) VALUES
('This is SQL Exercise, Practice and Solution', NULL, NULL, NULL, NULL),
(NULL, 10, 15, 3, 1),
(NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `test2`
--

CREATE TABLE `test2` (
  `id` int(11) NOT NULL,
  `new_column2` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `test2`
--

INSERT INTO `test2` (`id`, `new_column2`) VALUES
(0, 'OK'),
(2, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `test3`
--

CREATE TABLE `test3` (
  `new_column2` varchar(200) DEFAULT NULL,
  `test_column` char(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `test3`
--

INSERT INTO `test3` (`new_column2`, `test_column`) VALUES
('field', NULL),
(NULL, 'Hi World');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `test_hobbies`
--

CREATE TABLE `test_hobbies` (
  `id` int(11) DEFAULT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `test_keys`
--

CREATE TABLE `test_keys` (
  `id` int(11) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `hobby` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `test_view`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `test_view` (
`ord_num` int(11)
,`working_area` varchar(255)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `transaction_details`
--

CREATE TABLE `transaction_details` (
  `user_id` int(11) DEFAULT NULL,
  `amount` decimal(10,3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `transaction_details`
--

INSERT INTO `transaction_details` (`user_id`, `amount`) VALUES
(7387438, '50000.000'),
(123456, '100000.000'),
(123456, '10000.000');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `trig_comissions`
--

CREATE TABLE `trig_comissions` (
  `id` int(11) NOT NULL,
  `vendor_id` int(11) DEFAULT NULL,
  `group_com` decimal(6,3) DEFAULT NULL,
  `ind_com` decimal(8,3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `trig_comissions`
--

INSERT INTO `trig_comissions` (`id`, `vendor_id`, `group_com`, `ind_com`) VALUES
(1, 3, '120.000', '240.000'),
(2, 1, '80.000', '160.000'),
(3, 4, '22.500', '45.000'),
(4, 1, '30.000', '60.000'),
(5, 4, '225.000', '450.000'),
(6, 4, '10.000', '20.000'),
(7, 5, '75.000', '150.000'),
(8, 5, '12.500', '25.000'),
(9, 1, '250.000', '500.000'),
(10, 3, '90.000', '180.000'),
(11, 2, '12.500', '25.000'),
(12, 4, '60.000', '120.000'),
(13, 1, '20.000', '40.000'),
(14, 5, '200.000', '400.000'),
(15, 2, '12.500', '25.000'),
(16, 4, '100.000', '200.000'),
(17, 2, '7.500', '15.000'),
(18, 4, '135.000', '270.000'),
(19, 3, '90.000', '180.000'),
(20, 5, '250.000', '500.000'),
(21, 4, '200.000', '400.000'),
(22, 3, '90.000', '180.000'),
(23, 5, '40.000', '80.000'),
(24, 2, '90.000', '180.000'),
(25, 5, '200.000', '400.000'),
(26, 4, '90.000', '180.000'),
(27, 1, '250.000', '500.000'),
(28, 5, '90.000', '180.000'),
(29, 1, '20.000', '40.000'),
(30, 3, '135.000', '270.000'),
(31, 3, '100.000', '200.000'),
(32, 1, '5.000', '10.000'),
(33, 4, '15.000', '30.000'),
(34, 1, '90.000', '180.000'),
(35, 2, '150.000', '300.000'),
(36, 3, '40.000', '80.000'),
(37, 4, '135.000', '270.000'),
(38, 4, '450.000', '900.000'),
(39, 1, '45.000', '90.000'),
(40, 3, '60.000', '120.000'),
(41, 2, '10.000', '20.000'),
(42, 1, '7.500', '15.000'),
(43, 1, '15.000', '30.000'),
(44, 1, '450.000', '900.000'),
(45, 3, '75.000', '150.000'),
(46, 4, '15.000', '30.000'),
(47, 3, '10.000', '20.000'),
(48, 5, '135.000', '270.000'),
(49, 1, '135.000', '270.000'),
(50, 4, '90.000', '180.000'),
(51, 2, '25.000', '50.000'),
(52, 1, '60.000', '120.000'),
(53, 3, '150.000', '300.000'),
(54, 1, '175.000', '350.000'),
(55, 3, '70.000', '140.000'),
(56, 5, '90.000', '180.000'),
(57, 2, '12.500', '25.000'),
(58, 1, '225.000', '450.000'),
(59, 2, '25.000', '50.000'),
(60, 5, '270.000', '540.000'),
(61, 3, '120.000', '240.000'),
(62, 3, '75.000', '150.000'),
(63, 3, '175.000', '350.000'),
(64, 3, '5.000', '10.000'),
(65, 2, '25.000', '50.000'),
(66, 2, '225.000', '450.000'),
(67, 1, '15.000', '30.000'),
(68, 5, '25.000', '50.000'),
(69, 5, '50.000', '100.000'),
(70, 2, '50.000', '100.000'),
(71, 3, '70.000', '140.000'),
(72, 2, '135.000', '270.000'),
(73, 5, '10.000', '20.000'),
(74, 1, '90.000', '180.000'),
(75, 2, '2.500', '5.000'),
(76, 5, '70.000', '140.000'),
(77, 5, '25.000', '50.000'),
(78, 4, '100.000', '200.000'),
(79, 4, '405.000', '810.000'),
(80, 1, '50.000', '100.000'),
(81, 3, '10.000', '20.000'),
(82, 2, '17.500', '35.000'),
(83, 4, '10.000', '20.000'),
(84, 1, '15.000', '30.000'),
(85, 2, '135.000', '270.000'),
(86, 1, '90.000', '180.000'),
(87, 5, '270.000', '540.000'),
(88, 4, '100.000', '200.000'),
(89, 4, '200.000', '400.000'),
(90, 2, '22.500', '45.000'),
(91, 3, '15.000', '30.000'),
(92, 1, '12.500', '25.000'),
(93, 4, '75.000', '150.000'),
(94, 2, '450.000', '900.000'),
(95, 2, '225.000', '450.000'),
(96, 1, '90.000', '180.000'),
(97, 1, '15.000', '30.000'),
(98, 4, '15.000', '30.000'),
(99, 5, '10.000', '20.000');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `trig_sales`
--

CREATE TABLE `trig_sales` (
  `id` int(11) NOT NULL,
  `vendor_id` int(11) DEFAULT NULL,
  `product_name` varchar(50) DEFAULT NULL,
  `sale_amt` decimal(8,3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `trig_sales`
--

INSERT INTO `trig_sales` (`id`, `vendor_id`, `product_name`, `sale_amt`) VALUES
(1, 3, '\"product three\"', '2400.000'),
(2, 1, '\"product two\"', '1600.000'),
(3, 4, '\"product four\"', '450.000'),
(4, 1, '\"product three\"', '600.000'),
(5, 4, '\"product five\"', '4500.000'),
(6, 4, '\"product four\"', '200.000'),
(7, 5, '\"product three\"', '1500.000'),
(8, 5, '\"product four\"', '250.000'),
(9, 1, '\"product five\"', '5000.000'),
(10, 3, '\"product two\"', '1800.000'),
(11, 2, '\"product four\"', '250.000'),
(12, 4, '\"product two\"', '1200.000'),
(13, 1, '\"product four\"', '400.000'),
(14, 5, '\"product five\"', '4000.000'),
(15, 2, '\"product four\"', '250.000'),
(16, 4, '\"product five\"', '2000.000'),
(17, 2, '\"product four\"', '150.000'),
(18, 4, '\"product one\"', '2700.000'),
(19, 3, '\"product three\"', '1800.000'),
(20, 5, '\"product five\"', '5000.000'),
(21, 4, '\"product five\"', '4000.000'),
(22, 3, '\"product two\"', '1800.000'),
(23, 5, '\"product two\"', '800.000'),
(24, 2, '\"product two\"', '1800.000'),
(25, 5, '\"product five\"', '4000.000'),
(26, 4, '\"product one\"', '1800.000'),
(27, 1, '\"product five\"', '5000.000'),
(28, 5, '\"product three\"', '1800.000'),
(29, 1, '\"product two\"', '400.000'),
(30, 3, '\"product three\"', '2700.000'),
(31, 3, '\"product two\"', '2000.000'),
(32, 1, '\"product four\"', '100.000'),
(33, 4, '\"product four\"', '300.000'),
(34, 1, '\"product three\"', '1800.000'),
(35, 2, '\"product five\"', '3000.000'),
(36, 3, '\"product two\"', '800.000'),
(37, 4, '\"product one\"', '2700.000'),
(38, 4, '\"product one\"', '9000.000'),
(39, 1, '\"product one\"', '900.000'),
(40, 3, '\"product two\"', '1200.000'),
(41, 2, '\"product two\"', '200.000'),
(42, 1, '\"product four\"', '150.000'),
(43, 1, '\"product three\"', '300.000'),
(44, 1, '\"product one\"', '9000.000'),
(45, 3, '\"product three\"', '1500.000'),
(46, 4, '\"product four\"', '300.000'),
(47, 3, '\"product four\"', '200.000'),
(48, 5, '\"product one\"', '2700.000'),
(49, 1, '\"product three\"', '2700.000'),
(50, 4, '\"product three\"', '1800.000'),
(51, 2, '\"product four\"', '500.000'),
(52, 1, '\"product three\"', '1200.000'),
(53, 3, '\"product three\"', '3000.000'),
(54, 1, '\"product five\"', '3500.000'),
(55, 3, '\"product two\"', '1400.000'),
(56, 5, '\"product two\"', '1800.000'),
(57, 2, '\"product four\"', '250.000'),
(58, 1, '\"product five\"', '4500.000'),
(59, 2, '\"product five\"', '500.000'),
(60, 5, '\"product one\"', '5400.000'),
(61, 3, '\"product three\"', '2400.000'),
(62, 3, '\"product three\"', '1500.000'),
(63, 3, '\"product five\"', '3500.000'),
(64, 3, '\"product four\"', '100.000'),
(65, 2, '\"product four\"', '500.000'),
(66, 2, '\"product one\"', '4500.000'),
(67, 1, '\"product four\"', '300.000'),
(68, 5, '\"product four\"', '500.000'),
(69, 5, '\"product two\"', '1000.000'),
(70, 2, '\"product five\"', '1000.000'),
(71, 3, '\"product two\"', '1400.000'),
(72, 2, '\"product one\"', '2700.000'),
(73, 5, '\"product two\"', '200.000'),
(74, 1, '\"product two\"', '1800.000'),
(75, 2, '\"product four\"', '50.000'),
(76, 5, '\"product two\"', '1400.000'),
(77, 5, '\"product four\"', '500.000'),
(78, 4, '\"product five\"', '2000.000'),
(79, 4, '\"product one\"', '8100.000'),
(80, 1, '\"product five\"', '1000.000'),
(81, 3, '\"product four\"', '200.000'),
(82, 2, '\"product four\"', '350.000'),
(83, 4, '\"product four\"', '200.000'),
(84, 1, '\"product four\"', '300.000'),
(85, 2, '\"product one\"', '2700.000'),
(86, 1, '\"product three\"', '1800.000'),
(87, 5, '\"product one\"', '5400.000'),
(88, 4, '\"product five\"', '2000.000'),
(89, 4, '\"product five\"', '4000.000'),
(90, 2, '\"product four\"', '450.000'),
(91, 3, '\"product four\"', '300.000'),
(92, 1, '\"product four\"', '250.000'),
(93, 4, '\"product five\"', '1500.000'),
(94, 2, '\"product one\"', '9000.000'),
(95, 2, '\"product one\"', '4500.000'),
(96, 1, '\"product one\"', '1800.000'),
(97, 1, '\"product three\"', '300.000'),
(98, 4, '\"product four\"', '300.000'),
(99, 5, '\"product four\"', '200.000');

--
-- Disparadores `trig_sales`
--
DELIMITER $$
CREATE TRIGGER `trig_sal_com_au` AFTER INSERT ON `trig_sales` FOR EACH ROW BEGIN
INSERT INTO trig_comissions VALUES (NEW.id, NEW.vendor_id, (NEW.sale_amt*0.05), (NEW.sale_amt*0.1));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `turing_department`
--

CREATE TABLE `turing_department` (
  `id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `turing_department`
--

INSERT INTO `turing_department` (`id`, `name`) VALUES
(1, 'human resources'),
(2, 'information technologies'),
(3, 'management'),
(4, 'advertising'),
(5, 'logistics');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `turing_employee`
--

CREATE TABLE `turing_employee` (
  `id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `salary` int(11) DEFAULT NULL,
  `departmentid` int(11) DEFAULT NULL,
  `income_percentage` decimal(8,3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `turing_employee`
--

INSERT INTO `turing_employee` (`id`, `name`, `salary`, `departmentid`, `income_percentage`) VALUES
(1, 'susana', 7500, 3, '5.885'),
(2, 'cesar', 8050, 3, '6.317'),
(3, 'raul', 6800, 3, '5.336'),
(4, 'paul', 6500, 3, '5.101'),
(5, 'donald', 5000, 1, '3.924'),
(6, 'clara', 4500, 1, '3.531'),
(7, 'marie', 4400, 1, '3.453'),
(8, 'penelope', 4200, 1, '3.296'),
(9, 'dan', 6900, 2, '5.414'),
(10, 'glorie', 7475, 2, '5.866'),
(11, 'christine', 7245, 2, '5.685'),
(12, 'diana', 7130, 2, '5.595'),
(13, 'peter', 6785, 2, '5.324'),
(14, 'anton', 3450, 4, '2.707'),
(15, 'williams', 3680, 4, '2.888'),
(16, 'charles', 3910, 4, '3.068'),
(17, 'jean', 4140, 4, '3.249'),
(18, 'johann', 3795, 5, '2.978'),
(19, 'wolfgang', 3600, 5, '2.825'),
(19, 'alex', 3900, 5, '3.060'),
(20, 'luigi', 4200, 5, '3.296'),
(21, 'cesar', 8777, 2, '6.887'),
(22, 'carmilla', 5500, 4, '4.316');

--
-- Disparadores `turing_employee`
--
DELIMITER $$
CREATE TRIGGER `insert_turing_emp` AFTER INSERT ON `turing_employee` FOR EACH ROW BEGIN
UPDATE turing_employee SET income_percentage = (salary/(SELECT SUM(salary) FROM turing_employee)*100) WHERE id != NEW.id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `turing_test`
--

CREATE TABLE `turing_test` (
  `id` int(11) DEFAULT NULL,
  `salary` int(11) DEFAULT NULL,
  `income_percentage` decimal(8,3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `turing_test`
--

INSERT INTO `turing_test` (`id`, `salary`, `income_percentage`) VALUES
(1, 100, NULL),
(2, 200, NULL),
(3, 300, NULL);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v` (
`ENAME` varchar(255)
,`JOB` varchar(255)
,`SAL` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `view1`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `view1` (
`deptno` int(11)
,`ename` varchar(255)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `emp_cook_v1`
--
DROP TABLE IF EXISTS `emp_cook_v1`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `emp_cook_v1`  AS  (select `emp_cook`.`job` AS `job`,count(0) AS `COUNT(*)` from `emp_cook` group by `emp_cook`.`job` order by count(0) desc) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `project_view`
--
DROP TABLE IF EXISTS `project_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `project_view`  AS  select `emp_project_cook`.`proj_id` AS `proj_id`,`emp_project_cook`.`proj_start` AS `proj_start`,`emp_project_cook`.`proj_end` AS `proj_end` from `emp_project_cook` order by `emp_project_cook`.`proj_id` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `shape_view`
--
DROP TABLE IF EXISTS `shape_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `shape_view`  AS  (select `emp_cook`.`deptno` AS `deptno`,count(0) AS `count` from `emp_cook` where `emp_cook`.`deptno` is not null group by `emp_cook`.`deptno`) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `test_view`
--
DROP TABLE IF EXISTS `test_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `test_view`  AS  (select `a`.`ord_num` AS `ord_num`,`b`.`working_area` AS `working_area` from (`orders` `a` join `agents` `b` on(`a`.`agent_code` = `b`.`agent_code`)) where `a`.`agent_code` = 'A009') ;

-- --------------------------------------------------------

--
-- Estructura para la vista `v`
--
DROP TABLE IF EXISTS `v`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v`  AS  (select `employee_cook`.`ENAME` AS `ENAME`,`employee_cook`.`JOB` AS `JOB`,`employee_cook`.`SAL` AS `SAL` from `employee_cook` where `employee_cook`.`JOB` like 'CLERK') ;

-- --------------------------------------------------------

--
-- Estructura para la vista `view1`
--
DROP TABLE IF EXISTS `view1`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view1`  AS  select `b`.`DEPTNO` AS `deptno`,`a`.`ENAME` AS `ename` from (`employee_cook` `a` join `dept_cook` `b` on(`a`.`DEPTNO` = `b`.`DEPTNO`)) order by `b`.`DEPTNO` ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `employees`
--
ALTER TABLE `employees`
  ADD KEY `department_salary_index` (`department_id`,`salary`);

--
-- Indices de la tabla `json_test_id`
--
ALTER TABLE `json_test_id`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `novel_books`
--
ALTER TABLE `novel_books`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_id` (`student_id`);

--
-- Indices de la tabla `novel_students`
--
ALTER TABLE `novel_students`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `salesman`
--
ALTER TABLE `salesman`
  ADD PRIMARY KEY (`salesman_id`);

--
-- Indices de la tabla `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`id`),
  ADD KEY `course_id` (`course_id`);

--
-- Indices de la tabla `t`
--
ALTER TABLE `t`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `test2`
--
ALTER TABLE `test2`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `test_hobbies`
--
ALTER TABLE `test_hobbies`
  ADD PRIMARY KEY (`name`);

--
-- Indices de la tabla `test_keys`
--
ALTER TABLE `test_keys`
  ADD PRIMARY KEY (`id`),
  ADD KEY `hobby` (`hobby`);

--
-- Indices de la tabla `trig_comissions`
--
ALTER TABLE `trig_comissions`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `trig_sales`
--
ALTER TABLE `trig_sales`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `turing_department`
--
ALTER TABLE `turing_department`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `turing_employee`
--
ALTER TABLE `turing_employee`
  ADD KEY `departmentid` (`departmentid`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `json_test_id`
--
ALTER TABLE `json_test_id`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `salesman`
--
ALTER TABLE `salesman`
  MODIFY `salesman_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5008;

--
-- AUTO_INCREMENT de la tabla `trig_comissions`
--
ALTER TABLE `trig_comissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=100;

--
-- AUTO_INCREMENT de la tabla `trig_sales`
--
ALTER TABLE `trig_sales`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=100;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `novel_books`
--
ALTER TABLE `novel_books`
  ADD CONSTRAINT `novel_books_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `novel_students` (`id`);

--
-- Filtros para la tabla `students`
--
ALTER TABLE `students`
  ADD CONSTRAINT `students_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `test_keys`
--
ALTER TABLE `test_keys`
  ADD CONSTRAINT `test_keys_ibfk_1` FOREIGN KEY (`hobby`) REFERENCES `test_hobbies` (`name`);

--
-- Filtros para la tabla `trig_comissions`
--
ALTER TABLE `trig_comissions`
  ADD CONSTRAINT `trig_comissions_ibfk_1` FOREIGN KEY (`id`) REFERENCES `trig_sales` (`id`);

--
-- Filtros para la tabla `turing_employee`
--
ALTER TABLE `turing_employee`
  ADD CONSTRAINT `turing_employee_ibfk_1` FOREIGN KEY (`departmentid`) REFERENCES `turing_department` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
