// Generated by CoffeeScript 1.6.1
(function() {
  var Response, dbconfig, redis;

  redis = require("redis");

  Response = require('./vo/response').Response;

  dbconfig = require('./config').db;

  exports.authenticateUser = function(req, res) {
    var result;
    result = this.isLoginUser(req);
    if (!result) {
      res.redirect('/login');
    }
    return result;
  };

  exports.authenticateUserMobile = function(req, res) {
    var result;
    result = this.isLoginUser(req);
    if (!result) {
      res.redirect('/m/login');
    }
    return result;
  };

  exports.isLoginUser = function(req) {
    var _ref;
    return ((_ref = req.session) != null ? _ref.userId : void 0) && true;
  };

  exports.authenticateAdmin = function(req, res) {
    var result;
    result = this.isAdmin(req);
    if (!result) {
      if (this.isLoginUser(req)) {
        res.redirect('/show');
      } else {
        res.redirect('/login');
      }
    }
    return result;
  };

  exports.isAdmin = function(req) {
    return this.isLoginUser(req) && req.session.isAdmin === 1;
  };

  exports.showDBError = function(callback, client, message) {
    if (client == null) {
      client = null;
    }
    if (message == null) {
      message = '数据库错误';
    }
    if (client) {
      client.quit();
    }
    return callback(new Response(0, message));
  };

  exports.createClient = function() {
    var client;
    client = redis.createClient(dbconfig.port, dbconfig.host);
    if (dbconfig.pass) {
      client.auth(dbconfig.pass, function(err) {
        if (err) {
          throw err;
        }
      });
    }
    client.on("error", function(err) {
      console.log(err);
      return client.end();
    });
    return client;
  };

}).call(this);
