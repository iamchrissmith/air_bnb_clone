$(document).ready(function(){
  let search_button = $('#search-button');
  let check_out = $('#check_out');
  let check_in = $('#check_in');

  check_in.on('change', function(){
    if (check_out.val() === '') {
      search_button.attr('disabled', true);
    } else {
      search_button.attr('disabled', false);
    }
  });

  check_out.on('change', function(){
    if (check_in.val() === '') {
      search_button.attr('disabled', true);
    } else {
      search_button.attr('disabled', false);
    }
  });

  //not working, not sure how to call event on disabled button
  // search_button.hover(function(){
  //   if (search_button.attr('disabled', true)) {
  //     window.alert("A check in and check out date must be selected!");
  //   }
  // });
});