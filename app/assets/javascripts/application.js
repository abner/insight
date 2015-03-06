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

//= require cocoon


// require jquery-ui

//= require jquery-sortable

// require jquery.ddslick

//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require turbolinks
//= require select2
//= require select2_locale_pt-BR
//= require magnific

//= require nprogress
//= require nprogress-turbolinks
//= require nprogress-ajax

//= require cookies-1.2.1

// #require_tree .


//require noty/jquery.noty
//require noty/layouts/center
//require noty/themes/bootstrap
// $.noty.defaults.timeout = 8000
// $.noty.defaults.layout = 'center'
// $.noty.defaults.theme = 'bootstrapTheme'
// $.noty.defaults = {
//                     layout: 'center',
//                     theme: 'defaultTheme',
//                     type: 'alert',
//                     /*text: '',*/
//                     dismissQueue: true, // If you want to use queue feature set this true
//                     /* template: '',*/
//                     animation: {
//                     open: { height: 'toggle' },
//                     close: { height: 'toggle' },
//                     easing: 'swing',
//                     speed: 500 // opening & closing animation speed
//                     },
//                     timeout: true, // delay for closing event. Set false for sticky notifications
//                     force: false, // adds notification to the beginning of queue when set to true
//                     modal: true,
//                     timeout: 8000,
//                     maxVisible: 5, // you can set max visible notification for dismissQueue true option
//                     closeWith: ['click'], // ['click', 'button', 'hover']
//                     callback: {
//                       onShow: function () { },
//                       afterShow: function () { },
//                       onClose: function () { },
//                       afterClose: function () { }
//                     },
//                     buttons: false // an array of buttons
// };

//= require i18n
//= require i18n/translations
//= require i18n_set_locale
//= require alertify

//código para utilizar o alertify para as confirmações do link
//= require rails-alertify


$(function() {
  //$(document).foundation();


});
// dataConfirmModal.setDefaults({
//   title: 'Confirmação de Ação',
//   commit: 'Confirmar',
//   cancel: 'Cancelar'
// });


function init(){
  $('pre.preview_source code').each(function(i, e) {
    try { hljs.highlightBlock(e); } catch(e) {}
  });
  $('.dropdown-toggle').dropdown();

  $('.toggleMenu').on('click', function(){
      $('div.main_wrapper').toggleClass('collapsed');
      $('div.logo_serpro_50_anos').toggleClass('collapsed');

      Cookies.set('feedback_menu_collapsed', $('div.main_wrapper').hasClass('collapsed'));
  });

  //handler de click nos screenshots
  $(document).on('click', 'a.screenshot_link', null, function(){
    //alertify.alert('<img src="' + $(this).attr('href') + '" width="800" height="600"></img>').set('resizable',true).resizeTo(800,600).set('basic', true);
    alertify.alert('<img src="' + $(this).attr('href') + '"></img>').set('resizable',true).maximize().set('basic', true);
    return false;
  });


    $('a[data-popover-confirm=true]').on('click', function(e){
      e.preventDefault();
      var element = $(this);
      var id_content = element.data('idContent');
      if(!element.data('bs.popover')){
        var options = {
                      title:  I18n.t("alertify.Confirmation", {defaultValue: "Confirmation"}),
                      content: $(id_content).html(),
                      html: true,
                      trigger: 'focus',
                      placement: 'bottom'
                    };
        $(element).popover(options).popover('show');
      }

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

NProgress.configure({ parent: '#page-wrapper' });

//Turbolinks.enableProgressBar();
