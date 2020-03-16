'use strict';

var docID;
var rowIndex;

// Code Mirror Config
var cm = CodeMirror.fromTextArea(document.getElementById("txt-locate"), {
  mode: "twig",
  lineNumbers: false,
  lineWrapping: false,
  indentWithTabs: false,
  smartIndent: false,
  autofocus: true
});

cm.setSize(null, 100);

//Add text to locate formular
function cm_add(cm, col, newText) {
  var doc = cm.getDoc();
  var cursor = doc.getCursor();
  doc.replaceRange('{{' + col + '.' + newText + '}}', cursor);
}

function responseAdd($frm, response) {
  var html = '<tr data-id="' + response['id'] + '">';
  $.each(response.fields, function (key, value) {
    html += '<td class="ui-resizable">' + value + '</td>';
  });

  $('.table > tbody > tr:first').before(html + '</tr>');
}

function responseEdit($frm, response) {
  var $row = $('.table > tbody > tr:eq(' + $('#txt-selected').val() + ')');
  var n = 2;
  $.each(response['row'], function (key, value) {
    $row.find('td:nth-child(' + n + ')').text(value);
    n++;
  });
}

function responseRemove($frm, response) {
  var $row = $('.table > tbody > tr:eq(' + $('.txt-selected').val() + ')');
  $row.remove();
}

function responseRefresh($frm, response) {
  var $table = $("table.table");
  var tr = '';
  $table.find("tbody tr").remove();
  $.each(response['results'], function (r, row) {
    tr = '<tr data-id=' + row.item_id + '>';
    $.each(row, function (c, col) {
      tr += '<td>' + col + '</td>';
    });
    tr += '</tr>';
    $table.find('tbody').append(tr);
  });
}

function getColumns() {
  var columns = [];
  $('.table th').each(function () {
    columns.push({
      'id': $(this).attr('data-field'),
      'label': $(this).find('a').text(),
      'type': 'string'
    });
  });
  return columns;
}

//locate dialog, populate items selectpicker control from table headings
function populateSelectItems(cntrl) {
  //exclude columns
  var ex = Array('item_id', 'document_id', 'lat', 'lng');

  //remove any options
  cntrl.find('option').remove().end();

  //for each table header
  $(".table th").each(function () {

    var th = $(this).attr('data-field');

    if ($.inArray(th, ex) == -1) {
      cntrl.append('<option value="' + th + '">' + $(this).find('a').text() + '</option>');
    }
  });

  cntrl.selectpicker("refresh");
}

//locate dialog, populate documents selectpicker control with document data
function populateSelectDocs(cntrl) {

  var docID = $('.table td:eq(1)').text().trim();

  cntrl.find('option').remove().end();

  $.ajax({
    method: 'GET',
    url: 'documents/' + docID
  }).done(function (r) {
    $.each(r['doc']['meta'], function (key, value) {
      cntrl.append('<option value="' + value.name + '">' + value.name.replace('document_', '') + '</option>');
    });
    $('#sel-locate-docs').selectpicker("refresh");
  });
}

$(function () {

  //Pagination page click
  $('.pagination a').on('click', function (e) {
    alertSpin();
    $.ajax({
      method: 'GET',
      url: 'results/result?page=' + $(e.target).text()
    }).done(function (r) {
      $('table.table').html(r['content']);
      $('.table td').resizable();
      alertResponse(r);
    });
  });

  //Submit filter form
  $('#btn-filter').click(function () {
    var result = $('#builder').queryBuilder('getRules');
    if (!$.isEmptyObject(result)) {
      $.ajax({
        method: 'POST',
        url: 'results/filter',
        data: JSON.stringify(result, null, 2),
        contentType: "application/json; charset=utf-8",
        dataType: "json"
      }).done(function (r) {
        alertMessage(r);
        if (r['code'] == 200) {
          responseRefresh(r);
        }
      });
    }
  });

  //Post location -> lat/long for each row
  $('#btn-locate-ok').on('click', function () {
    $.ajax({
      method: 'POST',
      url: 'results/locate?code=' + cm.getValue()
    }).done(function (r) {
      alertResponse(r);
    });
  });

  //Locate, add selectpicker to location formular
  $(".btn-locate").on('click', function () {
    var $btn = $(this);
    //selected item
    var sel = $btn.parent('div').parent('div.row').find('.selectpicker').val();
    //add it at cursor
    cm_add(cm, $btn.attr('data-source'), sel);
  });

  //Export - Solr/Sheets/DB
  $('.btn-export').click(function (e) {
    $.ajax({
      method: 'GET',
      url: $(this).attr('href')
    }).done(function (r) {
      alertResponse(r);
    });
  });

  //Set up document dialog
  $('.document-id').click(function (e) {

    var $doc = $(this);

    var $modalBody = $('#mdl-document').find('.modal-body');

    $modalBody.html('');

    $.ajax({
      method: 'GET',
      url: $doc.attr('href')
    }).done(function (r) {

      $.each(r['doc']['meta'], function (key, value) {
        console.log(value.value);
        var html = '<div class="form-group">' + '<label for="name" style="text-transform: capitalize">' + value.name.replace('_', ' ') + '</label>' + '<input type="text" class="form-control" readonly value="' + value.value + '">' + '</div>';

        $modalBody.append(html);
      });
    });
  });

  //Show edit modal, populate fields
  $('#mdl-edit').on('shown.bs.modal', function () {
    var $row = $('table.table tr[data-id="' + $('.txt-selected').val() + '"]').find('td');
    $row.each(function (index) {
      var col = $('table.table th:eq(' + index + ')').attr('data-field');
      $('#mdl-edit .txt-' + col).val($(this).text().trim());
    });
  });

  //Filter modal show (populate selects)
  $('#mdl-filter').on('shown.bs.modal', function () {
    $('#builder').queryBuilder({
      "filters": getColumns()
    });
    $('#builder').removeClass('form-inline');
  });

  //Show location modal (populate selects)
  $("#mdl-locate").on('shown.bs.modal', function () {

    populateSelectItems($('#sel-locate-item'));

    populateSelectDocs($('#sel-locate-docs'));
  });
});
//# sourceMappingURL=results.js.map
//# sourceMappingURL=results.js.map
