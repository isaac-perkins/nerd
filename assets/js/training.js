"use strict";

var bEdit = false;

var cm = CodeMirror.fromTextArea(document.getElementById("txt-content"), {
  lineNumbers: true,
  lineWrapping: true,
  styleActiveLine: true,
  matchBrackets: true,
  mode: "xml"
});

cm.setSize('100%', '100%');

cm.on('contextmenu', function (event) {
  $('.CodeMirror').contextmenu({
    'target': '#context-menu',
    onItem: function onItem(context, e) {
      formatAnnotation($(e.target).text());
    }
  });
  bEdit = true;
});

cm.on('blur', function (event) {
  bEdit = true;
});

function formatAnnotation(lbl) {
  lbl = lbl.replace(/\s+/g, '_').toLowerCase();

  var insert = ' <START:' + lbl + '> ' + cm.getSelection() + ' <END> ';

  cm.replaceSelection(insert);
}

if (Dropzone) {
  Dropzone.autoDiscover = false;
}

interact('#dlg-annotation').draggable({

  inertia: true,

  restrict: {
    restriction: "parent",
    endOnly: true,
    elementRect: { top: 0, left: 0, bottom: 1, right: 1 }
  },

  autoScroll: true,
  onmove: dragMoveListener,

  onend: function onend(event) {
    var textEl = event.target.querySelector('p');

    textEl && (textEl.textContent = 'moved a distance of ' + Math.sqrt(Math.pow(event.pageX - event.x0, 2) + Math.pow(event.pageY - event.y0, 2) | 0).toFixed(2) + 'px');
  }
});

function dragMoveListener(event) {
  var target = event.target,
      x = (parseFloat(target.getAttribute('data-x')) || 0) + event.dx,
      y = (parseFloat(target.getAttribute('data-y')) || 0) + event.dy;

  // translate the element
  target.style.webkitTransform = target.style.transform = 'translate(' + x + 'px, ' + y + 'px)';

  // update the posiion attributes
  target.setAttribute('data-x', x);
  target.setAttribute('data-y', y);
}

window.dragMoveListener = dragMoveListener;

function responseNew(frm, r) {

  try {

    cm.setValue(r.content);

    var $select = $('#sel-training');

    $select.append('<option value="' + r.id + '">' + r.url + '</option>');

    $select.selectpicker('refresh');

    $select.selectpicker('val', r.id).prop('selected', true);

    getTraining(r.id);

    $('#txt-training-add').val('');

    $('#mdl-add').modal('hide');
  } catch (e) {

    console.error(e);

    //alertMessage()
  }
}

function responseRemove(frm, r) {

  try {

    cm.setValue('');

    var selectedOption = $('#sel-training option:selected');
    selectedOption.remove();
    $('#sel-training').selectpicker('refresh');
    var firstOption = $('#sel-training option:first-child').val();
    $('#sel-training').selectpicker('val', firstOption);
    getTraining(firstOption);

    $('#mdl-remove').modal('hide');

    //console.log(firstOption);
  } catch (e) {

    console.error(e);
    //alertMessage()
  }
}

function responseSave(frm, r) {
  console.log(r);
  bEdit = false;
}

function getTraining(id) {

  $.ajax({
    method: 'GET',
    url: '/jobs/' + $('#txt-job').val() + '/training/?t=' + id
  }).done(function (r) {
    try {
      cm.setValue(r.content);

      console.log(r.id);

      $('#txt-training').val(r.id);

      appendIDToForm($('#frm-training'), r.id);

      bEdit = true;
    } catch (e) {
      console.error(e);
    }
  });
}

$(function () {

  //Show Jobs nav item
  $(document).ready(function () {
    selectNavItem('jobs');
  });

  //Show annotations dialog
  $('.btn-annotation').click(function () {
    $('#dlg-annotation').toggleClass('d-none');
  });

  //Insert annotation
  $('#btn-annotate').click(function () {
    formatAnnotation($('#sel-targets').find("option:selected").text());
  });

  //Set up remove dialog
  $('#mdl-remove').on('shown.bs.modal', function () {

    appendIDToForm($(this).find('form'), $('#txt-training').val());

    $('#txt-training-remove').val($('#sel-training').find("option:selected").text());
  });

  $('.btn-build').click(function () {
    var action = $(this).attr('data-action');
    $.ajax({
      method: 'GET',
      url: '/jobs/' + $('#txt-job').val() + '/build/?act=' + action
    }).done(function (r) {
      console.log(r);

      try {
        alertMessage(r);
        //  cm.setValue(r.content);
        //  console.log(r.id);
        //$('#txt-training').val(r.id);
        //bEdit = true;
      } catch (e) {
        console.error(e);
      }
    });
  });

  //Training selected
  $('#sel-training').on('changed.bs.select', function () {
    getTraining($('#sel-training').val());
  });

  //File upload Drop Zone
  var dz = $("div.dz").dropzone({
    maxFilesize: 100,
    url: '/jobs/' + $('#txt-job').val() + '/training?url=' + $('#sel-training').val() + '&new=',
    success: function success(file, r) {
      cm.setValue(r['content']);
    },
    init: function init() {
      this.on("processing", function (file) {
        this.options.url += $('#chk-new').attr('data-value');
      });
    }
  });

  $(window).bind('keydown', function (event) {
    if (event.ctrlKey || event.metaKey) {
      if (String.fromCharCode(event.which).toLowerCase() == 's') {
        event.preventDefault();
        $('#frm-training').submit();
      }
    }
  });
});
//# sourceMappingURL=training.js.map
//# sourceMappingURL=training.js.map
