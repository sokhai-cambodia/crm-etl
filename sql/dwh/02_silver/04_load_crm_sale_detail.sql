delete from silver_usr.crm_sales_details;
commit;

insert into silver_usr.crm_sales_details (
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
)
select
    sd.sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    case
        when LENGTH(sd.sls_order_dt) !=8 then null
        else to_date(sd.sls_order_dt,'yyyy-mm-dd')
    end as sls_order_dt,
    case
        when LENGTH(sd.sls_ship_dt) !=8 then null
        else to_date(sd.sls_ship_dt,'yyyy-mm-dd')
    end as sls_ship_dt,
    case
        when LENGTH(sd.sls_due_dt) !=8 then null
        else to_date(sd.sls_due_dt,'yyyy-mm-dd')
    end as sls_due_dt,
    case
        when
            sd.sls_sales is null
            or sd.sls_sales <=0
            or sls_quantity * ABS(sls_price) != sd.sls_sales
            then sls_quantity * ABS(sls_price)
        else sd.sls_sales
    end as sls_sales,
    sd.sls_quantity,
    case
        when sls_price is null or sls_price <=0
        then sd.sls_sales / NULLIF(sd.sls_quantity,0)
        else sls_price
    end as sls_price
from bronze_usr.crm_sale_detail sd;
commit;

select * from silver_usr.crm_sales_details;
