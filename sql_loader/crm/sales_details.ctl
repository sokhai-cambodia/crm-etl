LOAD DATA
INFILE '/opt/oracle/oradata/datasets/source_crm/sales_details.csv'
INTO TABLE sale_detail
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
(
  sls_ord_num,
  sls_prd_key,
  sls_cust_id,
  sls_order_dt DATE "YYYYMMDD",
  sls_ship_dt  DATE "YYYYMMDD",
  sls_due_dt   DATE "YYYYMMDD",
  sls_sales,
  sls_quantity,
  sls_price
)
