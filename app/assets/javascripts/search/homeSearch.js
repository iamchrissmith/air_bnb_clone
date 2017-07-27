function homeSearch() {
  var input = document.getElementById('place_search');
  var autocomplete = new google.maps.places.Autocomplete(input);

  autocomplete.addListener('place_changed', function() {
    var place = autocomplete.getPlace();
    $('#search-button').click();
  });
}