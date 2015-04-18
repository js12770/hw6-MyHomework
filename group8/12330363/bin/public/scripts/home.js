(function(){
  var init, initNewSpec, initNewHw, initBtnsEditSpec, initBtnsGradeHw, initBtnsEditHw, getSpecAndRender, getHwAndRender, initBtnSaveSpecification, initBtnSaveHomework;
  $(function(){
    return init();
  });
  init = function(){
    getSpecAndRender();
    getHwAndRender();
    initNewSpec();
    initNewHw();
    initBtnsGradeHw();
  };
  initNewSpec = function(){
    $('#new-spec').click(function(){
      var inputRows;
      $('h4.modal-title').text('New Homework Specification');
      inputRows = $('.form-control');
      $(inputRows[0]).val('Homework title');
      $(inputRows[1]).val('Deadline (YYYY-MM-DD HH:MM:SS)');
      $('textarea').val('Homework content here...');
      $('#editor').modal('show');
    });
    initBtnSaveSpecification();
  };
  initNewHw = function(){
    $('#new-hw').click(function(){
      var inputRows;
      $('h4.modal-title').text('New Homework');
      inputRows = $('.form-control');
      $(inputRows[0]).val('Homework title');
      $(inputRows[1]).hide();
      $('textarea').val('Homework content here...');
      $('#editor').modal('show');
    });
    initBtnSaveHomework();
  };
  initBtnsEditSpec = function(){
    var i$, len$;
    for (i$ = 0, len$ = $('.edit-spec').length; i$ < len$; ++i$) {
      (fn$.call(this, i$, $('.edit-spec')[i$]));
    }
    initBtnSaveSpecification();
    function fn$(i, btn){
      $(btn).click(function(){
        var tds, inputRows;
        tds = $(btn).parent().siblings();
        $('h4.modal-title').text('Edit Homework Specification');
        inputRows = $('.form-control');
        $(inputRows[0]).val($(tds[0]).text());
        $(inputRows[1]).val($(tds[2]).text());
        $('textarea').val($(tds[4]).text());
        $('#editor').modal('show');
      });
    }
  };
  initBtnsGradeHw = function(){
    var i$, len$;
    for (i$ = 0, len$ = $('.grade-hw').length; i$ < len$; ++i$) {
      (fn$.call(this, i$, $('.grade-hw')[i$]));
    }
    function fn$(i, btn){
      $(btn).click(function(){
        var inputRows;
        $('h4.modal-title').text('Grading');
        inputRows = $('.form-control');
        $(inputRows[0]).val('Grade: 0 - 100');
        $(inputRows[1]).hide();
        $('textarea').val('');
        $('#editor').modal('show');
        $.post('/grade_homework', {
          title: 'todo',
          grades: $(inputRows[0]).val()
        });
      });
    }
  };
  initBtnsEditHw = function(){
    var i$, len$;
    for (i$ = 0, len$ = $('.edit-hw').length; i$ < len$; ++i$) {
      (fn$.call(this, i$, $('.edit-hw')[i$]));
    }
    initBtnSaveHomework();
    function fn$(i, btn){
      $(btn).click(function(){
        var tds, inputRows;
        tds = $(btn).parent().siblings();
        $('h4.modal-title').text('Edit Homework');
        inputRows = $('.form-control');
        $(inputRows[0]).val($(tds[0]).text());
        $(inputRows[1]).hide();
        $('textarea').val($(tds[4]).text());
        $('#editor').modal('show');
      });
    }
  };
  getSpecAndRender = function(){
    var this$ = this;
    $.getJSON('/get_specification', function(specs){
      var renderString, i$, len$, spec, rowString, btnString, j$, ref$, len1$, attr;
      renderString = '';
      for (i$ = 0, len$ = specs.length; i$ < len$; ++i$) {
        spec = specs[i$];
        rowString = '<tr>';
        if ($('#homework').hasClass('true')) {
          btnString = '<td><button class="btn btn-sm btn-primary edit-spec">Edit</button></td>';
        }
        rowString += btnString;
        for (j$ = 0, len1$ = (ref$ = [spec.title, spec.version, new Date(spec.deadline).toLocaleString(), spec.author, spec.content]).length; j$ < len1$; ++j$) {
          attr = ref$[j$];
          rowString += '<td>' + attr + '</td>';
        }
        rowString += '</tr>';
        renderString += rowString;
      }
      $('#specification tbody').html(renderString);
      initBtnsEditSpec();
    });
  };
  getHwAndRender = function(){
    var this$ = this;
    $.getJSON('/get_homework', function(hws){
      var renderString, i$, len$, hw, rowString, btnString, j$, ref$, len1$, attr;
      renderString = '';
      for (i$ = 0, len$ = hws.length; i$ < len$; ++i$) {
        hw = hws[i$];
        rowString = '<tr>';
        if ($('#homework').hasClass('true')) {
          btnString = '<td><button class="btn btn-sm btn-primary grade-hw">Grade</button></td>';
        } else if ($('#homework').hasClass('false')) {
          btnString = '<td><button class="btn btn-sm btn-primary edit-hw">Edit</button></td>';
        }
        rowString += btnString;
        for (j$ = 0, len1$ = (ref$ = [hw.specTitle, hw.version, new Date(hw.modifiedDate).toLocaleString(), hw.author, hw.content, hw.grades]).length; j$ < len1$; ++j$) {
          attr = ref$[j$];
          rowString += '<td>' + attr + '</td>';
        }
        rowString += '</tr>';
        renderString += rowString;
      }
      $('#homework tbody').html(renderString);
      if ($('#homework').hasClass('true')) {
        initBtnsGradeHw();
      } else if ($('#homework').hasClass('false')) {
        initBtnsEditHw();
      }
    });
  };
  initBtnSaveSpecification = function(){
    $('#save').click(function(){
      var inputRows;
      inputRows = $('.form-control');
      $.post('/post_specification', {
        title: $(inputRows[0]).val(),
        deadline: new Date($(inputRows[1]).val()),
        content: $('textarea').val()
      });
      getSpecAndRender();
    });
  };
  initBtnSaveHomework = function(){
    $('#save').click(function(){
      var inputRows;
      inputRows = $('.form-control');
      $.post('/submit_homework', {
        title: $(inputRows[0]).val(),
        deadline: new Date($(inputRows[1]).val()),
        content: $('textarea').val()
      });
      getHwAndRender();
    });
  };
}).call(this);
