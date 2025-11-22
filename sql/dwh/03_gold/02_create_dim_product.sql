create view gold_usr.dim_product as
select
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt,pn.prd_key) as product_key,
    pn.prd_id as product_id,
    pn.prd_key as product_number,
    pn.prd_nm as product_name,
    pn.cat_id as category_id,
    pc.cat as category,
    pc.subcat as sub_category,
    pc.maintenance,
    pn.prd_cost cost,
    pn.prd_line product_line,
    pn.prd_start_dt as start_date
from
    silver_usr.crm_prd_info pn
    left join silver_usr.erp_category pc on pn.cat_id =pc.id
where
    prd_end_dt is null;