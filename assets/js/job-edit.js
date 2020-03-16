'use strict';

//Get control from grand pa's data attributes

function get_select_control($this) {
  return get_tab_group($this) + '-' + get_form_group($this);
}

function get_form_group($btn) {
  return $btn.closest('[data-fg]').attr('data-fg');
}

function get_tab_group($btn) {
  return $btn.closest('[data-bd]').attr('data-bd');
}

$(function () {

  var selectedUrl = 0;

  $(document).ready(function () {
    selectNavItem('jobs');
  });

  $('input[type="checkbox"]').on('click', function () {
    var dt = '#' + $(this).attr('data-text');
    if ($(this).attr('checked') == 'checked') {
      $(dt).val('0');
    } else {
      $(dt).val('1');
    }
  });

  $('[name="chk-xpath"').on('click', function () {
    $('#div-xpath').toggleClass('d-none');
  });

  //urls add
  $('.btn-url-add').on('click', function () {

    var bt = get_tab_group($(this));
    var $sel = $('#sel-' + bt + '-url');
    var $txt = $('#txt-' + bt + '-url');

    $sel.append('<option value="' + $sel.find('option:selected').length + '">' + $txt.val() + '</option>');
    //console.log(bt);
    jobCrawl[bt].urls.push({
      uri: $txt.val(),
      filters: [],
      cookies: []
    });

    $txt.val('');

    $('#sel-' + bt + '-filter').empty();
    $('#sel-' + bt + '-cookie').empty();
  });

  //urls delete
  $('.btn-url-del').on('click', function () {

    var bt = get_tab_group($(this));
    var $sel = $('#sel-' + bt + '-url');

    jobCrawl[bt].urls.splice($sel.prop('selectedIndex'), 1);

    $sel.find('option:selected').remove();

    $('#sel-' + bt + '-filter').empty();
    $('#sel-' + bt + '-cookie').empty();
  });

  //url's select Click
  $('.sel-url').on('click', function () {

    var bt = get_tab_group($(this));

    selectedUrl = $('#sel-' + bt + '-url').prop('selectedIndex');

    var url = jobCrawl[bt].urls[selectedUrl];

    select_populate(url.filters, $('#sel-' + bt + '-filter'));
    select_populate(url.cookies, $('#sel-' + bt + '-cookie'));
  });

  /**
   * Filters and Cookie Selects (select,list,add/delete)
  **/

  //Select List Add
  $('.btn-list-add').on('click', function () {

    var cntrl = get_select_control($(this));
    //console.log(cntrl);
    var add = $('#txt-' + cntrl).val();
    var bt = get_tab_group($(this));
    var bs = get_form_group($(this)) + 's';

    if (add.length) {

      $('#sel-' + cntrl).append($('<option>', {
        value: add,
        text: add
      }));

      $('#txt-' + cntrl).val('');
      console.log(bt);
      jobCrawl[bt].urls[selectedUrl][bs].push(add);
    }
  });

  //Select List Delete
  $('.btn-list-del').on('click', function () {
    var cntrl = get_select_control($(this));
    var index = $('#sel-' + cntrl).prop('selectedIndex');
    var bt = get_tab_group($(this));
    var bs = get_form_group($(this)) + 's';

    $('#sel-' + cntrl).find('option:selected').remove();
    $('#txt-' + cntrl).val('');

    jobCrawl[bt].urls[selectedUrl][bs].splice(index, 1);
  });

  //Select Lists Click
  $('.sel-lists').bind('click', function () {

    var cntrl = get_select_control($(this));

    var t = $('#sel-' + cntrl + ' option:selected').text();

    $('#txt-' + cntrl).val(t);
  });
});

//Edit Job Form Submit
$(".btn-submit").on("click", function (e) {
  e.preventDefault();

  $.ajax({
    method: 'POST',
    url: '/jobs/' + $('#txt-job').val(),
    data: JSON.stringify($.extend(jobCrawl, $('#frm-jobs-edit').serializeFormJSON())),
    contentType: "application/json",
    dataType: "json",
    headers: {
      'Accept': 'application/json'
    }
  }).done(function (r) {

    if (r['code'] == 200) {
      //document.location = '/jobs/list';
    }
  }).fail(function (r) {
    console.log('erorr');
    console.log(r);
    //  alertResponse(r);
  });
});

//populate select lists (filters + cookies)
function select_populate(listItems, $list) {
  $list.empty();
  $.each(listItems, function (key, value) {
    $list.append($('<option/>', {
      value: key,
      text: value
    }));
  });
}
//# sourceMappingURL=job-edit.js.map
//# sourceMappingURL=job-edit.js.map
