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