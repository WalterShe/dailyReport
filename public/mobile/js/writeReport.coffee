# 初始化 ---------------------------------------------------------------
$(document).bind("pageinit", ->

  # 将本机时间当前日期设置为日期文本框的默认值
  getDateStr = (date)->
    today = new Date()
    year = date.getFullYear()
    month = date.getMonth() + 1
    date = date.getDate()
    return "#{year}-#{month}-#{date}"

  dateStr =  getDateStr(new Date())
  $("#dateTxt").val(dateStr)

  # end 将本机时间当前日期设置为日期文本框的默认值

  validator = new Validator()

  validDateTxt = ->
    dateStr = $.trim($("#dateTxt").val())
    contentStr = $.trim($("#content").val())
    try
      validator.check(contentStr).notEmpty()
      validator.check(dateStr).notEmpty()
      [year, months, date] = dateStr.split("-")
      #console.log "#{year}-#{months}-#{date}"
      validator.check(year).notNull().isNumeric().len(4,4)
      validator.check(months).notNull().isNumeric().len(1,2)
      validator.check(date).notNull().isNumeric().len(1,2)
      return true
    catch  error
      return false


  $("#reportSubmitBtn").click((event)->
    if validDateTxt()
      dateStr = $.trim($("#dateTxt").val())
      contentStr = $.trim($("#content").val())
      data = {date:dateStr, content:contentStr}
      Model.createReport(data, (response)->
        return if response.state == 0
        window.location.href = "/m/show")
    else
      $.mobile.changePage("#errorPage", { role: "dialog" }))

)