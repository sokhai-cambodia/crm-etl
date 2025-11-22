-- ===================================================
-- Data Warehouse Setup: Bronze, Silver, Gold Layers
-- ===================================================

-- Enable Oracle script mode for creating users in 21c+
ALTER SESSION SET "_oracle_script"=true;

-- ===================================================
-- 1. Create a role for Data Warehouse users
-- ===================================================
-- This role will have basic privileges to create tables, sequences, and sessions
CREATE ROLE dwh_role;
GRANT CREATE SESSION, CREATE TABLE, CREATE SEQUENCE TO dwh_role;

-- ===================================================
-- 2. Bronze Layer
-- ===================================================
-- Create tablespace for Bronze layer
CREATE TABLESPACE tbs_bronze_01
DATAFILE '/opt/oracle/oradata/XE/tbs_bronze_01.dbf' SIZE 1M
AUTOEXTEND ON NEXT 1M MAXSIZE 200M;

-- Create user for Bronze layer
CREATE USER bronze_usr IDENTIFIED BY 123
DEFAULT TABLESPACE tbs_bronze_01
QUOTA UNLIMITED ON tbs_bronze_01;

-- Grant role to Bronze user
GRANT dwh_role TO bronze_usr;

-- ===================================================
-- 3. Silver Layer
-- ===================================================
-- Create tablespace for Silver layer
CREATE TABLESPACE tbs_silver_01
DATAFILE '/opt/oracle/oradata/XE/tbs_silver_01.dbf' SIZE 1M
AUTOEXTEND ON NEXT 1M MAXSIZE 200M;

-- Create user for Silver layer
CREATE USER silver_usr IDENTIFIED BY 123
DEFAULT TABLESPACE tbs_silver_01
QUOTA UNLIMITED ON tbs_silver_01;

-- Grant role to Silver user
GRANT dwh_role TO silver_usr;

-- ===================================================
-- 4. Gold Layer
-- ===================================================
-- Create tablespace for Gold layer
CREATE TABLESPACE tbs_gold_01
DATAFILE '/opt/oracle/oradata/XE/tbs_gold_01.dbf' SIZE 1M
AUTOEXTEND ON NEXT 1M MAXSIZE 200M;

-- Create user for Gold layer
CREATE USER gold_usr IDENTIFIED BY 123
DEFAULT TABLESPACE tbs_gold_01
QUOTA UNLIMITED ON tbs_gold_01;

-- Grant role to Gold user
GRANT dwh_role TO gold_usr;

-- ===================================================
-- All Data Warehouse users and tablespaces created successfully
-- ===================================================
