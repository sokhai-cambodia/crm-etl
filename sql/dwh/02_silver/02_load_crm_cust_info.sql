delete from silver_usr.crm_cust_info;
commit;

insert into silver_usr.crm_cust_info(
cst_id,cst_key,cst_firstname,cst_lastname,cst_marital_status,cst_gndr,cst_create_date
)
select
    cst_id,cst_key,
    TRIM(cst_firstname) as cst_firstname,
    TRIM(cst_lastname) as cst_lastname,
    case 
        when upper(TRIM(cst_marital_status))='S' then 'Single'
        when upper(TRIM(cst_marital_status))='M' then 'Married'
        else 'N/A'
    end as cst_marital_status,
    case 
        when upper(TRIM(cst_gndr))='F' then 'Female'
        when upper(TRIM(cst_gndr))='M' then 'Male'
        else 'N/A'
    end as cst_gndr,
    cst_create_date
from bronze_usr.vw_crm_cust_info 
commit;

select * from silver_usr.crm_cust_info;