create view gold_usr.fact_sale as
select 
    sd.sls_ord_num as order_number,
    pr.product_key as product_key,
    cu.customer_key as customer_key,
    sd.sls_order_dt as order_date,
    sd.sls_ship_dt as shipping_date,
    sd.sls_due_dt as due_date,
    sd.sls_sales as sale_amount,
    sd.sls_quantity as quantity,
    sd.sls_price as price
from
    silver_usr.crm_sales_details sd
    left join gold_usr.dim_product pr on sd.sls_prd_key = pr.product_number
    left join gold_usr.dim_customers cu on sd.sls_cust_id = cu.customer_id;
