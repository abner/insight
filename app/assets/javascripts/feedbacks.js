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
   }
});

// $('a').on('ajax:error', function(xhr, status, error) {
//   // insert the failure message inside the "#account_settings" element
//   console.log(error);
// });

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
