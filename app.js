
/**
 * Module dependencies.
 */

var express = require('express')
  , http = require('http')
  , routeProfile = require('./routes/ruteProfile')
  , path = require('path')
  , RedisStore = require('connect-redis')(express);

var app = express();


// all environments
app.set('port', process.env.PORT || 3000);
app.set('views', __dirname + '/views');
app.set('view engine', 'hbs');
app.use(express.favicon());
app.use(express.logger('dev'));
app.use(express.compress());
app.use(express.bodyParser());
app.use(express.methodOverride());
app.use(express.cookieParser());
app.use(express.session({ store: new RedisStore({host:'127.0.0.1', port:6379, prefix:'sess', ttl:3600}), secret: 'iamwaltershe' }));
/**app.use(function(req, res, next){
    console.log("I'm Walter She.");
    next();
}); */
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
