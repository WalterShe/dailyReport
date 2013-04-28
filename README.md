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