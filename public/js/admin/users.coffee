$("#submitBtn").click(->
   userName = $("#userName").val()
   password = $("#password").val()
   #alert("un:#{userName}, pw:#{password}")
   $.post("/admin/users", { userName: userName, password:password },
       (data)->
           alert(data)
    , "json")
   )