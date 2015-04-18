// if 用户是老师
document.getElementById('add').onclick = function(){
  console.log('xx');
  var models = document.getElementsByClassName('editHW');
  var newHW = document.getElementsByClassName('editHW')[0].cloneNode(true);
  newHW.style.display = 'block';
  document.getElementById('part1').insertBefore(newHW, models[0]);
  addevent();
};

// if 用户是老师
function addevent(){
  var edits = document.getElementsByClassName('edit');
  for(var i=0;i<edits.length;i++){
    (function(i){ 
      edits[i].onclick = function(){
        var p = document.getElementsByClassName('myp')[i];
        var myspan = document.getElementsByClassName('hwN')[i];
        var models = document.getElementsByClassName('model');
        var edithw = document.getElementsByClassName('editHW')[0].cloneNode(true);
        var id = models[i].getElementsByTagName('myid')[0].innerHTML;
        edithw.style.display = "block";
        edithw.getElementsByTagName('form')[0].action = '/home/edithw/'+id.toString();
        edithw.getElementsByTagName('input')[0].value = myspan.innerHTML;
        edithw.getElementsByTagName('textarea')[0].innerHTML = p.innerHTML;
        document.getElementById('part1').insertBefore(edithw,models[i]);
        models[i].style.display = 'none';
        edits[i].onclick = null;
         // var mytextarea = document.getElementsByTagName('textarea')[i];
         // var myinput = document.getElementsByTagName('input')[i];
         
        // mytextarea.innerHTML = p.innerHTML;
        // myinput.value = myspan.innerHTML;
        // p.style.display = 'none';
        // myspan.style.display = 'none';
        // myinput.style.display = 'block';
        // mytextarea.style.display = 'block';
        // p.nextSibling.style.display = 'block';
      }
    })(i)
  }
  // 修改作业要求
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
        xhr.open('post','/home/edit',true);
      }
    })(i)
  }
}
addevent();

// function createXHR(){ 
//   var http_request; 
//   if (window.XMLHttpRequest) { 
//     http_request = new XMLHttpRequest(); 
//   } else if (window.ActiveXObject) { 
//   // IE 
//     try { 
//       http_request = new ActiveXObject("Msxml2.XMLHTTP"); 
//     } catch (e) { 
//       try { 
//         http_request = new ActiveXObject("Microsoft.XMLHTTP"); 
//       } catch (e) { 
//         alert("您的浏览器不支持Ajax"); 
//         return false; 
//       } 
//     } 
//   }
//   return http_request;
// } 