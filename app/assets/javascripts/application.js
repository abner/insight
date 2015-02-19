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
//= require magnific

//= require nprogress
//= require nprogress-turbolinks

// #require_tree .


$(function() {
  //$(document).foundation();


});
dataConfirmModal.setDefaults({
  title: 'Confirmação de Ação',
  commit: 'Confirmar',
  cancel: 'Cancelar'
});

function init(){
  $('pre code').each(function(i, e) {
    try { hljs.highlightBlock(e); } catch(e) {}
  });
  $('.dropdown-toggle').dropdown();
  
  $('.toogleMenu').on('click', function(){
      $('div.main_wrapper').toggleClass('collapsed'); 
  });
        
}

jQuery(document).on('ready page:load', init);



// Add it after jquery.magnific-popup.js and before first initialization code
$.extend(true, $.magnificPopup.defaults, {
  tClose: 'Fechar (Esc)', // Alt text on close button
  tLoading: 'Carregando...', // Text that is displayed during loading. Can contain %curr% and %total% keys
  gallery: {
    tPrev: 'Anterior (Seta para esquerda)', // Alt text on left arrow
    tNext: 'Próximo (Seta para a direnta)', // Alt text on right arrow
    tCounter: '%curr% de %total%' // Markup for "1 of 7" counter
  },
  image: {
    tError: '<a href="%url%">Imagem</a> não pode ser carregada.' // Error message when image could not be loaded
  },
  ajax: {
    tError: '<a href="%url%">O conteúdo</a> não pode ser carregado loaded.' // Error message when ajax request failed
  }
})

//Turbolinks.enableProgressBar();