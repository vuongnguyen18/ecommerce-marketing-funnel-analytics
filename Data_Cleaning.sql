/*create Database ecommerce_marketing_funnel;
USE ecommerce_marketing_funnel; */

/* The workflow for SQL is defined as: 
1. Raw tables 
2. Data profiling 
3. Data quality checks 
4. Clean views/tables 
5. Final Power BI schema */

-- 2. Data profiling
SELECT 'users' AS table_name, COUNT(*) AS row_count FROM dbo.users
UNION ALL
SELECT 'sessions', COUNT(*) FROM dbo.sessions
UNION ALL
SELECT 'interactions', COUNT(*) FROM dbo.interactions
UNION ALL
SELECT 'purchases', COUNT(*) FROM dbo.purchases
UNION ALL
SELECT 'products', COUNT(*) FROM dbo.products
UNION ALL
SELECT 'reviews', COUNT(*) FROM dbo.reviews;

-- 3. Data quality check
-- 3.1 Check missing value
--- Check missing value in user table
SELECT
    COUNT(*) AS total_rows,

    SUM(CASE WHEN user_id IS NULL OR TRIM(CAST(user_id AS VARCHAR(100))) = '' THEN 1 ELSE 0 END) AS missing_user_id,
    SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS missing_age,
    SUM(CASE WHEN gender IS NULL OR TRIM(CAST(gender AS VARCHAR(100))) = '' THEN 1 ELSE 0 END) AS missing_gender,
    SUM(CASE WHEN country IS NULL OR TRIM(CAST(country AS VARCHAR(100))) = '' THEN 1 ELSE 0 END) AS missing_country,
    SUM(CASE WHEN city IS NULL OR TRIM(CAST(city AS VARCHAR(100))) = '' THEN 1 ELSE 0 END) AS missing_city,
    SUM(CASE WHEN signup_date IS NULL THEN 1 ELSE 0 END) AS missing_signup_date,
    SUM(CASE WHEN income_level IS NULL OR TRIM(CAST(income_level AS VARCHAR(100))) = '' THEN 1 ELSE 0 END) AS missing_income_level,
    SUM(CASE WHEN preferred_category IS NULL OR TRIM(CAST(preferred_category AS VARCHAR(100))) = '' THEN 1 ELSE 0 END) AS missing_preferred_category,
    SUM(CASE WHEN loyalty_tier IS NULL OR TRIM(CAST(loyalty_tier AS VARCHAR(100))) = '' THEN 1 ELSE 0 END) AS missing_loyalty_tier
FROM dbo.users;

--- Check missing value in sessions table
SELECT
    COUNT(*) AS total_rows,

    SUM(CASE WHEN session_id IS NULL OR TRIM(CAST(session_id AS VARCHAR(100))) = '' THEN 1 ELSE 0 END) AS missing_session_id,
    SUM(CASE WHEN user_id IS NULL OR TRIM(CAST(user_id AS VARCHAR(100))) = '' THEN 1 ELSE 0 END) AS missing_user_id,
    SUM(CASE WHEN start_time IS NULL THEN 1 ELSE 0 END) AS missing_start_time,
    SUM(CASE WHEN device_type IS NULL OR TRIM(CAST(device_type AS VARCHAR(100))) = '' THEN 1 ELSE 0 END) AS missing_device_type,
    SUM(CASE WHEN referrer_source IS NULL OR TRIM(CAST(referrer_source AS VARCHAR(100))) = '' THEN 1 ELSE 0 END) AS missing_referrer_source,
    SUM(CASE WHEN is_converted IS NULL THEN 1 ELSE 0 END) AS missing_is_converted
FROM dbo.sessions;

--- check missing value in interactions table
SELECT
    COUNT(*) AS total_rows,

    SUM(CASE WHEN interaction_id IS NULL OR TRIM(CAST(interaction_id AS VARCHAR(100))) = '' THEN 1 ELSE 0 END) AS missing_interaction_id,
    SUM(CASE WHEN user_id IS NULL OR TRIM(CAST(user_id AS VARCHAR(100))) = '' THEN 1 ELSE 0 END) AS missing_user_id,
    SUM(CASE WHEN product_id IS NULL OR TRIM(CAST(product_id AS VARCHAR(100))) = '' THEN 1 ELSE 0 END) AS missing_product_id,
    SUM(CASE WHEN session_id IS NULL OR TRIM(CAST(session_id AS VARCHAR(100))) = '' THEN 1 ELSE 0 END) AS missing_session_id,
    SUM(CASE WHEN interaction_type IS NULL OR TRIM(CAST(interaction_type AS VARCHAR(100))) = '' THEN 1 ELSE 0 END) AS missing_interaction_type,
    SUM(CASE WHEN [timestamp] IS NULL THEN 1 ELSE 0 END) AS missing_timestamp,
    SUM(CASE WHEN dwell_time_ms IS NULL THEN 1 ELSE 0 END) AS missing_dwell_time_ms
FROM dbo.interactions;

--- check missing value in purchases
SELECT
    COUNT(*) AS total_rows,

    SUM(CASE WHEN purchase_id IS NULL OR TRIM(CAST(purchase_id AS VARCHAR(100))) = '' THEN 1 ELSE 0 END) AS missing_purchase_id,
    SUM(CASE WHEN order_id IS NULL OR TRIM(CAST(order_id AS VARCHAR(100))) = '' THEN 1 ELSE 0 END) AS missing_order_id,
    SUM(CASE WHEN user_id IS NULL OR TRIM(CAST(user_id AS VARCHAR(100))) = '' THEN 1 ELSE 0 END) AS missing_user_id,
    SUM(CASE WHEN product_id IS NULL OR TRIM(CAST(product_id AS VARCHAR(100))) = '' THEN 1 ELSE 0 END) AS missing_product_id,
    SUM(CASE WHEN session_id IS NULL OR TRIM(CAST(session_id AS VARCHAR(100))) = '' THEN 1 ELSE 0 END) AS missing_session_id,
    SUM(CASE WHEN interaction_id IS NULL OR TRIM(CAST(interaction_id AS VARCHAR(100))) = '' THEN 1 ELSE 0 END) AS missing_interaction_id,
    SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS missing_quantity,
    SUM(CASE WHEN unit_price IS NULL THEN 1 ELSE 0 END) AS missing_unit_price,
    SUM(CASE WHEN total_amount IS NULL THEN 1 ELSE 0 END) AS missing_total_amount,
    SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS missing_order_date
FROM dbo.purchases;

-- 3.2 Check duplicate keys
--- user_id
SELECT 
    user_id,
    COUNT(*) AS duplicate_count
FROM dbo.users
GROUP BY user_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

--- session_id
SELECT 
    session_id,
    COUNT(*) AS duplicate_count
FROM dbo.sessions
GROUP BY session_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

--- interaction_id
SELECT 
    interaction_id,
    COUNT(*) AS duplicate_count
FROM dbo.interactions
GROUP BY interaction_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

--- purchase_id
SELECT 
    purchase_id,
    COUNT(*) AS duplicate_count
FROM dbo.purchases
GROUP BY purchase_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- 3.3 Check invalid values
--- Check invalid age values
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN age < 13 OR age > 100 THEN 1 ELSE 0 END) AS invalid_age_rows
FROM dbo.users;

--- Check invalid category values in user segment
SELECT gender, COUNT(*) AS row_count
FROM dbo.users
GROUP BY gender
ORDER BY row_count DESC;

SELECT income_level, COUNT(*) AS row_count
FROM dbo.users
GROUP BY income_level
ORDER BY row_count DESC;

SELECT loyalty_tier, COUNT(*) AS row_count
FROM dbo.users
GROUP BY loyalty_tier
ORDER BY row_count DESC;

--- Check device and traffic source
SELECT device_type, COUNT(*) AS session_count
FROM dbo.sessions
GROUP BY device_type
ORDER BY session_count DESC;

SELECT referrer_source, COUNT(*) AS session_count
FROM dbo.sessions
GROUP BY referrer_source
ORDER BY session_count DESC;

--- Check interaction type
SELECT interaction_type, COUNT(*) AS interaction_count
FROM dbo.interactions
GROUP BY interaction_type
ORDER BY interaction_count DESC;

--- Check for unusual dwell time
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN dwell_time_ms < 0 THEN 1 ELSE 0 END) AS negative_dwell_time_rows,
    MIN(dwell_time_ms) AS min_dwell_time_ms,
    MAX(dwell_time_ms) AS max_dwell_time_ms,
    AVG(CAST(dwell_time_ms AS FLOAT)) AS avg_dwell_time_ms
FROM dbo.interactions;

--- Check purchase values
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN quantity <= 0 THEN 1 ELSE 0 END) AS invalid_quantity_rows,
    SUM(CASE WHEN unit_price < 0 THEN 1 ELSE 0 END) AS invalid_unit_price_rows,
    SUM(CASE WHEN total_amount < 0 THEN 1 ELSE 0 END) AS invalid_total_amount_rows,
    MIN(quantity) AS min_quantity,
    MAX(quantity) AS max_quantity,
    MIN(unit_price) AS min_unit_price,
    MAX(unit_price) AS max_unit_price,
    MIN(total_amount) AS min_total_amount,
    MAX(total_amount) AS max_total_amount
FROM dbo.purchases;

--- Check total_amount = quantity * unit_price
SELECT
    COUNT(*) AS total_rows,
    SUM(
        CASE 
            WHEN ABS(
                CAST(quantity AS DECIMAL(18,2)) * CAST(unit_price AS DECIMAL(18,2))
                - CAST(total_amount AS DECIMAL(18,2))
            ) > 0.01
            THEN 1 ELSE 0
        END
    ) AS amount_mismatch_rows
FROM dbo.purchases;

-- 3.4 Check relationship integrity
--- Check sessions if there is any invalid user 
SELECT COUNT(*) AS sessions_with_missing_user
FROM dbo.sessions s
LEFT JOIN dbo.users u
    ON s.user_id = u.user_id
WHERE u.user_id IS NULL;

--- Check interactions if there is any invalid sessions
SELECT COUNT(*) AS interactions_with_missing_session
FROM dbo.interactions i
LEFT JOIN dbo.sessions s
    ON i.session_id = s.session_id
WHERE s.session_id IS NULL;

--- Check interactions if there is not match users
SELECT COUNT(*) AS interactions_with_missing_user
FROM dbo.interactions i
LEFT JOIN dbo.users u
    ON i.user_id = u.user_id
WHERE u.user_id IS NULL;

--- Check if purchases not match sessions
SELECT COUNT(*) AS purchases_with_missing_session
FROM dbo.purchases p
LEFT JOIN dbo.sessions s
    ON p.session_id = s.session_id
WHERE s.session_id IS NULL;

--- Check purchases not match user
SELECT COUNT(*) AS purchases_with_missing_user
FROM dbo.purchases p
LEFT JOIN dbo.users u
    ON p.user_id = u.user_id
WHERE u.user_id IS NULL;

--- Check purchases not match interactions
SELECT COUNT(*) AS purchases_with_missing_interaction
FROM dbo.purchases p
LEFT JOIN dbo.interactions i
    ON p.interaction_id = i.interaction_id
WHERE i.interaction_id IS NULL;


-- 4. Clean views/tables
-- IMPORTANT:
-- Power BI will create dim_date, so SQL Server only creates:
-- dim_users, dim_device, dim_referrer_source, fact_session_funnel.
-- We use session_date DATE in fact_session_funnel instead of session_date_id.

-- 4.1 Clean users view
GO
CREATE OR ALTER VIEW dbo.vw_clean_users AS
SELECT DISTINCT
    CAST(user_id AS VARCHAR(36)) AS user_id,
    TRY_CAST(age AS INT) AS age,
    CASE
        WHEN TRY_CAST(age AS INT) BETWEEN 18 AND 24 THEN '18-24'
        WHEN TRY_CAST(age AS INT) BETWEEN 25 AND 34 THEN '25-34'
        WHEN TRY_CAST(age AS INT) BETWEEN 35 AND 44 THEN '35-44'
        WHEN TRY_CAST(age AS INT) BETWEEN 45 AND 54 THEN '45-54'
        WHEN TRY_CAST(age AS INT) >= 55 THEN '55+'
        ELSE 'Unknown'
    END AS age_group,
    LOWER(TRIM(CAST(gender AS VARCHAR(50)))) AS gender,
    UPPER(TRIM(CAST(country AS VARCHAR(50)))) AS country,
    TRIM(CAST(city AS VARCHAR(100))) AS city,
    TRY_CAST(signup_date AS DATE) AS signup_date,
    LOWER(TRIM(CAST(income_level AS VARCHAR(50)))) AS income_level,
    TRIM(CAST(preferred_category AS VARCHAR(100))) AS preferred_category,
    LOWER(TRIM(CAST(loyalty_tier AS VARCHAR(50)))) AS loyalty_tier
FROM dbo.users
WHERE user_id IS NOT NULL
  AND TRY_CAST(age AS INT) BETWEEN 13 AND 100;
GO

-- 4.2 Clean sessions view
CREATE OR ALTER VIEW dbo.vw_clean_sessions AS
SELECT DISTINCT
    CAST(session_id AS VARCHAR(36)) AS session_id,
    CAST(user_id AS VARCHAR(36)) AS user_id,
    CAST(
        TRY_CONVERT(DATETIME2(7), LEFT(CAST(start_time AS VARCHAR(50)), 27))
        AS DATETIME2(7)
    ) AS start_time,
    CAST(
        TRY_CONVERT(DATETIME2(7), LEFT(CAST(start_time AS VARCHAR(50)), 27))
        AS DATE
    ) AS session_date,
    LOWER(TRIM(CAST(device_type AS VARCHAR(30)))) AS device_type,
    LOWER(TRIM(CAST(referrer_source AS VARCHAR(50)))) AS referrer_source
FROM dbo.sessions
WHERE session_id IS NOT NULL
  AND user_id IS NOT NULL
  AND TRY_CONVERT(DATETIME2(7), LEFT(CAST(start_time AS VARCHAR(50)), 27)) IS NOT NULL;
GO

-- 4.3 Clean interactions view
CREATE OR ALTER VIEW dbo.vw_clean_interactions AS
SELECT DISTINCT
    CAST(interaction_id AS VARCHAR(36)) AS interaction_id,
    CAST(user_id AS VARCHAR(36)) AS user_id,
    CAST(session_id AS VARCHAR(36)) AS session_id,
    LOWER(TRIM(CAST(interaction_type AS VARCHAR(50)))) AS interaction_type,
    CAST(TRY_CONVERT(DATETIME2(7), LEFT(CAST([timestamp] AS VARCHAR(50)), 27)) AS DATETIME2(7)) AS interaction_time,
    TRY_CAST(dwell_time_ms AS INT) AS dwell_time_ms
FROM dbo.interactions
WHERE interaction_id IS NOT NULL
  AND session_id IS NOT NULL
  AND user_id IS NOT NULL
  AND TRY_CAST(dwell_time_ms AS INT) IS NOT NULL
  AND TRY_CAST(dwell_time_ms AS INT) >= 0
  AND LOWER(TRIM(CAST(interaction_type AS VARCHAR(50)))) IN ('view', 'click', 'add_to_cart', 'add to cart', 'wishlist');
GO

-- 4.4 Clean purchases view
CREATE OR ALTER VIEW dbo.vw_clean_purchases AS
SELECT DISTINCT
    CAST(purchase_id AS VARCHAR(36)) AS purchase_id,
    CAST(user_id AS VARCHAR(36)) AS user_id,
    CAST(session_id AS VARCHAR(36)) AS session_id,
    CAST(interaction_id AS VARCHAR(36)) AS interaction_id,
    TRY_CAST(quantity AS INT) AS quantity,
    TRY_CAST(unit_price AS DECIMAL(10,2)) AS unit_price,
    TRY_CAST(total_amount AS DECIMAL(12,2)) AS total_amount,
    CAST(TRY_CAST(quantity AS DECIMAL(18,2)) * TRY_CAST(unit_price AS DECIMAL(18,2)) AS DECIMAL(12,2)) AS calculated_amount,
    CAST(
        TRY_CAST(total_amount AS DECIMAL(18,2))
        - TRY_CAST(quantity AS DECIMAL(18,2)) * TRY_CAST(unit_price AS DECIMAL(18,2))
        AS DECIMAL(12,2)
    ) AS amount_difference,
    CAST(TRY_CONVERT(DATETIME2(7), LEFT(CAST(order_date AS VARCHAR(50)), 27)) AS DATETIME2(7)) AS order_time
FROM dbo.purchases
WHERE purchase_id IS NOT NULL
  AND user_id IS NOT NULL
  AND session_id IS NOT NULL
  AND TRY_CAST(quantity AS INT) > 0
  AND TRY_CAST(unit_price AS DECIMAL(10,2)) >= 0
  AND TRY_CAST(total_amount AS DECIMAL(12,2)) >= 0
  AND TRY_CONVERT(DATETIME2(7), LEFT(CAST(order_date AS VARCHAR(50)), 27)) IS NOT NULL;
GO

-- Optional check: confirm clean sessions has session_date
SELECT TOP 10 session_id, user_id, start_time, session_date, device_type, referrer_source
FROM dbo.vw_clean_sessions;
GO

-- 5. Final Power BI schema
-- Drop final tables first to avoid using an older fact table with session_date_id.
IF OBJECT_ID('dbo.fact_session_funnel', 'U') IS NOT NULL
BEGIN
    ALTER TABLE dbo.fact_session_funnel DROP CONSTRAINT IF EXISTS fk_fact_user;
    ALTER TABLE dbo.fact_session_funnel DROP CONSTRAINT IF EXISTS fk_fact_device;
    ALTER TABLE dbo.fact_session_funnel DROP CONSTRAINT IF EXISTS fk_fact_referrer;
END;
GO

DROP TABLE IF EXISTS dbo.fact_session_funnel;
DROP TABLE IF EXISTS dbo.dim_referrer_source;
DROP TABLE IF EXISTS dbo.dim_device;
DROP TABLE IF EXISTS dbo.dim_users;
GO

-- 5.1 Create dim_users
CREATE TABLE dbo.dim_users (
    user_id VARCHAR(36) PRIMARY KEY,
    age INT,
    age_group VARCHAR(20),
    gender VARCHAR(20),
    country VARCHAR(50),
    city VARCHAR(100),
    signup_date DATE,
    income_level VARCHAR(30),
    preferred_category VARCHAR(100),
    loyalty_tier VARCHAR(30)
);

INSERT INTO dbo.dim_users (
    user_id,
    age,
    age_group,
    gender,
    country,
    city,
    signup_date,
    income_level,
    preferred_category,
    loyalty_tier
)
SELECT
    user_id,
    age,
    age_group,
    gender,
    country,
    city,
    signup_date,
    income_level,
    preferred_category,
    loyalty_tier
FROM dbo.vw_clean_users;
GO

-- 5.2 Create dim_device
CREATE TABLE dbo.dim_device (
    device_id INT IDENTITY(1,1) PRIMARY KEY,
    device_type VARCHAR(30)
);

INSERT INTO dbo.dim_device (device_type)
SELECT DISTINCT device_type
FROM dbo.vw_clean_sessions
WHERE device_type IS NOT NULL
  AND device_type <> '';
GO

-- 5.3 Create dim_referrer_source
CREATE TABLE dbo.dim_referrer_source (
    referrer_source_id INT IDENTITY(1,1) PRIMARY KEY,
    referrer_source VARCHAR(50)
);

INSERT INTO dbo.dim_referrer_source (referrer_source)
SELECT DISTINCT referrer_source
FROM dbo.vw_clean_sessions
WHERE referrer_source IS NOT NULL
  AND referrer_source <> '';
GO

-- 5.4 Create fact_session_funnel
CREATE TABLE dbo.fact_session_funnel (
    session_id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(36),
    session_date DATE,
    device_id INT,
    referrer_source_id INT,

    start_time DATETIME2(7),

    has_view BIT,
    has_click BIT,
    has_add_to_cart BIT,
    has_wishlist BIT,
    has_purchase BIT,

    view_count INT,
    click_count INT,
    add_to_cart_count INT,
    wishlist_count INT,
    interaction_count INT,

    total_dwell_time_ms INT,
    avg_dwell_time_seconds DECIMAL(10,2),

    purchase_count INT,
    total_quantity INT,
    session_revenue DECIMAL(12,2),

    funnel_stage VARCHAR(50),
    drop_off_stage VARCHAR(50)
);
GO

-- 5.5 Insert data into fact_session_funnel
WITH interaction_agg AS (
    SELECT
        session_id,

        MAX(CASE WHEN interaction_type = 'view' THEN 1 ELSE 0 END) AS has_view,
        MAX(CASE WHEN interaction_type = 'click' THEN 1 ELSE 0 END) AS has_click,
        MAX(CASE WHEN interaction_type IN ('add_to_cart', 'add to cart') THEN 1 ELSE 0 END) AS has_add_to_cart,
        MAX(CASE WHEN interaction_type = 'wishlist' THEN 1 ELSE 0 END) AS has_wishlist,

        SUM(CASE WHEN interaction_type = 'view' THEN 1 ELSE 0 END) AS view_count,
        SUM(CASE WHEN interaction_type = 'click' THEN 1 ELSE 0 END) AS click_count,
        SUM(CASE WHEN interaction_type IN ('add_to_cart', 'add to cart') THEN 1 ELSE 0 END) AS add_to_cart_count,
        SUM(CASE WHEN interaction_type = 'wishlist' THEN 1 ELSE 0 END) AS wishlist_count,

        COUNT(*) AS interaction_count,
        SUM(dwell_time_ms) AS total_dwell_time_ms,
        CAST(AVG(CAST(dwell_time_ms AS DECIMAL(18,2))) / 1000 AS DECIMAL(10,2)) AS avg_dwell_time_seconds
    FROM dbo.vw_clean_interactions
    GROUP BY session_id
),

purchase_agg AS (
    SELECT
        session_id,
        1 AS has_purchase,
        COUNT(DISTINCT purchase_id) AS purchase_count,
        SUM(quantity) AS total_quantity,
        SUM(total_amount) AS session_revenue
    FROM dbo.vw_clean_purchases
    GROUP BY session_id
)

INSERT INTO dbo.fact_session_funnel (
    session_id,
    user_id,
    session_date,
    device_id,
    referrer_source_id,
    start_time,

    has_view,
    has_click,
    has_add_to_cart,
    has_wishlist,
    has_purchase,

    view_count,
    click_count,
    add_to_cart_count,
    wishlist_count,
    interaction_count,

    total_dwell_time_ms,
    avg_dwell_time_seconds,

    purchase_count,
    total_quantity,
    session_revenue,

    funnel_stage,
    drop_off_stage
)
SELECT
    s.session_id,
    s.user_id,
    s.session_date,
    d.device_id,
    r.referrer_source_id,
    s.start_time,

    ISNULL(i.has_view, 0),
    ISNULL(i.has_click, 0),
    ISNULL(i.has_add_to_cart, 0),
    ISNULL(i.has_wishlist, 0),
    ISNULL(p.has_purchase, 0),

    ISNULL(i.view_count, 0),
    ISNULL(i.click_count, 0),
    ISNULL(i.add_to_cart_count, 0),
    ISNULL(i.wishlist_count, 0),
    ISNULL(i.interaction_count, 0),

    ISNULL(i.total_dwell_time_ms, 0),
    ISNULL(i.avg_dwell_time_seconds, 0),

    ISNULL(p.purchase_count, 0),
    ISNULL(p.total_quantity, 0),
    ISNULL(p.session_revenue, 0),

    CASE
        WHEN ISNULL(p.has_purchase, 0) = 1 THEN 'Purchased'
        WHEN ISNULL(i.has_add_to_cart, 0) = 1 THEN 'Added to Cart'
        WHEN ISNULL(i.has_click, 0) = 1 THEN 'Clicked'
        WHEN ISNULL(i.has_view, 0) = 1 THEN 'Viewed'
        ELSE 'No Interaction'
    END AS funnel_stage,

    CASE
        WHEN ISNULL(p.has_purchase, 0) = 1 THEN 'Converted'
        WHEN ISNULL(i.has_add_to_cart, 0) = 1 THEN 'Drop after Cart'
        WHEN ISNULL(i.has_click, 0) = 1 THEN 'Drop after Click'
        WHEN ISNULL(i.has_view, 0) = 1 THEN 'Drop after View'
        ELSE 'No Interaction'
    END AS drop_off_stage

FROM dbo.vw_clean_sessions s
LEFT JOIN interaction_agg i
    ON s.session_id = i.session_id
LEFT JOIN purchase_agg p
    ON s.session_id = p.session_id
LEFT JOIN dbo.dim_device d
    ON s.device_type = d.device_type
LEFT JOIN dbo.dim_referrer_source r
    ON s.referrer_source = r.referrer_source
WHERE EXISTS (
    SELECT 1
    FROM dbo.dim_users u
    WHERE u.user_id = s.user_id
);
GO

-- 5.6 Add foreign keys
ALTER TABLE dbo.fact_session_funnel
ADD CONSTRAINT fk_fact_user
FOREIGN KEY (user_id) REFERENCES dbo.dim_users(user_id);

ALTER TABLE dbo.fact_session_funnel
ADD CONSTRAINT fk_fact_device
FOREIGN KEY (device_id) REFERENCES dbo.dim_device(device_id);

ALTER TABLE dbo.fact_session_funnel
ADD CONSTRAINT fk_fact_referrer
FOREIGN KEY (referrer_source_id) REFERENCES dbo.dim_referrer_source(referrer_source_id);
GO

-- 6. Final validation after clean
SELECT 'dim_users' AS table_name, COUNT(*) AS row_count FROM dbo.dim_users
UNION ALL
SELECT 'dim_device', COUNT(*) FROM dbo.dim_device
UNION ALL
SELECT 'dim_referrer_source', COUNT(*) FROM dbo.dim_referrer_source
UNION ALL
SELECT 'fact_session_funnel', COUNT(*) FROM dbo.fact_session_funnel;

SELECT
    SUM(CASE WHEN session_id IS NULL THEN 1 ELSE 0 END) AS null_session_id,
    SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS null_user_id,
    SUM(CASE WHEN session_date IS NULL THEN 1 ELSE 0 END) AS null_session_date,
    SUM(CASE WHEN device_id IS NULL THEN 1 ELSE 0 END) AS null_device_id,
    SUM(CASE WHEN referrer_source_id IS NULL THEN 1 ELSE 0 END) AS null_referrer_source_id
FROM dbo.fact_session_funnel;

SELECT
    COUNT(*) AS total_sessions,
    SUM(CAST(has_view AS INT)) AS sessions_with_view,
    SUM(CAST(has_click AS INT)) AS sessions_with_click,
    SUM(CAST(has_add_to_cart AS INT)) AS sessions_with_add_to_cart,
    SUM(CAST(has_wishlist AS INT)) AS sessions_with_wishlist,
    SUM(CAST(has_purchase AS INT)) AS sessions_with_purchase,
    SUM(session_revenue) AS total_revenue
FROM dbo.fact_session_funnel;

SELECT
    drop_off_stage,
    COUNT(*) AS session_count,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(10,2)) AS percentage
FROM dbo.fact_session_funnel
GROUP BY drop_off_stage
ORDER BY session_count DESC;
GO

-- Validate final SQL table
SELECT 'dim_users' AS table_name, COUNT(*) AS row_count FROM dbo.dim_users
UNION ALL
SELECT 'dim_device', COUNT(*) FROM dbo.dim_device
UNION ALL
SELECT 'dim_referrer_source', COUNT(*) FROM dbo.dim_referrer_source
UNION ALL
SELECT 'fact_session_funnel', COUNT(*) FROM dbo.fact_session_funnel;

--- Check null keys in fact table
SELECT
    SUM(CASE WHEN session_id IS NULL THEN 1 ELSE 0 END) AS null_session_id,
    SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS null_user_id,
    SUM(CASE WHEN session_date IS NULL THEN 1 ELSE 0 END) AS null_session_date,
    SUM(CASE WHEN device_id IS NULL THEN 1 ELSE 0 END) AS null_device_id,
    SUM(CASE WHEN referrer_source_id IS NULL THEN 1 ELSE 0 END) AS null_referrer_source_id
FROM dbo.fact_session_funnel;

--- check funnel summary
SELECT
    COUNT(*) AS total_sessions,
    SUM(CAST(has_view AS INT)) AS sessions_with_view,
    SUM(CAST(has_click AS INT)) AS sessions_with_click,
    SUM(CAST(has_add_to_cart AS INT)) AS sessions_with_add_to_cart,
    SUM(CAST(has_wishlist AS INT)) AS sessions_with_wishlist,
    SUM(CAST(has_purchase AS INT)) AS sessions_with_purchase,
    SUM(session_revenue) AS total_revenue
FROM dbo.fact_session_funnel;

--- check drop-off stage
SELECT
    drop_off_stage,
    COUNT(*) AS session_count,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(10,2)) AS percentage
FROM dbo.fact_session_funnel
GROUP BY drop_off_stage
ORDER BY session_count DESC;