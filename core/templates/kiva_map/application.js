var $$data;
var $$map;
var $$markers = {};
var $$markersIcon = {
  'fundraising': "green_marker.png",
  'funded': "blue_marker.png",
  'in_repayment': "yellow_marker.png",
  'paid': "orange_marker.png"
}

function initialize(data) {
  $$data = data;
  google.load('maps', '2', {'callback' : mapsLoaded});   
}

function mapsLoaded() {
  if (GBrowserIsCompatible()) {
    $$map = new google.maps.Map2($('#map').get(0));
    $$map.setMapType(G_HYBRID_MAP);
    $$map.setCenter(new google.maps.LatLng(0, 0), 2);
    $$map.addControl(new GMapTypeControl());
    $$map.addControl(new GLargeMapControl());
    
    $.each($$data, function(type, points) {
      addMarkers(type, points);
    });
    showLoans('fundraising');
  };
}

function addMarkers(type, points) {
  $$markers[type] = new Array();
  var old_lat = '';
  var old_lng = '';
  var info = '';
  var first_iteration = true;
  var new_data = new Array();
  var cont = 0;
  $.each(points, function() {
    latlng = getLoanLatLng(this);
    var lat = latlng[0];
    var lng = latlng[1];
    if ((cont != 0) && (new_data[cont - 1][0] == lat && new_data[cont - 1][1] == lng)) {
      // Same coordinates
      new_data[cont - 1][2] = new_data[cont - 1][2] + createContentForSingleLoan(this);
    } else {
      // New coordinates
      new_data[cont] = new Array();
      new_data[cont][0] = lat;
      new_data[cont][1] = lng;
      new_data[cont][2] = createContentForSingleLoan(this);
      cont = cont + 1;
    }
  });
  
  // Rendering
  $.each(new_data, function() {
    var item = this;
    var point = new GLatLng(item[0], item[1]);
    var blueIcon = new GIcon(G_DEFAULT_ICON);
    var icon = new GIcon(G_DEFAULT_ICON);
    icon.image = $$markersIcon[type];
    var marker = new GMarker(point, icon);
    $$map.addOverlay(marker);
    $$markers[type].push(marker);
    GEvent.addListener(marker, 'click', function() { marker.openInfoWindowHtml('<ul class="loans">' + item[2] + '<div class="clear"></div></ul>'); });
    marker.hide();
  });
}

function getLoanLatLng(loan) {
  return loan['location']['geo']['pairs'].split(' ', 2);
}

function createContentForSingleLoan(data) {
  out =  '<li>';
  out += '  <img src="http://kiva.org/img/w80h80/' + data['image']['id'] + '.jpg"/>';
  out += '  <p class="name"><a href="http://kiva.org/app.php?page=businesses&action=about&id=' + data['id'] + '" target="_blank">' + data['name'] + '</a> &middot; <strong>$' + data['funded_amount'] + '</strong> of <strong>$' + data['loan_amount'] + '</strong></p>';
  out += '  <p class="activity">' + data['activity'] + ' (' + data['sector'] + ')</p>';
  out += '  <p class="use">' + data['use'] + '</p>';
  out += '  <div class="clear"></div>';
  out += '</li>';
  return out;
}

function showAllLoans() {
  $.each($$markers, function(type, points) {
    showLoans(type);
  });
}

function hideAllLoans() {
  $.each($$markers, function(type, points) {
    for (var i = 0; i < $$markers[type].length; i++) {
      $$markers[type][i].hide();
    };
  });
}

function showLoans(type) {
  hideAllLoans();
  for (var i = 0; i < $$markers[type].length; i++) {
    $$markers[type][i].show();
  };
}

function uncheckAllRadioInputsUnless(checkedElement) {
  $('input:checked').each(function(){
    this.checked = false;
  });
  $(checkedElement).get(0).checked = true;
}