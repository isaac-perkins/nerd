/*!
 * Start Bootstrap - SB Admin 2 v4.0.2 (https://startbootstrap.com/template-overviews/sb-admin-2)
 * Copyright 2013-2019 Start Bootstrap
 * Licensed under MIT (https://github.com/BlackrockDigital/startbootstrap-sb-admin-2/blob/master/LICENSE)
 */
"use strict"; // Start of use strict

(function ($) {

  // Toggle the side navigation

  $("#sidebarToggle, #sidebarToggleTop").on('click', function (e) {
    $("body").toggleClass("sidebar-toggled");
    $(".sidebar").toggleClass("toggled");
    Cookies.set('main.sidebar', $(".sidebar").hasClass('toggled'));
    if ($(".sidebar").hasClass("toggled")) {
      $('.sidebar .collapse').collapse('hide');
    };
  });

  // Close any open menu accordions when window is resized below 768px
  $(window).resize(function () {
    if ($(window).width() < 768) {
      $('.sidebar .collapse').collapse('hide');
    };
  });

  // Prevent the content wrapper from scrolling when the fixed side navigation hovered over
  $('body.fixed-nav .sidebar').on('mousewheel DOMMouseScroll wheel', function (e) {
    if ($(window).width() > 768) {
      var e0 = e.originalEvent,
          delta = e0.wheelDelta || -e0.detail;
      this.scrollTop += (delta < 0 ? 1 : -1) * 30;
      e.preventDefault();
    }
  });

  // Scroll to top button appear
  $(document).on('scroll', function () {
    var scrollDistance = $(this).scrollTop();
    if (scrollDistance > 100) {
      $('.scroll-to-top').fadeIn();
    } else {
      $('.scroll-to-top').fadeOut();
    }
  });

  // Smooth scrolling using jQuery easing
  $(document).on('click', 'a.scroll-to-top', function (e) {
    var $anchor = $(this);
    $('html, body').stop().animate({
      scrollTop: $($anchor.attr('href')).offset().top
    }, 1000, 'easeInOutExpo');
    e.preventDefault();
  });
})(jQuery);

//Set CodeMirror Modes
function setMode(cm, mode) {
  if (mode !== undefined) {
    var script = '/assets/scripts/vendor/' + mode + '.js';
    $.getScript(script, function (data, success) {
      if (success) {
        cm.setOption('mode', mode);
      }
    });
  }
}

function selectNavItem(page) {
  $('.nav-' + page).parent('li').addClass('active');
}

function appendIDToForm($frm, id) {
  $frm.attr('action', function (i, value) {
    value = value.split("?")[0];
    return value + "?t=" + id;
  });
}

function alertMessage(response) {
  response = response || null;
  var code = 0;
  var msg = '';
  var cls;
  var $alert = $('div.alert');

  if (response) {
    code = response['code'];
    msg = response['msg'];
  }

  $alert.removeClass('alert-success').removeClass('alert-danger');

  if (code == 200) {
    cls = 'alert-success';
  } else {
    cls = 'alert-danger';
  }

  $alert.addClass(cls);
  $alert.html(msg);
}

$(function () {

  $.fn.serializeFormJSON = function () {
    var o = {};
    var a = this.serializeArray();
    $.each(a, function () {
      if (o[this.name]) {
        if (!o[this.name].push) {
          o[this.name] = [o[this.name]];
        }
        o[this.name].push(this.value || '');
      } else {
        o[this.name] = this.value || '';
      }
    });
    return o;
  };

  $(document).ready(function () {

    if (Cookies.get('main.sidebar') == 'true') {
      $('.sidebar .collapse').collapse('hide');
      $('.sidebar').addClass('toggled');
    }

    $('.nav-item').removeClass('active');
  });

  //Submit any form that get submitted as json
  $('form').submit(function (e) {
    var $frm = $(this);

    if ($frm.attr('data-ajax') == 'false') {
      return;
    }

    e.preventDefault();

    alertMessage();

    $.ajax({
      method: $frm.attr('method'),
      url: $frm.attr('action'),
      data: JSON.stringify($frm.serializeFormJSON()),
      contentType: "application/json",
      dataType: "json",
      headers: {
        'Accept': 'application/json'
      }
    }).done(function (r) {

      alertMessage(r);

      if (r['code'] == 200 && $frm.attr('data-href')) {
        document.location = $frm.attr('data-href');
      }

      if ($frm.attr('data-callback')) {
        var fn = $frm.attr('data-callback');
        window[fn]($frm, r);
      }
    });
  });

  $('.btn-back').on('click', function () {

    window.history.go(-1);

    return false;
  });

  //Select an item in a table
  //specify buttuns to enable/disable - class="item-selected"
  //create a textbox to maintain the selected value - id="txt-selected"
  $('table.table').on('click', 'tr', function () {

    var $this = $(this);

    $('tr').css('background-color', '#fff');

    $this.css('background-color', '#ededf0');

    $('.item-selected').attr('disabled', 'disabled');

    $('.txt-selected').val($this.attr('data-id'));

    $("button.item-selected").removeAttr('disabled');
  });
});
//# sourceMappingURL=nerd.js.map
//# sourceMappingURL=nerd.js.map
