// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

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

function updateCDTime(kickoff) {
	now      = new Date();
	diff = kickoff - now;

	days  = Math.floor( diff / (1000*60*60*24) );
	hours = Math.floor( diff / (1000*60*60) );
	mins  = Math.floor( diff / (1000*60) );
	secs  = Math.floor( diff / 1000 );

	dd = days;
	hh = hours - days  * 24;
	mm = mins  - hours * 60;
	ss = secs  - mins  * 60;

	// document.getElementById("worldcup_countdown_time").innerHTML = dd + ' days<br/>' + hh + ' hours<br/>' + mm + ' minutes<br/>' + ss + ' seconds' ;
	document.getElementById("countdown_time")
        .innerHTML =
            dd + ' days ' +
            hh + ' hours ' +
            mm + ' minutes ' +
            ss + ' seconds' ;

}
