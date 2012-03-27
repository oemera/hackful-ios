jQuery.fn.equalize = function(attr, value) {
	if (typeof(value) == "undefined") {
		var maxValue = 0;
		this.each(function() {
			var value = _value(this, attr);
			if (value > maxValue)
				maxValue = value;
		});
		value = maxValue;
	}
	
	this.each(function() {
		_setValue(this, attr, value);
	});
	
	return this;
	
	function _value(ob, attr) {
		if (attr == "height")
			return $(ob).height();
		else if (attr == "width")
			return $(ob).width();
	};
	
	function _setValue(ob, attr, value) {
		if (attr == "height")
			$(ob).height(value);
		else if (attr == "width")
			$(ob).width(value);
	};
};
