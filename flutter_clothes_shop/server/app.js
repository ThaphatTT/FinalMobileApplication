const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const mysql = require('mysql');
const jwt = require('jsonwebtoken');
require('dotenv').config();

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
  const sql = 'SELECT email,password FROM users WHERE email = ? AND password = ?'
  pool.query(sql, [email, password], (error, results) => {
    if (error) throw error;
    if (results.length > 0) {
      const user = results[0];
      const token = jwt.sign({ id: user.id }, secretKey, { expiresIn: '1h' });
      res.send({ message: 'Login successful', user, token });
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

app.listen(port, ()=> console.log((`listen on port ${port}`)));