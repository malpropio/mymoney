# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on 'change ready page:load', ->
  $('.datepicker').datepicker({format: 'yyyy-mm-dd', autoclose: true, weekStart: 0, todayHighlight: true})

  $('#spending_category_id').ready ->
    # get value from dropdown
    #var selectedOption = $('#spending_category_id').val();
    #alert GetElementInsideContainer('desc_text', 'spending_description').value
    selectedOption = $('#spending_category_id option:selected').text().toLowerCase()
    if selectedOption == 'loans'
      $('form #desc_select').show()
      $('form #desc_text').hide()
      #alert GetElementInsideContainer('desc_text', 'spending_description').value
      GetElementInsideContainer('desc_text', 'spending_description').setAttribute("value","");
      #alert GetElementInsideContainer('desc_text', 'spending_description').value
    else
      $('form #desc_select').hide()
      $('form #desc_text').show()
    return;

GetElementInsideContainer = (containerID, childID) ->
  elm = document.getElementById(childID)
  parent = if elm then elm.parentNode else {}
  if parent.id and parent.id == containerID then elm else {}
