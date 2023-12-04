CREATE DATABASE thecabinet;

USE thecabinet;

CREATE TABLE IF NOT EXISTS `cabinet` (
  `item` varchar(255) NOT NULL,
  `amount` int(100) DEFAULT NULL,
  PRIMARY KEY (`item`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=10001;

INSERT INTO `cabinet` (`item`, `amount`) VALUES
('plate', 25),
('fork', 40),
('spoon', 40),
('knife', 40),
('cup', 25),
('potato peeler', 500);
