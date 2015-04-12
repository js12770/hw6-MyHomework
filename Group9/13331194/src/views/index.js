window.onload = function(){
	document.getElementById("myhomework").onclick = function() {
		console.log("fdjkl")
		if (document.getElementById("add").style.width == "0px")
			document.getElementById("add").style.width = "";
			document.getElementById("add").style.height = "";
		else
			document.getElementById("add").style.width = "0px";
			document.getElementById("add").style.height = "0px";
	}
}