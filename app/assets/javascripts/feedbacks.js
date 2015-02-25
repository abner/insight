var process_destroy_ajax_return = function(result, target){

  var item = $(target);

  if(item){
    item.parent().parent().remove();
  }

};
$('a').on('ajax:success', function(event, result, status, xhr) {
  if(result.success){
     if(result.action == 'archive' || result.action == 'destroy'){
       process_destroy_ajax_return(result, event.target);
     }
   } else {
   	   //$('#ajax_error_alert p.errorMessage').html(result.error_message);
   	   //$('#ajax_error_alert').show();
   }
});


$('a').on('ajax:error', function(evt, xhr, error, dta) {
   // insert the failure message inside the "#account_settings" element
   //$('#ajax_error_alert p.errorMessage').html(error);
   //$('#ajax_error_alert').show();
   alertify.notify('Erro na requisição: ' + error, 'error',0);
//   console.log(error);
 });

 //$(document).on('ajax:error', function(event, xhr, error_msg, error_obj) {

   //var data = status.

   // insert the failure message inside the "#account_settings" element
   //$('#ajax_error_alert p.errorMessage').html(error);
   //$('#ajax_error_alert').show();
   //alertify.notify('Erro na requisição: ' + error, 'error',0);
   //   console.log(error);
 //});


$(document).on('click', '.feedback_detail a.close_panel', null, function(){
    $(this).parents('.feedback_detail').first().fadeOut();
});

$(document).on('click', '.feedback_detail_link', null, function(){
  var targetSelector = $(this).data('targetSelector');
  $(targetSelector).fadeIn();
});

$(document).on('click','.comment_form span.submit', null, function(){
  if($(this).parents('form.comment_form')[0].checkValidity()){
    $(this).parents('form.comment_form').trigger('submit');

  } else {
      var form = $(this).parents('form.comment_form')[0];
      $('<input type="submit">').hide().appendTo(form).click().remove();
  }
});

$(document).on('keypress', 'form.comment_form textarea', null, function(e){
  if (e.ctrlKey && (e.keyCode == 13 || e.keyCode == 10)) {
    var form = $(this).closest('form')[0];
    $('<input type="submit">').hide().appendTo(form).click().remove();
  }
});

$(document).on('mouseenter', 'table#feedbacks tr.feedback_line', null, function(){
  //$(this).effect('highlight');
});

$(document).on('click', 'table#feedbacks tr.feedback_line', null, function(){
  var targetSelector = $(this).data('targetSelector');
  $(targetSelector).fadeIn();
});

$(document).tooltip({
  selector: "a[data-toggle=tooltip]"
})

// $(document).on("ajax:success", "a", function(event, result, status, xhr){
//   console.log('event');
//   console.log(event);
//
//   if(result.success){
//     if(result.action == 'archive' || result.action == 'destroy'){
//       process_destroy_ajax_return(result);
//     }
//   }
// });

//
// $( document ).ajaxComplete(function(event,jqXHR, options) {
//   console.log(jqXHR);
// });
