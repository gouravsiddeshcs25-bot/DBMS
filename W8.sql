SELECT S.sid, S.sname
FROM SUPPLIERS S
WHERE S.sid NOT IN (
    SELECT C.sid
    FROM CATALOG C
    JOIN PARTS P ON C.pid = P.pid
    WHERE P.color = 'Red'
);
SELECT S.sid, S.sname, COALESCE(SUM(C.cost), 0) AS total_value
FROM SUPPLIERS S
LEFT JOIN CATALOG C ON S.sid = C.sid
GROUP BY S.sid, S.sname;
SELECT S.sid, S.sname
FROM SUPPLIERS S
JOIN CATALOG C ON S.sid = C.sid
WHERE C.cost < 20
GROUP BY S.sid, S.sname
HAVING COUNT(C.pid) >= 2;
SELECT P.pid, P.pname, S.sname, C.cost
FROM CATALOG C
JOIN PARTS P ON C.pid = P.pid
JOIN SUPPLIERS S ON C.sid = S.sid
WHERE C.cost = (
    SELECT MIN(C2.cost)
    FROM CATALOG C2
    WHERE C2.pid = C.pid
);
CREATE VIEW MostExpensiveSuppliers AS
SELECT P.pid, P.pname, S.sid, S.sname, C.cost
FROM CATALOG C
JOIN PARTS P ON C.pid = P.pid
JOIN SUPPLIERS S ON C.sid = S.sid
WHERE C.cost = (
    SELECT MAX(C2.cost)
    FROM CATALOG C2
    WHERE C2.pid = C.pid
);
DELIMITER //

CREATE TRIGGER prevent_low_cost
BEFORE INSERT ON CATALOG
FOR EACH ROW
BEGIN
    IF NEW.cost < 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Catalog cost cannot be below 1';
    END IF;
END //

DELIMITER ;
DELIMITER //

CREATE TRIGGER set_default_cost
BEFORE INSERT ON CATALOG
FOR EACH ROW
BEGIN
    IF NEW.cost IS NULL THEN
        SET NEW.cost = 10;
    END IF;
END //

DELIMITER ;