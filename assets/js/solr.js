'use strict';

var ItemMap = {
  bounds: null,
  map: null
};

var Grid = {
  table: null
};

var map;

ItemMap.init = function (selector, center, zoom, usr, pwd) {
  var map_options = {
    zoom: zoom,
    center: center,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  this.map = new google.maps.Map($(selector)[0], map_options);
  this.bounds = new google.maps.LatLngBounds();
  this.usr = usr;
  this.pwd = pwd;

  map = this.map;
};

ItemMap.draw = function (data) {
  $(data).each(function (key, doc) {

    var lat = parseFloat(doc['lat']);
    var lng = parseFloat(doc['lng']);
    var p = new google.maps.LatLng(lat, lng);

    ItemMap.bounds.extend(p);

    var m = ItemMap.mark(p);
    var infoWindow = new google.maps.InfoWindow();
    var html = '<h4>' + doc['address'] + '</h4>';
    var ex = ["item_id", "document_id", "lat", "lng", "_version_", "latlong"];

    $.each(doc, function (k, v) {
      if ($.inArray(k, ex) == -1) {
        html += '<p>' + k + ': ' + v + '</p>';
      }
    });

    google.maps.event.addListener(m, 'click', function () {
      infoWindow.setContent(html);
      infoWindow.open(ItemMap.map, m);
    });

    var center = new google.maps.LatLng(lat, lng);
    map.panTo(center);
  });
};

ItemMap.mark = function (p) {
  return new google.maps.Marker({
    position: p,
    map: ItemMap.map
  });
};

Grid.init = function (table) {
  this.table = table;
};

Grid.draw = function (data) {
  var ex = ["_version_", "latlong", "id", "item_id", "document_id"];
  var html = '<thead><tr>';

  $.each(data[0], function (k, v) {
    if ($.inArray(k, ex) == -1) {
      html += '<th>' + k + '</th>';
    }
  });

  html += '</tr></thead><tbody>';

  $(data).each(function (key, doc) {
    html += '<tr>';
    $.each(doc, function (k, v) {
      if ($.inArray(k, ex) == -1) {
        html += '<td>' + v + '</td>';
      }
    });
    html += '</tr>';
  });

  html += '</tbody>';

  this.table.append(html);
};

//Dropzone.autoDiscover = false;

$(function () {

  $(document).ready(function () {
    selectNavItem('solr');
  });

  if ($('#map').length) {
    var center = new google.maps.LatLng($('#maps-lat').val(), $('#maps-lng').val());

    ItemMap.init('#map', center, 6);

    Grid.init($('#solr-table table'));

    //Solr Markers
    $.ajax({
      url: $('#solr-url').val() + $('#solr-core').val() + '/select?',
      data: 'q=*:*&d=20&rows=1000&start=0&fq={!geofilt sfield=latlong}&pt=' + $('#maps-lat').val() + ',' + $('#maps-lng').val() + '&d=100',
      dataType: 'jsonp',
      headers: {
        "Authorization": "Basic " + btoa($('#solr-usr').val() + ':' + $('#solr-pwd').val())
      }
    }).done(function (r) {
      var docs = r['response']['docs'];
      ItemMap.draw(docs);
      Grid.draw(docs);
    });
  }

  $('#btn-view').on('click', function () {
    $('.page-view').toggle();
    $(this).find('span').toggleClass('fa-map');
    $(this).find('span').toggleClass('fa-table');
  });

  $('#btn-import').on('click', function () {
    document.location = '/solr/import';
  });

  $('#btn-search').on('click', function () {
    document.location = '/solr/';
  });

  $('#uploads').on('click', '#btn-new', function () {
    document.location = '/solr/import';
  });

  $('.show-detail').on('click', function () {
    $(this).text($(this).text() == "Show" ? "Hide" : "Show");
  });

  $('#btn-help').on('click', function () {
    $('div.import-help').toggle();
  });

  $('#btn-columns').on('click', function () {
    $('#ul-columns').toggle();
  });
  function toggleHelp() {
    $('#upload').hide();
    $('p.import-help').hide();
  }
  /*
    $("body").dropzone({
      url: '/solr/import',
      maxFilesize: 2,
      maxFiles: 1,
      acceptedFiles: '.csv',
      previewsContainer: "#uploads",
      clickable: "#upload",
      paramName: "file",
  
      sending: function sending(xhr, frmData) {
        console.log(frmData);
        toggleHelp();
      },
  
      success: function success(file, response) {
        console.log(response);
        if (response['status'] !== 'danger') {
  
          var successMsg = '<div class="text-success">' + response['msg'] + '</div>';
          var newUpload = '<div><button id="btn-new" class="btn btn-success" type="button">New Upload</button>';
  
          $('div.dz-success-mark').append(successMsg).append(newUpload).fadeIn('slow');
        } else {
  
          showError(response);
        }
      },
      error: function error(file, response) {
        showError(response);
      }
    });
  */
  function showError(response) {
    console.log(response);
    toggleHelp();
    $('div.dz-error-mark').fadeIn('slow');
    if (response['msg']) {
      $('div.dz-error-message  span').html(response['msg']);
    } else {
      $('div.dz-error-message  span').html(response);
    }
    $('div.dz-error-mark').prepend('<div class="dz-error-link"><a href="/solr/import" class="btn btn-danger" title="Back">Start Again</a></div>');
  }
});
//# sourceMappingURL=solr.js.map
//# sourceMappingURL=solr.js.map
//# sourceMappingURL=solr.js.map
