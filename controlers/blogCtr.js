// Generated by CoffeeScript 1.10.0
(function() {
  var utils;

  utils = require('../utils');

  exports.index = function(req, res) {
    var conn, data;
    data = {
      blogname: "书摘"
    };
    conn = utils.createMysql();
    conn.query('SELECT 1 + 1 AS solution', function(err, rows, fields) {
      return console.log('The solution is: ', rows[0].solution);
    });
    conn.end();
    return res.render("blog/index", data);
  };

}).call(this);
