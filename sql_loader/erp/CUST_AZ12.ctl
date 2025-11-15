LOAD DATA
INFILE '/opt/oracle/oradata/datasets/source_erp/CUST_AZ12.csv'
INTO TABLE customer
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
(
  cid,
  bdate DATE "YYYY-MM-DD",
  gen
)
