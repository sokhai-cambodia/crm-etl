require('dotenv').config();
const oracledb = require('oracledb');
const Minio = require('minio');
const fs = require('fs');
const path = require('path');

// --- Oracle DB config ---
const oracleConfig = {
  user: process.env.ORACLE_USER,
  password: process.env.ORACLE_PASSWORD,
  connectString: `${process.env.ORACLE_HOST}:${process.env.ORACLE_PORT}/${process.env.ORACLE_SERVICE}`
};

// --- MinIO config ---
const minioClient = new Minio.Client({
  endPoint: process.env.MINIO_HOST,
  port: parseInt(process.env.MINIO_PORT),
  useSSL: false,
  accessKey: process.env.MINIO_ACCESS_KEY,
  secretKey: process.env.MINIO_SECRET_KEY
});

const bucketName = process.env.MINIO_BUCKET;

// --- Load JSON from MinIO and insert into Oracle ---
async function loadFromMinioToOracle() {
  let conn;
  try {
    console.log('Load job started at', new Date());

    conn = await oracledb.getConnection(oracleConfig);

    // 1. List all objects in bucket
    const objectsList = [];
    const stream = minioClient.listObjectsV2(bucketName, '', true);
    stream.on('data', obj => objectsList.push(obj.name));

    await new Promise((resolve, reject) => {
      stream.on('end', resolve);
      stream.on('error', reject);
    });

    console.log('Files found in MinIO:', objectsList);

    // 2. Loop through each file
    for (const fileName of objectsList) {
      const tempFilePath = path.join(__dirname, fileName);

      // 2a. Download file from MinIO
      await minioClient.fGetObject(bucketName, fileName, tempFilePath);
      console.log(`Downloaded ${fileName}`);

      // 2b. Read JSON content
      const fileContent = fs.readFileSync(tempFilePath, 'utf-8');
      const data = JSON.parse(fileContent);

      // 2c. Insert into Oracle table
      const insertSQL = `
        INSERT INTO bronze_usr.crm_customer_info
        (cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date)
        VALUES (:cst_id, :cst_key, :cst_firstname, :cst_lastname, :cst_marital_status, :cst_gndr, :cst_create_date)
      `;

      for (const row of data) {
        await conn.execute(insertSQL, {
          cst_id: row.customer_id,
          cst_key: row.customer_number,
          cst_firstname: row.first_name,
          cst_lastname: row.last_name,
          cst_marital_status: row.marital_status,
          cst_gndr: row.gender,
          cst_create_date: new Date(row.create_date),
        });
      }

      // Commit after each file
      await conn.commit();
      console.log(`Inserted data from ${fileName} into Oracle`);

      // 2d. Delete local temp file
      fs.unlinkSync(tempFilePath);
    }

    console.log('Load job finished at', new Date());

  } catch (err) {
    console.error('Load job error:', err);
  } finally {
    if (conn) await conn.close();
  }
}

// --- Run job ---
// loadFromMinioToOracle();

cron.schedule(process.env.ETL_LOAD_CRON, () => {
  loadFromMinioToOracle();
});
