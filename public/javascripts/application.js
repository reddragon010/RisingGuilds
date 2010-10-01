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
