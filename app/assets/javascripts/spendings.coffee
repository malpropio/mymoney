# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

$(document).on 'change ready page:load', -> 
  $('.datepicker').datepicker({format: 'yyyy-mm-dd', autoclose: true, weekStart: 0, todayHighlight: true});
  
  $('#spending_category_id').change ->
    # get value from dropdown
    #var divClass = $('#spending_category_id').val(); 
    divClass = $('#spending_category_id option:selected').text().toLowerCase()
    if divClass == 'loans'
      $('form #desc_select').show()
      $('form #desc_text').hide()
    else
      $('form #desc_select').hide()
      $('form #desc_text').show()
    return;
