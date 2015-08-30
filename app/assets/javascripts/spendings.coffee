# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready page:load', -> 
  $('.datepicker').datepicker({format: 'yyyy-mm-dd', autoclose: true, weekStart: 0, todayHighlight: true});

