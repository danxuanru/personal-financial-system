CREATE DATABASE IF NOT EXISTS financialSystemDB;

USE financialSystemDB;

CREATE TABLE Users (
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(256) NOT NULL,
	telegram_bot_id VARCHAR(256) UNIQUE,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Accounts (
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(256) NOT NULL,
	parent_id INT,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	uid INT NOT NULL,
	CONSTRAINT fk_user FOREIGN KEY(uid) REFERENCES Users(id),
	CONSTRAINT fk_account_parent FOREIGN KEY(parent_id) REFERENCES Accounts(id)
);

CREATE TABLE AccountBalanceSnapshot (
	id INT PRIMARY KEY AUTO_INCREMENT,
	aid INT NOT NULL,
	balance DECIMAL(15,2) NOT NULL,
	snapshot_date DATE NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT fk_snapshot_account FOREIGN KEY(aid) REFERENCES Accounts(id),
	UNIQUE KEY uq_snapshot (aid, snapshot_date)   --每個帳戶每天只會進行一次snapshot
);

CREATE TABLE Category (
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(256) NOT NULL,
	category_type ENUM('expense', 'revenue'),
	parent_id INT,
	CONSTRAINT fk_category_parent FOREIGN KEY(parent_id) REFERENCES Category(id)
);

CREATE TABLE PaymentMethod (
	id INT PRIMARY KEY AUTO_INCREMENT,
	method_name VARCHAR(256) NOT NULL,
	linked_account_id INT,
	payment_type VARCHAR(256) NOT NULL,
	credit_limit DECIMAL(15,2),
	is_active BOOLEAN NOT NULL DEFAULT TRUE,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT fk_payment_account FOREIGN KEY(linked_account_id) REFERENCES Accounts(id)
);

CREATE TABLE Transactions (
	id INT PRIMARY KEY AUTO_INCREMENT,
	transaction_type ENUM('expense', 'revenue') NOT NULL,
	amount DECIMAL(15,2) NOT NULL,
	transactions_date DATE NOT NULL,
	merchant_name VARCHAR(256),
	description VARCHAR(512),
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	cid INT NOT NULL,
	pid INT NOT NULL,
	aid INT NOT NULL,
	CONSTRAINT fk_transaction_category FOREIGN KEY(cid) REFERENCES Category(id),
	CONSTRAINT fk_transaction_payment FOREIGN KEY(pid) REFERENCES PaymentMethod(id),
	CONSTRAINT fk_transaction_account FOREIGN KEY(aid) REFERENCES Accounts(id)
);

CREATE TABLE Benefits (
	id INT PRIMARY KEY AUTO_INCREMENT,
	merchant_name VARCHAR(256) NOT NULL,
	merchant_category VARCHAR(128),
	benefit_type ENUM('cash', 'point', 'discount') NOT NULL,
	Benefit_value DECIMAL(8,4) NOT NULL,
	is_active BOOLEAN NOT NULL DEFAULT TRUE,
	valid_from DATE,
	valid_until DATE,
	max_benefit DECIMAL(15,2),
	min_spend DECIMAL(15,2),
	conditions TEXT,
	pid INT NOT NULL,
	CONSTRAINT fk_benefit_payment FOREIGN KEY(pid) REFERENCES PaymentMethod(id)
);

CREATE TABLE TransactionBenefit (
	id INT PRIMARY KEY AUTO_INCREMENT,
	tid INT NOT NULL,
	bid INT NOT NULL,
	applied_value DECIMAL(15,2) NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT fk_tb_transaction FOREIGN KEY(tid) REFERENCES Transactions(id), 
	CONSTRAINT fk_tb_benefit FOREIGN KEY(bid) REFERENCES Benefits(id),
	UNIQUE KEY uq_tb (tid, bid)  --同一筆交易不重複套用同一優惠
);

CREATE TABLE CrawlSnapshot (
	id INT PRIMARY KEY AUTO_INCREMENT,
	source_url VARCHAR(256),
	issuer VARCHAR(128),
	raw_data LONGTEXT,
	status ENUM('pending', 'success', 'failed') NOT NULL DEFAULT 'pending',
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	bid INT NOT NULL,
	CONSTRAINT fk_crawl_benfit FOREIGN KEY(bid) REFERENCES Benefits(id)
);