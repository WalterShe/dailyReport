{Response} = require('./vo/response')

#如果用户登陆了，返回true，否则返回false，并且转向登陆界面
exports.authenticateUser = (req,res)->
  result = @isLoginUser(req)
  res.redirect('/login') unless result

  result

#如果用户登陆了，返回true，否则返回false
exports.isLoginUser = (req)->
  req.session.userId and true


#如果用户是管理员，返回true，否则返回false ，并且转向登陆界面
exports.authenticateAdmin = (req,res)->
  result = @isAdmin(req)
  unless result
    if @isLoginUser(req)
      res.redirect('/show')
    else
      res.redirect('/login')

  result

#如果用户是管理员，返回true，否则返回false
exports.isAdmin = (req)->
  @isLoginUser(req) and req.session.isAdmin == 1

exports.showDBError = (callback, client=null, message='数据库错误')->
  client.quit()
  callback(new Response(0,message))
