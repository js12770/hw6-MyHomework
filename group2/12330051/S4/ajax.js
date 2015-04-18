// Generated by CoffeeScript 1.9.1
(function() {
  var calculate, callback, disable, enable, flag, ini, list, robot, sequen, sequen_, setLabel;

  list = $("#control-ring li");

  sequen = [false, false, false, false, false];

  sequen_ = ['A', 'B', 'C', 'D', 'E'];

  flag = false;

  callback = function(data, textStatus) {
    var allspan, j, len, unread;
    allspan = $(".random");
    for (j = 0, len = allspan.length; j < len; j++) {
      unread = allspan[j];
      if (unread.innerHTML === "...") {
        unread.innerHTML = data;
      }
    }
    enable();
    if ($("li .random").length === 5) {
      calculate();
    } else {
      robot();
    }
    return 0;
  };

  enable = function() {
    var allli, li;
    allli = $("#control-ring li");
    $((function() {
      var j, len, results;
      results = [];
      for (j = 0, len = allli.length; j < len; j++) {
        li = allli[j];
        if (!$(li).find(".random").get(0)) {
          results.push(li);
        }
      }
      return results;
    })()).css("background-color", "rgba(61,40,166,1)");
    return 0;
  };

  disable = function() {
    var allli, li;
    allli = $("#control-ring li");
    $((function() {
      var j, len, results;
      results = [];
      for (j = 0, len = allli.length; j < len; j++) {
        li = allli[j];
        results.push(li);
      }
      return results;
    })()).css("background-color", "grey");
    $("#control-ring").unbind("click");
    return 0;
  };

  calculate = function() {
    var add, j, len, ref, span, sum;
    sum = 0;
    add = function(random) {
      return sum = sum + parseInt(random.innerHTML);
    };
    ref = $(".random");
    for (j = 0, len = ref.length; j < len; j++) {
      span = ref[j];
      add(span);
    }
    $("#info").get(0).innerHTML += '<br>' + sum;
    $("#info-bar").css("background-color", "grey");
    $("#info-bar").unbind("click");
    return flag = true;
  };

  setLabel = function(tar) {
    var unread;
    unread = $("<span class = 'random'>...</span>");
    $(tar).append(unread.get(0));
    return 0;
  };

  ini = function() {
    if (flag) {
      $(".random").remove();
      $("#info").get(0).innerHTML = "";
      enable();
      sequen = [false, false, false, false, false];
      return flag = false;
    }
  };

  robot = function() {
    var i, start;
    start = function(li) {
      setLabel(li);
      $.get("/", callback);
      return disable();
    };
    i = Math.floor(Math.random() * 5);
    while (sequen[i] === true) {
      i = Math.floor(Math.random() * 5);
    }
    $("#info").get(0).innerHTML += sequen_[i];
    sequen[i] = true;
    return start(list[i]);
  };

  $(".icon").click(robot);

  $(".icon").mouseleave(ini);

}).call(this);
