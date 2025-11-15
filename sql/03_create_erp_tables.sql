-- Create ERP tables

CREATE TABLE customer (
    CID    VARCHAR2(50),
    BDATE  DATE,
    GEN    VARCHAR2(20)
);

CREATE TABLE location (
    CID   VARCHAR2(50),
    CNTRY VARCHAR2(100)
);

CREATE TABLE category (
    ID           VARCHAR2(50),
    CAT          VARCHAR2(100),
    SUBCAT       VARCHAR2(100),
    MAINTENANCE  VARCHAR2(5)
);
