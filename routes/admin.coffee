
userModel = require('../models/usersModel')

exports.index = (req, res) ->
  res.render("admin/department")

exports.usersIndex = (req, res) ->
  res.render("admin/users")

exports.createUser = (req, res) ->
  userName = req.body.userName
  password = req.body.password
  userModel.createUser(userName, password, (response)->
           res.send(response))
