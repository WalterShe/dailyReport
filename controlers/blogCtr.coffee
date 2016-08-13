utils = require('../utils')

exports.index = (req, res) ->
  data={blogname:"书摘"}
  conn = utils.createMysql()
  conn.query('SELECT 1 + 1 AS solution',(err, rows, fields) ->
    console.log('The solution is: ', rows[0].solution)
  )
  conn.end()
  res.render("blog/index", data)