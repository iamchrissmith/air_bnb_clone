let map;

// Populates search fields if they exist in the session

function persistSearchData() {
  if (!sessionStorage.guests) { sessionStorage.setItem('guests', 1) }

  if (sessionStorage.place) { $('#location').val(sessionStorage.place) };
  if (sessionStorage.guests) { $('#guests').val(sessionStorage.guests) };
};

// Autocompletes location search input

function placeAutoComplete() {
  let location = document.getElementById('location');
  let options = {
    types: ['(cities)']
  }

  let autocomplete = new google.maps.places.Autocomplete(location, options);

  autocomplete.addListener('place_changed', function() {
    let place = autocomplete.getPlace();

    sessionStorage.setItem('place', place.formatted_address );
    searchMap();
  });
};

// Date range picker

function dateRangePicker() {
  if (sessionStorage.date_range) {
    $('input[name="date_range"]').daterangepicker({
      "startDate": sessionStorage.date_range.split(' - ')[0],
      "endDate": sessionStorage.date_range.split(' - ')[1]
    });
  } else {
    $('input[name="date_range"]').daterangepicker();
  };

  $('input[name="date_range"]').on('apply.daterangepicker', function() {
    let date = document.getElementById('date_range');

    sessionStorage.setItem('date_range', date.value);
    searchMap();
  });

  $('input[name="date_range"]').on('hide.daterangepicker', function() {
    let date = document.getElementById('date_range');

    sessionStorage.setItem('date_range', date.value);
    searchMap();
  });
};

// Listeners for search updates

function guestListener() {
  let guests = document.getElementById('guests');

  guests.addEventListener('change', function() {
    sessionStorage.setItem('guests', guests.value);
    searchMap();
  });
};

// Property search and map location are based on a geocoded result from the
// autocomplete place field. Geocoder wraps map and ajax call so they have
// access to the geocoded results

function initializeGeocoder() {
  let geocoder = new google.maps.Geocoder();

  let address = document.getElementById('location').value;
  geocoder.geocode( { 'address': address }, function(results, status) {
    initializeMap(results[0].geometry.location);
    initializeProperties(results[0].geometry.location);
  });
}

// Googlemap initializer

function initializeMap(mapCenter) {
  map = new google.maps.Map(document.getElementById('map'), {
    center: mapCenter,
    mapTypeId: 'roadmap',
    zoom: 10
  });
}

// Properties initializer

function initializeProperties(mapCenter) {


  let dateRange = document.getElementById('date_range').value;
  let guests = document.getElementById('guests').value;

  let properties = $.get("/api/v1/properties/search", {
    location: {lat: mapCenter.lat(), long: mapCenter.lng(), radius: 25 },
    dates: dateRange,
    guests: guests }, makeProperties
  );

  function makeProperties(data) {
    clearProperties();

    // Build property cards, stick them in property frame, and add Listeners
    // for when a user clicks on the property-card
    data.forEach(function(datum){
      $('.property-frame').append(propertyCard(datum));
      $('#property' + datum.id).on('click', function(){
        window.location.href = ('/properties/' + datum.id)
      });
    });

    let defaultIcon = {
          url: 'property-map-icon.png',
          // This marker is 35 pixels wide by 35 pixels high.
          size: new google.maps.Size(50, 30),
          // The origin for this image is (0, 0).
          origin: new google.maps.Point(0, 0),
          // The anchor for this image is the base of the flagpole at (0, 32).
          anchor: new google.maps.Point(0, 32)
        };

    let highlightIcon = {
          url: 'property-map-icon-highlight.png',
          // This marker is 35 pixels wide by 35 pixels high.
          size: new google.maps.Size(50, 30),
          // The origin for this image is (0, 0).
          origin: new google.maps.Point(0, 0),
          // The anchor for this image is the base of the flagpole at (0, 32).
          anchor: new google.maps.Point(0, 32)
        };

    // Build markers to place on map
    let markers = data.map(function(datum) {
      return new google.maps.Marker({
        position: {lat: datum.lat, lng: datum.long},
        customInfo: propertyCard(datum),
        id: datum.id,
        data_object: datum,
        icon: defaultIcon,
        label: {
          text: '$' + datum.price_per_night,
          fontSize: "10px",
        }
      });
    });

    // Add markers to the map
    markers.forEach(function(marker) {
      marker.setMap(map);
    });

    let infoWindow = new google.maps.InfoWindow()

    // Give each marker a listener to open infoWindow when clicked
    markers.forEach(function(marker) {
      google.maps.event.addListener(marker, 'click', function() {
        infoWindow.setContent(this.customInfo)
        infoWindow.open(map, marker);

        $('#property' + marker.id).on('click', function(){
          window.location.href = ('/properties/' + marker.id)
        });
      });
    }, this);

    markers.forEach(function(marker) {
      $('#property' + marker.id).hover(function(){
        marker.setIcon(highlightIcon)
      }, function(){
        marker.setIcon(defaultIcon)
      });
    });
  };
}

// Clears all properties from the view.

function clearProperties() {
  $('.property-frame').empty();
}

// Main page function called in googlemap API request. Sort of like refreshing
// the page except you're not refreshing the page.

function searchMap() {
  persistSearchData();

  dateRangePicker();
  guestListener();
  placeAutoComplete();

  initializeGeocoder();
};

const propertyCard = function(datum) {
  return `
  <div class='property-card' id='property${datum.id}'>
    <img src='${datum.image_url}'>
    <div class='info'>
      <h3>From $${datum.price_per_night} - ${datum.description}</h3>
      <span>${datum.number_of_beds} Beds
    </div>
  </div>
  `
};