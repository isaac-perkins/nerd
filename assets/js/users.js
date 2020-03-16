"use strict";

function responseAdd($frm, resp) {

    if (resp['code'] == 200) {

        var html = '<tr data-id="' + resp['user']['id'] + '">' + '<td>' + $frm.find("[name=email]").val() + '</td>' + '<td><i><small>(invite sent)</small></i></td>' + '<td></td>' + '</tr>';

        $('table.table tr:last').after(html);

        $('#mdl-user-new').modal('hide');
    }
}

function responseRemove($frm, resp) {

    if (resp['code'] == 200) {

        $('tr[data-id="' + $('.txt-selected').val() + '"]').remove();
    }
}

$(function () {

    $(window).on('load', function () {

        selectNavItem('settings');
    });

    $('table.table').on('click', 'tr', function () {

        var $frm = $("button.item-selected").parent('form');

        $frm.attr('action', '/users/' + $(this).attr('data-id'));
    });
});
//# sourceMappingURL=users.js.map
