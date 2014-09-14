//= require_tree .
//= require "jquery"
//= require "magnific-popup"

$(document).ready(function(){
  $('.content').find('a[href$=".jpg"] img, a[href$=".png"] img')
    .parent()
    .magnificPopup({
      type: 'image',
      gallery: {
        enabled: true
      }
  });
});
