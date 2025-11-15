
# Data Warehouse

This the demo project dataware house for learning.



## 🛠 Skills
Docker, Oracle, SQLDeveloper...
## Installation

Using docker desktop for run this project.
## Deployment

To deploy this project run

```bash
  docker compose -f docker-compose.yml up
```


## Running Tests

To run tests, Start your first oracle database, run the following command

Find your container:
```bash
  docker ps -a --format "{{.Names}}\t{{.ID}}\t{{.Status}}" | sort | column -t
```

Start Excecute command:
```bash
  docker exec -it oracle-xe bash
```

Start Login to DBA account:
```bash
  sqlplus system/password@//localhost:1521/XEPDB1
```

Craate user:
```bash
  CREATE USER usr IDENTIFIED BY "password";
  GRANT CREATE SESSION TO usr;
  GRANT CREATE TABLE TO usr;
  ALTER USER usr QUOTA 100M ON USERS;
```

Craate tablespace:
```bash
  CREATE TABLESPACE tbs
  DATAFILE '/opt/oracle/oradata/XE/XEPDB1/tbs.dbf' SIZE 100M
  AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED;

  ALTER USER usr DEFAULT TABLESPACE tbs;
  ALTER USER usr QUOTA 100M ON tbs;
```

Craate table:
```bash
  docker exec -it oracle-xe bash
  sqlplus usr/password@//localhost:1521/XEPDB1

  CREATE TABLE tbl (
    id	VARCHAR2(20) PRIMARY KEY,
    title	VARCHAR2(100)
    create_date  DATE,
  );
```

