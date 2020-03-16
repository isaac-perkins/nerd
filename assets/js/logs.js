"use strict";

$(function () {

  /* Code Mirror Editor Config */
  var cm = CodeMirror.fromTextArea(document.getElementById("txt-content"), {
    lineNumbers: false,
    lineWrapping: true,
    styleActiveLine: true,
    matchBrackets: true,
    mode: "xml"
  });

  cm.setSize('100%', '100%');

  $('.log ul.dropdown-menu li a').on('click', function () {
    document.location = '/jobs/' + $('#txt-job').val() + '/log?log=' + $(this).text();
  });
});
//# sourceMappingURL=logs.js.map
//# sourceMappingURL=logs.js.map
//# sourceMappingURL=logs.js.map
