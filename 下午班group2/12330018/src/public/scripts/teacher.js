// if 用户是老师
document.getElementById('add').onclick = function(){
  var models = document.getElementsByClassName('model');
  var newModel = models[models.length-1].cloneNode(true);
  document.getElementById('part1').insertBefore(newModel, models[0]);
  addevent();
  models[0].getElementsByClassName('edit')[0].click();
}


// if 用户是老师
function addevent(){
  var edits = document.getElementsByClassName('edit');
  for(var i=0;i<edits.length;i++){
    (function(i){ 
      edits[i].onclick = function(){
        var mytextarea = document.getElementsByTagName('textarea')[i];
        var myinput = document.getElementsByTagName('input')[i];
        var p = document.getElementsByClassName('myp')[i];
        var myspan = document.getElementsByClassName('hwN')[i];
        mytextarea.innerHTML = p.innerHTML;
        myinput.value = myspan.innerHTML;
        p.style.display = 'none';
        myspan.style.display = 'none';
        myinput.style.display = 'block';
        mytextarea.style.display = 'block';
        p.nextSibling.style.display = 'block';
      }
    })(i)
  }
  
  var modifys = document.getElementsByClassName('modify');
  for(var i=0;i<modifys.length;i++){
    (function(i){
      modifys[i].onclick = function(){
        var textarea = document.getElementsByTagName('textarea')[i];
        var myinput = document.getElementsByTagName('input')[i];
        var p = document.getElementsByClassName('myp')[i];
        var myspan = document.getElementsByClassName('hwN')[i];
        p.innerHTML = textarea.value;
        myspan.innerHTML = myinput.value;
        textarea.style.display = 'none';
        myinput.style.display = 'none';
        myspan.style.display = 'block';
        p.style.display = 'block';
        modifys[i].style.display = 'none';
        var xhr = createXHR();
        xhr.open('get','/home',true);
      }
    })(i)
  }
}
addevent();

function createXHR(){ 
  var http_request; 
  if (window.XMLHttpRequest) { 
    http_request = new XMLHttpRequest(); 
  } else if (window.ActiveXObject) { 
  // IE 
    try { 
      http_request = new ActiveXObject("Msxml2.XMLHTTP"); 
    } catch (e) { 
      try { 
        http_request = new ActiveXObject("Microsoft.XMLHTTP"); 
      } catch (e) { 
        alert("您的浏览器不支持Ajax"); 
        return false; 
      } 
    } 
  }
  return http_request;
} 