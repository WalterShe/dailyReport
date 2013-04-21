exports.loginIndex = (req, res) ->
    res.render("login")

exports.login = (req, res) ->
  username = req.body.userName
  password = req.body.password

  #res.send("#{username} login in.")
  res.redirect('/admin')

exports.createUser = (req, res) ->
  userName = sanitize(req.body.userName).trim()
  password = sanitize(req.body.password).trim()
  errorMessage = ""
  try
    check(userName, "字符长度为6-25，不能含有:符号").len(6,25).notContains(":")
  catch  error
    errorMessage = error.message

  try
    check(password, "字符长度为7-25，不能含有:符号").len(7,25).notContains(":")
  catch  error
    errorMessage = "#{errorMessage}, #{error.message}"

  if errorMessage == ""
    hashedPassword = crypto.createHash("sha1").update(password).digest('hex');
    userModel.createUser(userName, hashedPassword, (response)->
      res.send(response))
  else
    res.send(new Response(0,errorMessage))