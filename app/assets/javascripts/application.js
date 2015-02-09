// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require data-confirm-modal
//= require jquery-ui
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require turbolinks
//= require select2
//= require select2_locale_pt-BR
//= require foundation
// #require_tree .


dataConfirmModal.setDefaults({
  title: 'Confirmação de Ação',
  commit: 'Confirmar',
  cancel: 'Cancelar'
});

function loadHighlights(){
  $('pre code').each(function(i, e) {
    try { hljs.highlightBlock(e); } catch(e) {}
  });
}


jQuery(document).on('ready page:load', loadHighlights);


//Turbolinks.enableProgressBar();
