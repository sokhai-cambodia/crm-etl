alter session set "_oracle_script"=true;

create role dwh_role;
grant create session,create table,create sequence to dwh_role;

Create tablespace tbs_bronze_01
datafile 'tbs_bronze_01.dbf' size 1M autoextend on next 1M maxsize 200M;
create user bronze_usr identified by 123
default tablespace tbs_bronze_01 quota unlimited on tbs_bronze_01;
grant dwh_role to bronze_usr;

Create tablespace tbs_silver_01
datafile 'tbs_silver_01.dbf' size 1M autoextend on next 1M maxsize 200M;
create user silver_usr identified by 123
default tablespace tbs_silver_01 quota unlimited on tbs_silver_01;
grant dwh_role to silver_usr;


Create tablespace tbs_gold_01
datafile 'tbs_gold_01.dbf' size 1M autoextend on next 1M maxsize 200M;
create user gold_usr identified by 123
default tablespace tbs_gold_01 quota unlimited on tbs_gold_01;
grant dwh_role to gold_usr;
