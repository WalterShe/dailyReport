/**
 * Module dependencies.
 */

var express = require('express')
  , http = require('http')
  , connect = require('connect')
  , routeProfile = require('./routes/routeProfile')
  , path = require('path')
  , redis = require("redis")
  , redisConfig = require('./config')
  , session = require('express-session')
  , redisStore = require('connect-redis')(session)
  , appport = redisConfig.app.port
  , sessiondbconfig = redisConfig.sessiondb;

var app = express();
var redisClient = redis.createClient(redisConfig.db.port,redisConfig.db.host);
redisClient.on("error", function(err) {
   console.log(err);
});

var mysql = require('mysql');
var conn = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'root',
    database:'wordpress',
    port: 3306
});
conn.connect();
conn.query('SELECT 1 + 1 AS solution', function(err, rows, fields) {
    if (err) throw err;
    console.log('The solution is: ', rows[0].solution);
});
conn.end();


// all environments
app.set('port', appport || process.env.PORT || 3000);
app.set('views', __dirname + '/views');
app.set('view engine', 'hbs');
app.use(require('morgan')('dev'));
app.use(require('compression')());
app.use(require('body-parser')());
app.use(require('method-override')());
app.use(require('cookie-parser')());
app.use(session({ store: new redisStore({host:sessiondbconfig.host, port:sessiondbconfig.port, pass:sessiondbconfig.pass, db:sessiondbconfig.db, prefix:'sess', ttl:3600}), secret: 'iamwaltershe' }));
//app.use(app.router);
app.use(express.static(path.join(__dirname, 'public')));

// development only
if ('development' == app.get('env')) {
  app.use(require('errorhandler')());
}

routeProfile.createRoutes(app);

http.createServer(app).listen(app.get('port'), function(){
  console.log('Express server listening on port ' + app.get('port'));
});
