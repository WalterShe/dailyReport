
/**
 * Module dependencies.
 */

var express = require('express')
  , http = require('http')
  , routeProfile = require('./routes/ruteProfile')
  , path = require('path')
  , redis = require("redis")
  , RedisStore = require('connect-redis')(express)
  , appport = require('./config').app.port
  , sessiondbconfig = require('./config').sessiondb;

var app = express();
var redisClient = redis.createClient();
redisClient.on("error", function(err) {
   console.log(err);
});

// all environments
app.set('port', appport || process.env.PORT || 3000);
app.set('views', __dirname + '/views');
app.set('view engine', 'hbs');
app.use(express.favicon());
app.use(express.logger('dev'));
app.use(express.compress());
app.use(express.bodyParser());
app.use(express.methodOverride());
app.use(express.cookieParser());
app.use(express.session({ store: new RedisStore({host:sessiondbconfig.host, port:sessiondbconfig.port, pass:sessiondbconfig.pass, db:sessiondbconfig.db, prefix:'sess', ttl:3600}), secret: 'iamwaltershe' }));
app.use(app.router);
app.use(express.static(path.join(__dirname, 'public')));

// development only
if ('development' == app.get('env')) {
  app.use(express.errorHandler());
}

routeProfile.createRutes(app);

http.createServer(app).listen(app.get('port'), function(){
  console.log('Express server listening on port ' + app.get('port'));
});
