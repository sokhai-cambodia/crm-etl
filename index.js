require('dotenv').config();
const cron = require('node-cron');

const schedule = process.env.CRON_SCHEDULE || '*/1 * * * *';

cron.schedule(schedule.)