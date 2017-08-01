var map = L.map('mapid').setView([37.8, -96], 4);

L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw', {
  maxZoom: 18,
  attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, ' +
    '<a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
    'Imagery © <a href="http://mapbox.com">Mapbox</a>',
  id: 'mapbox.light'
}).addTo(map);


// control that shows state info on hover
var info = L.control();

info.onAdd = function (map) {
  this._div = L.DomUtil.create('div', 'info');
  this.update();
  return this._div;
};

info.update = function (props) {
  this._div.innerHTML = '<h4>Properties By State</h4>' +  (props ?
    '<b>' + props.name + '</b><br />' + props.density + ' properties'
    : 'Hover over a state');
};

info.addTo(map);

// get color depending on population density value
function getColor(d) {
  return d > 1000 ? '#800026' :
      d > 500  ? '#BD0026' :
      d > 200  ? '#E31A1C' :
      d > 100  ? '#FC4E2A' :
      d > 50   ? '#FD8D3C' :
      d > 20   ? '#FEB24C' :
      d > 10   ? '#FED976' :
            '#FFEDA0';
}

function style(feature) {
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

var geojson;

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

var propertyData1 = [ {state: "WY", total: 0}, {state:"CO", total:1000} ];
var updateStatesData = function (data) {
  for(var i = 0, len = statesData.features.length; i < len; i++) {
    let state = statesData.features[i].properties;
    for(var j = 0, dataLen = data.length; j < dataLen; j++) {
      let property = data[j];
      // console.log(property.state, state.name)
      if (state_keys[property.state] === state.name) {
        state.density = property.total;
      }
    }
  }
  return statesData;
}

const loadGeodata = function(data){
  geojson = L.geoJson(updateStatesData(data), {
    style: style,
    onEachFeature: onEachFeature
  }).addTo(map);
}
const getPropertiesByState = function() {
  $.ajax({
    method: 'GET',
    url: '/api/v1/properties/by_state',
    success: function(response){
      loadGeodata(response);
    },
    errors: function(xhr, textStatus, errorThrown){
      console.log(xhr, textStatus, errorThrown)
    }
  });
}
getPropertiesByState();

var legend = L.control({position: 'bottomright'});

legend.onAdd = function (map) {

  var div = L.DomUtil.create('div', 'info legend'),
    grades = [0, 10, 20, 50, 100, 200, 500, 1000],
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

$('#reset_map_zoom').on('click', function(ev) {
  ev.preventDefault();
  map.setView([37.8, -96], 4)
});
$('#revenue_per_night').on('click', function(ev){
  ev.preventDefault();

  geojson.remove();
  loadGeodata(propertyData1);
});
$('#properties_by_state').on('click', function(ev){
  ev.preventDefault();

  geojson.remove();
  getPropertiesByState();
});
