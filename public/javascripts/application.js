// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
/*
Event.observe(window,"load",function() {
       $$("*").findAll(function(node){
         return node.getAttribute('title');
       }).each(function(node){
         new Tooltip(node,node.title);
         node.removeAttribute("title");
       });
     });

document.observe("dom:loaded", function() {
  // the element in which we will observe all clicks and capture
  // ones originating from pagination links
  var container = $(document.body)

  if (container) {
    var img = new Image
    img.src = '/images/ajax-loader.gif'

    function createSpinner() {
      return new Element('img', { src: img.src, 'class': 'spinner' })
    }

    container.observe('click', function(e) {
      var el = e.element()
      if (el.match('.pagination.ajax a')) {
        el.up('.pagination.ajax').insert(createSpinner())
        new Ajax.Request(el.href, { method: 'get' })
        e.stop()
      }
    })
  }
})
*/

$(function() {
  $(".pagination .ajax a").live("click", function() {
    $(".pagination .ajax").html("Page is loading...");
    $.get(this.href, null, null, "script");
    return false;
  });
});

$('a[data-popup]').live('click', function(e) {
      window.open($(this).attr('href'));
			return false;
   }); 
