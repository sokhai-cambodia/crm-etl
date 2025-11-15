-- Create CRM tables

CREATE TABLE customer_info (
    cst_id             NUMBER,
    cst_key            VARCHAR2(50),
    cst_firstname      VARCHAR2(100),
    cst_lastname       VARCHAR2(100),
    cst_marital_status VARCHAR2(5),
    cst_gndr           VARCHAR2(10),
    cst_create_date    DATE
);

CREATE TABLE product_info (
    prd_id       NUMBER,
    prd_key      VARCHAR2(50),
    prd_nm       VARCHAR2(200),
    prd_cost     NUMBER(10,2),
    prd_line     VARCHAR2(10),
    prd_start_dt DATE,
    prd_end_dt   DATE
);

CREATE TABLE sale_detail (
    sls_ord_num   VARCHAR2(20),
    sls_prd_key   VARCHAR2(50),
    sls_cust_id   NUMBER,
    sls_order_dt  DATE,
    sls_ship_dt   DATE,
    sls_due_dt    DATE,
    sls_sales     NUMBER(12,2),
    sls_quantity  NUMBER,
    sls_price     NUMBER(12,2)
);
