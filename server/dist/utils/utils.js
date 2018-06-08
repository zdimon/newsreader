// Generated by CoffeeScript 1.9.3
(function() {
  module.exports = {
    getNowDate: function(diff) {
      var dd, mm, today;
      if (diff == null) {
        diff = 0;
      }
      today = new Date();
      if (diff > 0) {
        today.setDate(today.getDate() - diff);
      }
      dd = today.getDate();
      if (dd < 10) {
        dd = '0' + dd;
      }
      mm = today.getMonth() + 1;
      if (mm < 10) {
        mm = '0' + mm;
      }
      return (today.getFullYear()) + "-" + mm + "-" + dd;
    },
    count_in_object: function(obj) {
      var count, i, len, prop;
      count = 0;
      for (i = 0, len = obj.length; i < len; i++) {
        prop = obj[i];
        ++count;
      }
      return count;
    }
  };

}).call(this);