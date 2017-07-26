$('form').submit(function(e) {
    e.preventDefault();
    var url = window.location.pathname;
    var property_id = url.substring(url.lastIndexOf('/') + 1);
    var valuesToSubmit = $(this).serialize();
    $.ajax({
        type: "POST",
        url: '/api/v1/properties/' + property_id + '/reservations',
        data: valuesToSubmit,
        dataType: "JSON",
        success: function(response) {
          console.log("success", response);
        },
        error: function(xhr, textStatus, errorThrown) {}
    });
});
