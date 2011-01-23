// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function() {
  $(".pagination.ajax a").live("click", function() {
    $(".pagination").html("Page is loading...");
    $.get(this.href, null, null, "script");
    return false;
  });
});

$('a[data-popup]').live('click', function(e) {
  window.open($(this).attr('href'));
	return false;
}); 
	
$(document).ready(function() {
  $('a.popup').click(function() {
    $('<div />').appendTo('body').dialog({
      title: $(this).attr('title'),
      modal: true
    }).load($(this).attr('href') + ' form', function() {
      $form = $(this).find('form')
      $form.find(':text:first').focus();
      $btn = $form.find(':submit');
      var txt = $btn.val();
      $btn.remove();
      var buttons = {};
      buttons[txt] = function() {
        $.ajax({
          type: $form.attr('method'),
          url: $form.attr('action'),
          data: $form.serialize(),
          dataType: 'script',
          complete: function(xhr, status) {
            if(status=='success'){
							$form.html("");
							$form.append('<div class="'+status+'">'+xhr.responseText+'</div>');
							$(".ui-dialog-buttonset").hide();
							location.reload(true);
            	return false;
						}else{
							$form.append('<div class="'+status+'">'+xhr.responseText+'</div>');
            	return false;
						}
          }
        });
      };
      $(this).dialog('option','buttons', buttons );
			$('.ui-dialog').keydown(function(e){
				if (e.keyCode == 13) {              
		  		$('.ui-dialog').find('button:first').trigger('click');
					return false;
		  	}
			});
    });
    return false;
  });
});

//Shows a hidden text
//params: code - code that becomes visible
function show_code(code) {
  $(code).slideToggle('slow');
};
