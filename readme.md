# 📦 Data Warehouse Demo Project

This is a **demo Data Warehouse project** designed for learning and practicing concepts like Oracle Database, SQL*Loader, ETL, CRM/ERP datasets, and containerized deployment with Docker.

---

## 🛠 Skills Used
- Docker / Docker Compose  
- Oracle Database (XE)  
- SQL*Loader  
- Bash scripting  
- DBeaver / SQL Developer  
- Data Warehouse Concepts (CRM + ERP datasets)

---

## 🚀 Installation

Use **Docker Desktop** to run this project locally.

### Start the Oracle database:
```bash
docker compose -f docker-compose.yml up
```

This will download the Oracle XE image and start the database.

---

## 🗄️ Database Setup (CRM & ERP)

After starting the container, initialize the database using:

```bash
bash scripts/setup_crm_erp_database.sh
```

This script will automatically:
- Copy SQL scripts and datasets into the Oracle container
- Wait for Oracle to finish initializing
- Create tablespaces & users (CRM + ERP)
- Create all CRM tables
- Create all ERP tables
- Load sample datasets using SQL*Loader

Everything will be initialized in one click.

---

## 📂 Project Structure

```
project-root/
│
├── docker-compose.yml
├── README.md
│
├── sql/
│   ├── 01_users_tablespaces.sql
│   ├── 02_create_crm_tables.sql
│   ├── 03_create_erp_tables.sql
│
├── sql_loader/
│   ├── crm/
│   │   ├── cust_info.ctl
│   │   ├── prd_info.ctl
│   │   └── sales_details.ctl
│   ├── erp/
│       ├── CUST_AZ12.ctl
│       ├── LOC_A101.ctl
│       └── PX_CAT_G1V2.ctl
│
├── datasets/
│   ├── crm/
│   ├── erp/
│
└── scripts/
    └── setup_crm_erp_database.sh
```

---

## 🔍 Connecting With DBeaver / SQL Developer

### CRM User
```
Username: usr_crm
Password: admin
Service : XEPDB1
Port    : 1521
Host    : localhost
```

### ERP User
```
Username: usr_erp
Password: admin
Service : XEPDB1
Port    : 1521
Host    : localhost
```

### System Admin
```
Username: system
Password: admin
```

---

## 🧪 Test Loaded Data

Example:
```sql
SELECT * FROM CRM_CUSTOMERS;
SELECT * FROM ERP_PRODUCTS;
```

---

## 🙌 Thanks
This project is for learning and practicing Data Warehouse, ETL, and Oracle database automation.

Enjoy learning, my friend!
