$(document).ready ->
  $.datepicker._defaults.dateFormat = "dd M yy"
  $("input.ui-date-text").on "change", ->
    sels = $(this).siblings("select:lt(3)")
    d = $.datepicker.parseDate($.datepicker._defaults.dateFormat, $(this).val())
    $(sels[0]).val d.getFullYear()
    $(sels[1]).val d.getMonth() + 1
    $(sels[2]).val d.getDate()
  
  $(".date, .datetime").each (i, el) ->
    input = document.createElement("input")
    $(input).attr 
      type: "text"
      class: "ui-date-text"
    
    $(el).find("select:first").before input
    $(el).find("select:lt(3)").hide()
    values = []
    $(input).siblings("select:lt(3)").each (i, el) ->
      val = $(el).val()
      values.push val  if val != ""
    
    if values.length > 1
      d = new Date(values[0], parseInt(values[1], 10) - 1, values[2])
      $(input).val $.datepicker.formatDate($.datepicker._defaults.dateFormat, d)
    $(input).datepicker()

