define(["jquery"], function(jQuery) {

    function initialize() {
        jQuery("#module1").html("<h2>module 1 started!</h2>");
    }

    return {
        initialize: initialize
    };
});
