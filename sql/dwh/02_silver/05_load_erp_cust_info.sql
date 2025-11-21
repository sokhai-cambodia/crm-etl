delete from silver_usr.erp_cust_info;
commit;

insert into silver_usr.erp_cust_info (
    cid,
    bdate,
    gen
)
select
    case
        when cid like 'NAS%' then SUBSTR(cid,4,LENGTH(cid))
        else cid
    end as cid,
    case 
        when bdate > sysdate then null
        else bdate
    end bdate,
    case
        when upper(trim(gen)) in ('F','FEMALE') then 'Female'
        when upper(trim(gen)) in ('M','MALE') then 'Male'
        else 'N/A'
    end as gen
from bronze_usr.erp_customer;
commit;

select * from silver_usr.erp_cust_info;