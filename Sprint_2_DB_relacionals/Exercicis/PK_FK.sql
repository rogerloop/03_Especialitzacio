CREATE TABLE table1 (
id INT PRIMARY KEY,
name VARCHAR (50)
);

DESC table1;

ALTER TABLE table1 DROP PRIMARY KEY;

ALTER TABLE table1 ADD PRIMARY KEY (id);

CREATE TABLE table2 (
id INT,
name VARCHAR (50), FOREIGN KEY (id) REFERENCES table1(id)
);

DESC table2;

SHOW CREATE TABLE table2;

ALTER TABLE table2 DROP FOREIGN KEY table2_ibfk_1;

CREATE TABLE table3 (
id INT,
name VARCHAR(50), FOREIGN KEY (id) REFERENCES table1(id) ON DELETE CASCADE
);

INSERT INTO table1 (id, name)
VALUES 
('1', 'neha'),
('2', 'Geeta'),
('3', 'Rohit');


INSERT INTO table3 (id, name)
SELECT id, name
FROM table1
;

DELETE FROM table1 WHERE id = 3;

ALTER TABLE table3 DROP FOREIGN KEY table3_ibfk_1;

ALTER TABLE table3 ADD CONSTRAINT table3_ibfk_1 FOREIGN KEY (id) REFERENCES table1(id) ON DELETE SET NULL;

CREATE table table4 ( id INT, name VARCHAR(50), CONSTRAINT harshal FOREIGN KEY (id) REFERENCES table1(id) ON DELETE SET NULL);

DELETE FROM table1 WHERE id = 2;