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
        status : 'ok',
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
    const sql = 'SELECT id, email, fname, lname, birthday, address FROM users WHERE id = ?'
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

app.get('/clothes/AllNewType', (req, res) => {
  pool.getConnection((err, connection) => {
    if(err) throw err;
    const sql = "SELECT * FROM `clothes_type`";
    pool.query(sql, (err, result) => {
      if(err) throw err;
      res.send(result);
    })
    connection.release();
  })
})

app.post('/clothes/CreateNewType', (req, res) => {
  pool.getConnection((err,connection)=>{
    if(err) throw err;
    const { clothes_type } = req.body;
    const sql = "INSERT INTO `clothes_type` (`clothes_type`) VALUES (?)";
    pool.query(sql, clothes_type,(err,result) =>{
      if(err) throw err;
      res.send({
        message : 'create a new name brand successed'
      });
    })
    connection.release();
  })
})

app.get('/clothes/AllNewSize', (req, res) => {
  pool.getConnection((err, connection) => {
    if(err) throw err;
    const sql = "SELECT * FROM `clothes_size`";
    pool.query(sql, (err, result) => {
      if(err) throw err;
      res.send(result);
    })
    connection.release();
  })
})

app.post('/clothes/CreateNewSize', (req, res) => {
  pool.getConnection((err,connection)=>{
    if(err) throw err;
    const { clothes_size, clothes_type } = req.body;
    const sql = "INSERT INTO `clothes_size` (`size`,`type_clothes`) VALUES (?, ?)";
    pool.query(sql, [clothes_size,clothes_type],(err,result) =>{
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

app.get('/post/condition', (req, res) => {
  pool.getConnection((err, connection) => {
    if(err) throw err;
    const sql = "SELECT * FROM `clothes_condition`";
    pool.query(sql, (err, result) => {
      if(err) throw err;
      res.send(result);
    })
    connection.release();
  })
})

app.get('/post/equipment', (req, res) => {
  pool.getConnection((err, connection) => {
    if(err) throw err;
    const sql = "SELECT * FROM `clothes_equipment`";
    pool.query(sql, (err, result) => {
      if(err) throw err;
      res.send(result);
    })
    connection.release();
  })
})

app.post('/post/createPostUserProduct',(req,res) =>{
  pool.getConnection((err,connection)=>{
    if(err) throw err;
    const data = {
      user_id: req.body.user_id,
      clothes_id: req.body.clothes_id,
      condition_id: req.body.condition_id,
      equipment_id: req.body.equipment_id,
      sizeclothes_id: req.body.sizeclothes_id,
      typeclothes_id: req.body.typeclothes_id,
      product_price: req.body.product_price,
      post_status: req.body.post_status,
    };
    console.log(`connected as id ${connection.threadId}`);
    console.log(req.body);
    const sql = "INSERT INTO `post`(`u_id`, `c_id`, `cc_id`, `ce_id`, `c_size`, `c_type`, `c_price`, `p_status`) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    connection.query(sql,[data.user_id, data.clothes_id, data.condition_id, data.equipment_id,data.sizeclothes_id, data.typeclothes_id, data.product_price, data.post_status],(err,results) =>{
      if(err) throw err;
      const responseData = {
        message: 'create a user succussed',
        data: data,
        postId: results.insertId,
        status: 'ok'
      };
      res.send(responseData);
      connection.release();
    })
  });
});

app.post('/post/createImage', upload.array('img_post'), (req, res) => {
  pool.getConnection((err, connection) => {
    if (err) throw err;
    if (!req.files || req.files.length === 0) {
      res.status(400).send({ message: 'No files were uploaded.' });
      return;
    }
    const data = {
      postId: req.body.postId,
      images: req.files,
    };
    console.log(`connected as id ${connection.threadId}`);
    const sql = "INSERT INTO `image_post`(`idpost`, `img_post`) VALUES (?, ?)";
    data.images.forEach(image => {
      let img_post = fs.readFileSync(image.path);
      connection.query(sql, [data.postId, img_post], (err, results) => {
        if (err) throw err;
      });
    });
    res.send({
      message: 'Images created successfully!',
      data: data,
      status: 'ok'
    });
    connection.release();
  });
});

app.get('/post/buyProduct/:id', (req, res) => {
  pool.getConnection((err,connection)=>{
    if(err) throw err;
    const { id } = req.params;
    const sql = 'SELECT * FROM `post` WHERE `c_id` = ?'
    pool.query(sql, [id], (error, results) => {
      if (error) throw error;
        res.send({ 
          message: 'buyProduct data fetch success', 
          results
        });
    });
    connection.release();
  })
});

app.get('/post/buyProduct/Image/:id', (req, res) => {
  pool.getConnection((err, connection) => {
    if(err) throw err;
    const { id } = req.params;
    const sql = 'SELECT `img_post` FROM `image_post` WHERE `idpost` = ?';
    pool.query(sql,[id],(err, result) => {
      if(err) throw err;
      const clothes = result.map((item) => ({
        ...item,
        img_post: Buffer.from(item.img_post).toString('base64'),
      }));
      res.send(clothes);
    })
    connection.release();
  })
})

app.get('/post/buyProduct/Verify/:id', (req, res) => {
  pool.getConnection((err,connection)=>{
    if(err) throw err;
    const { id } = req.params;
    const sql = 'SELECT * FROM `post` WHERE `c_id` = ?'
    pool.query(sql, [id], (error, results) => {
      if (error) throw error;
      res.send({ 
        message: 'buyProduct data fetch success', 
        results
      });
    });
    connection.release();
  })
});

app.get('/order/orderSelling/:id', (req, res) => {
  pool.getConnection((err,connection)=>{
    if(err) throw err;
    const { id } = req.params;
    const sql = 'SELECT * FROM `post` WHERE `u_id` = ?'
    pool.query(sql, [id], (error, results) => {
      if (error) throw error;
      res.send({ 
        message: 'orderSelling data fetch success', 
        results
      });
    });
    connection.release();
  })
});

app.post('/order/orderBuying',(req, res) => {
  pool.getConnection((err, connection) => {
    if (err) throw err;
    const data = {
      idUser: req.body.idUser,
      idPost: req.body.idPost,
      date: new Date(),
      total: req.body.total,
      o_status: 1,
    };
    console.log(`connected as id ${connection.threadId}`);
    const sql = "INSERT INTO `order`(`iduser`, `idpost`, `date`, `total`,`o_status`) VALUES (?, ?, ?, ?, ?)";
    pool.query(sql, [data.idUser, data.idPost, data.date, data.total, data.o_status], (error, results) => {
      if (error) throw error;
      res.send({ 
        message: 'buyProduct insert data successfully!',
        data: data,
        orderId: results.insertId,
        status: 'ok'
      });
    });
    connection.release();
  });
});

app.post('/order/orderBuying/imgPayment', upload.single('img_payment'), (req, res) => {
  pool.getConnection((err, connection) => {
    if(err) throw err;
    const { orderId} = req.body;
    const img_payment = fs.readFileSync(req.file.path);
    const sql = "INSERT INTO `img_payment` (`idOrder`, `img_payment`) VALUES (?, ?)";
    pool.query(sql, [orderId, img_payment], (err, result) => {
      if(err) throw err;
      res.send({
        message : 'create a image payment successed',
        status : 'ok'
      });
    });
    connection.release();
  });
});


app.post('/order/ChangeStatus',(req, res) => {
  pool.getConnection((err, connection) => {
    if (err) throw err;
    const data = {
      idPost: req.body.idPost,
      p_status: req.body.p_status,
    };
    console.log(data.idPost);
    console.log(`connected as id ${connection.threadId}`);
    const sql = "UPDATE `post` SET `p_status` = ? WHERE `id` = ?";
    pool.query(sql, [data.p_status, data.idPost], (error, results) => {
      if (error) throw error;
      res.send({ 
        message: 'Change data successfully!',
        data: data,
        status: 'ok'
      });
    });
    connection.release();
  });
});

app.get('/order/orderBuying/Users/:id', (req, res) => {
  pool.getConnection((err,connection)=>{
    if(err) throw err;
    const { id } = req.params;
    const sql = 'SELECT * FROM `order` WHERE `iduser` = ?'
    pool.query(sql, [id], (error, results) => {
      if (error) throw error;
      res.send({ 
        message: 'User`s ordey buy fetch success', 
        results
      });
    });
    connection.release();
  })
});

app.get('/order/orderSelling/UserBuying/:id', (req, res) => {
  pool.getConnection((err,connection)=>{
    if(err) throw err;
    const { id } = req.params;
    const sql = 'SELECT * FROM `post` WHERE `id` = ?'
    pool.query(sql, [id], (error, results) => {
      if (error) throw error;
      res.send({ 
        message: 'orderSelling data fetch success', 
        results
      });
    });
    connection.release();
  })
});

app.get('/order/status', (req, res) => {
  pool.getConnection((err, connection) => {
    if(err) throw err;
    const sql = "SELECT * FROM `order_status`";
    pool.query(sql, (err, result) => {
      if(err) throw err;
      res.send(result);
    })
    connection.release();
  })
})

app.get('/order/Check', (req, res) => {
  pool.getConnection((err, connection) => {
    if(err) throw err;
    const sql = "SELECT * FROM `order`";
    pool.query(sql, (err, result) => {
      if(err) throw err;
      res.send(result);
      console.log(result);
    })
    connection.release();
  })
})

app.get('/order/ImagePayment/:id', (req, res) => {
  pool.getConnection((err, connection) => {
    if(err) throw err;
    const { id } = req.params;
    const sql = 'SELECT `idOrder`, `img_payment` FROM `img_payment` WHERE `idOrder` = ?';
    pool.query(sql,[id],(err, result) => {
      if(err) throw err;
      const imgPayment = result.map((item) => ({
        ...item,
        img_payment: Buffer.from(item.img_payment).toString('base64'),
      }));
      res.send(imgPayment);
    })
    connection.release();
  })
})

app.post('/order/ChangeStatus/admin',(req, res) => {
  pool.getConnection((err, connection) => {
    if (err) throw err;
    const data = {
      id: req.body.id,
      o_status: req.body.o_status,
    };
    console.log(data.idPost);
    console.log(`connected as id ${connection.threadId}`);
    const sql = "UPDATE `order` SET `o_status` = ? WHERE `id` = ?";
    pool.query(sql, [data.o_status, data.id], (error, results) => {
      if (error) throw error;
      res.send({ 
        message: 'Change data successfully!',
        data: data,
        status: 'ok'
      });
    });
    connection.release();
  });
});

app.post('/order/ChangeStatus/postuserSell/admin',(req, res) => {
  pool.getConnection((err, connection) => {
    if (err) throw err;
    const data = {
      id: req.body.id,
      p_status: req.body.p_status,
    };
    console.log(data.id);
    console.log(`connected as id ${connection.threadId}`);
    const sql = "UPDATE `post` SET `p_status` = ? WHERE `id` = ?";
    pool.query(sql, [data.p_status, data.id], (error, results) => {
      if (error) throw error;
      res.send({ 
        message: 'Change data successfully!',
        data: data,
        status: 'ok'
      });
    });
    connection.release();
  });
});

app.get('/post/lowestpost/:id', (req, res) => {
  pool.getConnection((err, connection) => {
    if(err) throw err;
    const { id } = req.params;
    const sql = "SELECT * FROM `post` WHERE `c_id` = ? ORDER BY `c_price` ASC LIMIT 1";
    pool.query(sql,[id], (err, result) => {
      if(err) throw err;
      res.send(result);
    })
    connection.release();
  })
})

app.get('/post/highestpost/:id', (req, res) => {
  pool.getConnection((err, connection) => {
    if(err) throw err;
    const { id } = req.params;
    const sql = "SELECT * FROM `post` WHERE `c_id` = ? ORDER BY `c_price` DESC LIMIT 1";
    pool.query(sql, [id], (err, result) => {
      if(err) throw err;
      res.send(result);
    })
    connection.release();
  })
})


app.listen(port, ()=> console.log((`listen on port ${port}`)));