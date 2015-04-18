window.onload = function(){
  var nav1 = document.getElementById('nav1');
  var nav2 = document.getElementById('nav2');
  var part1 = document.getElementById('part1');
  var part2 = document.getElementById('part2');

  nav1.onclick = function(){
    part1.style.display = "block";
    part2.style.display = "none";
    nav1.className = 'active';
    nav2.className = '';
  }
  nav2.onclick = function(){
    part2.style.display = "block";
    part1.style.display = "none";
    nav2.className = 'active';
    nav1.className = '';
  }
}

