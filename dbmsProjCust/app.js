const http = require('http');
const mysql = require('mysql');
const express = require('express');
const ejs = require('ejs');
const session = require('express-session');
const bodyParser = require('body-parser');
const passport = require('passport');
const sgMail = require("@sendgrid/mail");
sgMail.setApiKey('put your sendgrid api key here');
var app = express();
app.use(express.static("views"));

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
	password: '',
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

//forgetpassword for agent
app.get('/forgetpasswordforagent', function(req, res){
	res.render('./forget_password.ejs');
});
var random_num = 0;
var agentf = 0;

function funcs(email, res){
	const msg = {
		to: email,
		from: "puneetverma951761@gmail.com",
		subject: "FORGOT PASSWORD",
		html: `<html><head></head><body><a href="http://localhost:3007/change">CLICK ON THIS LINK TO CHANGE YOUR PASSWORD</a></body></html>`,
	}
	console.log(email);
	sgMail.send(msg).then(() => {
		console.log(email);
		console.log("FORGET PASSWORD LINK SENT TO "+email);
		res.redirect("/agent");
	}).catch((error) => {
		console.log(error.response.body);
	});
}


async function func1(email,agentf, res){
	console.log("Start query...");
	
	await pool.query('select * from agent where agentid='+ agentf, function(err, result, fields) {
		console.log("working on query...");
		if(result.length > 0){
		if(err) {console.log("Agent not found"); res.redirect('forgetpasswordforagent');}
		
		else{
			email = ""+result[0].email; console.log("sending email to " + email); funcs(email, res);
			if(email === ""){
				console.log("Incorrect AgentId haviing agentid ='" + agentf+"'");
				res.redirect('/forgetpasswordforagent');
			}
		}
		}
		else{
                res.send(`<!DOCTYPE html><html lang="en"><head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <style>
        input{

            padding: 2px;
            font-size: 20px;
            display: inline;
        }
        p{
            margin: 10px;
        }
    </style>
</head>
<body>
    <div class="login-form" style="width: 50%; height: 400px; margin: 20px; margin-left: auto; margin-right: auto; background-color: teal;" >
        <h1 style="margin: 20px; text-align: center;">Login Form</h1>

        <form action="/forgetpasswordforagent" method="POST">
         <p>Agent Id : <input type="number" name="agentid" placeholder="Enter Your valid Agent Id...." required><br><br></p>
          <p style="margin-left: 70px;">  <input type="submit"></p>
        </form>
    </div>
</body>
</html>
<script>alert("YOU ENTERED WRONG AGENTID")</script>`);
                //res.render('./forget_password.ejs');
        }

	});}
/*	else{
		res.send(`<!DOCTYPE html><html lang="en"><head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <style>
        input{

            padding: 2px;
            font-size: 20px;
            display: inline;
        }
        p{
            margin: 10px;
        }
    </style>
</head>
<body>
    <div class="login-form" style="width: 50%; height: 400px; margin: 20px; margin-left: auto; margin-right: auto; background-color: teal;" >
        <h1 style="margin: 20px; text-align: center;">Login Form</h1>

        <form action="/forgetpasswordforagent" method="POST">
         <p>Agent Id : <input type="number" name="agentid" placeholder="Enter Your valid Agent Id...." required><br><br></p>
          <p style="margin-left: 70px;">  <input type="submit"></p>
        </form>
    </div>
</body>
</html>
<script>alert("YOU ENTERED WRONG AGENTID")</script>`);
		//res.render('./forget_password.ejs');
	}

}*/

app.post('/forgetpasswordforagent', function(req, res) {
	//var email = req.body.email
	console.log("post");
	var email = "";
	agentf= req.body.agentid;
	func1(email, agentf, res);
});

app.get('/change', function(req, res){
	res.render('./change.ejs');
});

app.post('/change', function(req, res){
	var new_password = req.body.new_password;
	pool.query("update agent set password='" + new_password + "' where agentid='"+agentf+"'", function(err, result, fields) {
		if(err){console.log(err);}
		else{console.log("PASSWORD CHANGED!"); res.redirect('/agent');}
	});
});



/*add or delete property by agent*/

app.post('/agentpage', function(req, res) {
	var type = req.body.update_property.toUpperCase();
	if (type === "DELETE_PROPERTY") {
		res.redirect('/delete_property');
	} else if (type === "ADD_PROPERTY") {
		res.redirect('/add_property');
	} else if (type === "NEW_REQUEST") {
		res.redirect('/new_request');
	}
});
app.get('/add_property', isLoggedIn, (req, res) => {
	res.render('./add_property.ejs');
});
app.post('/add_property', function(req, res) {

	var reg_num = req.body.reg_num;

	var date_list = req.body.date_list;
	var size = req.body.size;
	var address = req.body.address;
	var ownerName = req.body.ownerName;
	var price = req.body.price;
	var type = req.body.type;
	var bathrooms = req.body.bathrooms;
	var bedrooms = req.body.bedrooms;

	pool.query('select curdate()', function(err1, res1, hyt) {
		var d = res1;
		pool.query('insert into listing(agentid,reg_num,datelisted,sellingDate,available) values(?,?,?,?,?)', [agentid, reg_num, new Date(), '0000-00-00 00:00:00', 'available'], function(err, results, fields) {
			if (err) console.log(err);
			pool.query('insert into property(reg_num,address,ownername,price,type,bathrooms,bedroooms,size,agentid) values(' + reg_num + ',"' + address + '","' + ownerName + '",' + price + ',"' + type + '","' + bathrooms + '","' + bedrooms + '","' + size + '","' + agentid + '")', function(error, results, fields) {
				if (error) console.log(error);
				res.redirect("/agentpage");
			});
		});
	});
});


app.get('/delete_property', isLoggedIn, (req, res) => {
	res.render('./delete_property.ejs');
});
app.post('/delete_property', function(req, res) {
	var reg_num = req.body.reg_num;
	pool.query('delete from  listing where reg_num= ' + reg_num, function(err, results, fields) {
		pool.query('delete from  property where reg_num= ' + reg_num, function(error, results, fields) {
			if (error) console.log(error);
			res.redirect('/agentpage');
		});
	});
});

app.post('/agentpage', function(request, response) {

	pool.query('SELECT * FROM new_buyer', function(error, results, fields) {

		response.redirect('/new_request');


	});


});

app.get('/new_request', (req, res) => {
	setResHtml("SELECT * FROM new_buyer", (responseData) => {
		res.render('./new_request.ejs', { data: responseData });
	});
});

app.post('/new_request', function(req, res) {
	var val = req.body.new_deal;
	var c = 0;
	var reg_num = "";
	var email = "";
	for (var i = 0; i < val.length; i++) {
		if (c == 1) {
			email = email + val.charAt(i);
		}
		if (val.charAt(i) == '|') {
			c = 1;
		}
		if (c == 0) {
			reg_num = reg_num + val.charAt(i);
		}

	}
	console.log(reg_num);
	console.log(email);
	// var reg_num = "";
	// for(var i = 0; i < reg[0].length; i++){
	// 	reg_num = reg_num + reg[0][i];
	// }
	// var email = "";
	// for(var i=0 ; i < reg[0].length; i++){
	// 	email = email+ reg[0][i];
	// }
	pool.query('select *from new_buyer where reg_num=' + email + ' and email="' + reg_num + '"', function(error, results, fields) {
		console.log(error);
		if (error) console.log(error);

		pool.query('insert into buyer(name,phone,propertyType) values("' + results[0].name + '",' + results[0].phone + ',"' + 'buy' + '")', function(error1, results1, fields) {
			if (error1) console.log(error1);
			pool.query('select buyerid from buyer where name="' + results[0].name + '" and phone=' + results[0].phone + '', function(error2, results2, fields) {
				if (error2) console.log(error2);
				pool.query('insert into work_with(buyerid,agentid) values(?,?)', [results2[0].buyerid, agentid], function(error3, results3, fields) {
					if (error3) console.log(error3);
					pool.query('update listing set available="sold", sellingDate=now() where reg_num= ' + email, function(error4, results4, fields) {

						if (error1) console.log(error1);
						if (error2) console.log(error2);
						res.redirect('/agentpage');
					});
				});
			});
		});
	});
});
//end





app.get('/', function(request, response) {
	response.redirect('/data');
});

app.get('/data', function(request, response) {
	response.render('./data.ejs');
});
app.get('/agentlogin', (req, res) => {
	res.render('./agentlogin.ejs');
});

app.post('/agentlogin', function(request, response) {
	agentid = request.body.agentid;
	var password = request.body.password;
	if (agentid && password) {
		pool.query('SELECT * FROM agent WHERE agentid = ? AND password = ?', [agentid, password], function(error, results, fields) {
			if (results.length > 0) {
				request.session.loggedin = true;
				request.session.username = agentid;
				response.redirect('/agentpage');
			} else {
				response.send('Incorrect agentid or Password!');
			}
			response.end();
		});
	} else {
		response.send('Please enter Username and Password!');
		response.end();
	}
});
app.get('/agentpage', isLoggedIn, (req, res) => {
	setResHtml("SELECT reg_num,name,phone,firmid,date_list,available,address,ownername,price FROM agent natural join listing natural join property where agent.agentid=" + req.session.username, (responseData) => {
		res.render('./agentpage.ejs', { data: responseData });
	});
});
app.get('/agentsignup', (req, res) => {
	res.render('./agentsignup.ejs');
});
app.post('/agentsignup', function(req, res) {

	var name = req.body.Name;
	var phoneno = req.body.phoneno;
	var firmid = req.body.firmid;
	var email = req.body.email;

	var sql = "INSERT INTO new_agent(name, email, phone, firmid) VALUES ?";
	var post = [
		[name, email, phoneno, firmid]
	];
	pool.query(sql, [post], function(err, result) {
		if (err) throw err;
		res.redirect('/data');
	});

});
app.get('/data', function(req, res) {
	res.render('./data.ejs');
});

app.post('/data', function(req, res) {
	var type = req.body.Type.toUpperCase();
	if (type === "HOME") {
		res.redirect('/data');
	} else if (type === "PROPERTY") {
		res.redirect('/properties');
	} else if (type === "SOLDPROPERTY") {
		res.redirect('/soldproperties');
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
	}

	if (type === "FIRM") {
		res.redirect('/firm');
	} else if (type === "ADMINISTRATOR") {
		res.redirect('/administrator');
	} else if (type === "LOGOUT") {
		res.redirect('/logout');
	}

});

app.get('/agent', (req, res) => {
	setResHtml("SELECT agentid, name, phone, firmid, date_list from agent", (responseData) => {
		res.render('./agent.ejs', { data: responseData });
	});
});

app.post('/agent', function(req, res) {
	var type = req.body.data.toUpperCase();
	if (type === "LOGIN") {
		res.redirect('/agentlogin');
	} else if (type === "SIGNUP") {
		res.redirect('/agentsignup');
	}
	else if (type === "FORGET PASSWORD"){
		res.redirect('/forgetpasswordforagent');
	}

});



app.get('/properties', (req, res) => {
	setResHtml("select * from property natural join listing where listing.available='available'", (responseData) => {
		res.render('./properties.ejs', { data: responseData });
	});
});
app.post('/properties', function(req, res) {
	var name = req.body.name.toUpperCase();
	var mob = req.body.mob.toUpperCase();
	var email = req.body.email.toUpperCase();
	pool.query('insert into new_buyer values("' + email + '", ' + mob + ', "' + name + '", ' + propertyID + ')', function(err, result, fields) {
		res.redirect('/properties');
	});
});

app.get('/soldproperties', (req, res) => {
	setResHtml("select * from property  natural join listing where listing.available='sold' ", (responseData) => {
		res.render('./soldproperties.ejs', { data: responseData });
	});
});
app.get("/property/:propertyID", (req, res) => {

	propertyID = req.params.propertyID;
	console.log(propertyID);

	setResHtml("select * from property where reg_num=" + propertyID, (responseData1) => {
		setResHtml("select * from listing where reg_num=" + propertyID, (responseData2) => {

			res.render('./property.ejs', { data1: responseData1, data2: responseData2 });
		});
	});
});

app.get('/newbuyer', (req, res) => {
	res.render('./newbuyer.ejs');
});

app.post('/property', function(req, res) {
	var type = req.body.data.toUpperCase();
	res.redirect('/newbuyer');

});
app.get('/house/:houseID', function(req, res) {

	propertyID = req.params.houseID;
	res.redirect('/newbuyer');

});


app.get('/apartment/:apartmentID', function(req, res) {
	propertyID = req.params.apartmentID;
	res.redirect('/newbuyer');

});


app.get('/work_with', (req, res) => {
	setResHtml("select * from work_with", (responseData) => {
		res.render('./work_with.ejs', { data: responseData });
	});
});
app.get('/buyer', (req, res) => {
	setResHtml("select * from buyer", (responseData) => {
		res.render('./buyer.ejs', { data: responseData });
	});
});
app.get('/firm', (req, res) => {
	setResHtml("select * from firm", (responseData) => {
		res.render('./firm.ejs', { data: responseData });
	});
});
app.get('/listing', (req, res) => {
	setResHtml("select * from listing", (responseData) => {
		res.render('./listing.ejs', { data: responseData });
	});
});
app.get('/apartment', (req, res) => {
	setResHtml("select p.agentid, p.reg_num,p.ownername,p.price,p.bathrooms,p.bedrooms,p.size from apartment p natural join listing where listing.available='available'", (responseData) => {
		res.render('./apartment.ejs', { data: responseData });
	});
});

app.get('/house', (req, res) => {

	setResHtml("select p.agentid, p.reg_num,p.ownername,p.price,p.bathrooms,p.bedrooms,p.size from house p natural join listing where listing.available='available'", (responseData) => {

		res.render('./house.ejs', { data: responseData });
	});
});
app.get('/address', (req, res) => {
	setResHtml("select * from address", (responseData) => {
		res.render('./address.ejs', { data: responseData });
	});
});

function isLoggedIn(req, res, next) {
	if (req.session.loggedin) {
		return next();
	}
	res.send("Not Logged In");
}

app.listen(3007, () => {
	console.log("Connected to 3007");
});

//end
