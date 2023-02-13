-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: May 01, 2022 at 04:32 PM
-- Server version: 10.4.22-MariaDB
-- PHP Version: 8.1.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `challenge`
--

-- --------------------------------------------------------

--
-- Table structure for table `actor_test`
--

CREATE TABLE `actor_test` (
  `act_id_id` int(11) DEFAULT NULL,
  `act_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `actor_test`
--

INSERT INTO `actor_test` (`act_id_id`, `act_name`) VALUES
(101, 'James Stewart'),
(102, 'Deborah Kerr'),
(103, 'Peter OToole'),
(104, 'Robert De Niro'),
(105, 'F. Murray Abraham'),
(106, 'Harrison Ford'),
(107, 'Bill Paxton'),
(108, 'Stephen Baldwin'),
(109, 'Jack Nicholson'),
(110, 'Mark Wahlberg');

-- --------------------------------------------------------

--
-- Table structure for table `address`
--

CREATE TABLE `address` (
  `address_id` int(11) DEFAULT NULL,
  `salesperson_id` int(11) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `address`
--

INSERT INTO `address` (`address_id`, `salesperson_id`, `city`, `state`, `country`) VALUES
(1, 2, 'Los Angeles', 'California', NULL),
(2, 3, 'Denver', 'Colorado', NULL),
(3, 4, 'Atlanta', 'Georgia', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `bank_trans`
--

CREATE TABLE `bank_trans` (
  `trans_id` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `login_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `bank_trans`
--

INSERT INTO `bank_trans` (`trans_id`, `customer_id`, `login_date`) VALUES
(101, 3002, '2019-09-01'),
(101, 3002, '2019-08-01'),
(102, 3003, '2018-09-13'),
(102, 3002, '2018-07-24'),
(103, 3001, '2019-09-25'),
(102, 3004, '2017-09-05');

-- --------------------------------------------------------

--
-- Table structure for table `bed_info`
--

CREATE TABLE `bed_info` (
  `bed_id` int(11) DEFAULT NULL,
  `student_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `bed_info`
--

INSERT INTO `bed_info` (`bed_id`, `student_name`) VALUES
(101, 'Alex'),
(102, 'Jhon'),
(103, 'Pain'),
(104, 'Danny'),
(105, 'Paul'),
(106, 'Rex'),
(107, 'Philip'),
(108, 'Josh'),
(109, 'Evan'),
(110, 'Green');

-- --------------------------------------------------------

--
-- Table structure for table `cities_test`
--

CREATE TABLE `cities_test` (
  `city_name` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `city_population` int(11) DEFAULT NULL,
  `city_area` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `cities_test`
--

INSERT INTO `cities_test` (`city_name`, `country`, `city_population`, `city_area`) VALUES
('Tokyo', 'Japan', 13515271, 2191),
('Delhi', 'India', 16753235, 1484),
('Shanghai', 'China', 24870895, 6341),
('Sao Paulo', 'Brazil', 12252023, 1521),
('Mexico City', 'Mexico', 9209944, 1485),
('Cairo', 'Egypt', 9500000, 3085),
('Mumbai', 'India', 12478447, 603),
('Beijing', 'China', 21893095, 16411),
('Osaka', 'Japan', 2725006, 225),
('New York', 'United States', 8398748, 786),
('Buenos Aires', 'Argentina', 3054300, 203),
('Chongqing', 'China', 32054159, 82403),
('Istanbul', 'Turkey', 15519267, 5196),
('Kolkata', 'India', 4496694, 205),
('Manila', 'Philippines', 1780148, 43);

-- --------------------------------------------------------

--
-- Table structure for table `commision3`
--

CREATE TABLE `commision3` (
  `salesman_id` int(11) DEFAULT NULL,
  `commision_amt` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `commision3`
--

INSERT INTO `commision3` (`salesman_id`, `commision_amt`) VALUES
(101, 10000),
(103, 4000),
(104, 8000),
(102, 6000),
(105, 11000);

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `customer_id` int(11) DEFAULT NULL,
  `customer_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`customer_id`, `customer_name`) VALUES
(101, 'Liam'),
(102, 'Josh'),
(103, 'Sean'),
(104, 'Evan'),
(105, 'Toby');

-- --------------------------------------------------------

--
-- Table structure for table `customers3`
--

CREATE TABLE `customers3` (
  `customer_id` int(11) DEFAULT NULL,
  `customer_name` varchar(255) DEFAULT NULL,
  `customer_city` varchar(255) DEFAULT NULL,
  `avg_profit` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `customers3`
--

INSERT INTO `customers3` (`customer_id`, `customer_name`, `customer_city`, `avg_profit`) VALUES
(101, 'Liam', 'New York', 25000),
(102, 'Josh', 'Atlanta', 22000),
(103, 'Sean', 'New York', 27000),
(104, 'Evan', 'Toronto', 15000),
(105, 'Toby', 'Dallas', 20000);

-- --------------------------------------------------------

--
-- Table structure for table `director_test`
--

CREATE TABLE `director_test` (
  `dir_id` int(11) DEFAULT NULL,
  `dir_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `director_test`
--

INSERT INTO `director_test` (`dir_id`, `dir_name`) VALUES
(201, 'Alfred Hitchcock'),
(202, 'Jack Clayton'),
(203, 'James Cameron'),
(204, 'Michael Cimino'),
(205, 'Milos Forman'),
(206, 'Ridley Scott'),
(207, 'Stanley Kubrick'),
(208, 'Bryan Singer'),
(209, 'Roman Polanski');

-- --------------------------------------------------------

--
-- Table structure for table `dr_clinic`
--

CREATE TABLE `dr_clinic` (
  `visiting_date` date DEFAULT NULL,
  `availability` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `dr_clinic`
--

INSERT INTO `dr_clinic` (`visiting_date`, `availability`) VALUES
('2016-06-11', 1),
('2016-06-12', 1),
('2016-06-13', 0),
('2016-06-14', 1),
('2016-06-15', 0),
('2016-06-16', 0),
('2016-06-17', 1),
('2016-06-18', 1),
('2016-06-19', 1),
('2016-06-20', 1),
('2016-06-21', 1);

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

CREATE TABLE `employees` (
  `employee_id` int(11) DEFAULT NULL,
  `employee_name` varchar(255) DEFAULT NULL,
  `email_id` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `employees`
--

INSERT INTO `employees` (`employee_id`, `employee_name`, `email_id`) VALUES
(101, 'Liam Alton', 'li.al@abc.com'),
(102, 'Josh Day', 'jo.da@abc.com'),
(103, 'Sean Mann', 'se.ma@abc.com'),
(104, 'Evan Blake', 'ev.bl@abc.com'),
(105, 'Toby Scott', 'jo.da@abc.com');

-- --------------------------------------------------------

--
-- Table structure for table `emp_test_table`
--

CREATE TABLE `emp_test_table` (
  `employee_id` int(11) DEFAULT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `manager_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `emp_test_table`
--

INSERT INTO `emp_test_table` (`employee_id`, `first_name`, `manager_id`) VALUES
(100, 'Steven', 100),
(101, 'Neena', 100),
(102, 'Lex', 100),
(103, 'Alexander', 102),
(104, 'Bruce', 103),
(105, 'David', 103),
(106, 'Valli', 103),
(107, 'Diana', 103),
(108, 'Nancy', 101),
(109, 'Daniel', 108),
(110, 'John', 108);

-- --------------------------------------------------------

--
-- Table structure for table `exam_test`
--

CREATE TABLE `exam_test` (
  `exam_id` int(11) DEFAULT NULL,
  `subject_id` int(11) DEFAULT NULL,
  `exam_year` int(11) DEFAULT NULL,
  `no_of_student` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `exam_test`
--

INSERT INTO `exam_test` (`exam_id`, `subject_id`, `exam_year`, `no_of_student`) VALUES
(71, 201, 2017, 5146),
(71, 201, 2018, 3545),
(71, 202, 2018, 5945),
(71, 202, 2019, 2500),
(71, 203, 2017, 2500),
(72, 201, 2018, 3500),
(72, 202, 2017, 3651),
(73, 201, 2018, 2647),
(73, 201, 2019, 2647),
(73, 202, 2018, 4501);

-- --------------------------------------------------------

--
-- Table structure for table `item`
--

CREATE TABLE `item` (
  `item_code` int(11) DEFAULT NULL,
  `item_desc` varchar(255) DEFAULT NULL,
  `cost` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `item`
--

INSERT INTO `item` (`item_code`, `item_desc`, `cost`) VALUES
(101, 'mother board', 2700),
(102, 'RAM', 800),
(103, 'key board', 300),
(104, 'mouse', 300);

-- --------------------------------------------------------

--
-- Table structure for table `items3`
--

CREATE TABLE `items3` (
  `item_code` int(11) DEFAULT NULL,
  `item_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `items3`
--

INSERT INTO `items3` (`item_code`, `item_name`) VALUES
(10091, 'juice'),
(10092, 'chocolate'),
(10093, 'cookies'),
(10094, 'cake');

-- --------------------------------------------------------

--
-- Table structure for table `item_price4`
--

CREATE TABLE `item_price4` (
  `item_code` int(11) DEFAULT NULL,
  `date_from` date DEFAULT NULL,
  `date_to` date DEFAULT NULL,
  `item_cost` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `item_price4`
--

INSERT INTO `item_price4` (`item_code`, `date_from`, `date_to`, `item_cost`) VALUES
(101, '2018-04-07', '2018-06-28', 8),
(102, '2018-02-15', '2018-04-17', 13),
(103, '2018-03-12', '2018-04-30', 10),
(101, '2018-06-29', '2018-10-31', 15),
(103, '2018-05-01', '2019-08-24', 14),
(102, '2018-04-18', '2018-07-10', 25),
(104, '2018-06-11', '2018-10-10', 25),
(101, '2018-11-01', '2019-01-15', 20);

-- --------------------------------------------------------

--
-- Table structure for table `logs`
--

CREATE TABLE `logs` (
  `student_id` int(11) DEFAULT NULL,
  `marks` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `logs`
--

INSERT INTO `logs` (`student_id`, `marks`) VALUES
(101, 83),
(102, 79),
(103, 83),
(104, 83),
(105, 83),
(106, 79),
(107, 79),
(108, 83);

-- --------------------------------------------------------

--
-- Table structure for table `managing_body`
--

CREATE TABLE `managing_body` (
  `manager_id` int(11) DEFAULT NULL,
  `manager_name` varchar(255) DEFAULT NULL,
  `running_years` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `managing_body`
--

INSERT INTO `managing_body` (`manager_id`, `manager_name`, `running_years`) VALUES
(51, 'James', 5),
(52, 'Cork', 3),
(53, 'Paul', 4),
(54, 'Adam', 3),
(55, 'Hense', 4),
(56, 'Peter', 2);

-- --------------------------------------------------------

--
-- Table structure for table `match_crowd`
--

CREATE TABLE `match_crowd` (
  `match_no` int(11) DEFAULT NULL,
  `match_date` date DEFAULT NULL,
  `audience` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `match_crowd`
--

INSERT INTO `match_crowd` (`match_no`, `match_date`, `audience`) VALUES
(1, '2016-06-11', 75113),
(2, '2016-06-12', 62343),
(3, '2016-06-13', 43035),
(4, '2016-06-14', 55408),
(5, '2016-06-15', 38742),
(6, '2016-06-16', 63670),
(7, '2016-06-17', 73648),
(8, '2016-06-18', 52409),
(9, '2016-06-19', 67291),
(10, '2016-06-20', 49752),
(11, '2016-06-21', 28840),
(12, '2016-06-22', 32836),
(13, '2016-06-23', 44268);

-- --------------------------------------------------------

--
-- Table structure for table `movie_direction_test`
--

CREATE TABLE `movie_direction_test` (
  `dir_id` int(11) DEFAULT NULL,
  `mov_id` int(11) DEFAULT NULL,
  `act_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `movie_direction_test`
--

INSERT INTO `movie_direction_test` (`dir_id`, `mov_id`, `act_id`) VALUES
(201, 901, 101),
(203, 902, 107),
(204, 904, 104),
(203, 905, 107),
(206, 906, 106),
(203, 908, 107),
(209, 909, 109),
(203, 910, 107);

-- --------------------------------------------------------

--
-- Table structure for table `movie_test`
--

CREATE TABLE `movie_test` (
  `mov_id` int(11) DEFAULT NULL,
  `movie_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `movie_test`
--

INSERT INTO `movie_test` (`mov_id`, `movie_name`) VALUES
(901, 'Vertigo'),
(902, 'Aliens'),
(903, 'Lawrence of Arabia'),
(904, 'The Deer Hunter'),
(905, 'True Lies'),
(906, 'Blade Runner'),
(907, 'Eyes Wide Shut'),
(908, 'Titanic'),
(909, 'Chinatown'),
(910, 'Ghosts of the Abyss');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `order_date` date DEFAULT NULL,
  `order_amount` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `customer_id`, `order_date`, `order_amount`) VALUES
(401, 103, '2012-03-08', 4500),
(402, 101, '2012-09-15', 3650),
(403, 102, '2012-06-27', 4800);

-- --------------------------------------------------------

--
-- Table structure for table `orders2`
--

CREATE TABLE `orders2` (
  `order_id` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `item_desc` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `orders2`
--

INSERT INTO `orders2` (`order_id`, `customer_id`, `item_desc`) VALUES
(101, 2109, 'juice'),
(102, 2139, 'chocolate'),
(103, 2120, 'juice'),
(104, 2108, 'cookies'),
(105, 2130, 'juice'),
(106, 2103, 'cake'),
(107, 2122, 'cookies'),
(108, 2125, 'cake'),
(109, 2139, 'cake'),
(110, 2141, 'cookies'),
(111, 2116, 'cake'),
(112, 2128, 'cake'),
(113, 2146, 'chocolate'),
(114, 2119, 'cookies'),
(115, 2142, 'cake');

-- --------------------------------------------------------

--
-- Table structure for table `orders3`
--

CREATE TABLE `orders3` (
  `order_id` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `order_date` date DEFAULT NULL,
  `order_amount` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `orders3`
--

INSERT INTO `orders3` (`order_id`, `customer_id`, `supplier_id`, `order_date`, `order_amount`) VALUES
(401, 103, 501, '2012-03-08', 4500),
(402, 101, 503, '2012-09-15', 3650),
(403, 102, 503, '2012-06-27', 4800),
(404, 104, 502, '2012-06-17', 5600),
(405, 104, 504, '2012-06-22', 6000),
(406, 105, 502, '2012-06-25', 5600);

-- --------------------------------------------------------

--
-- Table structure for table `orders3a`
--

CREATE TABLE `orders3a` (
  `order_id` int(11) DEFAULT NULL,
  `distributor_id` int(11) DEFAULT NULL,
  `item_ordered` int(11) DEFAULT NULL,
  `item_quantity` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `orders3a`
--

INSERT INTO `orders3a` (`order_id`, `distributor_id`, `item_ordered`, `item_quantity`) VALUES
(1, 501, 10091, 250),
(2, 502, 10093, 100),
(3, 503, 10091, 200),
(4, 502, 10091, 150),
(5, 502, 10092, 300),
(6, 504, 10094, 200),
(7, 503, 10093, 250),
(8, 503, 10092, 250),
(9, 501, 10094, 180),
(10, 503, 10094, 350);

-- --------------------------------------------------------

--
-- Table structure for table `orders_executed`
--

CREATE TABLE `orders_executed` (
  `orders_from` int(11) DEFAULT NULL,
  `executed_from` int(11) DEFAULT NULL,
  `executed_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `orders_executed`
--

INSERT INTO `orders_executed` (`orders_from`, `executed_from`, `executed_date`) VALUES
(101, 202, '2019-11-17'),
(101, 203, '2019-11-17'),
(102, 202, '2019-11-17'),
(103, 203, '2019-11-18'),
(103, 202, '2019-11-19'),
(104, 203, '2019-11-20');

-- --------------------------------------------------------

--
-- Table structure for table `orders_issued`
--

CREATE TABLE `orders_issued` (
  `distributor_id` int(11) DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `quotation_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `orders_issued`
--

INSERT INTO `orders_issued` (`distributor_id`, `company_id`, `quotation_date`) VALUES
(101, 202, '2019-11-15'),
(101, 203, '2019-11-15'),
(101, 204, '2019-11-15'),
(102, 202, '2019-11-16'),
(102, 201, '2019-11-15'),
(103, 203, '2019-11-17'),
(103, 202, '2019-11-17'),
(104, 203, '2019-11-18'),
(104, 204, '2019-11-18');

-- --------------------------------------------------------

--
-- Table structure for table `order_return`
--

CREATE TABLE `order_return` (
  `order_id` int(11) DEFAULT NULL,
  `return_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `order_return`
--

INSERT INTO `order_return` (`order_id`, `return_date`) VALUES
(153, '2020-10-12'),
(154, '2020-11-07'),
(156, '2020-12-05'),
(159, '2020-09-17');

-- --------------------------------------------------------

--
-- Table structure for table `order_stat`
--

CREATE TABLE `order_stat` (
  `order_id` int(11) DEFAULT NULL,
  `com_name` varchar(255) DEFAULT NULL,
  `ord_qty` int(11) DEFAULT NULL,
  `ord_stat` varchar(255) DEFAULT NULL,
  `stat_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `order_stat`
--

INSERT INTO `order_stat` (`order_id`, `com_name`, `ord_qty`, `ord_stat`, `stat_date`) VALUES
(151, 'MMS INC', 500, 'Booked', '2020-08-15'),
(152, 'BCT LTD', 300, 'Cancelled', '2020-08-15'),
(153, 'MMS INC', 400, 'Cancelled', '2020-08-26'),
(154, 'XYZ COR', 500, 'Booked', '2020-08-15'),
(155, 'MMS INC', 500, 'Cancelled', '2020-10-11'),
(156, 'BWD PRO LTD', 250, 'Cancelled', '2020-11-15'),
(157, 'BCT LTD', 600, 'Booked', '2020-10-07'),
(158, 'MMS INC', 300, 'Booked', '2020-12-11'),
(159, 'XYZ COR', 300, 'Booked', '2020-08-26'),
(160, 'BCT LTD', 400, 'Booked', '2020-11-15');

-- --------------------------------------------------------

--
-- Table structure for table `patient`
--

CREATE TABLE `patient` (
  `patient_id` int(11) DEFAULT NULL,
  `patient_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `patient`
--

INSERT INTO `patient` (`patient_id`, `patient_name`) VALUES
(1001, 'Gilbart Kane'),
(1002, 'Thomas Richi'),
(1003, 'Ricardo Grance'),
(1004, 'Vanio Tishuma'),
(1005, 'Charls Brown');

-- --------------------------------------------------------

--
-- Table structure for table `purchase`
--

CREATE TABLE `purchase` (
  `customer_id` int(11) DEFAULT NULL,
  `item_code` int(11) DEFAULT NULL,
  `purch_qty` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `purchase`
--

INSERT INTO `purchase` (`customer_id`, `item_code`, `purch_qty`) VALUES
(101, 504, 25),
(101, 503, 50),
(102, 502, 40),
(102, 503, 25),
(102, 501, 45),
(103, 505, 30),
(103, 503, 25),
(104, 505, 40),
(101, 502, 25),
(102, 504, 40),
(102, 505, 50),
(103, 502, 25),
(104, 504, 40),
(103, 501, 35);

-- --------------------------------------------------------

--
-- Table structure for table `sale`
--

CREATE TABLE `sale` (
  `product_id` int(11) DEFAULT NULL,
  `sale_qty` int(11) DEFAULT NULL,
  `qtr_no` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `sale`
--

INSERT INTO `sale` (`product_id`, `sale_qty`, `qtr_no`) VALUES
(1, 15000, 'qtr1'),
(1, 10000, 'qtr2'),
(2, 20000, 'qtr1'),
(2, 12000, 'qtr2'),
(3, 20000, 'qtr1'),
(3, 15000, 'qtr2'),
(3, 23000, 'qtr3'),
(3, 22000, 'qtr4'),
(4, 25000, 'qtr2'),
(4, 18000, 'qtr4');

-- --------------------------------------------------------

--
-- Table structure for table `sale4`
--

CREATE TABLE `sale4` (
  `sale_date` date DEFAULT NULL,
  `item_cost` int(11) DEFAULT NULL,
  `sale_qty` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `sale4`
--

INSERT INTO `sale4` (`sale_date`, `item_cost`, `sale_qty`) VALUES
('2018-05-15', 101, 120),
('2018-04-27', 103, 80),
('2018-04-10', 102, 200),
('2018-07-12', 101, 100),
('2018-07-07', 103, 50),
('2018-09-17', 104, 100),
('2018-06-25', 102, 100);

-- --------------------------------------------------------

--
-- Table structure for table `salemast`
--

CREATE TABLE `salemast` (
  `sale_id` int(11) DEFAULT NULL,
  `employee_id` int(11) DEFAULT NULL,
  `sale_date` date DEFAULT NULL,
  `sale_amt` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `salemast`
--

INSERT INTO `salemast` (`sale_id`, `employee_id`, `sale_date`, `sale_amt`) VALUES
(1, 1000, '2012-03-08', 4500),
(2, 1001, '2012-03-09', 5500),
(3, 1003, '2012-04-10', 3500),
(3, 1003, '2012-04-10', 2500);

-- --------------------------------------------------------

--
-- Table structure for table `salemast2`
--

CREATE TABLE `salemast2` (
  `salesperson_id` int(11) DEFAULT NULL,
  `order_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `salemast2`
--

INSERT INTO `salemast2` (`salesperson_id`, `order_id`) VALUES
(5001, 1001),
(5002, 1002),
(5003, 1002),
(5004, 1002),
(5005, 1003),
(5006, 1004);

-- --------------------------------------------------------

--
-- Table structure for table `salemast3`
--

CREATE TABLE `salemast3` (
  `salesman_id` int(11) DEFAULT NULL,
  `salesman_name` varchar(255) DEFAULT NULL,
  `yearly_sale` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `salemast3`
--

INSERT INTO `salemast3` (`salesman_id`, `salesman_name`, `yearly_sale`) VALUES
(101, 'Adam', 250000),
(103, 'Mark', 100000),
(104, 'Liam', 200000),
(102, 'Evan', 150000),
(105, 'Blake', 275000),
(106, 'Noah', 50000);

-- --------------------------------------------------------

--
-- Table structure for table `sales`
--

CREATE TABLE `sales` (
  `transaction_id` int(11) DEFAULT NULL,
  `salesman_id` int(11) DEFAULT NULL,
  `sale_amount` decimal(7,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `sales`
--

INSERT INTO `sales` (`transaction_id`, `salesman_id`, `sale_amount`) VALUES
(501, 18, '5200.00'),
(502, 50, '5566.00'),
(503, 38, '8400.00'),
(599, 24, '16745.00'),
(600, 12, '14900.00');

-- --------------------------------------------------------

--
-- Table structure for table `salesman`
--

CREATE TABLE `salesman` (
  `salesman_id` int(11) DEFAULT NULL,
  `salesman_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `salesman`
--

INSERT INTO `salesman` (`salesman_id`, `salesman_name`) VALUES
(11, 'Jonathan Goodwin'),
(12, 'Adam Hughes'),
(13, 'Mark Davenport'),
(59, 'Cleveland Hart'),
(60, 'Marion Gregory');

-- --------------------------------------------------------

--
-- Table structure for table `salespersons`
--

CREATE TABLE `salespersons` (
  `salesperson_id` varchar(255) DEFAULT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `salespersons`
--

INSERT INTO `salespersons` (`salesperson_id`, `first_name`, `last_name`) VALUES
('1', 'Green', 'Wright'),
('2', 'Jones', 'Collins'),
('3', 'Bryant', 'Davis');

-- --------------------------------------------------------

--
-- Table structure for table `sales_info`
--

CREATE TABLE `sales_info` (
  `distributor_id` int(11) DEFAULT NULL,
  `item_code` int(11) DEFAULT NULL,
  `retailer_id` int(11) DEFAULT NULL,
  `date_of_sell` date DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `sales_info`
--

INSERT INTO `sales_info` (`distributor_id`, `item_code`, `retailer_id`, `date_of_sell`, `quantity`) VALUES
(5001, 101, 1001, '2020-02-12', 3),
(5001, 103, 1002, '2020-03-15', 15),
(5002, 101, 1001, '2019-06-24', 2),
(5001, 104, 1003, '2019-09-11', 8),
(5003, 101, 1003, '2020-10-21', 5),
(5003, 104, 1002, '2020-12-27', 10),
(5002, 102, 1001, '2019-05-18', 12),
(5002, 103, 1004, '2020-06-17', 8),
(5003, 103, 1001, '2020-04-12', 3);

-- --------------------------------------------------------

--
-- Table structure for table `scheme`
--

CREATE TABLE `scheme` (
  `scheme_code` int(11) DEFAULT NULL,
  `scheme_manager_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `scheme`
--

INSERT INTO `scheme` (`scheme_code`, `scheme_manager_id`) VALUES
(1001, 51),
(1001, 53),
(1001, 54),
(1001, 56),
(1002, 51),
(1002, 55),
(1003, 51),
(1004, 52);

-- --------------------------------------------------------

--
-- Table structure for table `so2_pollution`
--

CREATE TABLE `so2_pollution` (
  `city_id` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `so2_amt` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `so2_pollution`
--

INSERT INTO `so2_pollution` (`city_id`, `date`, `so2_amt`) VALUES
(701, '2015-10-15', 5),
(702, '2015-10-16', 7),
(703, '2015-10-17', 9),
(704, '2018-10-18', 15),
(705, '2015-10-19', 14);

-- --------------------------------------------------------

--
-- Table structure for table `speciality`
--

CREATE TABLE `speciality` (
  `specialist` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `speciality`
--

INSERT INTO `speciality` (`specialist`) VALUES
(NULL),
('neurology'),
('hematology');

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `student_id` int(11) DEFAULT NULL,
  `student_name` varchar(255) DEFAULT NULL,
  `teacher_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`student_id`, `student_name`, `teacher_id`) VALUES
(1001, 'Alex', 601),
(1002, 'Jhon', NULL),
(1003, 'Peter', NULL),
(1004, 'Minto', 604),
(1005, 'Crage', NULL),
(1006, 'Chang', 601),
(1007, 'Philip', 602);

-- --------------------------------------------------------

--
-- Table structure for table `students2`
--

CREATE TABLE `students2` (
  `student_id` int(11) DEFAULT NULL,
  `student_name` varchar(255) DEFAULT NULL,
  `marks_achieved` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `students2`
--

INSERT INTO `students2` (`student_id`, `student_name`, `marks_achieved`) VALUES
(1, 'Alex', 87),
(2, 'Jhon', 92),
(3, 'Pain', 83),
(4, 'Danny', 87),
(5, 'Paul', 92),
(6, 'Rex', 89),
(7, 'Philip', 87),
(8, 'Josh', 83),
(9, 'Evan', 92),
(10, 'Larry', 87);

-- --------------------------------------------------------

--
-- Table structure for table `student_test`
--

CREATE TABLE `student_test` (
  `student_id` int(11) DEFAULT NULL,
  `marks_achieved` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `student_test`
--

INSERT INTO `student_test` (`student_id`, `marks_achieved`) VALUES
(1, 56),
(2, 74),
(3, 15),
(4, 74),
(5, 89),
(6, 56),
(7, 93);

-- --------------------------------------------------------

--
-- Table structure for table `subject_test`
--

CREATE TABLE `subject_test` (
  `subject_id` int(11) DEFAULT NULL,
  `subject_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `subject_test`
--

INSERT INTO `subject_test` (`subject_id`, `subject_name`) VALUES
(201, 'Mathematics'),
(202, 'Physics'),
(203, 'Chemistry');

-- --------------------------------------------------------

--
-- Table structure for table `tablefortest1`
--

CREATE TABLE `tablefortest1` (
  `srno` int(11) DEFAULT NULL,
  `pos_neg_val` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tablefortest1`
--

INSERT INTO `tablefortest1` (`srno`, `pos_neg_val`) VALUES
(1, 56),
(2, -74),
(3, 15),
(4, 51),
(5, 9),
(6, 32);

-- --------------------------------------------------------

--
-- Table structure for table `tablefortest2`
--

CREATE TABLE `tablefortest2` (
  `id` int(11) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tablefortest2`
--

INSERT INTO `tablefortest2` (`id`, `date_of_birth`) VALUES
(1, '1907-08-15'),
(2, '1883-06-27'),
(3, '1900-01-01'),
(4, '1901-01-01'),
(5, '2005-09-01'),
(6, '1775-11-23'),
(7, '1800-01-01');

-- --------------------------------------------------------

--
-- Table structure for table `tablefortest3`
--

CREATE TABLE `tablefortest3` (
  `srno` int(11) DEFAULT NULL,
  `col_val` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tablefortest3`
--

INSERT INTO `tablefortest3` (`srno`, `col_val`) VALUES
(1, 56),
(2, 74),
(3, 15),
(4, 51),
(5, 9),
(6, 32);

-- --------------------------------------------------------

--
-- Table structure for table `topics`
--

CREATE TABLE `topics` (
  `topic_id` int(11) DEFAULT NULL,
  `writer_id` int(11) DEFAULT NULL,
  `rated_by` int(11) DEFAULT NULL,
  `date_of_rating` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `topics`
--

INSERT INTO `topics` (`topic_id`, `writer_id`, `rated_by`, `date_of_rating`) VALUES
(10001, 504, 507, '2020-07-17'),
(10003, 502, 503, '2020-09-22'),
(10001, 503, 507, '2020-02-07'),
(10002, 501, 507, '2020-05-13'),
(10002, 502, 502, '2020-04-10'),
(10002, 504, 502, '2020-11-16'),
(10003, 501, 502, '2020-10-05'),
(10001, 507, 507, '2020-12-23'),
(10004, 503, 501, '2020-08-28'),
(10003, 505, 504, '2020-12-21');

-- --------------------------------------------------------

--
-- Table structure for table `treatment`
--

CREATE TABLE `treatment` (
  `patient_id` int(11) DEFAULT NULL,
  `specialist_call` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `treatment`
--

INSERT INTO `treatment` (`patient_id`, `specialist_call`) VALUES
(1001, 'medicine'),
(1003, 'medicine'),
(1002, 'cardiology'),
(1001, 'hematology'),
(1004, 'medicine'),
(1003, 'cardiology'),
(1005, 'neurology'),
(1002, 'neurology'),
(1001, 'cardiology'),
(1005, 'cardiology'),
(1003, 'cardiology'),
(1005, 'hematology'),
(1004, 'hematology'),
(1005, 'neurology'),
(1002, 'neurology'),
(1001, 'hematology');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
