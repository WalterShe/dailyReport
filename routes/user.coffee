exports.loginIndex = (req, res) ->
    res.render("login")

exports.login = (req, res) ->
  username = req.body.userName
  password = req.body.password

  #res.send("#{username} login in.")
  res.redirect('/admin')