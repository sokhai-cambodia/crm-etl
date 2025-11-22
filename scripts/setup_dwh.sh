#!/bin/bash

# -------------------------------
# Step 0: Load .env variables
# -------------------------------
export $(grep -v '^#' ./.env | xargs)

CONTAINER_NAME="oracle-xe"
DB_USER="system"
DB_PASSWORD="$ORACLE_PASSWORD"
DB_SERVICE="$ORACLE_CONNECT" # adjust if needed

SQL_PATH="/opt/oracle/oradata/sql/dwh"

# -------------------------------
# Step 1: Wait for Oracle to be ready
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
# Step 2: Run DW SQL script for each user
# -------------------------------
docker exec -i "$CONTAINER_NAME" bash -c "echo exit | sqlplus $DB_USER/$DB_PASSWORD@//$DB_SERVICE @$SQL_PATH/setup_dwh_layers.sql"

echo "DW setup completed!"
