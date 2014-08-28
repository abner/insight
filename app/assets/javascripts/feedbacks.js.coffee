document.addEventListener "page:change", ->

  $('#feedbacks').dataTable
    sPaginationType: "full_numbers",
    lengthMenu: [ 20, 30, 50, 75, 100 ]
    bJQueryUI: true
    retrieve: true
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#feedbacks').data('source')
    language:
      sEmptyTable: "Nenhum registro encontrado"
      sInfo: "Mostrando de _START_ até _END_ de _TOTAL_ registros"
      sInfoEmpty: "Mostrando 0 até 0 de 0 registros"
      sInfoFiltered: "(Filtrados de _MAX_ registros)"
      sInfoPostFix: ""
      sInfoThousands: "."
      sLengthMenu: "_MENU_ resultados por página"
      sLoadingRecords: "Carregando..."
      sProcessing: "Processando..."
      sZeroRecords: "Nenhum registro encontrado"
      sSearch: "Pesquisar"
      oPaginate:
        sNext: "Próximo"
        sPrevious: "Anterior"
        sFirst: "Primeiro"
        sLast: "Último"

      oAria:
        sSortAscending: ": Ordenar colunas de forma ascendente"
        sSortDescending: ": Ordenar colunas de forma descendente"

### Row Details
http://www.datatables.net/examples/server_side/row_details.html
###
