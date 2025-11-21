#!/bin/bash

# -------------------------------
# Step 0: Load .env variables
# -------------------------------
export $(grep -v '^#' ./.env | xargs)

CONTAINER_NAME="oracle-xe"
DB_PASSWORD="$ORACLE_PASSWORD"
DB_SERVICE="$ORACLE_DATABASE:$ORACLE_PORT/$ORACLE_DATABASE"  # adjust if needed

DWH_USERS=("bronze_usr" "silver_usr" "gold_usr")
DWH_PASSWORD="$DWH_PASSWORD"

SQL_PATH="/opt/oracle/oradata/sql/dwh"

# -------------------------------
# Step 1: Wait for Oracle to be ready
# -------------------------------
echo "Waiting for Oracle to be ready..."
until docker exec -i "$CONTAINER_NAME" bash -c "echo exit | sqlplus -L -S system/$DB_PASSWORD@//$DB_SERVICE" &>/dev/null
do
  echo "Oracle not ready yet... sleeping 5 seconds"
  sleep 5
done
echo "Oracle is ready!"
echo "---------------------------"

# -------------------------------
# Step 2: Run DW SQL script for each user
# -------------------------------
for user in "${DWH_USERS[@]}"; do
  echo "Setting up DW for $user ..."
  docker exec -i "$CONTAINER_NAME" bash -c "echo exit | sqlplus $user/$DB_PASSWORD@//$DB_SERVICE @$SQL_PATH/setup_dwh_layers.sql"
  echo "Done $user"
  echo "---------------------------"
done

echo "DW setup completed!"
