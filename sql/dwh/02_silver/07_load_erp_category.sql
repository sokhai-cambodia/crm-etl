delete from silver_usr.erp_category;
commit;

insert into silver_usr.erp_category (
    id,
    cat,
    subcat,
    maintenance
)
select
    id,
    cat,
    subcat,
    maintenance
from bronze_usr.erp_category;
commit;

select * from silver_usr.erp_category;