list = $("#control-ring li")
sequen = [false,false,false,false,false ]
sequen_ = ['A','B','C','D' ,'E']
flag = false
callback = (data,textStatus)->
	allspan = $(".random")
	unread.innerHTML = data for unread in allspan when unread.innerHTML == "..."
	enable()
	if ($("li .random").length == 5)
		calculate()
	else robot()
	0
enable = ->
	allli = $("#control-ring li")
	$(li for li in allli when not $(li).find(".random").get(0)).css "background-color" , "rgba(61,40,166,1)"
	0
disable = ->
	allli = $("#control-ring li")
	$(li for li in allli ).css "background-color" , "grey"
	$("#control-ring").unbind "click"
	0
calculate=->
	sum = 0
	add =(random)->
		sum = sum+parseInt random.innerHTML
	add span for span in $(".random")
	$("#info").get(0).innerHTML += '<br>' + sum;
	$("#info-bar").css "background-color","grey"
	$("#info-bar").unbind "click"
	flag = true

setLabel = (tar)->
	unread = $("<span class = 'random'>...</span>")
	$(tar).append(unread.get(0))
	0

ini = ()->
    if flag
      $(".random").remove()
      $("#info").get(0).innerHTML = ""
      enable()
      sequen = [false,false,false,false,false ]
      flag = false
robot =->
	start=(li)->
		setLabel(li)
		$.get("/",callback) 
		disable()
	i = Math.floor(Math.random()*5)
	while sequen[i] is true
       i = Math.floor(Math.random()*5)
    $("#info").get(0).innerHTML += sequen_[i]
    sequen[i] = true
	start list[i] 

$(".icon").click robot
$(".icon").mouseleave ini