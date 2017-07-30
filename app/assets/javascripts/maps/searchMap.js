let map;

// Populates search fields if they exist in the session

function persistSearchData() {
  if (sessionStorage.place) { $('#location').val(sessionStorage.place) };
  if (sessionStorage.guests) { $('#guests').val(sessionStorage.guests) };
};

// Autocompletes location search input

function placeAutoComplete() {
  let location = document.getElementById('location');
  let autocomplete = new google.maps.places.Autocomplete(location);

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
  let properties = $.get("/api/v1/properties/search", {
    lat: mapCenter.lat(),
    long: mapCenter.lng(),
    radius: 25 }, makeProperties
  );

  function makeProperties(data) {
    // Finally! I can make property objects!!!
  }
}

// Function called in googlemap API request

function searchMap() {
  persistSearchData();

  dateRangePicker();
  guestListener();
  placeAutoComplete();

  initializeGeocoder();
};