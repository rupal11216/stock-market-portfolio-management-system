-- Portfolio Management System SQL Setup Script

-- DROP TABLES (if exist for re-run)
BEGIN
    FOR table_name IN (
        SELECT table_name 
        FROM user_tables 
        WHERE table_name IN ('MARKET_NEWS', 'DIVIDEND', 'STOCK_PRICES', 'FEES', 'TRANSACTION', 'WATCHLIST', 'PORTFOLIO', 'STOCK', 'USERS')
    ) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || table_name.table_name || ' CASCADE CONSTRAINTS';
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/

-- USER TABLE
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone_no VARCHAR(15),
    email VARCHAR(100),
    join_date DATE
);

-- STOCK TABLE
CREATE TABLE stock (
    stock_id INT PRIMARY KEY,
    stock_symbol VARCHAR(10) UNIQUE,
    comp_name VARCHAR(100),
    market_sector VARCHAR(100)
);

-- PORTFOLIO TABLE
CREATE TABLE portfolio (
    portfolio_id INT PRIMARY KEY,
    user_id INT,
    total_value DECIMAL(15, 2),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- WATCHLIST TABLE
CREATE TABLE watchlist (
    watch_id INT PRIMARY KEY,
    user_id INT,
    stock_id INT,
    watchdate DATE,
    FOREIGN KEY (user_id) REFERENCES USERS(user_id),
    FOREIGN KEY (stock_id) REFERENCES stock(stock_id)
);

-- TRANSACTION TABLE
CREATE TABLE transaction (
    transaction_id INT PRIMARY KEY,
    portfolio_id INT,
    transaction_type VARCHAR(10) CHECK (transaction_type IN ('buy', 'sell')),
    transaction_date DATE,
    stock_id INT,
    quantity INT CHECK (quantity > 0),
    price_per_share DECIMAL(10, 2) CHECK (price_per_share > 0),
    FOREIGN KEY (portfolio_id) REFERENCES portfolio(portfolio_id),
    FOREIGN KEY (stock_id) REFERENCES stock(stock_id),
    UNIQUE (portfolio_id, stock_id, transaction_date, transaction_type)
);

-- FEES TABLE
CREATE TABLE fees (
    fee_id INT PRIMARY KEY,
    transaction_id INT,
    fee_type VARCHAR(50),
    fee_amount DECIMAL(10, 2),
    FOREIGN KEY (transaction_id) REFERENCES transaction(transaction_id)
);

-- STOCK PRICES TABLE
CREATE TABLE stock_prices (
    sp_id INT PRIMARY KEY,
    stock_id INT,
    price DECIMAL(10, 2),
    price_date DATE,
    FOREIGN KEY (stock_id) REFERENCES stock(stock_id)
);

-- DIVIDEND TABLE
CREATE TABLE dividend (
    dividend_id INT PRIMARY KEY,
    stock_id INT,
    d_amount DECIMAL(10, 2),
    d_date DATE,
    FOREIGN KEY (stock_id) REFERENCES stock(stock_id)
);

-- MARKET NEWS TABLE
CREATE TABLE market_news (
    news_id INT PRIMARY KEY,
    stock_id INT,
    headline VARCHAR(255),
    news_content VARCHAR2(5000),
    news_date DATE,
    news_source VARCHAR(100),
    FOREIGN KEY (stock_id) REFERENCES stock(stock_id)
);

-- SAMPLE DATA INSERTS

-- USERS portfolio watchlist transaction feees
INSERT INTO users VALUES (1, 'Alice', 'Smith', '1234567890', 'alice@example.com', DATE '2023-01-01');
INSERT INTO users VALUES (2, 'Bob', 'Johnson', '2345678901', 'bob@example.com', DATE '2023-02-01');
INSERT INTO users VALUES (3, 'Charlie', 'Lee', '3456789012', 'charlie@example.com', DATE '2023-03-01');
INSERT INTO users VALUES (4, 'Dana', 'Kim', '4567890123', 'dana@example.com', DATE '2023-04-01');
INSERT INTO users VALUES (5, 'Eve', 'Brown', '5678901234', 'eve@example.com', DATE '2023-05-01');
INSERT INTO users VALUES (6, 'Frank', 'White', '6789012345', 'frank@example.com', DATE '2023-06-01');
INSERT INTO users VALUES (7, 'Grace', 'Hall', '7890123456', 'grace@example.com', DATE '2023-07-01');
INSERT INTO users VALUES (8, 'Hank', 'Adams', '8901234567', 'hank@example.com', DATE '2023-08-01');
INSERT INTO users VALUES (9, 'Ivy', 'Clark', '9012345678', 'ivy@example.com', DATE '2023-09-01');
INSERT INTO users VALUES (10, 'Jack', 'Davis', '0123456789', 'jack@example.com', DATE '2023-10-01');

-- STOCKS
INSERT INTO stock VALUES (101, 'AAPL', 'Apple Inc.', 'Technology');
INSERT INTO stock VALUES (102, 'GOOG', 'Google LLC', 'Technology');
INSERT INTO stock VALUES (103, 'AMZN', 'Amazon.com Inc.', 'E-commerce');
INSERT INTO stock VALUES (104, 'TSLA', 'Tesla Inc.', 'Automotive');
INSERT INTO stock VALUES (105, 'NFLX', 'Netflix Inc.', 'Entertainment');
INSERT INTO stock VALUES (106, 'MSFT', 'Microsoft Corp.', 'Technology');
INSERT INTO stock VALUES (107, 'META', 'Meta Platforms', 'Social Media');
INSERT INTO stock VALUES (108, 'NVDA', 'NVIDIA Corp.', 'Semiconductors');
INSERT INTO stock VALUES (109, 'DIS', 'Walt Disney Co.', 'Entertainment');
INSERT INTO stock VALUES (110, 'BABA', 'Alibaba Group', 'E-commerce');

-- PORTFOLIOS
INSERT INTO portfolio VALUES (201, 1, 100000.00);
INSERT INTO portfolio VALUES (202, 2, 200000.00);
INSERT INTO portfolio VALUES (203, 3, 150000.00);
INSERT INTO portfolio VALUES (204, 4, 250000.00);
INSERT INTO portfolio VALUES (205, 5, 300000.00);
INSERT INTO portfolio VALUES (206, 6, 120000.00);
INSERT INTO portfolio VALUES (207, 7, 180000.00);
INSERT INTO portfolio VALUES (208, 8, 220000.00);
INSERT INTO portfolio VALUES (209, 9, 270000.00);
INSERT INTO portfolio VALUES (210, 10, 320000.00);

-- WATCHLIST
INSERT INTO watchlist VALUES (301, 1, 101, DATE '2023-06-01');
INSERT INTO watchlist VALUES (302, 2, 102, DATE '2023-06-02');
INSERT INTO watchlist VALUES (303, 3, 103, DATE '2023-06-03');
INSERT INTO watchlist VALUES (304, 4, 104, DATE '2023-06-04');
INSERT INTO watchlist VALUES (305, 5, 105, DATE '2023-06-05');
INSERT INTO watchlist VALUES (306, 6, 106, DATE '2023-06-06');
INSERT INTO watchlist VALUES (307, 7, 107, DATE '2023-06-07');
INSERT INTO watchlist VALUES (308, 8, 108, DATE '2023-06-08');
INSERT INTO watchlist VALUES (309, 9, 109, DATE '2023-06-09');
INSERT INTO watchlist VALUES (310, 10, 110, DATE '2023-06-10');

-- TRANSACTIONS
CREATE SEQUENCE transaction_seq START WITH 1 INCREMENT BY 1;

INSERT INTO transaction VALUES (transaction_seq.NEXTVAL, 201, 'buy', DATE '2023-06-10', 101, 10, 150.00);
INSERT INTO transaction VALUES (402, 202, 'sell', DATE '2023-06-11', 102, 5, 2800.00);
INSERT INTO transaction VALUES (403, 203, 'buy', DATE '2023-06-12', 103, 15, 3200.00);
INSERT INTO transaction VALUES (404, 204, 'buy', DATE '2023-06-13', 104, 20, 700.00);
INSERT INTO transaction VALUES (405, 205, 'sell', DATE '2023-06-14', 105, 8, 500.00);
INSERT INTO transaction VALUES (406, 206, 'buy', DATE '2023-06-15', 106, 12, 250.00);
INSERT INTO transaction VALUES (407, 207, 'sell', DATE '2023-06-16', 107, 6, 300.00);
INSERT INTO transaction VALUES (408, 208, 'buy', DATE '2023-06-17', 108, 18, 400.00);
INSERT INTO transaction VALUES (409, 209, 'buy', DATE '2023-06-18', 109, 25, 120.00);
INSERT INTO transaction VALUES (410, 210, 'sell', DATE '2023-06-19', 110, 10, 150.00);

-- FEES
INSERT INTO fees VALUES (501, 401, 'Brokerage', 10.00);
INSERT INTO fees VALUES (502, 402, 'Transaction', 15.00);
INSERT INTO fees VALUES (503, 403, 'Service', 12.50);
INSERT INTO fees VALUES (504, 404, 'Brokerage', 14.00);
INSERT INTO fees VALUES (505, 405, 'Transaction', 9.00);
INSERT INTO fees VALUES (506, 406, 'Brokerage', 11.00);
INSERT INTO fees VALUES (507, 407, 'Transaction', 13.00);
INSERT INTO fees VALUES (508, 408, 'Service', 10.50);
INSERT INTO fees VALUES (509, 409, 'Brokerage', 12.00);
INSERT INTO fees VALUES (510, 410, 'Transaction', 8.50);

-- STOCK PRICES
INSERT INTO stock_prices VALUES (601, 101, 155.00, DATE '2023-06-15');
INSERT INTO stock_prices VALUES (602, 102, 2825.00, DATE '2023-06-15');
INSERT INTO stock_prices VALUES (603, 103, 3250.00, DATE '2023-06-15');
INSERT INTO stock_prices VALUES (604, 104, 710.00, DATE '2023-06-15');
INSERT INTO stock_prices VALUES (605, 105, 510.00, DATE '2023-06-15');
INSERT INTO stock_prices VALUES (606, 106, 260.00, DATE '2023-06-15');
INSERT INTO stock_prices VALUES (607, 107, 315.00, DATE '2023-06-15');
INSERT INTO stock_prices VALUES (608, 108, 420.00, DATE '2023-06-15');
INSERT INTO stock_prices VALUES (609, 109, 125.00, DATE '2023-06-15');
INSERT INTO stock_prices VALUES (610, 110, 160.00, DATE '2023-06-15');

-- DIVIDENDS
INSERT INTO dividend VALUES (701, 101, 1.50, DATE '2023-06-20');
INSERT INTO dividend VALUES (702, 102, 2.00, DATE '2023-06-21');
INSERT INTO dividend VALUES (703, 103, 2.50, DATE '2023-06-22');
INSERT INTO dividend VALUES (704, 104, 3.00, DATE '2023-06-23');
INSERT INTO dividend VALUES (705, 105, 1.75, DATE '2023-06-24');
INSERT INTO dividend VALUES (706, 106, 1.25, DATE '2023-06-25');
INSERT INTO dividend VALUES (707, 107, 1.50, DATE '2023-06-26');
INSERT INTO dividend VALUES (708, 108, 2.00, DATE '2023-06-27');
INSERT INTO dividend VALUES (709, 109, 1.75, DATE '2023-06-28');
INSERT INTO dividend VALUES (710, 110, 1.50, DATE '2023-06-29');

-- MARKET NEWS
INSERT INTO market_news VALUES (801, 101, 'Apple iPhone 15 Launch', 'Apple released its latest model.', DATE '2023-06-25', 'Bloomberg');
INSERT INTO market_news VALUES (802, 102, 'Google AI Breakthrough', 'New AI models released.', DATE '2023-06-26', 'TechCrunch');
INSERT INTO market_news VALUES (803, 103, 'Amazon Expands Globally', 'New markets entered.', DATE '2023-06-27', 'Reuters');
INSERT INTO market_news VALUES (804, 104, 'Tesla New Factory', 'Opened in Berlin.', DATE '2023-06-28', 'CNBC');
INSERT INTO market_news VALUES (805, 105, 'Netflix New Shows', '2023 lineup revealed.', DATE '2023-06-29', 'Hollywood Reporter');
INSERT INTO market_news VALUES (806, 106, 'Microsoft Cloud Growth', 'Azure revenue increases.', DATE '2023-06-30', 'Forbes');
INSERT INTO market_news VALUES (807, 107, 'Meta VR Expansion', 'New VR devices launched.', DATE '2023-07-01', 'The Verge');
INSERT INTO market_news VALUES (808, 108, 'NVIDIA AI Chips', 'Demand surges for GPUs.', DATE '2023-07-02', 'TechRadar');
INSERT INTO market_news VALUES (809, 109, 'Disney Streaming Growth', 'Subscribers hit record.', DATE '2023-07-03', 'Variety');
INSERT INTO market_news VALUES (810, 110, 'Alibaba Cloud Expansion', 'New data centers opened.', DATE '2023-07-04', 'Reuters');


/*
-- RELATIONAL TABLES

-- USER_PORTFOLIO_RELATION
CREATE TABLE user_portfolio_relation (
    user_id INT,
    portfolio_id INT,
    PRIMARY KEY (user_id, portfolio_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (portfolio_id) REFERENCES portfolio(portfolio_id)
);

-- USER_WATCHLIST_RELATION
CREATE TABLE user_watchlist_relation (
    user_id INT,
    watch_id INT,
    PRIMARY KEY (user_id, watch_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (watch_id) REFERENCES watchlist(watch_id)
);

-- PORTFOLIO_TRANSACTION_RELATION
CREATE TABLE portfolio_transaction_relation (
    portfolio_id INT,
    transaction_id INT,
    PRIMARY KEY (portfolio_id, transaction_id),
    FOREIGN KEY (portfolio_id) REFERENCES portfolio(portfolio_id),
    FOREIGN KEY (transaction_id) REFERENCES transaction(transaction_id)
);

-- TRANSACTION_FEES_RELATION
CREATE TABLE transaction_fees_relation (
    transaction_id INT,
    fee_id INT,
    PRIMARY KEY (transaction_id, fee_id),
    FOREIGN KEY (transaction_id) REFERENCES transaction(transaction_id),
    FOREIGN KEY (fee_id) REFERENCES fees(fee_id)
);

-- STOCK_PRICE_RELATION
CREATE TABLE stock_price_relation (
    stock_id INT,
    sp_id INT,
    PRIMARY KEY (stock_id, sp_id),
    FOREIGN KEY (stock_id) REFERENCES stock(stock_id),
    FOREIGN KEY (sp_id) REFERENCES stock_prices(sp_id)
);

-- STOCK_DIVIDEND_RELATION
CREATE TABLE stock_dividend_relation (
    stock_id INT,
    dividend_id INT,
    PRIMARY KEY (stock_id, dividend_id),
    FOREIGN KEY (stock_id) REFERENCES stock(stock_id),
    FOREIGN KEY (dividend_id) REFERENCES dividend(dividend_id)
);

-- STOCK_NEWS_RELATION
CREATE TABLE stock_news_relation (
    stock_id INT,
    news_id INT,
    PRIMARY KEY (stock_id, news_id),
    FOREIGN KEY (stock_id) REFERENCES stock(stock_id),
    FOREIGN KEY (news_id) REFERENCES market_news(news_id)
);

-- USER_BUYS_STOCK_RELATION
CREATE TABLE user_buys_stock_relation (
    user_id INT,
    stock_id INT,
    transaction_id INT,
    PRIMARY KEY (user_id, stock_id, transaction_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (stock_id) REFERENCES stock(stock_id),
    FOREIGN KEY (transaction_id) REFERENCES transaction(transaction_id)
);
-- STOCK_INVOLVES_TRANSACTION_RELATION
CREATE TABLE stock_involves_transaction_relation (
    stock_id INT,
    transaction_id INT,
    PRIMARY KEY (stock_id, transaction_id),
    FOREIGN KEY (stock_id) REFERENCES stock(stock_id),
    FOREIGN KEY (transaction_id) REFERENCES transaction(transaction_id)
);
-- PORTFOLIO_INCLUDES_STOCK_RELATION
CREATE TABLE portfolio_includes_stock_relation (
    portfolio_id INT,
    stock_id INT,
    PRIMARY KEY (portfolio_id, stock_id),
    FOREIGN KEY (portfolio_id) REFERENCES portfolio(portfolio_id),
    FOREIGN KEY (stock_id) REFERENCES stock(stock_id)
);

*/
-- Add new user

-- Procedure to add a new user to the system.
-- Expected format for p_email: Must be a valid email address (e.g., user@example.com).
-- Expected format for p_phone_no: Maximum length of 15 characters, numeric or alphanumeric.

CREATE OR REPLACE PROCEDURE add_new_user (
    p_first_name IN VARCHAR2,
    p_last_name IN VARCHAR2,
    p_phone_no IN VARCHAR2,
    p_email IN VARCHAR2
) AS
BEGIN
    -- Validate email format
    IF NOT REGEXP_LIKE(p_email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid email format.');
        RETURN;
    END IF;

    -- Validate phone number length
    IF LENGTH(p_phone_no) > 15 THEN
        DBMS_OUTPUT.PUT_LINE('Error: Phone number exceeds maximum length of 15 characters.');
        RETURN;
    END IF;

    INSERT INTO users (user_id, first_name, last_name, phone_no, email, join_date)
    VALUES (
        (SELECT NVL(MAX(user_id), 0) + 1 FROM users), 
        p_first_name, 
        p_last_name, 
        p_phone_no, 
        p_email, 
        SYSDATE
    );
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('User ' || p_first_name || ' ' || p_last_name || ' added successfully.');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Error: Email or phone number already exists.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
-- 2nd buy stock procedure
CREATE OR REPLACE PROCEDURE buy_stock (
    p_user_id IN NUMBER,
    p_stock_symbol IN VARCHAR2,
    p_quantity IN NUMBER,
    p_purchase_price IN NUMBER
)
AS
    v_stock_id NUMBER;
    v_portfolio_id NUMBER;
BEGIN
    -- Get the stock ID
    SELECT stock_id INTO v_stock_id 
    FROM stock 
    WHERE stock_symbol = p_stock_symbol;

    -- Get the user's portfolio ID
    SELECT portfolio_id INTO v_portfolio_id 
    FROM portfolio 
    WHERE user_id = p_user_id;

    -- Insert the BUY transaction
    INSERT INTO transaction (
        transaction_id, portfolio_id, transaction_type, transaction_date,
        stock_id, quantity, price_per_share
    )
    VALUES (
        transaction_seq.NEXTVAL,
        v_portfolio_id,
        'BUY',
        SYSDATE,
        v_stock_id,
        p_quantity,
        p_purchase_price
    );

    -- Update the portfolio's total value
    UPDATE portfolio
    SET total_value = total_value + (p_quantity * p_purchase_price)
    WHERE portfolio_id = v_portfolio_id;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Purchase of ' || p_quantity || ' shares of ' || p_stock_symbol || ' recorded.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid user or stock.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
--3. sell stock procedure
CREATE OR REPLACE PROCEDURE sell_stock (
    p_user_id IN NUMBER,
    p_stock_symbol IN VARCHAR2,
    p_quantity IN NUMBER,
    p_sale_price IN NUMBER
)
AS
    v_stock_id NUMBER;
    v_portfolio_id NUMBER;
    v_available_quantity NUMBER;
BEGIN
    -- Get the stock ID
    SELECT stock_id INTO v_stock_id 
    FROM stock 
    WHERE stock_symbol = p_stock_symbol;

    -- Get the user's portfolio ID
    SELECT portfolio_id INTO v_portfolio_id 
    FROM portfolio 
    WHERE user_id = p_user_id;

    -- Check if the user has enough stock to sell
    SELECT NVL(SUM(CASE 
                   WHEN transaction_type = 'BUY' THEN quantity 
                   WHEN transaction_type = 'SELL' THEN -quantity 
                   ELSE 0 
               END), 0)
    INTO v_available_quantity
    FROM transaction
    WHERE portfolio_id = v_portfolio_id AND stock_id = v_stock_id;

    IF v_available_quantity < p_quantity THEN
        DBMS_OUTPUT.PUT_LINE('Error: Insufficient stock to sell.');
        RETURN;
    END IF;

    -- Insert the SELL transaction
    INSERT INTO transaction (
        transaction_id, portfolio_id, transaction_type, transaction_date,
        stock_id, quantity, price_per_share
    )
    VALUES (
        transaction_seq.NEXTVAL,
        v_portfolio_id,
        'SELL',
        SYSDATE,
        v_stock_id,
        p_quantity,
        p_sale_price
    );

    -- Update the portfolio's total value
    UPDATE portfolio
    SET total_value = total_value - (p_quantity * p_sale_price)
    WHERE portfolio_id = v_portfolio_id;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Sale of ' || p_quantity || ' shares of ' || p_stock_symbol || ' recorded.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid user or stock.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
--4.  Get current value of user portfolio 
CREATE OR REPLACE FUNCTION get_portfolio_value(v_portfolio_id IN NUMBER) 
    RETURN NUMBER IS
    v_total_value NUMBER := 0;
BEGIN
    -- Loop through each stock in the portfolio
    FOR stock_rec IN (
        SELECT t.stock_id,
               SUM(CASE WHEN t.transaction_type = 'buy' THEN t.quantity
                        ELSE -t.quantity END) AS total_quantity
        FROM transaction t
        WHERE t.portfolio_id = v_portfolio_id
        GROUP BY t.stock_id
    ) LOOP
        -- Get the latest price for each stock
        SELECT sp.price INTO v_total_value
        FROM stock_prices sp
        WHERE sp.stock_id = stock_rec.stock_id
        AND sp.price_date = (SELECT MAX(price_date) FROM stock_prices);
        
        -- Multiply the stock quantity by the price and add it to the total value
        v_total_value := v_total_value + (stock_rec.total_quantity * v_total_value);
    END LOOP;

    -- If no value was calculated, return 0
    IF v_total_value IS NULL THEN
        v_total_value := 0;
    END IF;

    RETURN v_total_value;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- In case no data was found, return 0
        RETURN 0;
    WHEN OTHERS THEN
        -- In case of any other error, print a message and return NULL
        DBMS_OUTPUT.PUT_LINE('Error calculating portfolio value: ' || SQLERRM);
        RETURN NULL;
END;
/

--5. Display user's current holding 
CREATE OR REPLACE PROCEDURE display_user_holdings (
    p_user_id IN NUMBER
) AS
    v_portfolio_id NUMBER;
BEGIN
    -- Get the user's portfolio ID
    SELECT portfolio_id INTO v_portfolio_id 
    FROM portfolio 
    WHERE user_id = p_user_id;

    -- Print header
    DBMS_OUTPUT.PUT_LINE('--- Current Holdings for User ID: ' || p_user_id || ' ---');
    
    -- Loop through each stock in the portfolio
    FOR stock_rec IN (
        SELECT 
            s.stock_symbol,
            SUM(CASE WHEN t.transaction_type = 'buy' THEN t.quantity
                     WHEN t.transaction_type = 'sell' THEN -t.quantity
                     ELSE 0 END) AS total_quantity
        FROM transaction t
        JOIN stock s ON t.stock_id = s.stock_id
        WHERE t.portfolio_id = v_portfolio_id
        GROUP BY s.stock_symbol
    ) LOOP
        -- Print the stock symbol and quantity
        DBMS_OUTPUT.PUT_LINE('Stock: ' || stock_rec.stock_symbol || 
                             ', Quantity: ' || stock_rec.total_quantity);
    END LOOP;

    -- Print footer
    DBMS_OUTPUT.PUT_LINE('------------------------------------------');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No holdings found for this user.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred while displaying holdings: ' || SQLERRM);
END;
/
--6.  Display Watchlist Stocks
CREATE OR REPLACE PROCEDURE display_watchlist_stocks (
    p_user_id IN NUMBER
) AS
    v_count NUMBER := 0;
BEGIN
    -- Check if the user exists
    SELECT COUNT(*) INTO v_count
    FROM users
    WHERE user_id = p_user_id;

    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Error: User with ID ' || p_user_id || ' does not exist.');
        RETURN;
    END IF;

    -- Print header
    DBMS_OUTPUT.PUT_LINE('--- Stocks in Watchlist for User ID: ' || p_user_id || ' ---');

    -- Loop through the user's watchlist
    FOR stock_rec IN (
        SELECT s.stock_symbol, w.watchdate
        FROM watchlist w
        JOIN stock s ON w.stock_id = s.stock_id
        WHERE w.user_id = p_user_id
    ) LOOP
        -- Print the stock symbol and watch date
        DBMS_OUTPUT.PUT_LINE('Stock: ' || stock_rec.stock_symbol || 
                             ' - Added on: ' || TO_CHAR(stock_rec.watchdate, 'YYYY-MM-DD'));
    END LOOP;

    -- If no stocks in the watchlist, print a message
    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No stocks in watchlist for this user.');
    END IF;

    -- Print footer
    DBMS_OUTPUT.PUT_LINE('------------------------------------------');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred while displaying watchlist stocks: ' || SQLERRM);
END;
/




--7. Display recent news for a stock

CREATE OR REPLACE PROCEDURE display_stock_news (
    p_stock_symbol IN VARCHAR2,
    p_num_articles IN NUMBER DEFAULT 5 -- Display the last 5 articles by default
) AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Recent News for ' || p_stock_symbol || ' ---');

    FOR news_rec IN (
        SELECT headline, news_source, TO_CHAR(news_date, 'YYYY-MM-DD') AS formatted_date
        FROM (
            SELECT headline, news_source, news_date
            FROM market_news
            WHERE stock_id = (SELECT stock_id FROM stock WHERE stock_symbol = p_stock_symbol)
            ORDER BY news_date DESC
        )
        WHERE ROWNUM <= p_num_articles
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Headline: ' || news_rec.headline);
        DBMS_OUTPUT.PUT_LINE('Source: ' || news_rec.news_source);
        DBMS_OUTPUT.PUT_LINE('Published On: ' || news_rec.formatted_date);
        DBMS_OUTPUT.PUT_LINE('---------------------------------------');
    END LOOP;

    -- Handle case where no news articles are found
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No recent news found for "' || p_stock_symbol || '".');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred while displaying news: ' || SQLERRM);
END;
/