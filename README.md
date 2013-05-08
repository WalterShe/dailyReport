初次安装好redis后，执行如下命令添加管理员账户：
redis 127.0.0.1:6379> incr next_user_id
(integer) 1
执行完该命令后表明 next_user_id 的值为1，然后执行如下命令（1:user_name和1:password中的1即为上一步执行incr next_user_id后的
next_user_id的值）
redis 127.0.0.1:6379> hmset users 1:user_name adminn 1:password 20eabe5d64b0e216796e834f52d61f
OK
执行下面的命令将管理员adminn的id添加到管理员集合中
redis 127.0.0.1:6379> sadd administrators 1
(integer) 1

执行完以上命令后我们新增加了一个管理员账户adminn,密码为1234567。可以使用该账户登陆进入管理后台进行管理。

数据库字段说明：

用户数据：
next_user_id  (类型 string) 用户id值，每生成一个新用户该值通过incr方法递增1

users (类型 hash) 所有注册用户信息存储在此
 每个user包含如下key:value
 hmset("users", "#{userId}:user_name", userName, "#{userId}:password", password, "#{userId}:department_id", departmentId, "#{userId}:superior_id", superiorId)
 superiorId 为该用户直接上级用户的Id,如果没有直接上级，那么该 key 不存在

部门数据：
next_department_id  (类型 string) 部门id 的值，每生成一个新部门该值通过incr方法递增1

departments (类型 hash) 所有部门信息存储在此
 每个department包含如下key:value
 hset("departments", "#{departmentId}:name", departmentName, "#{departmentId}:pid", pid)
 pid 为该部门直接上级部门，如果没有直接上级部门，那么该 key 不存在

日报数据：
next_report_id  (类型 string) 日报id 的值，每生成一个新日报该值通过incr方法递增1

userid:#{userId}:reportIds (类型 sorted sets)
score 为日期数值 2004-04-09 转换为 20040409
member 为report id

userid:#{userId}:reports (类型 hash)
 #{reportId}:date为日报日期  #{reportId}:content为日报内容

管理员：
administrators (类型 set) 存储的是用户id,管理员用户的id都在该集合中