$(document).ready(function() {
    $('.vote-checkbox').click(function(evt) {
        $(evt.target).children('[type=checkbox]').click();
    });
} );