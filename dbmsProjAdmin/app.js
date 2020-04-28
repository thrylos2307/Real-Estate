const http = require('http');
const mysql = require('mysql');
const express = require('express');
const ejs = require('ejs');
const session = require('express-session');
const bodyParser = require('body-parser');
const passport = require('passport');
var app = express();

app.use(session({
    secret: 'secret',
    resave: false,
    saveUninitialized: false
}));


app.use(passport.initialize());
app.use(passport.session());

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

const pool = mysql.createPool({
    host: 'localhost',
    user: 'root',
    password: 'tushar0305',
    database: 'dbms_project',
    charset: 'utf8'
});



function setResHtml(sql, cb) {
    pool.getConnection((err, con) => {
        if (err) throw err;

        con.query(sql, (err, res, cols) => {
            if (err) throw err;

            return cb(res);
        });
    });
}

app.get('/', function(request, response) {
    response.redirect('/auth');
});

app.get('/auth', function(request, response) {
    response.render('./auth.ejs', { stat: 1 });
});

app.post('/auth', function(request, response) {
    var username = request.body.username;
    var password = request.body.password;
    if (username && password) {
        pool.query('SELECT * FROM admin WHERE username = ? AND password = ?', [username, password], function(error, results, fields) {

            if (results.length > 0) {
                request.session.loggedin = true;
                request.session.username = username;
                response.redirect('/data');
            } else {

                console.log("WRONG PASSWORD/USERNAME");
                response.render('./auth.ejs', { stat: 0 });

            }
            response.end();
        });
    } else {
        response.send('Please enter Username and Password!');
        response.end();
    }
});

app.get('/data', isLoggedIn, function(req, res) {
    res.render('./data.ejs');
});

app.post('/data', function(req, res) {
    var type = req.body.Type.toUpperCase();
    if (type === "PROPERTY") {
        res.redirect('/properties');
    } else if (type === "AGENT_DETAILS") {
        res.redirect('/agent');
    } else if (type === "LISTING") {
        res.redirect('/listing');
    } else if (type === "ADDRESS") {
        res.redirect('/address');
    }

    if (type === "HOUSE") {
        res.redirect('/house');
    } else if (type === "APARTMENT") {
        res.redirect('/apartment');
    } else if (type === "WORK_WITH") {
        res.redirect('/work_with');
    } else if (type === "BUYER") {
        res.redirect('/buyer');
    } else if (type === "ADD_FIRM") {
        res.redirect('/add_firm');
    }



    if (type === "FIRM") {
        res.redirect('/firm');
    } else if (type === "ADMINISTRATOR") {
        res.redirect('/administrator');
    } else if (type === "LOGOUT") {
        res.redirect('/logout');
    } else if (type === "DELETE") {
        res.redirect('/delete');

    } else if (type === "ADD") {
        res.redirect('/add');
    } else if (type === "NEW_REQUESTS_FOR_AGENTS") {
        res.redirect('/New_Requests_For_Agents');
    }

});



app.get('/add_firm', isLoggedIn, (req, res) => {

    res.render('./add_firm.ejs');
});
app.post('/add_firm', function(req, res) {

    var firmid = req.body.firmid;
    var name = req.body.name;

    pool.query('insert into firm values(' + firmid + ',"' + name + '")', function(error, results, fields) {
        if (error) console.log(error);

        res.redirect('/data');
    });
});



app.get('/New_Requests_For_Agents', (req, res) => {
    setResHtml("SELECT * from new_agent", (responseData) => {

        res.render('./newagent.ejs', { data: responseData });
    });
});
app.post('/New_Requests_For_Agents', function(req, res) {
    var email = req.body.email;

    pool.query('select *from new_agent where email="' + email + '"', function(error, results, fields) {
        console.log(error);
        console.log(results[0]);
        pass = results[0].name + results[0].firmid;
        pool.query('insert into agent(name,phone,firmid,date_list,password) values(?,?,?,?,?)', [results[0].name, results[0].phone, results[0].firmid, new Date(), pass], function(error1, results1, fields1) {

            console.log(error1);

            res.redirect('/agent');
        });
    });
});
// app.post('/New_Requests_For_Agents', function(req, res){
// // 	var email = req.body.email;
// +results[0].name+'",'+results[0].phone+','+results[0].firmid+
// 	pool.query('select *from new_agent where email= '+email, function(error, results, fields){
// 		console.log(results);
// 		console.log(error);
// // 		func(results);
// results[0].name + '",' + results[0].phone + ',' + results[0].firmid + ',"' + new Date()

// 			res.redirect('/agent');
// });
// });
//  async function func(results)
// {
// await selectFrom(results);
// }
// async function selectFrom(data) {
// 	try {
// 	  const res = await pool.query(
// 		'insert into agent(name,phone,firmid,date_list,password) values("'+results[0][0]+'",'+results[0][2]+','+results[0][3]+',"'+00-00-00+'",'+results[0][2]+')', function(error, results1, ada){console.log(error);}
// 		);
// 	  return res.rows[0][data];
// 	} catch (err) {

// 	  return err.stack;
// 	}
//   }
app.get('/agent', isLoggedIn, (req, res) => {
    setResHtml("SELECT *from agent", (responseData) => {
        res.render('./agent.ejs', { data: responseData });
    });
});
app.post('/agent', function(req, res) {
    var type = req.body.update_agent.toUpperCase();
    if (type === "DELETE_AGENT") {
        res.redirect('/delete_agent');
    } else if (type === "ADD_AGENT") {
        res.redirect('/add_agent');
    }
});
app.get('/add_agent', isLoggedIn, (req, res) => {
    res.render('./add_agent.ejs');
});

app.post('/add_agent', function(req, res) {

    var name = req.body.name;
    var phone = req.body.phone;
    var firmid = req.body.firm;
    var password = req.body.password;


    pool.query('insert into agent(name,phone,firmid,date_list,password) values(?,?,?,?,?)', [name, phone, firmid, new Date(), password], function(error, results, fields) {
        if (error) console.log(error);
        res.redirect('/agent');
    });
});

app.get('/delete_agent', isLoggedIn, (req, res) => {

    res.render('./delete_agent.ejs');
});

app.post('/delete_agent', function(req, res) {
    var agentId = req.body.agentId;
    pool.query('delete from agent where agentid=' + agentId + '', function(error, results, fields) {
        if (error) console.log(error);
        res.redirect('/agent');
    });
});
app.get('/properties', isLoggedIn, (req, res) => {
    setResHtml("select * from property", (responseData) => {
        res.render('./properties.ejs', { data: responseData });
    });
});

app.get('/work_with', isLoggedIn, (req, res) => {
    setResHtml("select * from work_with", (responseData) => {
        res.render('./work_with.ejs', { data: responseData });
    });
});
app.get('/buyer', isLoggedIn, (req, res) => {
    setResHtml("select * from buyer", (responseData) => {
        res.render('./buyer.ejs', { data: responseData });
    });
});
app.get('/firm', isLoggedIn, (req, res) => {
    setResHtml("select * from firm", (responseData) => {
        res.render('./firm.ejs', { data: responseData });
    });
});
app.get('/listing', isLoggedIn, (req, res) => {
    setResHtml("select * from listing", (responseData) => {
        res.render('./listing.ejs', { data: responseData });
    });
});
app.get('/apartment', isLoggedIn, (req, res) => {
    setResHtml("select * from apartment", (responseData) => {
        res.render('./apartment.ejs', { data: responseData });
    });
});

app.get('/house', isLoggedIn, (req, res) => {
    setResHtml("select * from house", (responseData) => {
        res.render('./house.ejs', { data: responseData });
    });
});
app.get('/address', isLoggedIn, (req, res) => {
    setResHtml("select * from address", (responseData) => {
        res.render('./address.ejs', { data: responseData });
    });
});

app.get('/add', isLoggedIn, (req, res) => {
    res.render('./add.ejs');
});
app.post('/add', function(request, response) {
    var agentid = request.body.agentid;

    var reg_num = request.body.reg_num;
    var address = request.body.address;
    var room = request.body.room;
    var ownername = request.body.ownername;
    var price = request.body.price;
    var bathroom = request.body.bathroom;
    var type = request.body.type;
    var size = request.body.size;


    pool.query('insert into listing(agentid,reg_num,datelisted,sellingDate,available) values(?,?,?,?,?)', [agentid, reg_num, new Date(), "0000-00-00 00:00:00", "available"], function(error, results, fields) {
        if (error) console.log(error)
        pool.query('insert into property(reg_num,address,ownername,price,type,bathrooms,bedroooms,size,agentid) values(' + reg_num + ',"' + address + '","' + ownername + '",' + price + ',"' + type + '",' + room + ',' + bathroom + ',' + size + ',' + agentid + ')', function(error1, results, fields) {

            if (error1) console.log(error1);
            response.redirect("/data");
        });
    });
});
app.get('/delete', isLoggedIn, (req, res) => {
    res.render('./delete.ejs');
});
app.post('/delete', function(request, response) {
    var reg = request.body.reg_num;
    pool.query('delete from listing where reg_num= ' + reg, function(error, results, fields) {

        response.redirect('/data');
    });

});

app.get('/administrator', isLoggedIn, (req, res) => {
    res.render('./administrator.ejs');
});
app.post('/administrator', function(request, response) {
    var newpassword = request.body.NewPassword;
    pool.query('UPDATE admin SET password = ' + newpassword, function(error, results, fields) {
        request.session.loggedin = false;
        response.redirect('/auth');
    });
});
app.get('/logout', isLoggedIn, (req, res) => {
    req.session.loggedin = false;
    res.redirect('/auth');
});

function isLoggedIn(req, res, next) {
    if (req.session.loggedin) {
        return next();
    }
    res.send("Not Logged In");
}


app.listen(3000, () => {
    console.log("Connected to 3000");
});