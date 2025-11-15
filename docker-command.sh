docker ps -a --format "{{.Names}}\t{{.ID}}\t{{.Status}}" | sort | column -t

docker compose -f docker-compose.yml up
docker compose -f docker-compose.yml down

docker cp datasets oracle-xe:/opt/oracle/oradata
docker cp sql_loader oracle-xe:/opt/oracle/oradata

docker exec -it oracle-xe bash

sqlplus usr_erp/admin@//localhost:1521/XEPDB1

-- usr_crm
sqlldr userid=usr_crm/admin@//localhost:1521/XEPDB1 control=/opt/oracle/oradata/sql_loader/crm/cust_info.ctl skip=1
sqlldr userid=usr_crm/admin@//localhost:1521/XEPDB1 control=/opt/oracle/oradata/sql_loader/crm/prd_info.ctl skip=1
sqlldr userid=usr_crm/admin@//localhost:1521/XEPDB1 control=/opt/oracle/oradata/sql_loader/crm/sales_details.ctl skip=1

-- usr_erp
sqlldr userid=usr_erp/admin@//localhost:1521/XEPDB1 control=/opt/oracle/oradata/sql_loader/erp/CUST_AZ12.ctl skip=1
sqlldr userid=usr_erp/admin@//localhost:1521/XEPDB1 control=/opt/oracle/oradata/sql_loader/erp/LOC_A101.ctl skip=1
sqlldr userid=usr_erp/admin@//localhost:1521/XEPDB1 control=/opt/oracle/oradata/sql_loader/erp/PX_CAT_G1V2.ctl skip=1
