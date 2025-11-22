require('dotenv').config(); // Load .env

const oracledb = require('oracledb');
const Minio = require('minio');
const fs = require('fs');
const cron = require('node-cron');
const path = require('path');

// --- Oracle DB config from .env ---
const oracleConfig = {
  user: process.env.ORACLE_USER,
  password: process.env.ORACLE_PASSWORD,
  connectString: `${process.env.ORACLE_HOST}:${process.env.ORACLE_PORT}/${process.env.ORACLE_SERVICE}`
};

// --- MinIO config from .env ---
const minioClient = new Minio.Client({
  endPoint: process.env.MINIO_HOST,
  port: parseInt(process.env.MINIO_PORT),
  useSSL: false,
  accessKey: process.env.MINIO_ACCESS_KEY,
  secretKey: process.env.MINIO_SECRET_KEY
});

const bucketName = process.env.MINIO_BUCKET;

// --- ETL function ---
async function runETL() {
  let conn;

  try {
    console.log('ETL job started at', new Date());

    // 1. Connect to Oracle
    conn = await oracledb.getConnection(oracleConfig);

    // 2. Extract data
    const result = await conn.execute(
      `SELECT cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date
       FROM usr_crm.customer_info`
    );

    // 3. Transform rows to JSON objects
    const data = result.rows.map(row => ({
      customer_id: row[0],
      customer_number: row[1],
      first_name: row[2],
      last_name: row[3],
      marital_status: row[4],
      gender: row[5],
      create_date: row[6]
    }));

    // 4. Save JSON locally
    const fileName = `customers_${new Date().toISOString().slice(0,10).replace(/-/g,'')}.json`;
    const filePath = path.join(__dirname, fileName);
    fs.writeFileSync(filePath, JSON.stringify(data, null, 2));

    // 5. Upload to MinIO
    const exists = await minioClient.bucketExists(bucketName);
    if (!exists) {
      await minioClient.makeBucket(bucketName, 'us-east-1');
    }
    await minioClient.fPutObject(bucketName, fileName, filePath, {
      'Content-Type': 'application/json'
    });

    console.log(`Data uploaded to MinIO bucket '${bucketName}' as ${fileName}`);

    // 6. Remove local file
    fs.unlinkSync(filePath);

    console.log('ETL job finished at', new Date());

  } catch (err) {
    console.error('ETL job error:', err);
  } finally {
    if (conn) await conn.close();
  }
}

// --- Schedule ETL using .env cron ---
cron.schedule(process.env.ETL_CRON, () => {
  runETL();
});
// console.log('hello world');
// runETL();
``