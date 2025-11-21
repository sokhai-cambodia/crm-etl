-- 10_bronze_create.sql
-- Create Bronze (raw ingestion) tables for CRM and ERP.
-- Run as: usr_crm for CRM tables, usr_erp for ERP tables (or run as system and use schema prefix).

-----------------------------
-- CRM Bronze (run as usr_crm)
-----------------------------
-- customer info raw
CREATE TABLE crm_customer_info (
    cst_id          VARCHAR2(100),
    cst_key         VARCHAR2(200),
    cst_firstname   VARCHAR2(200),
    cst_lastname    VARCHAR2(200),
    cst_marital_status VARCHAR2(20),
    cst_gndr        VARCHAR2(50),
    cst_create_date DATE,
    load_date           TIMESTAMP DEFAULT SYSTIMESTAMP,
    source_file         VARCHAR2(255)
);

-- product info raw
CREATE TABLE crm_product_info (
    prd_id       VARCHAR2(100),
    prd_key      VARCHAR2(200),
    prd_nm       VARCHAR2(500),
    prd_cost     VARCHAR2(100),
    prd_line     VARCHAR2(100),
    prd_start_dt DATE,
    prd_end_dt   DATE,
    load_date        TIMESTAMP DEFAULT SYSTIMESTAMP,
    source_file      VARCHAR2(255)
);

-- sales details raw
CREATE TABLE crm_sale_detail (
    sls_ord_num  VARCHAR2(200),
    sls_prd_key  VARCHAR2(200),
    sls_cust_id  VARCHAR2(200),
    sls_order_dt DATE,
    sls_ship_dt  DATE,
    sls_due_dt   DATE,
    sls_sales    NUMBER,
    sls_quantity NUMBER,
    sls_price    NUMBER,
    load_date        TIMESTAMP DEFAULT SYSTIMESTAMP,
    source_file      VARCHAR2(255)
);


-----------------------------
-- ERP Bronze (run as usr_erp)
-----------------------------
-- ERP customer raw
CREATE TABLE erp_customer (
    cid    VARCHAR2(200),
    bdate  DATE,
    gen    VARCHAR2(100),
    load_date  TIMESTAMP DEFAULT SYSTIMESTAMP,
    source_file VARCHAR2(255)
);

-- ERP location raw
CREATE TABLE erp_location (
    cid    VARCHAR2(200),
    cntry  VARCHAR2(200),
    load_date  TIMESTAMP DEFAULT SYSTIMESTAMP,
    source_file VARCHAR2(255)
);

-- ERP category/raw
CREATE TABLE erp_category (
    id        VARCHAR2(200),
    cat       VARCHAR2(200),
    subcat    VARCHAR2(200),
    maintenance VARCHAR2(50),
    load_date      TIMESTAMP DEFAULT SYSTIMESTAMP,
    source_file    VARCHAR2(255)
);

-- Done