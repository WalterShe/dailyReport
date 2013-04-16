
userModel = require('../models/usersModel')
departmentModel = require('../models/departmentsModel')

exports.index = (req, res) ->
  res.render("admin/department")

exports.usersIndex = (req, res) ->
  res.render("admin/users")

exports.createUser = (req, res) ->
  userName = req.body.userName
  password = req.body.password
  userModel.createUser(userName, password, (response)->
           res.send(response))

exports.createDepartment = (req, res) ->
  departmentName = req.body.departmentName
  parentId = req.body.pid
  res.send({message:"departmentName:#{departmentName}, pid:#{parentId}"})
  ###
  departmentModel.createDepartment(departmentName, parentId, (response)->
    res.send(response))
   ###