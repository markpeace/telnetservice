var http = require('http');
var apn = require('apn');
var url = require('url');

var myiPad = "bee87b3ad28ae90e42d24600c19b6169462fd3f683119f2224cf104dd4bcfd36";

var myDevice = new apn.Device(myiPad);

var note = new apn.Notification();
note.badge = 1;
note.alert = { "body" : "Your turn!" };
note.payload = {'messageFrom': 'Holly'};

note.device = myDevice;

var callback = function(errorNum, notification){
        console.log('Error is: %s', errorNum);        
}
var options = {
        gateway: 'gateway.push.apple.com', // this URL is different for Apple's Production Servers and changes when you go to production
        errorCallback: callback,
        cert: 'productionCert.pem',                 
        key:  'key.pem',                 
        passphrase: 'mmmbeer00',                 
        port: 2195,                       
        enhanced: true,                   
        cacheLength: 100                  
}
var apnsConnection = new apn.Connection(options);
r=apnsConnection.sendNotification(note);
console.log(r)