document.addEventListener "page:change", ->
  $('#feedbacks').dataTable
    sPaginationType: "full_numbers",
    lengthMenu: [ 20, 30, 50, 75, 100 ],
    bJQueryUI: true
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#feedbacks').data('source')
