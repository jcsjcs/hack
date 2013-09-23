$(document).ready ->
  $.datepicker._defaults.dateFormat = "yy-mm-dd"

  $('input.ui-date-text').datepicker()

