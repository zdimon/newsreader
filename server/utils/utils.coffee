module.exports =
    getNowDate: ()->
        today = new Date()
        dd =  today.getDate()
        if dd<10
            dd='0'+dd
        mm = today.getMonth()+1
        if mm<10
            mm='0'+mm
        "#{today.getFullYear()}-#{mm}-#{dd}"
