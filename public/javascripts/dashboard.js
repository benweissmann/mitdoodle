$(document).ready(function() {
    $('.data-table').dataTable( {
        "sPaginationType": "bootstrap",
        "oLanguage": {
            "sLengthMenu": "_MENU_ records per page"
        },
        "bAutoWidth": false,
        "bLengthChange": false,
        "bSort": false,
        "iDisplayLength": 5
    } );
} );