-- ==========================================
-- Personal Financial System - PostgreSQL
-- ==========================================

-- 先建立 ENUM 類型
CREATE TYPE category_type AS ENUM ('expense', 'revenue');
CREATE TYPE transaction_type AS ENUM ('expense', 'revenue');
CREATE TYPE benefit_type AS ENUM ('cash', 'point', 'discount');
CREATE TYPE crawl_status AS ENUM ('pending', 'success', 'failed');

-- ==========================================
-- 自動更新 updated_at 的 trigger function
-- （PostgreSQL 沒有 ON UPDATE CURRENT_TIMESTAMP）
-- ==========================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ==========================================
-- Users
-- ==========================================
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(256) NOT NULL,
    telegram_bot_id VARCHAR(256) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- Accounts（支援樹狀結構 parent_id）
-- ==========================================
CREATE TABLE accounts (
    id SERIAL PRIMARY KEY,
    name VARCHAR(256) NOT NULL,
    parent_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    uid INT NOT NULL,
    CONSTRAINT fk_user FOREIGN KEY (uid) REFERENCES users(id),
    CONSTRAINT fk_account_parent FOREIGN KEY (parent_id) REFERENCES accounts(id)
);

-- ==========================================
-- AccountBalanceSnapshot
-- ==========================================
CREATE TABLE account_balance_snapshot (
    id SERIAL PRIMARY KEY,
    aid INT NOT NULL,
    balance DECIMAL(15,2) NOT NULL,
    snapshot_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_snapshot_account FOREIGN KEY (aid) REFERENCES accounts(id),
    UNIQUE (aid, snapshot_date)   -- 每個帳戶每天只會進行一次 snapshot
);

-- ==========================================
-- Category（支援樹狀結構 parent_id）
-- ==========================================
CREATE TABLE category (
    id SERIAL PRIMARY KEY,
    name VARCHAR(256) NOT NULL,
    category_type category_type,
    parent_id INT,
    CONSTRAINT fk_category_parent FOREIGN KEY (parent_id) REFERENCES category(id)
);

-- ==========================================
-- PaymentMethod
-- ==========================================
CREATE TABLE payment_method (
    id SERIAL PRIMARY KEY,
    method_name VARCHAR(256) NOT NULL,
    linked_account_id INT,
    payment_type VARCHAR(256) NOT NULL,
    credit_limit DECIMAL(15,2),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_payment_account FOREIGN KEY (linked_account_id) REFERENCES accounts(id)
);

-- ==========================================
-- Transactions
-- ==========================================
CREATE TABLE transactions (
    id SERIAL PRIMARY KEY,
    transaction_type transaction_type NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    transactions_date DATE NOT NULL,
    merchant_name VARCHAR(256),
    description VARCHAR(512),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    cid INT NOT NULL,
    pid INT NOT NULL,
    aid INT NOT NULL,
    CONSTRAINT fk_transaction_category FOREIGN KEY (cid) REFERENCES category(id),
    CONSTRAINT fk_transaction_payment FOREIGN KEY (pid) REFERENCES payment_method(id),
    CONSTRAINT fk_transaction_account FOREIGN KEY (aid) REFERENCES accounts(id)
);

-- 自動更新 updated_at
CREATE TRIGGER set_transactions_updated_at
    BEFORE UPDATE ON transactions
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ==========================================
-- Benefits
-- ==========================================
CREATE TABLE benefits (
    id SERIAL PRIMARY KEY,
    merchant_name VARCHAR(256) NOT NULL,
    merchant_category VARCHAR(128),
    benefit_type benefit_type NOT NULL,
    benefit_value DECIMAL(8,4) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    valid_from DATE,
    valid_until DATE,
    max_benefit DECIMAL(15,2),
    min_spend DECIMAL(15,2),
    conditions TEXT,
    pid INT NOT NULL,
    CONSTRAINT fk_benefit_payment FOREIGN KEY (pid) REFERENCES payment_method(id)
);

-- ==========================================
-- TransactionBenefit
-- ==========================================
CREATE TABLE transaction_benefit (
    id SERIAL PRIMARY KEY,
    tid INT NOT NULL,
    bid INT NOT NULL,
    applied_value DECIMAL(15,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_tb_transaction FOREIGN KEY (tid) REFERENCES transactions(id),
    CONSTRAINT fk_tb_benefit FOREIGN KEY (bid) REFERENCES benefits(id),
    UNIQUE (tid, bid)  -- 同一筆交易不重複套用同一優惠
);

-- ==========================================
-- CrawlSnapshot
-- ==========================================
CREATE TABLE crawl_snapshot (
    id SERIAL PRIMARY KEY,
    source_url VARCHAR(256),
    issuer VARCHAR(128),
    raw_data TEXT,            -- MySQL 的 LONGTEXT → PostgreSQL 的 TEXT
    status crawl_status NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    bid INT NOT NULL,
    CONSTRAINT fk_crawl_benefit FOREIGN KEY (bid) REFERENCES benefits(id)
);
