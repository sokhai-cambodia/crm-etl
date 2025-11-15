LOAD DATA
INFILE '/opt/oracle/oradata/datasets/source_erp/LOC_A101.csv'
INTO TABLE location
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
(
  cid,
  cntry
)
