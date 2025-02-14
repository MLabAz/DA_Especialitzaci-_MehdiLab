CREATE TABLE companies(
company_id VARCHAR(10) PRIMARY KEY,
company_name VARCHAR(255),
phone VARCHAR(15),
email VARCHAR(100),
country VARCHAR(100),
website VARCHAR(255)
);

SELECT @@secure_file_priv;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/companies.csv' 
INTO TABLE companies 
FIELDS TERMINATED BY ',' 
ENCLOSED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM companies;


CREATE TABLE users(
id int PRIMARY KEY ,
name VARCHAR(100) ,
surname VARCHAR(100) ,
phone VARCHAR(150) ,
email VARCHAR(150) ,
birth_date VARCHAR(100) ,
country VARCHAR(150) ,
city VARCHAR(150) ,
postal_code VARCHAR(100),
address VARCHAR(255)  
);


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_usa.csv' 
INTO TABLE users 
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS; 

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_uk.csv' 
INTO TABLE users 
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS; 

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_ca.csv' 
INTO TABLE users 
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS; 

SELECT * FROM users;



CREATE TABLE credit_cards(
id VARCHAR(20) PRIMARY KEY,
user_id int,
iban VARCHAR(32),
pan VARCHAR(20),
pin VARCHAR(4),
cvv INT,
track1 VARCHAR(255),
track2 VARCHAR(255),
expiring_date VARCHAR(20)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/credit_cards.csv' 
INTO TABLE credit_cards 
FIELDS TERMINATED BY ',' 
ENCLOSED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM credit_cards;


CREATE TABLE transactions(
id VARCHAR(255) PRIMARY KEY,
card_id VARCHAR(20),
business_id  VARCHAR(10) ,
timestamp date,
amount DECIMAL(10,2),
declined TINYINT,
product_ids VARCHAR(20),
user_id int,
lat FLOAT,
longitude FLOAT,
CONSTRAINT FK_TransactionsCredit FOREIGN KEY (card_id)
REFERENCES credit_cards(id),
CONSTRAINT FK_Transactionscompanies FOREIGN KEY (business_id)
REFERENCES companies(company_id),
CONSTRAINT FK_TransactionsUser FOREIGN KEY (user_id)
REFERENCES users(id)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/transactions.csv' 
INTO TABLE transactions 
FIELDS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM transactions;


