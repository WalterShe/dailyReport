
user = require('../controlers/userCtr')
admin = require('../controlers/adminCtr')

exports.createRutes = (app)->
  #app.get('/', routes.index);
  app.get('/login', user.loginIndex);
  app.post('/login', user.login);
  app.get('/admin', admin.index);
  app.post('/admin/createdepartment', admin.createDepartment);
  app.get('/admin/users', admin.usersIndex);
  app.post('/admin/createusers', admin.createUser);
  app.get('/admin/alldepartments', admin.getAllDepartments);