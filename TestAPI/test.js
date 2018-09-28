var Shinobi = require(__dirname + "/Module");
var rtspUrl = [];

// write RTSP URL
rtspUrl.push('rtsp://192.168.1.106:8555/unicast');

var host = '192.168.1.104';
var url_ = rtspUrl[0];
var ports = 8080; //  web port  - ports[0]
var cameraName = 'Test';
var callback = '';

// Set up Camera
Shinobi.ShinobiSetup(host, ports, cameraName, rtspUrl, callback, function(result,data){
        if (result){
            console.log(result);
        }
});

// Delete Camera
/*
Shinobi.ShinobiDeleteMonitor(host, ports, cameraName, callback,function(result,data){
        if (result){
            console.log(result);
        }
});
*/
