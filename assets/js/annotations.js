"use strict";

function responseAdd($frm, resp) {

  if (resp['code'] == 200) {

    var html = '<tr data-id="' + resp['annotation']['id'] + '">' + '<td>' + $frm.find("[name=title]").val() + '</td>' + '<td>' + resp['annotation']['name'] + '</td>' + '<td>' + resp['annotation']['multi'] + '</td>' + '</tr>';

    $('table.table tr:last').after(html);

    $('#txt-annotation-label').val('');
  }
}

function responseRemove($frm, resp) {

  if (resp['code'] == 200) {

    $('tr[data-id="' + $('.txt-selected').val() + '"]').remove();
  }
}

$(function () {

  $('table.table').on('click', 'tr', function () {

    var $frm = $("button.item-selected").parent('form');

    $frm.attr('action', '/annotations/' + $(this).attr('data-id'));
  });
});
//# sourceMappingURL=annotations.js.map
