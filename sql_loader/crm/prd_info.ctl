LOAD DATA
INFILE '/opt/oracle/oradata/datasets/source_crm/prd_info.csv'
INTO TABLE product_info
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
(
  prd_id,
  prd_key,
  prd_nm,
  prd_cost,
  prd_line,
  prd_start_dt DATE "YYYY-MM-DD",
  prd_end_dt   DATE "YYYY-MM-DD"
)
