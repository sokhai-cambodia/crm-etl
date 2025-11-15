-- System
ALTER SESSION SET "_oracle_script"=true;
ALTER SESSION SET CONTAINER = XEPDB1;

-- Create user
CREATE USER usr_crm identified by admin;
CREATE USER usr_erp identified by admin;

-- Set Quota user
ALTER USER usr_crm QUOTA UNLIMITED ON users;
ALTER USER usr_erp QUOTA UNLIMITED ON users;

-- Set permission user
GRANT CREATE SESSION TO usr_crm, usr_erp;
GRANT CREATE TABLE TO usr_crm;

GRANT CREATE SESSION TO usr_erp;
GRANT CREATE TABLE TO usr_erp;

-- Verify Privileges user
SELECT * FROM session_privs;

--DROP TABLESPACE tbs_crm;
--DROP TABLESPACE tbs_erp;

-- Create tablespace
CREATE TABLESPACE tbs_crm
DATAFILE '/opt/oracle/oradata/XE/XEPDB1/tbs_crm.dbf' SIZE 100M
AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED;

CREATE TABLESPACE tbs_erp
DATAFILE '/opt/oracle/oradata/XE/XEPDB1/tbs_erp.dbf' SIZE 100M
AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED;

-- Verify tablespace
SELECT tablespace_name, file_name FROM dba_data_files WHERE file_name LIKE '%tbs_crm%';
SELECT tablespace_name, file_name FROM dba_data_files WHERE file_name LIKE '%tbs_erp%';

-- Set default tbs to user
ALTER USER usr_crm DEFAULT TABLESPACE tbs_crm;
ALTER USER usr_crm QUOTA 100M ON tbs_crm;

ALTER USER usr_erp DEFAULT TABLESPACE tbs_erp;
ALTER USER usr_erp QUOTA 100M ON tbs_erp;


-- Create table for CRM
-- cust-info
CREATE TABLE customer_info (
    cst_id             NUMBER,
    cst_key            VARCHAR2(50),
    cst_firstname      VARCHAR2(100),
    cst_lastname       VARCHAR2(100),
    cst_marital_status VARCHAR2(5),
    cst_gndr           VARCHAR2(10),
    cst_create_date    DATE
);
-- prd-info
CREATE TABLE product_info (
    prd_id       NUMBER,
    prd_key      VARCHAR2(50),
    prd_nm       VARCHAR2(200),
    prd_cost     NUMBER(10,2),
    prd_line     VARCHAR2(10),
    prd_start_dt DATE,
    prd_end_dt   DATE
);
-- sales-details
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

-- Create table for ERP
-- cust-az12
CREATE TABLE customer (
    CID    VARCHAR2(50),
    BDATE  DATE,
    GEN    VARCHAR2(20)
);
-- loc-a101
CREATE TABLE location (
    CID   VARCHAR2(50),
    CNTRY VARCHAR2(100)
);
-- px-cat-g1v2
CREATE TABLE category (
    ID           VARCHAR2(50),
    CAT          VARCHAR2(100),
    SUBCAT       VARCHAR2(100),
    MAINTENANCE  VARCHAR2(5)
);


-- Verify Data
-- crm
SELECT * FROM customer_info;
SELECT * FROM product_info;
SELECT * FROM sale_detail;
-- erp
SELECT * FROM customer;
SELECT * FROM location;
SELECT * FROM category;
