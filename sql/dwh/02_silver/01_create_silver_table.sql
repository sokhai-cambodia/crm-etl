create table silver_usr.crm_cust_info(
    cst_id NUMBER,
    cst_key NVARCHAR2(50),
    cst_firstname NVARCHAR2(50),
    cst_lastname NVARCHAR2(50),
    cst_marital_status NVARCHAR2(50),
    cst_gndr NVARCHAR2(50),
    cst_create_date date,
    load_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

create table silver_usr.crm_prd_info(
    prd_id NUMBER,
    cat_id NVARCHAR2(50),
    prd_key NVARCHAR2(50),
    prd_nm NVARCHAR2(50),
    prd_cost NVARCHAR2(50),
    prd_line NVARCHAR2(50),
    prd_start_dt NVARCHAR2(50),
    prd_end_dt NVARCHAR2(50),
    load_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

create table silver_usr.crm_sales_details(
    sls_ord_num NVARCHAR2(50),
    sls_prd_key NVARCHAR2(50),
    sls_cust_id NUMBER,
    sls_order_dt date,
    sls_ship_dt date,
    sls_due_dt date,
    sls_sales NUMBER,
    sls_quantity NUMBER,
    sls_price NUMBER,
    load_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);

create table silver_usr.erp_loc_a101(
    cid NVARCHAR2(50),
    cntry NVARCHAR2(50),
    load_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

create table silver_usr.erp_cust_az12(
    cid NVARCHAR2(50),
    bdate date,
    gen  NVARCHAR2(50),
    load_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

create table silver_usr.erp_px_cat_g1v2(
    id NVARCHAR2(50),
    cat NVARCHAR2(50),
    subcat NVARCHAR2(50),
    maintenance NVARCHAR2(50),
    load_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);