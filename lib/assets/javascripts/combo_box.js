/*
 * jQuery Combo Box
 */
(function($) {
    // Initializes combo-box controls
    $.initializeComboBoxes = function() {
	var element = $(this);
	if (element.alreadyBound !== 'true') {
	
	    element.comboBoxCache = element.val();
	    element.valueField = $('#'+element.attr('data-value-container'))[0];
	    if ($.isEmptyObject(element.valueField)) {
		alert('An input '+element.id+' with a "data-combo-box" attribute must contain a "data-value-container" attribute');
	    }
	    element.maxSize = parseInt(element.attr('data-max-size'));
	    if (isNaN(element.maxSize) || element.maxSize === 0) { element.maxSize = 64; }
	    element.size = (element.comboBoxCache.length < 32 ? 32 : element.comboBoxCache.length > element.maxSize ? element.maxSize : element.comboBoxCache.length);
	    
	    element.autocomplete({
		source: element.attr('data-combo-box'),
		minLength: 1,
		select: function(event, ui) {
		    var selected = ui.item;
		    element.valueField.value = selected.id;
		    element.comboBoxCache = selected.label;
		    element.attr("size", (element.comboBoxCache.length < 32 ? 32 : element.comboBoxCache.length > element.maxSize ? element.maxSize : element.comboBoxCache.length));
		    $(element.valueField).trigger("emulated:change");
		    return true;
		}
	    });
	    element.alreadyBound = 'true';
	}
	return false;
    };
    // Bind elements with the method 
    $('input[data-combo-box]').ready(initializeComboBoxes);
    $('input[data-combo-box]').ajaxStop(initializeComboBoxes);
})(jQuery);