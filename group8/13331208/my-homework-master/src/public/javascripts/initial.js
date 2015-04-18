window.onload = function() {
	$('#requirement-textbox').text($('#requirement-box').text());

	$('textarea, input[type="text"]').each(
		function() {
			if ($('button').attr('disabled') == 'disabled')
				return;
			$(this).bind('focusout', function() {
				if (this.value.replace(/\s/g, "").length == 0) {
					$(this).parents('.textbox').addClass('has-error');
					$('button').attr('disabled', true);
					console.log('Empty input not allowed.');
				  	$(this).focus();
				  } else {
				  	$(this).parents('.textbox').removeClass('has-error');
				  	$('button').attr('disabled', false);
				  }
			});
		}
	);

	$('input[type="datetime-local"]').each(
		function() {
			if ($('button').attr('disabled') == 'disabled')
				return;
			$(this).bind('focusout', function() {
				console.log(new Date(this.value));
				if (new Date(this.value) < Date.now()) {
					$(this).parents('.textbox').addClass('has-error');
					$('button').attr('disabled', true);
					console.log('Invalid date not allowed.');
				  	$(this).focus();
				  } else {
				  	$(this).parents('.textbox').removeClass('has-error');
				  	$('button').attr('disabled', false);
				  }
			});
		}
	);
	

	$('#homefull').css('height', (window.screen.availHeight-50-48-48)+'px');

}
