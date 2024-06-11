const pool = require("../db.js");
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

// Kullanıcı kaydı
const createUser =  async (req, res) => {
  const { username, email, password } = req.body;
  const hashedPassword = await bcrypt.hash(password, 10);
  try {
    console.log(req.body);
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
    console.log(req.body);
    const result = await pool.query(
      'SELECT * FROM users WHERE username = $1',
      [username]
    );
    if (result.rows.length > 0) {
      const user = result.rows[0];
      const validPassword = await bcrypt.compare(password, user.password);
      if (validPassword) {
        const token = jwt.sign({ id: user.id },'AIb6d35fvJM4O9pXqXQNla2jBCH9kuLz', { expiresIn: '1h' });
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
  const { username,model,customer, fee,qr_code } = req.body;
  try{
    console.log(req.body);
    const result = await pool.query(
      'INSERT INTO teknikservis (username, model, customer_name, fee, qr_code) VALUES ($1, $2, $3, $4, $5) RETURNING *',
      [username, model, customer, fee, qr_code]
    );
      res.status(201).json(result.rows[0]);
  }catch(error){
     console.log(error.message);
      res.status(401).json({error: error.message});
  }
};

const getTsList = async (req, res) =>{
  const {username}=req.params;
  console.log(username);
  try {
    const result = await pool.query('SELECT username,customer_name, fee, model FROM teknikservis WHERE username=$1',[username]);
    res.status(200).json(result.rows);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};



module.exports={
    createUser,
    loginUser,
    getUser,
    tsAdd,
    getTsList,
};