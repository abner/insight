document.addEventListener "page:change", ->
  $('#feedbacks').dataTable
    sPaginationType: "full_numbers"
    bJQueryUI: true
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#feedbacks').data('source')
