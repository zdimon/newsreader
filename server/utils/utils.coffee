module.exports =
    getNowDate: (diff=0)-> # generate current date 2017-03-31
        today = new Date()
        if diff >0
            today.setDate today.getDate()-diff
        dd =  today.getDate()
        if dd<10
            dd='0'+dd
        mm = today.getMonth()+1
        if mm<10
            mm='0'+mm
        "#{today.getFullYear()}-#{mm}-#{dd}"

    count_in_object: (obj)->
        count = 0;
        for prop in obj
            ++count;
        count
