#!/bin/bash

# -------------------------------
# Step 0: Load .env variables
# -------------------------------
export $(grep -v '^#' ./.env | xargs)

CONTAINER_NAME="oracle-xe"
DB_USER="system"
DB_PASSWORD="$ORACLE_PASSWORD"
DB_SERVICE="localhost:$ORACLE_PORT/$ORACLE_DATABASE"

CRM_USER="usr_crm"
ERP_USER="usr_erp"

# Local folders
SQL_FOLDER="./sql"
SQL_LOADER_FOLDER="./sql_loader"
DATASETS_FOLDER="./datasets"

# Container paths
ORADATA_PATH="/opt/oracle/oradata"
SQL_PATH="$ORADATA_PATH/sql"
SQL_LOADER_PATH="$ORADATA_PATH/sql_loader"
DATASETS_PATH="$ORADATA_PATH/datasets"

# -------------------------------
# Step 1: Copy folders into container
# -------------------------------
echo "Copying folders into container..."
docker cp "$SQL_FOLDER" "$CONTAINER_NAME:$ORADATA_PATH"
docker cp "$SQL_LOADER_FOLDER" "$CONTAINER_NAME:$ORADATA_PATH"
docker cp "$DATASETS_FOLDER" "$CONTAINER_NAME:$ORADATA_PATH"
echo "Folders copied successfully!"
echo "---------------------------"

# -------------------------------
# Step 2: Wait for Oracle to be ready
# -------------------------------
echo "Waiting for Oracle to be ready..."
until docker exec -i "$CONTAINER_NAME" bash -c "echo exit | sqlplus -L -S $DB_USER/$DB_PASSWORD@//$DB_SERVICE" &>/dev/null
do
  echo "Oracle not ready yet... sleeping 5 seconds"
  sleep 5
done
echo "Oracle is ready!"
echo "---------------------------"

# -------------------------------
# Step 3: Run SQL scripts as correct users
# -------------------------------
echo "Running SQL scripts..."

# Step 3a: Users and tablespaces (must be run as SYSTEM)
docker exec -i "$CONTAINER_NAME" bash -c "echo exit | sqlplus system/$DB_PASSWORD@$DB_SERVICE @$SQL_PATH/01_users_tablespaces.sql"

# Step 3b: CRM tables (run as usr_crm)
docker exec -i "$CONTAINER_NAME" bash -c "echo exit | sqlplus $CRM_USER/$DB_PASSWORD@$DB_SERVICE @$SQL_PATH/02_create_crm_tables.sql"

# Step 3c: ERP tables (run as usr_erp)
docker exec -i "$CONTAINER_NAME" bash -c "echo exit | sqlplus $ERP_USER/$DB_PASSWORD@$DB_SERVICE @$SQL_PATH/03_create_erp_tables.sql"

echo "SQL scripts executed!"
echo "---------------------------"



# -------------------------------
# Step 4: Run SQL*Loader scripts``
# -------------------------------
CRM_CTL_FILES=(
  "crm/cust_info.ctl"
  "crm/prd_info.ctl"
  "crm/sales_details.ctl"
)

for ctl in "${CRM_CTL_FILES[@]}"; do
  echo "Loading $ctl ..."
  docker exec -i "$CONTAINER_NAME" bash -c "sqlldr $CRM_USER/$DB_PASSWORD@$DB_SERVICE control=$SQL_LOADER_PATH/$ctl skip=1"
  echo "Done $ctl"
  echo "---------------------------"
done

ERP_CTL_FILES=(
  "erp/CUST_AZ12.ctl"
  "erp/LOC_A101.ctl"
  "erp/PX_CAT_G1V2.ctl"
)

for ctl in "${ERP_CTL_FILES[@]}"; do
  echo "Loading $ctl ..."
  docker exec -i "$CONTAINER_NAME" bash -c "sqlldr $ERP_USER/$DB_PASSWORD@$DB_SERVICE control=$SQL_LOADER_PATH/$ctl skip=1"
  echo "Done $ctl"
  echo "---------------------------"
done

echo "All scripts executed successfully!"
