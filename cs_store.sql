CREATE TABLE Customers(
birth_day date, 
first_name varchar(20), 
last_name varchar(20), 
c_id int,
PRIMARY KEY(c_id));

CREATE TABLE Employees(
birth_day date, 
first_name varchar(20), 
last_name varchar(20),
e_id int,
PRIMARY KEY(e_id));

CREATE TABLE Transactions(
e_id int,
c_id int,
date date,
t_id int,
PRIMARY KEY(t_id),
FOREIGN KEY (e_id) REFERENCES Employees(e_id),
FOREIGN KEY (c_id) REFERENCES Customers(c_id));

CREATE TABLE Promotion(
number_to_buy int,
how_many_are_free int,
type int,
PRIMARY KEY(type));

CREATE TABLE Items(
price_for_each int, 
type int, 
amount_in_stock int, 
name varchar(20), 
PRIMARY KEY(name)); 

CREATE TABLE ItemsInTransactions(
name varchar(20), 
t_id int,
iit_id int,
PRIMARY KEY (iit_id),
FOREIGN KEY (name) REFERENCES Items(name),
FOREIGN KEY (t_id) REFERENCES Transactions(t_id));



CREATE VIEW LouisTransactions AS SELECT COUNT(t_id) AS number_of_transactions FROM Employees NATURAL JOIN Transactions WHERE Employees.first_name = 'Louis' AND Employees.last_name = 'Davies' AND MONTH(Transactions.date) = 9;

CREATE VIEW PeopleInShop AS SELECT birth_day, first_name, last_name FROM Employees JOIN Transactions WHERE Employees.e_id = Transactions.e_id And Transactions.date = '2022-9-28'  UNION DISTINCT SELECT birth_day, first_name, last_name FROM Customers , Transactions WHERE Customers.c_id = Transactions.c_id And Transactions.date = '2022-9-28' order by birth_day;

CREATE VIEW ItemsLeft1 AS SELECT name, type, amount_in_stock - COUNT(t_id) AS amount_left FROM Items NATURAL JOIN ItemsInTransactions WHERE  Items.name = ItemsInTransactions.name AND Items.type = 1 AND Items.type = 1 OR Items.type = 2 group by name ORDER BY type, name;

CREATE VIEW ItemsLeft2 AS SELECT Items.name, Items.type, amount_in_stock - COUNT(ItemsInTransactions.t_id) AS amount_left FROM Items LEFT JOIN ItemsInTransactions ON Items.name = ItemsInTransactions.name WHERE Items.type = 3 OR Items.type = 4 group by name ORDER BY type, name;

CREATE VIEW IITRanking AS SELECT iit_id, t_id, type, price_for_each AS price, COUNT(*) AS rnk FROM ItemsInTransactions, Items GROUP BY iit_id, price_for_each ORDER BY t_id DESC, type DESC, price DESC, iit_id DESC;

CREATE VIEW TransactionCost AS SELECT t_id, SUM( DISTINCT price_for_each ) AS cost FROM ItemsInTransactions natural join Items, Promotion WHERE  Promotion.type = Items.type group by t_id;



