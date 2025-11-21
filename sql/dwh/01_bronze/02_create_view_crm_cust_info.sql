create VIEW bronze_usr.vw_crm_cust_info as 
select
    cst_id,cst_key,cst_firstname,cst_lastname,cst_marital_status,cst_gndr,cst_create_date,
    ROW_NUMBER() over (PARTITION BY cst_id order by cst_create_date desc) as flag_last
from
bronze_usr.crm_customer_info;