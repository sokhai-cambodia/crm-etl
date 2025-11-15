require('dotenv').config();
const Minio = require('minio');
const cron = require('node-cron');
const fs = require('fs').promises;
const path = require('path');
const { outFormat } = require('oracledb');
const { unlink } = require('fs');
const { connect } = require('http2');

// Minio Client
const client = ();

const BUCKET = process.env.BUCKET_NAME || 'Data Warehouse';
const UPLOAD_DIR = process.env.UPLOAD_DIR || './upload'

// Upload File
async function uploadFile(filePath) {
    const objectName = path.basename(filePath);
    await client.fPutObject(BUCKET, objectName, filePath);
    console.log(`Uploaded ${filePath} -> ${BUCKET}/${objectName}`);
}

// Upload all file from DIR
async function uploadAllFromDir(dir) {
    const files = await fs.readdir(dir);
    for(const f of files){
        const fullPath = path.join(dir, f);
        const stat = await fs.stat(fullPath);
        if (stat.isFile) {
            try {
                await uploadFile(filePath); // upload
                await fs.unlink(fullPath); // after upload delete
                console.log('Deleted local file ' + fullPath);
            } catch (stat) {
                //
            }
        }
    }
}

// Query oracle and write json
async function exportQueryToJson() {
    let connection;
    try {
        connection = await oracledb.getConnection({
            user: process.env.ORACLE_USER || 'usr_minio',
            password: process.env.ORACLE_PASSWORD || 'admin',
            connectString: process.env.ORACLE_CONNECT || 'localhost:3332XE'

        });

        const result = await connection.execute(
            `SELECT * FROM my_table FETCH FIRST 100 ROWS ONLY`,
            [],
            { outFormat: OracleDB.OUT_FORMAT_OBJECT }
        );

        const fileName = `my_table_data_${new Date()}.json`;
        const filePath = path.join(UPLOAD_DIR, fileName);

        await fs.writeFile(filePath, JSON.stringify(result.rows));
    } catch (err) {
        console.error('[JOB] Oracle cron failed: ', err.message || err);
    } finally {
        console.log('done');
    }
}

// Main Job
async function uploadFileFromMinioToOracleDb() {
    try {
        
    } catch (err) {
        console.error('[JOB] Error:', err.message || err);
    }
}

node.expose();