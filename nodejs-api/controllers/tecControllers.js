const pool = require("../db.js");
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

// Kullanıcı kaydı
const createUser =  async (req, res) => {
  const { username, email, password } = req.body;
  const hashedPassword = await bcrypt.hash(password, 10);
  try {
    const result = await pool.query(
      'INSERT INTO users (username, email, password) VALUES ($1, $2, $3) RETURNING *',
      [username, email, hashedPassword]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

const loginUser= async (req, res) => {
  const { username, password } = req.body;
  try {
    const result = await pool.query(
      'SELECT * FROM users WHERE username = $1',
      [username]
    );
    if (result.rows.length > 0) {
      const user = result.rows[0];
      const validPassword = await bcrypt.compare(password, user.password);
      if (validPassword) {
        const token = jwt.sign({ id: user.id },'AIb6d35fvJM4O9pXqXQNla2jBCH9kuLz', { expiresIn: '1h' }); //1 saat içinde girmezsen atıyor hesaptan
        res.json({ token });
      } else {
        res.status(401).json({ message: 'Invalid credentials' });
      }
    } else {
      res.status(401).json({ message: 'Invalid credentials' });
    }
  } catch (error) {
    console.log(error.message);
    res.status(400).json({ error: error.message });
  }
};

const getUser = async (req, res) =>{
  const token = req.headers['authorization'];
  if (!token) {
    return res.status(401).json({ error: 'Yetkisiz erişim' });
  }

  try {
    const decoded = jwt.verify(token, 'AIb6d35fvJM4O9pXqXQNla2jBCH9kuLz');
    const result = await pool.query('SELECT id, username FROM users WHERE id = $1', [decoded.id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Kullanıcı bulunamadı' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    res.status(401).json({ error: 'Yetkisiz erişim' });
  }
};

const tsAdd = async (req, res) =>{
  const { username,model,customer, fee,qr_code,ariza } = req.body;
  try{
    const result = await pool.query(
      'INSERT INTO teknikservis (username, model, customer_name, fee, qr_code,ariza) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *',
      [username, model, customer, fee, qr_code, ariza]
    );
      res.status(201).json(result.rows[0]);
  }catch(error){
     console.log(error.message);
      res.status(401).json({error: error.message});
  }
};

const getTsList = async (req, res) =>{
  const {username}=req.params;
  try {
    const result = await pool.query('SELECT id,username,customer_name, fee, model, ariza, isfinished FROM teknikservis WHERE username=$1',[username]);
    console.log(result.rows);
    res.status(200).json(result.rows);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};



const updateTsStatus = async(req, res) =>{
  const { id } = req.params;
  try {
    const result = await pool.query('UPDATE teknikservis SET isfinished = TRUE WHERE id = $1', [id]);
    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Database update failed' });
  }
};

const addBuyySell = async(req, res) =>{
  const { username,model,customer, fee,qr_code,issell,alisfiyati } = req.body;
  try{
    const result = await pool.query(
      'INSERT INTO alimsatim (username, model, customer_name, fee, qr_code, issell,alisfiyati) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *',
      [username, model, customer, fee, qr_code, issell, alisfiyati]
    );
      res.status(201).json(result.rows[0]);
  }catch(error){
     console.log(error.message);
      res.status(401).json({error: error.message});
  }
};

const getBsList = async (req, res) =>{
  const {username}=req.params;
  try {
    const result = await pool.query('SELECT id,username,customer_name, fee, model, issell, alisfiyati FROM alimSatim WHERE username=$1',[username]);
    console.log(result.rows);
    res.status(200).json(result.rows);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

const updateBsStatus = async(req, res) =>{
  const { id } = req.params;
  try {
    const result = await pool.query('UPDATE alimsatim SET issell = TRUE WHERE id = $1', [id]);
    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Database update failed' });
  }
};

const getProfitList = async (req, res) =>{
  const {username}=req.params;
  try{
    const incomeQuery = `
    SELECT SUM(fee) AS fee
    FROM alimsatim
    WHERE username = $1
  `;
  const incomeResult = await pool.query(incomeQuery, [username]);
  const income = incomeResult.rows[0].fee || 0;

  const incomeQuery2 = `
    SELECT SUM(fee) AS fee1
    FROM teknikservis
    WHERE username = $1 and isfinished= 'true'
  `;
  const incomeResult2 = await pool.query(incomeQuery2, [username]);
  const income2 = incomeResult2.rows[0].fee1 || 0;

const expenseQuery = `
    SELECT SUM(alisfiyati) AS alisfiyati
    FROM alimsatim
    WHERE username = $1 AND issell = 'true'
  `;
    const expenseResult = await pool.query(expenseQuery, [username]);
    const expense = expenseResult.rows[0].alisfiyati || 0;
    var totalIncome=parseInt(income)+parseInt(income2);
    var earnedMoney = parseInt(totalIncome)-parseInt(expense);
    res.json({
      earnedMoney,
      totalIncome,
      expense
    });
  }
  catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
 
};

module.exports={
    createUser,
    loginUser,
    getUser,
    tsAdd,
    getTsList,
    updateTsStatus,
    addBuyySell,
    getBsList,
    updateBsStatus,
    getProfitList,
};