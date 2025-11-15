-- System
ALTER SESSION SET "_oracle_script"=true;
ALTER SESSION SET CONTAINER = XEPDB1;

-- Create users
CREATE USER usr_crm IDENTIFIED BY admin;
CREATE USER usr_erp IDENTIFIED BY admin;

-- Set Quotas
ALTER USER usr_crm QUOTA UNLIMITED ON USERS;
ALTER USER usr_erp QUOTA UNLIMITED ON USERS;

-- Grant Privileges
GRANT CREATE SESSION TO usr_crm, usr_erp;
GRANT CREATE TABLE TO usr_crm;
GRANT CREATE TABLE TO usr_erp;

-- Create tablespaces
CREATE TABLESPACE tbs_crm
DATAFILE '/opt/oracle/oradata/XE/XEPDB1/tbs_crm.dbf' SIZE 100M
AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED;

CREATE TABLESPACE tbs_erp
DATAFILE '/opt/oracle/oradata/XE/XEPDB1/tbs_erp.dbf' SIZE 100M
AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED;

-- Assign default tablespaces
ALTER USER usr_crm DEFAULT TABLESPACE tbs_crm;
ALTER USER usr_crm QUOTA 100M ON tbs_crm;

ALTER USER usr_erp DEFAULT TABLESPACE tbs_erp;
ALTER USER usr_erp QUOTA 100M ON tbs_erp;
