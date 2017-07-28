function homeSearch() {
  var input = document.getElementById('place_search');
  var autocomplete = new google.maps.places.Autocomplete(input);

  autocomplete.addListener('place_changed', function() {
    var place = autocomplete.getPlace();
    sessionStorage.setItem('place', place.formatted_address );
    $('#search-button').click();
  });
}