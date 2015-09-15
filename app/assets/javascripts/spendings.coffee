# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on 'change ready page:load', ->
  $('.datepicker').datepicker({format: 'yyyy-mm-dd', autoclose: true, weekStart: 0, todayHighlight: true});

  $('#spending_category_id').ready ->
    selectedOption = $('#spending_category_id option:selected').text().toLowerCase()
    if selectedOption == 'loans'
      $('form #desc_text').hide()
      $('form #desc_cc').hide()
      $('form #desc_asset').hide()
      $('form #desc_loan').show()
    else if selectedOption == 'credit cards'
      $('form #desc_cc').show()
      $('form #desc_loan').hide()
      $('form #desc_text').hide()
      $('form #desc_asset').hide()
    else if selectedOption == 'savings'
      $('form #desc_cc').hide()
      $('form #desc_loan').hide()
      $('form #desc_text').hide()
      $('form #desc_asset').show()
    else
      $('form #desc_loan').hide()
      $('form #desc_text').show()
      $('form #desc_cc').hide()
      $('form #desc_asset').hide()
    return;

GetElementInsideContainer = (containerID, childID) ->
  elm = document.getElementById(childID)
  parent = if elm then elm.parentNode else {}
  if parent.id and parent.id == containerID then elm else {}
