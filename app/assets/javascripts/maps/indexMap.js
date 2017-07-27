let map;

function indexMap() {
  var geocoder = new google.maps.Geocoder;

  map = new google.maps.Map(document.getElementById('map'), {
  });

  geocodeAddress(geocoder, map);

  // var marker = new google.maps.Marker({
  //   position: uluru,
  //   map: map
  // });
}

function geocodeAddress(geocoder, map) {
  let location = $("#location").text();

  geocoder.geocode({'placeId': "Denver"}, function(results, status) {
    debugger
    if (status === 'OK') {
      if (results[0]) {
        map.setZoom(10);
        map.setCenter(results[0].geometry.location);

        var marker = new google.maps.Marker({
          map: map,
          position: results[0].geometry.location
        });

        infowindow.setContent(results[0].formatted_address);
        infowindow.open(map, marker);

      } else {
        window.alert('No results found');
      }

    } else {
      window.alert('Geocoder failed due to: ' + status);
    }
  });
}