$.rails.allowAction = function(element){
    if( undefined === element.attr('data-confirm') ){
        return true;
    }

    $.rails.showConfirmDialog(element);
    return false;
};

$.rails.confirmed = function(element){
    element.removeAttr('data-confirm');
    element.trigger('click.rails');
};

$.rails.showConfirmDialog = function(element){
    var msg = element.data('confirm');
    alertify.confirm(msg, function(e){
        if(e){
            $.rails.confirmed(element);
        }
    })
};

<!-- then override glossary values -->
alertify.defaults.transition = "fade";
alertify.defaults.glossary.title = I18n.t("alertify.Confirmation", {defaultValue: "Confirmation"});
alertify.defaults.glossary.ok = I18n.t("alertify.OK", {defaultValue: "OK"});
alertify.defaults.glossary.cancel = I18n.t("alertify.Cancel", {defaultValue: "Cancel"});
