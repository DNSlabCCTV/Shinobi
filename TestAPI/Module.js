const fs = require('fs');
const mysql = require('mysql');
const jsdom = require("jsdom");
const { JSDOM } = jsdom;
const { window } = new JSDOM(`<!DOCTYPE html>`);
const $ = require('jquery')(window);




var dbConnection = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "",
    database: "ccio",
    port:3306
});






module.exports.ShinobiSetup = function(host, ports, cameraName, rtspUrl, callback){
dbConnection.query('select * from Users;', function (err, rows, fields) {
        if(err){
            console.log(err);
        }
        fs.readFile('Add_Monitor.txt', function (err, data) {
          if (err) throw err;
          data = JSON.parse(data);
	  console.log("rtsp:",rtspUrl[0]);
          //rtsp://admin:dns3438@192.168.1.100:88/videoMain
	  data.mid = cameraName;
	  console.log("mid:",data.mid);
	  data.name = cameraName;
	  console.log("name:",data.name);
	  data.host = rtspUrl[0].substring(rtspUrl[0].indexOf('@')+1,rtspUrl[0].length-13);
	  console.log("host:",data.host);
	  var details = JSON.parse(data.details);
	  details.auto_host = rtspUrl[0];
	  console.log("detail.auto_host:",details.auto_host);
	  //rtsp://admin:dns3438@192.168.1.100:88/videoMain
	  var sub = details.auto_host.substring(7,details.auto_host.indexOf('@'));
	  details.muser = sub.substring(0,sub.indexOf(':'));
	  console.log("muser:",details.muser);
	  details.mpass = sub.substring(sub.indexOf(':')+1,sub.length);
	  console.log("mpass:",details.mpass);
	  details = JSON.stringify(details);
	  data.details = details;
          data = JSON.stringify(data);
	  console.log(data);
	  //console.log(data)
          var get_url = 'http://'+host+':'+ports+'/'+rows[0].auth+'/configureMonitor/'+rows[0].ke+'/'+cameraName+'?data='+data;
          $.get(get_url, function(data, status){
            console.log(data);
          });
	});
});
}










module.exports.ShinobiDeleteMonitor = function(host, ports, cameraName, callback){
function getData(callback){
    dbConnection.query('select * from Users;', function (err, rows, fields) {
        if(err){
            console.log(err);
        }
	var Monitor_id ;
	var get_url = 'http://'+host+':'+ports+'/'+rows[0].auth+'/monitor/'+rows[0].ke;
          $.get(get_url, function(data, status){
		callback(data);
	  });
    });
}
getData(function(data){
var Monitor_id;
console.log(data.length);
if(data.length >= 2){
   for(var i=0; i<data.length; i++){
	if(data[i].mid = cameraName){
	   Monitor_id = data[i].mid;
   	}
	else{
	   console.log('There is no camera - '+cameraName);
	}
   };
}else{
   Monitor_id = data;
}
    dbConnection.query('select * from Users;', function (err, rows, fields){
	var get_url = 'http://'+host+':'+ports+'/'+rows[0].auth+'/configureMonitor/'+rows[0].ke+'/'+Monitor_id+'/delete';
	$.get(get_url, function(data, status){
	   console.log(data);
	});
    });
});
}
