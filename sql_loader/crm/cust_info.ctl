LOAD DATA
INFILE '/opt/oracle/oradata/datasets/source_crm/cust_info.csv'
INTO TABLE customer_info
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
(
  cst_id,
  cst_key,
  cst_firstname,
  cst_lastname,
  cst_marital_status,
  cst_gndr,
  cst_create_date DATE "YYYY-MM-DD"
)