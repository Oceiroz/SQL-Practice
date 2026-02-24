USE dblab6;

SELECT * FROM supermarket;

SELECT * FROM supermarket LIMIT 10;

SELECT * FROM supermarket
WHERE City = "Yangon";

SELECT * FROM supermarket
WHERE `Customer type` = "Member" and Payment = "Ewallet";

SELECT * FROM supermarket
WHERE 8.0 < Rating and Rating < 9.0;

SELECT DISTINCT `Product line` FROM supermarket;

SELECT * FROM supermarket
ORDER BY Total DESC LIMIT 5;

SELECT AVG(Rating) FROM supermarket;

SELECT SUM(Total) FROM supermarket
GROUP BY Branch;

SELECT Payment FROM supermarket
GROUP BY Payment
ORDER BY COUNT(Payment) ASC LIMIT 1;

SELECT AVG(`Unit price`), AVG(`Total`), AVG(`gross income`) FROM supermarket
GROUP BY `Customer type`;

SELECT AVG(Rating) FROM supermarket
GROUP BY City;

SELECT * FROM supermarket
WHERE Branch = (
	SELECT Branch FROM supermarket
    GROUP BY Branch
    ORDER BY SUM(`gross income`) DESC
    LIMIT 1
);

INSERT INTO supermarket VALUES (999-999-9999, 'A', 'Yangon', 'Member', 'Female', 'Health and beauty', 50.00, 2, 5.00, 105.00, '11/17/2025', '11:30', 'Cash', 100.00, 100.00,  5.00, 9.5);

ALTER TABLE supermarket
ADD COLUMN store_manager varchar(50);

ALTER TABLE supermarket
RENAME COLUMN cogs TO cost_of_goods_sold;

ALTER TABLE supermarket
DROP COLUMN `gross margin percentage`;

SELECT * FROM supermarket
WHERE Total > (
	SELECT AVG(Total) FROM supermarket
);

SELECT City, `Invoice ID`, Total FROM supermarket
WHERE `Customer type` = "Normal"
ORDER BY City;

CREATE TABLE sales_audit(

message VARCHAR(255)

);


DELIMITER $$
CREATE TRIGGER trigger1 
BEFORE UPDATE
ON supermarket FOR EACH ROW
BEGIN DECLARE errorMessage VARCHAR(255);
SET errorMessage = CONCAT("The new Total cannot be smaller than the cost of goods sold");
IF NEW.Total < NEW.cost_of_goods_sold THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errorMessage;
END IF;
END$$
DELIMITER ;


DELIMITER $$
CREATE TRIGGER trigger2
AFTER UPDATE
ON supermarket FOR EACH ROW
BEGIN
INSERT INTO sales_audit VALUES(OLD.Total, NEW.Total);
END$$
DELIMITER ;
