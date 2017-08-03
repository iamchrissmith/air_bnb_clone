const map = L.map('mapid').setView([37.8, -96], 4);

const buildMap = () => {
  L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw', {
    maxZoom: 18,
    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, ' +
      '<a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
      'Imagery © <a href="http://mapbox.com">Mapbox</a>',
    id: 'mapbox.light'
  }).addTo(map);

}

var geojson;

let custom_grades = [0, 1, 2, 5, 10, 20, 50, 100];

const getColor = (d) => {
  return d > custom_grades[7] ? '#800026' :
      d > custom_grades[6] ? '#BD0026'    :
      d > custom_grades[5] ? '#E31A1C'    :
      d > custom_grades[4] ? '#FC4E2A'    :
      d > custom_grades[3] ? '#FD8D3C'    :
      d > custom_grades[2] ? '#FEB24C'    :
      d > custom_grades[1] ? '#FED976'    :
            '#FFEDA0';
}

let legend;

const addLegendtoMap = () => {
  legend = L.control({position: 'bottomright'});

  legend.onAdd = function (map) {
    var div = L.DomUtil.create('div', 'info legend'),
      grades = custom_grades,
      labels = [],
      from, to;

    for (var i = 0; i < grades.length; i++) {
      from = grades[i];
      to = grades[i + 1];

      labels.push(
        '<i style="background:' + getColor(from + 1) + '"></i> ' +
        from + (to ? '&ndash;' + to : '+'));
    }

    div.innerHTML = labels.join('<br>');
    return div;
  };

  legend.addTo(map);
}

const setBounds = (results) => {
  let low = Number.POSITIVE_INFINITY;
  let high = Number.NEGATIVE_INFINITY;
  let tmp;
  for (let i=results.length-1; i>=0; i--) {
      tmp = parseFloat(results[i].total);
      if (tmp < low) low = tmp;
      if (tmp > high) high = tmp;
  }
  return [high, low]
}

const setGrades = (results) => {
  let [high, low] = setBounds(results);
  const difference = high - low;
  custom_grades = [0, 1, 2, 5, 10, 20, 50, 100];
  const golden_ratio = 1.61803398875;

  while (high > (custom_grades[custom_grades.length - 1] * golden_ratio)) {
    custom_grades = custom_grades.map( (x) => x * 2 );
  }
  addLegendtoMap();
}

const updateStatesData = (data) => {
  setGrades(data);
  for(var i = 0, len = statesData.features.length; i < len; i++) {
    let state = statesData.features[i].properties;
    for(var j = 0, dataLen = data.length; j < dataLen; j++) {
      let property = data[j];
      if (state_keys[property.state] === state.name) {
        state.density = property.total;
      }
    }
  }
  return statesData;
}

const info = L.control();

const buildInfo = (label, currency = '', data_label = label) => {

  info.onAdd = function (map) {
    this._div = L.DomUtil.create('div', 'info');
    this.update();
    return this._div;
  };

  info.update = function (props) {
    this._div.innerHTML = '<h4>'+ label +' By State</h4>' +  (props ?
      '<b>' + props.name + '</b><br />' + currency + props.density + ' ' + data_label
      : 'Hover over a state');
  };

  info.addTo(map);
}


const style = (feature) => {
  return {
    weight: 2,
    opacity: 1,
    color: 'white',
    dashArray: '3',
    fillOpacity: 0.7,
    fillColor: getColor(feature.properties.density)
  };
}

function highlightFeature(e) {
  var layer = e.target;

  layer.setStyle({
    weight: 5,
    color: '#666',
    dashArray: '',
    fillOpacity: 0.7
  });

  if (!L.Browser.ie && !L.Browser.opera && !L.Browser.edge) {
    layer.bringToFront();
  }

  info.update(layer.feature.properties);
}

function resetHighlight(e) {
  geojson.resetStyle(e.target);
  info.update();
}

function zoomToFeature(e) {
  map.fitBounds(e.target.getBounds());
}

function onEachFeature(feature, layer) {
  layer.on({
    mouseover: highlightFeature,
    mouseout: resetHighlight,
    click: zoomToFeature
  });
}

const loadGeodata = function(data){
  geojson = L.geoJson(updateStatesData(data), {
    style: style,
    onEachFeature: onEachFeature
  }).addTo(map);
}

const getRevenueByState = function() {
  $.ajax({
    method: 'GET',
    url: '/api/v1/reservations/revenue_by_state',
    success: function(response){
      loadGeodata(response.results);
      buildInfo('Revenue', '$', '');
    },
    errors: function(xhr, textStatus, errorThrown){
      console.log(xhr, textStatus, errorThrown)
    }
  });
}

const getPropertiesByState = function() {
  $.ajax({
    method: 'GET',
    url: '/api/v1/properties/by_state',
    success: function(response){
      loadGeodata(response.results);
      buildInfo('Properties');
    },
    errors: function(xhr, textStatus, errorThrown){
      console.log(xhr, textStatus, errorThrown)
    }
  });
}

$(document).ready( () => {
  buildMap();
  getPropertiesByState();

  $('#reset_map_zoom').on('click', function(ev) {
    ev.preventDefault();
    map.setView([37.8, -96], 4)
  });
  $('#revenue_by_state').on('click', function(ev){
    ev.preventDefault();

    geojson.remove();
    legend.remove();
    getRevenueByState();
  });
  $('#properties_by_state').on('click', function(ev){
    ev.preventDefault();

    geojson.remove();
    legend.remove();
    getPropertiesByState();
  });
});
