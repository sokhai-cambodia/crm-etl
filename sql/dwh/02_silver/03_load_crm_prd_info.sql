delete from silver_usr.crm_prd_info;
commit;

insert into silver_usr.crm_prd_info(
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt   
)
select
    prd_id,
    REPLACE(SUBSTR(prd_key,1,5),'-','_') as cat_id,
    SUBSTR(prd_key,7,LENGTH(prd_key)) as prd_key,
    prd_nm,
    NVL(prd_cost,0) as prd_cost,
    case
        when upper(trim(prd_line)) ='M' then 'Mountain'
        when upper(trim(prd_line)) ='R' then 'Road'
        when upper(trim(prd_line)) ='S' then 'Other Sale'
        when upper(trim(prd_line)) ='T' then 'Touring'
        else 'N/A'
    end as prd_line,
    cast(prd_start_dt as date) as prd_start_dt,
        case when to_date(prd_end_dt,'yyyy-mm-dd')< prd_start_dt then cast(
        LEAD(prd_start_dt) over (partition by prd_key order by prd_start_dt) -1 as date
        ) 
        else to_date(prd_end_dt,'yyyy-mm-dd')
        end as prd_end_dt
from bronze_usr.crm_product_info;
commit;

select * from silver_usr.crm_prd_info;