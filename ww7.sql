CREATE TABLE SUPPLIERS (
    sid INT PRIMARY KEY,
    sname VARCHAR(50),
    city VARCHAR(50)
);
CREATE TABLE PARTS (
    pid INT PRIMARY KEY,
    pname VARCHAR(50),
    color VARCHAR(20)
);
CREATE TABLE CATALOG (
    sid INT,
    pid INT,
    cost INT,
    PRIMARY KEY (sid, pid),
    FOREIGN KEY (sid) REFERENCES SUPPLIERS(sid),
    FOREIGN KEY (pid) REFERENCES PARTS(pid)
);
INSERT INTO SUPPLIERS (sid, sname, city) VALUES
(10001, 'Acme Widget', 'Bangalore'),
(10002, 'Johns', 'Kolkata'),
(10003, 'Vimal', 'Mumbai'),
(10004, 'Reliance', 'Delhi');
INSERT INTO PARTS (pid, pname, color) VALUES
(20001, 'Book', 'Red'),
(20002, 'Pen', 'Red'),
(20003, 'Pencil', 'Green'),
(20004, 'Mobile', 'Green'),
(20005, 'Charger', 'Black');
INSERT INTO CATALOG (sid, pid, cost) VALUES
(10001, 20001, 10),
(10001, 20002, 10),
(10001, 20003, 30),
(10001, 20004, 10),
(10001, 20005, 10),
(10002, 20001, 10),
(10002, 20002, 20),
(10003, 20003, 30),
(10004, 20003, 40);
SELECT DISTINCT P.pname
FROM PARTS P
JOIN CATALOG C ON P.pid = C.pid;
SELECT S.sname
FROM SUPPLIERS S
WHERE NOT EXISTS (
    SELECT P.pid
    FROM PARTS P
    WHERE NOT EXISTS (
        SELECT C.sid
        FROM CATALOG C
        WHERE C.sid = S.sid 
          AND C.pid = P.pid
    )
);
SELECT S.sname
FROM SUPPLIERS S
WHERE NOT EXISTS (
    SELECT P.pid
    FROM PARTS P
    WHERE P.color = 'Red'
      AND NOT EXISTS (
          SELECT C.sid
          FROM CATALOG C
          WHERE C.sid = S.sid 
            AND C.pid = P.pid
      )
);
SELECT P.pname
FROM PARTS P
JOIN CATALOG C ON P.pid = C.pid
JOIN SUPPLIERS S ON C.sid = S.sid
WHERE S.sname = 'Acme Widget'
  AND NOT EXISTS (
      SELECT *
      FROM CATALOG C2
      WHERE C2.pid = P.pid 
        AND C2.sid <> S.sid
  );
SELECT DISTINCT C.sid
FROM CATALOG C
WHERE C.cost > (
    SELECT AVG(C2.cost)
    FROM CATALOG C2
    WHERE C2.pid = C.pid
);
SELECT C.pid, S.sname
FROM CATALOG C
JOIN SUPPLIERS S ON C.sid = S.sid
WHERE C.cost = (
    SELECT MAX(C2.cost)
    FROM CATALOG C2
    WHERE C2.pid = C.pid
);
SELECT P.pname, S.sname, C.cost
FROM CATALOG C
JOIN PARTS P ON C.pid = P.pid
JOIN SUPPLIERS S ON C.sid = S.sid
WHERE C.cost = (SELECT MAX(cost) FROM CATALOG);