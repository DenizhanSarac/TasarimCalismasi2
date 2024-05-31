const { Pool } = require('pg');
// PostgreSQL bağlantı ayarları
const pool = new Pool({
    user: 'postgres',
    host: '127.0.0.1',
    database: 'teknikservis',
    password: '12345',
    port: 5432,
});

module.exports = pool;