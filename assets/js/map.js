'use strict';

// http://articles.sitepoint.com/article/google-maps-api-jquery

var ItemMap = {
  bounds: null,
  map: null
};
var map;

ItemMap.init = function (selector, center, zoom) {
  var map_options = {
    zoom: zoom,
    center: center,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  this.map = new google.maps.Map($(selector)[0], map_options);
  this.bounds = new google.maps.LatLngBounds();
  map = this.map;
};

ItemMap.draw = function (data) {
  $.get(data, function (xml) {
    //console.log(xml);
    $(xml).find('marker').each(function () {

      var lat = parseFloat($(this).find('lat').text());
      var lng = parseFloat($(this).find('lng').text());

      var p = new google.maps.LatLng(lat, lng);

      // Extend the bounds to include the new point
      ItemMap.bounds.extend(p);

      var m = ItemMap.mark(p);

      // Create the tooltip and its text
      var infoWindow = new google.maps.InfoWindow();

      //echo this;
      var html = '<h4>' + $(this).find('address').text() + '</h4>';
      var ex = ["ITEM_ID", "DOCUMENT_ID", "LNG", "LAT"];

      $(this).children().each(function (key, value) {
        //tag name
        var t = $(value).prop("tagName");
        //exclude value
        if ($.inArray(t, ex) == -1) {
          html += '<p>' + t + ': ' + $(value).text() + '</p>';
        }
      });

      // Add a listener
      google.maps.event.addListener(m, 'click', function () {
        infoWindow.setContent(html);
        infoWindow.open(ItemMap.map, m);
      });

      /*
      var circle = new google.maps.Circle({
            radius: 70*1000,
            center: point,
            map: ItemMap.map,
            fillColor: '#FF0000',
            fillOpacity: 0.2,
            strokeColor: '#FF0000',
            strokeOpacity: 0.6
      });
      */
      var center = new google.maps.LatLng(lat, lng);
      // using global variable:
      map.panTo(center);
    });
  });

  // Fit the map around the markers we added:
  //ItemMap.map.fitBounds(ItemMap.bounds);
};

ItemMap.mark = function (p) {
  // Add the marker itself
  return new google.maps.Marker({
    position: p,
    map: ItemMap.map
  });
};
//# sourceMappingURL=map.js.map
//# sourceMappingURL=map.js.map
//# sourceMappingURL=map.js.map
