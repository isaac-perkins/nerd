'use strict';

// Add new job table

function responseAdd($frm, resp) {

  var html = '<tr data-id="' + resp['job']['id'] + '">' + '<td>' + resp['job']['title'] + '</td>' + '<td>' + resp['job']['description'] + '</td>' + '<td>' + '<span class="fa fa-sm fa-link">0</span>' + '<span class="fa fa-sm fa-tag pl-2">0</span>' + '</td>' + '</tr>';

  $('table.table tr:last').after(html);

  $('#mdl-add').modal('hide');
}

function responseRemove($frm, resp) {

  if (resp['code'] == 200) {

    $('tr[data-id="' + $('.txt-selected').val() + '"]').remove();

    $('#mdl-remove').modal('hide');
  }
}

$(function () {

  //Show Jobs Nav Item
  $(document).ready(function () {
    selectNavItem('jobs');
  });

  //Modal remove show - set title textbox value
  $('#mdl-remove').on('show.bs.modal', function (e) {

    var selectedID = $('.txt-selected').val();

    $("#mdl-remove").find('form').attr('action', '/jobs/' + selectedID);

    var row = $("table").find('[data-id="' + selectedID + '"]');

    $('#txt-title').val(row.find('td:first').text());
  });

  $('.navigate').click(function () {
    document.location = '/jobs/' + $('.txt-selected').val() + '/' + $(this).attr('data-navigate');
  });
});
/*
//jobs list table click
$('tr').on('click', function () {

  $('tr').css('background-color', '#fff');
  $(this).css('background-color', '#f5f5f5');

  $('.item-trained').attr('disabled', 'disabled');

  $('#txt-job').val($(this).attr('data-id'));

  //$('#txt-cron').val($(this).attr('data-cron'));

  //var cp = $('#txt-cron');

  //cp.cronPicker();
  //cp.cronPicker()
  //cp.setCronExpression($(this).attr('data-cron'));

  $("#toolbar button.job-selected").removeAttr('disabled');

  var status = $(this).find('td:last').html().trim();

  if (status == 'Built') {
    $('.item-trained').removeAttr('disabled');
  }

  //if (status == 'Training') {
  //  $('#btn-start').removeAttr('disabled');
  //}
});
  $('form[name="schedule"]').on('submit', function (e) {
    e.preventDefault();
    var $f = $(this);
    alertSpin();
    $.ajax({
      type: 'post',
      url: '/jobs/' + $('#txt-job').val() + '/schedule',
      data: '{"cron": "' + $('#txt-cron').val() + '"}'
    }).done(function (r) {
      alertResponse(r);
      console.log(r);
    });
  });

  $('form[name="schedule"]').on('submit', function (e) {
    e.preventDefault();
    console.log($('#txt-cron').val());

    $.ajax({
        method: 'POST',
        url: $('#frm-edit-job').attr('action'),
        data: JSON.stringify($.extend($('#frm-edit-job').serializeFormJSON(), jobCrawl)),
        contentType: "application/json",
        dataType: "json",
        headers: {
          'Accept': 'application/json'
      }
    }).done(function(r) {
         if (r['status'] == 'success') {
          document.location = '/jobs/list';
        }
     }).fail(function(r) {
         console.log('erorr'); console.log(r);
     });

  });
*/
//# sourceMappingURL=jobs.js.map
//# sourceMappingURL=jobs.js.map
//# sourceMappingURL=jobs.js.map
