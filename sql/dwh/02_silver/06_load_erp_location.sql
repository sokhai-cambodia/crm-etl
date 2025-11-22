delete from silver_usr.erp_location;
commit;

insert into silver_usr.erp_location (
    cid,
    cntry
)
select
replace(cid,'-','') as cid,
case
    when trim(cntry) ='DE' then 'Germany'
    when trim(cntry) in ('US','USA') then 'United States'
    when trim(cntry) = '' or trim(cntry) is null then 'N/A'
    else trim(cntry)
end cntry
from bronze_usr.erp_location;
commit;

select * from silver_usr.erp_location;