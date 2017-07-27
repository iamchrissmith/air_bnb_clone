let map;

function searchMap() {
  var geocoder = new google.maps.Geocoder;

  map = new google.maps.Map(document.getElementById('map'), {
  });

  var input = document.getElementById('place_search');
  var autocomplete = new google.maps.places.Autocomplete(input);

  autocomplete.addListener('place_changed', function() {
    var place = autocomplete.getPlace();
    $('#search-button').click();
  });
}