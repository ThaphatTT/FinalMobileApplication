const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const mysql = require('mysql');
const jwt = require('jsonwebtoken');
const { error } = require('console');
require('dotenv').config();
const multer = require('multer');
const fs = require('fs');
// create secert key
// const crypto = require('crypto');
// const secretKey = crypto.randomBytes(64).toString('hex');
// console.log(secretKey);


const secretKey = process.env.SECRET_KEY;

const app = express();

const port = 4000 || process.env.PORT;



app.use(cors());
app.use(bodyParser.urlencoded({ extended : false }))
app.use(bodyParser.json())
const upload = multer({ dest: 'uploads/' });

const pool = mysql.createPool({
  connectionLimit : 10,
  host : 'localhost',
  user : 'root',
  password : '',
  database : 'shopClothes'
});

app.get('/',(req,res)=>{
  pool.getConnection((err, connection) =>{
    if (err) throw err;
    console.log(`connected as id ${connection.threadId}`);
    console.log(req.body);
    const sql = 'SELECT * FROM `users`'
    connection.query(sql, (err, result)=>{
      if(!err){
        res.send(result);
      }else{
        console.log(err);
      }
    });
    connection.release();
  });
});

app.post('/login', (req, res) => {
  pool.getConnection((err,connection)=>{
  if(err) throw err;
  const { email, password } = req.body;
  const sql = 'SELECT id, email, password FROM users WHERE email = ? AND password = ?'
  pool.query(sql, [email, password], (error, results) => {
    if (error) throw error;
    if (results.length > 0) {
      const user = results[0];
      console.log(user);
      const token = jwt.sign({ id: user.id }, secretKey, { expiresIn: '12h' });
      res.send({ 
        message: 'Login successful', 
        user, 
        token 
      });
    } else {
      res.status(401).send({ message: 'Invalid email or password' });
    }
  });
  connection.release();
  })
});

app.post('/createUser',(req,res) =>{
  pool.getConnection((err,connection)=>{
    if(err) throw err;
    const data = {
      email: req.body.email,
      password: req.body.password,
      fname: req.body.fname,
      lname: req.body.lname,
      birthday: req.body.birthday,
      mphone: req.body.mphone,
      sex: req.body.sex,
      address: req.body.address,
      permission: 1
    };
    console.log(`connected as id ${connection.threadId}`);
    console.log(req.body);
    const sql = "INSERT INTO `users`(`email`, `password`, `fname`, `lname`, `birthday`, `mphone`, `sex`, `address`, `permission`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
    connection.query(sql,[data.email, data.password, data.fname, data.lname, data.birthday, data.mphone, data.sex, data.address, data.permission],(err,results) =>{
      if(err) throw err;
      res.send({
        message : 'create a user succussed',
        data : data,
        status : 'ok'
      })
      connection.release();
    })
  });
});

app.get('/user/:id', (req, res) => {
  pool.getConnection((err,connection)=>{
    if(err) throw err;
    const { id } = req.params;
    const sql = 'SELECT id, email, fname, lname, birthday FROM users WHERE id = ?'
    pool.query(sql, [id], (error, results) => {
      if (error) throw error;
      if (results.length > 0) {
        const user = results[0];
        res.send({ 
          message: 'User data retrieved', 
          user 
        });
        console.log(user);
      } else {
        res.status(404).send({ message: 'User not found' });
      }
    });
    connection.release();
  })
});

app.get('/user/permission/:id', (req, res) => {
  pool.getConnection((err,connection)=>{
    if(err) throw err;
    const { id } = req.params;
    const sql = 'SELECT  id, permission FROM users WHERE id = ?'
    pool.query(sql, [id], (error, results) => {
      if (error) throw error;
      if (results.length > 0) {
        const user = results[0];
        res.send({ 
          message: 'User data retrieved', 
          user 
        });
        console.log(user);
      } else {
        res.status(404).send({ message: 'User not found' });
      }
    });
    connection.release();
  })
});

app.get('/user/editProfile/:id', (req, res) => {
  pool.getConnection((err,connection)=>{
    if(err) throw err;
    const { id } = req.params;
    const sql = 'SELECT id, email, password, fname, lname, birthday, mphone FROM users WHERE id = ?'
    pool.query(sql, [id], (error, results) => {
      if (error) throw error;
      if (results.length > 0) {
        const user = results[0];
        res.send({ 
          message: 'User data retrieved', 
          user 
        });
        console.log(user);
      } else {
        res.status(404).send({ message: 'User not found' });
      }
    });
    connection.release();
  })
});


app.patch('/user/editProfile/:id', (req, res) => {
  pool.getConnection((err,connection)=>{
    if(err) throw err;
    const { id } = req.params;
    const { email, password, fname, lname, birthday, mphone, sex } = req.body;
    const sql = 'UPDATE users SET email = ?, password = ?, fname = ?, lname = ?, birthday = ?, mphone = ?, sex = ? WHERE id = ?'
    pool.query(sql, [email, password, fname, lname, birthday, mphone, sex, id], (error, results) => {
      if (error) throw error;
      res.send({ 
        message: 'User data updated',
      });
    });
    connection.release();
  })
});

app.get('/user/Shipping/:id', (req, res) => {
  pool.getConnection((err,connection)=>{
    if(err) throw err;
    const { id } = req.params;
    const sql = 'SELECT address FROM users WHERE id = ?'
    pool.query(sql, [id], (error, results) => {
      if (error) throw error;
      if (results.length > 0) {
        const user = results[0];
        res.send({ 
          message: 'User data retrieved', 
          user 
        });
        // console.log(user);
      } else {
        res.status(404).send({ message: 'User not found' });
      }
    });
    connection.release();
  })
});

app.patch('/user/editShipping/:id', (req, res) => {
  pool.getConnection((err,connection)=>{
    if(err) throw err;
    const { id } = req.params;
    const { address } = req.body;
    const sql = 'UPDATE users SET address = ? WHERE id = ?'
    pool.query(sql, [address, id], (error, results) => {
      if (error) throw error;
      res.send({ 
        message: 'User shipping address data updated',
      });
    });
    connection.release();
  })
});

app.get('/clothes/getAllBrands', (req, res) => {
  pool.getConnection((err, connection) => {
    if(err) throw err;
    const sql = "SELECT * FROM `clothes_brands`";
    pool.query(sql, (err, result) => {
      if(err) throw err;
      res.send(result);
    })
    connection.release();
  })
})


app.post('/clothes/createNewbrand',(req,res)=>{
  pool.getConnection((err,connection)=>{
    if(err) throw err;
    const { clothes_brand } = req.body;
    const sql = "INSERT INTO `clothes_brands` (`clothes_brand`) VALUES (?)";
    pool.query(sql, clothes_brand,(err,result) =>{
      if(err) throw err;
      res.send({
        message : 'create a new name brand successed'
      });
    })
    connection.release();
  })
})

app.get('/clothes/getAllClothes', (req, res) => {
  pool.getConnection((err, connection) => {
    if(err) throw err;
    const sql = "SELECT * FROM `clothes_name`";
    pool.query(sql, (err, result) => {
      if(err) throw err;
      res.send(result);
    })
    connection.release();
  })
})

app.post('/clothes/createNewClothes',(req,res)=>{
  pool.getConnection((err,connection)=>{
    if(err) throw err;
    const { clothes_name } = req.body;
    const sql = "INSERT INTO `clothes_name` (`clothes_name`) VALUES (?)";
    pool.query(sql, clothes_name,(err,result) =>{
      if(err) throw err;
      res.send({
        message : 'create a new name brand successed'
      });
    })
    connection.release();
  })
})

app.post('/clothes/createClothes', upload.single('c_image'), (req, res) => {
  pool.getConnection((err, connection) => {
    if(err) throw err;
    const { c_brand, c_name, c_price } = req.body;
    const c_image = fs.readFileSync(req.file.path);
    const sql = "INSERT INTO `clothes` (`c_brand`, `c_name`, `c_price`, `c_image`) VALUES (?, ?, ?, ?)";
    pool.query(sql, [c_brand, c_name, c_price, c_image], (err, result) => {
      if(err) throw err;
      res.send({
        message : 'create a new clothes successed',
        status : 'ok'
      });
    });
    connection.release();
  });
});

app.get('/clothes', (req, res) => {
  pool.getConnection((err, connection) => {
    if(err) throw err;
    const sql = "SELECT * FROM `clothes`";
    pool.query(sql, (err, result) => {
      if(err) throw err;
      const clothes = result.map((item) => ({
        ...item,
        c_image: Buffer.from(item.c_image).toString('base64'),
      }));
      res.send(clothes);
    })
    connection.release();
  })
})


app.listen(port, ()=> console.log((`listen on port ${port}`)));