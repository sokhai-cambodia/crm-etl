const path = require('path');

// Load .env from project root
require('dotenv').config({ path: path.resolve(__dirname, '../.env') });

const Minio = require('minio');
const cron = require('node-cron');
const fs = require('fs').promises;
const oracledb = require('oracledb');

// Minio Client
const client = new Minio.Client({
    endPoint: process.env.MINIO_ENDPOINT || 'localhost',
    port: parseInt(process.env.MINIO_PORT || '9000'),
    useSSL: process.env.MINIO_SSL === 'true',
    accessKey: process.env.MINIO_ACCESS_KEY || 'minioadmin',
    secretKey: process.env.MINIO_SECRET_KEY || 'minioadmin',
});

const BUCKET = process.env.BUCKET_NAME || 'data-warehouse';
const UPLOAD_DIR = process.env.UPLOAD_DIR || './upload';

// Upload a single file to Minio
async function uploadFile(filePath) {
    const objectName = path.basename(filePath);
    try {
        await client.fPutObject(BUCKET, objectName, filePath);
        console.log(`Uploaded ${filePath} -> ${BUCKET}/${objectName}`);
        await fs.unlink(filePath);
        console.log(`Deleted local file: ${filePath}`);
    } catch (err) {
        console.error(`Failed to upload ${filePath}:`, err.message || err);
    }
}

// Upload all files from a directory
async function uploadAllFromDir(dir) {
    const files = await fs.readdir(dir);
    for (const f of files) {
        const fullPath = path.join(dir, f);
        const stat = await fs.stat(fullPath);
        if (stat.isFile()) {
            await uploadFile(fullPath);
        }
    }
}

// Query Oracle and write JSON file
async function exportQueryToJson() {
    let connection;
    try {
        connection = await oracledb.getConnection({
            user: process.env.ORACLE_USER || 'usr_minio',
            password: process.env.ORACLE_PASSWORD || 'admin',
            connectString: process.env.ORACLE_CONNECT || 'localhost:3332/XE'
        });

        const result = await connection.execute(
            `SELECT * FROM my_table FETCH FIRST 100 ROWS ONLY`,
            [],
            { outFormat: oracledb.OUT_FORMAT_OBJECT }
        );

        const fileName = `my_table_data_${Date.now()}.json`;
        const filePath = path.join(UPLOAD_DIR, fileName);

        await fs.writeFile(filePath, JSON.stringify(result.rows, null, 2));
        console.log(`Exported Oracle data to ${filePath}`);

        // Upload exported JSON to Minio
        await uploadFile(filePath);

    } catch (err) {
        console.error('[JOB] Oracle export failed:', err.message || err);
    } finally {
        if (connection) await connection.close();
    }
}

// Main job
async function runJob() {
    try {
        // Export from Oracle to JSON + upload to Minio
        await exportQueryToJson();

        // Upload any other files in the directory
        await uploadAllFromDir(UPLOAD_DIR);

        console.log('[JOB] Done');
    } catch (err) {
        console.error('[JOB] Error:', err.message || err);
    }
}

// Schedule job to run every hour
cron.schedule('0 * * * *', () => {
    console.log('[CRON] Job started at', new Date());
    runJob();
});
