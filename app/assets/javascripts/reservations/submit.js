$(document).ready(function() {

  jQuery.validator.addMethod("greaterThan",
  function(value, element, params) {
    if (params == 'today') {
      compareTo = new Date();
    } else {
      compareTo = $(params).val();
    }
    console.log("Value: "+value);
    console.log("Compare: "+compareTo);
    if (!/Invalid|NaN/.test(new Date(value))) {
        return new Date(value) > new Date(compareTo);
    }

    return isNaN(value) && isNaN(compareTo) || (Number(value) > Number(compareTo));
  },'Must be greater than {0}.');

  function successfulReservation (response) {
    $('.booking-box form').remove();
    $('#reservation-success-message').show();
    $('#res-id').append(" "+response.reservation.id)
  }

  $('.booking-box form').validate({
    submitHandler: function(form, e) {
      e.preventDefault();
      var url = window.location.pathname;
      var property_id = url.substring(url.lastIndexOf('/') + 1);
      var valuesToSubmit = $(form).serialize();
      $.ajax({
          type: "POST",
          url: '/api/v1/properties/' + property_id + '/reservations',
          data: valuesToSubmit,
          dataType: "JSON",
          success: function(response) {
            successfulReservation(response)
          },
          error: function(xhr, textStatus, errorThrown) {}
      });
    }
  });
  $('#reservation_start_date').rules("add", {
    required: true,
    greaterThan: 'today',
    messages: {
      greaterThan: "Start Date must be after today"
    }
  });
  $('#reservation_end_date').rules("add", {
    required: true,
    greaterThan: '#reservation_start_date',
    messages: {
      greaterThan: "End Date must be after Start Date"
    }
  });
});
