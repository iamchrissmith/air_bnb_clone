let map;
let addressCoords;
let geocoder;
let address;

// Populates search fields if they exist in the session

function persistSearchData() {
  if (sessionStorage.place) { $('#place_search').val(sessionStorage.place) };
  if (sessionStorage.guests) { $('#guests').val(sessionStorage.guests) };
};

// Autocompletes location search input

function placeAutoComplete() {
  let place_search = document.getElementById('place_search');
  let autocomplete = new google.maps.places.Autocomplete(place_search);

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

// Main GoogleMap.js API callback function

function searchMap() {
  geocoder = new google.maps.Geocoder();

  persistSearchData();
  placeAutoComplete();
  dateRangePicker();
  guestListener();

  address = $('#place_search').val();

  geocoder.geocode( { 'address': address }, function(results, status) {
    map = new google.maps.Map(document.getElementById('map'), {
      center: results[0].geometry.location,
      mapTypeId: 'roadmap',
      zoom: 10
    });
  });

  let properties = $.get("/api/v1/properties/properties", { city: address } );
};