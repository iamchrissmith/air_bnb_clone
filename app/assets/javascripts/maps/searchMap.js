let map;

// Main GoogleMap.js API callback function

function searchMap() {

  persistSearchData();
  placeAutoComplete();
  dateRangePicker();
  searchListener();

  map = new google.maps.Map(document.getElementById('map'), {
  });
};

// Functions

// Populates search fields if they exist in the session

const persistSearchData = function() {
  if (sessionStorage.place) { $('#place_search').val(sessionStorage.place) };
  if (sessionStorage.guests) { $('#guests').val(sessionStorage.guests) };
  if (sessionStorage.check_in) { $('#date_range').val(sessionStorage.check_in) };
};

// Autocompletes location search input

const placeAutoComplete = function() {
  let place_search = document.getElementById('place_search');
  let autocomplete = new google.maps.places.Autocomplete(place_search);

  autocomplete.addListener('place_changed', function() {
    let place = autocomplete.getPlace();

    sessionStorage.setItem('place', place.formatted_address );
    $('#search-button').click();
  });
};

// Date range picker

const dateRangePicker = function() {
  $('input[name="date_range"]').daterangepicker({
    "startDate": sessionStorage.date_range.split(' - ')[0],
    "endDate": sessionStorage.date_range.split(' - ')[1]
  });
};

// Listeners for search updates

const searchListener = function() {
  let guests = document.getElementById('guests');

  guests.addEventListener('change', function() {
    sessionStorage.setItem('guests', guests.value);
    $('#search-button').click();
  });

  $('input[name="date_range"]').on('apply.daterangepicker', function() {
    let date = document.getElementById('date_range');

    sessionStorage.setItem('date_range', date.value);
    $('#search-button').click();
  });
};

