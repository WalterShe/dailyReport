crypto = require('crypto');

sanitize = require('validator').sanitize
check = require('validator').check

userModel = require('../models/usersModel')
{Response} = require('../vo/Response')

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


exports.getAllUsers = (req, res) ->
  userModel.getAllUsers((response)->
    res.send(response))
