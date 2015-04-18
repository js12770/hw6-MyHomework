var submithw = document.getElementsByClassName('submithw');

for (var i = 0; i < submithw.length; i++) {
  (function(i){
    submithw[i].onclick = function(){
      document.getElementById('nav2').click();
      var models = document.getElementsByClassName('model');
      var id = models[i].getElementsByTagName('myid')[0].innerHTML;
      var hw = document.getElementsByClassName('myp')[i];
      var hwname = document.getElementsByClassName('hwN')[i];
      var ddl = document.getElementsByClassName('ddl')[0];
      var hwd = document.getElementsByClassName('hwd')[0];
      var myform = document.getElementsByClassName('form-textarea')[0];

      myform.action = '/home/submithw/'+id.toString();
      hwd.getElementsByClassName('hwN')[0].innerHTML = hwname.innerHTML;
      myform.style.display = 'block';
      hwd.style.display = 'block';
      hwd.getElementsByClassName('myp')[0].innerHTML = hw.innerHTML;
      ddl.innerHTML = models[i].getElementsByClassName('deadline')[0].innerHTML;
    }
  })(i);
}




