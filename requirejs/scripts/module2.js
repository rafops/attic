define(["jquery"], function(jQuery) {

    function initialize() {
        jQuery("#module2").css('background-color', 'red').html("module 2 started!");
    }

    return {
        initialize: initialize
    };
});
