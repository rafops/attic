define(["jquery"], function(jQuery) {

    function initialize() {
        jQuery("#module3").css('color', 'blue').html("<b>module 3 started!</b>");
    }

    return {
        initialize: initialize
    };
});
