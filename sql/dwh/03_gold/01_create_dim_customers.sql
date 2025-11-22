CREATE OR REPLACE FORCE NONEDITIONABLE VIEW gold_usr.dim_customers ("CUSTOMER_KEY", "CUSTOMER_ID", "CUSTOMER_NUMBER", "FIRST_NAME", "LAST_NAME", "MARITAL_STATUS", "GENDER", "CREATE_DATE", "BIRTHDATE", "COUNTRY") AS 
select 
    ROW_NUMBER() OVER (ORDER BY cci.cst_id) as customer_key,
    cci.cst_id as customer_id,
    cci.cst_key as customer_number,
    cci.cst_firstname as first_name,
    cci.cst_lastname as last_name,
    cci.cst_marital_status as marital_status,
        case 
        when cci.cst_gndr != 'n/a' then cci.cst_gndr
        else eci.gen
    end as gender,
    cci.cst_create_date as create_date,
    eci.bdate as birthdate,
    elt.cntry as country
from 
    silver_usr.crm_cust_info cci
    left join silver_usr.erp_cust_info eci on cci.cst_key = eci.cid
    left join silver_usr.erp_location elt on cci.cst_key = elt.cid;