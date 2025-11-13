create database salaryss;
use salaryss;

CREATE TABLE Supplier (
    sid INT PRIMARY KEY,
    sname VARCHAR(50),
    city VARCHAR(50)
);

CREATE TABLE Parts (
    pid INT PRIMARY KEY,
    pname VARCHAR(50),
    color VARCHAR(20)
);

CREATE TABLE Catalog (
    sid INT,
    pid INT,
    cost FLOAT,
    PRIMARY KEY (sid, pid),
    FOREIGN KEY (sid) REFERENCES Supplier(sid),
    FOREIGN KEY (pid) REFERENCES Parts(pid)
);

INSERT INTO Supplier VALUES (1, 'Acme Widget Suppliers', 'Mumbai');
INSERT INTO Supplier VALUES (2, 'Global Parts Co', 'Delhi');
INSERT INTO Supplier VALUES (3, 'Indus Supplies', 'Bangalore');

INSERT INTO Parts VALUES (101, 'Bolt', 'Red');
INSERT INTO Parts VALUES (102, 'Nut', 'Blue');
INSERT INTO Parts VALUES (103, 'Clamp', 'Red');
INSERT INTO Parts VALUES (104, 'Gear', 'Green');
INSERT INTO Parts VALUES (105, 'Spring', 'Red');

INSERT INTO Catalog VALUES (1, 101, 15.0);
INSERT INTO Catalog VALUES (1, 102, 20.0);
INSERT INTO Catalog VALUES (1, 104, 17.0);
INSERT INTO Catalog VALUES (2, 103, 12.5);
INSERT INTO Catalog VALUES (2, 101, 16.5);
INSERT INTO Catalog VALUES (2, 105, 19.0);
INSERT INTO Catalog VALUES (3, 105, 21.0);
INSERT INTO Catalog VALUES (3, 101, 15.5);
INSERT INTO Catalog VALUES (3, 103, 13.5);



SELECT DISTINCT P.pname
FROM Parts P
JOIN Catalog C ON P.pid = C.pid;


SELECT S.sname
FROM Supplier S
WHERE NOT EXISTS (
    SELECT P.pid FROM Parts P
    WHERE NOT EXISTS (
        SELECT * FROM Catalog C WHERE C.sid = S.sid AND C.pid = P.pid
    )
);


SELECT S.sname
FROM Supplier S
WHERE NOT EXISTS (
    SELECT P.pid FROM Parts P WHERE P.color = 'Red'
    AND NOT EXISTS (
        SELECT * FROM Catalog C WHERE C.sid = S.sid AND C.pid = P.pid
    )
);


SELECT P.pname
FROM Parts P
JOIN Catalog C ON P.pid = C.pid
WHERE C.sid = (
    SELECT sid FROM Supplier WHERE sname = 'Acme Widget Suppliers'
)
AND P.pid NOT IN (
    SELECT pid FROM Catalog WHERE sid != (
        SELECT sid FROM Supplier WHERE sname = 'Acme Widget Suppliers'
    )
);

SELECT DISTINCT C.sid
FROM Catalog C
WHERE C.cost >
    (SELECT AVG(cost) FROM Catalog WHERE pid = C.pid);


SELECT S.sname, C.pid
FROM Catalog C
JOIN Supplier S ON C.sid = S.sid
WHERE C.cost = (
    SELECT MAX(cost) FROM Catalog WHERE pid = C.pid
);
