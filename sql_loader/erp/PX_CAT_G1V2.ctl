LOAD DATA
INFILE '/opt/oracle/oradata/datasets/source_erp/PX_CAT_G1V2.csv'
INTO TABLE category
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
(
  id,
  cat,
  subcat,
  maintenance
)
