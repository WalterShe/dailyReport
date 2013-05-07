crypto = require('crypto')

sanitize = require('validator').sanitize
check = require('validator').check

userModel = require('../models/usersModel')
{Response} = require('../vo/Response')

exports.loginIndex = (req, res) ->
    res.render("login")

exports.login = (req, res) ->
  userName = sanitize(req.body.userName).trim()
  password = sanitize(req.body.password).trim()
  hashedPassword = crypto.createHash("sha1").update(password).digest('hex')

  userModel.getAllUsersWithPassword((response)->
    users = response.data
    userId = null
    for key, value of users
      [id,property] = key.split(":")

      if (property == "user_name" and value == userName)
        userId = id
        break

    return res.render("login",{hasError:true, message:"用户名:#{userName}不存在"}) unless userId

    hasThisUser = false
    for key, value of users
      [id,property] = key.split(":")
      if (id == userId and property == "password" and value == hashedPassword)
        userId = id
        hasThisUser = true
        break
    return res.render("login",{hasError:true, message:"密码错误"}) unless hasThisUser

    #console.log "userName:#{userName}, userId:#{userId}"
    req.session.userId = userId
    res.redirect("/show"))


exports.createUser = (req, res) ->
  userName = sanitize(req.body.userName).trim()
  password = sanitize(req.body.password).trim()
  departmentId = req.body.departmentId;
  superiorId = req.body.superiorId;

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
    userModel.createUser(userName, hashedPassword, departmentId, superiorId, (response)->
      res.send(response))
  else
    res.send(new Response(0,errorMessage))

exports.removeUser = (req, res) ->
  userId = sanitize(req.body.userId).trim()
  userModel.removeUser(userId, (response)->
      res.send(response))

exports.updateUser = (req, res) ->
  userId = sanitize(req.body.userId).trim()
  userName = sanitize(req.body.userName).trim()
  password = sanitize(req.body.password).trim()
  departmentId = req.body.departmentId;
  superiorId = req.body.superiorId;

  errorMessage = ""
  try
    check(userName, "字符长度为6-25，不能含有:符号").len(6,25).notContains(":")
  catch  error
    errorMessage = error.message

  ###try
    check(password, "字符长度为7-25，不能含有:符号").len(7,25).notContains(":")
  catch  error
    errorMessage = "#{errorMessage}, #{error.message}" ###

  if errorMessage == ""
    hashedPassword = null
    hashedPassword = crypto.createHash("sha1").update(password).digest('hex') if password
    userModel.updateUser(userId, userName, hashedPassword, departmentId, superiorId, (response)->
      res.send(response))
  else
    res.send(new Response(0,errorMessage))

exports.getAllUsers = (req, res) ->
  userModel.getAllUsers((response)->
    res.send(response))

