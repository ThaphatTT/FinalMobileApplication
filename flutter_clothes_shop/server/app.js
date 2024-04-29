const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const mysql = require('mysql');

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

app.listen(port, ()=> console.log((`listen on port ${port}`)));