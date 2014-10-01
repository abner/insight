window.Feedback.Form = function( elements ) {

    this.elements = elements || [{
        type: "textarea",
        name: "Issue",
        label: "Please describe the issue you are experiencing",
        required: false
    }];

    this.dom = document.createElement("div");

};

window.Feedback.Form.prototype = new window.Feedback.Page();

window.Feedback.Form.prototype.render = function() {

    var i = 0, len = this.elements.length, item;
    emptyElements( this.dom );
    for (; i < len; i++) {
        item = this.elements[ i ];

    	item.label_element = element("label", item.label + ":" + (( item.required === true ) ? " *" : ""));
    	
        switch( item.type ) {
            case "textarea":
                this.dom.appendChild(item.label_element);
                item.element = document.createElement("textarea");
                if (item.required) {
        			item.element.setAttribute("required", "true");
                }
                this.dom.appendChild( ( item.element) );
                break;
            case "radio":
            	this.dom.appendChild(item.label_element);
                var items = item.options;
                item.elements = [];
                for ( var j = 0; j < items.length; j++ ){
            		var radio = document.createElement("input");
            		radio = document.createElement("input");
            		radio.setAttribute("id",item.name + "_" + items[j]);
            		radio.setAttribute("type","radio");
            		radio.setAttribute("name",item.name);
            		radio.setAttribute("value", items[j])
            		if (item.defaultValue == items[j]) {
            			radio.setAttribute("checked", "checked")
            		}
            		if (item.disabled === true) {
            			radio.setAttribute("disabled","disabled");
            		}
                	if (item.required) {
                		radio.setAttribute("required", "true");
                	}
            		var radio_label = document.createElement("label");     
            		radio_label.htmlFor = radio.id;  
            		
            		var radio_text = document.createTextNode(items[j]); 
            		radio_label.appendChild(radio_text);
                    item.elements[j] = radio;
                    this.dom.appendChild(radio);
            		this.dom.appendChild(radio_label);
            		
                }
        		break;
            case "starrating":
            	this.dom.appendChild(item.label_element);
                var items = item.options;
                item.elements = [];
                var divStarRating = document.createElement("div");
                divStarRating.className = "feedback-rating";
                // in reverse order to keep star rating working as originally designed
                for ( var j = items.length-1; j >= 0; j-- ){
            		var radio = document.createElement("input");
            		radio = document.createElement("input");
            		radio.setAttribute("id",item.name + "_" + j);
            		radio.setAttribute("type","radio");
            		radio.setAttribute("name",item.name);
            		radio.setAttribute("value", items[j])
            		if (item.disabled === true) {
            			radio.setAttribute("disabled","disabled");
            		}
                	if (item.required) {
                		radio.setAttribute("required", "true");
                	}
            		var radio_label = document.createElement("label");     
            		radio_label.htmlFor = radio.id;  
            		
            		var radio_text = document.createTextNode(items[j]);
            		radio_label.setAttribute("title",items[j]);
            		radio_label.appendChild(radio_text);
                    item.elements[j] = radio;
                    divStarRating.appendChild(radio);
                    divStarRating.appendChild(radio_label);
                }
                this.dom.appendChild(divStarRating);
        		break;
            case "select":
                this.dom.appendChild(item.label_element);
                item.element = document.createElement("select");
                var items = item.options;
                var options = [];
                for ( var j = 0; j < items.length; j++ ){
                    options.push(new Option(items[j], items[j], false, false));
                    item.element.appendChild(options[j]);
                }
                if (item.required) {
       	 			item.element.setAttribute("required", "true");
                }
                this.dom.appendChild( ( item.element) );
                break;
            case "hidden":
                item.element = document.createElement("input");
                item.element.setAttribute("type","hidden");
                item.element.setAttribute("value",item.value);
                this.dom.appendChild( (item.element ) );
                break;
            default:
        		this.dom.appendChild(item.label_element);
        		item.element = document.createElement("input");
        		item.element.setAttribute("type",item.type);
        		if (item.disabled === true) {
        			item.element.setAttribute("disabled","disabled");
                }
                if (item.required) {
        			item.element.setAttribute("required", "true");
        		}
        		this.dom.appendChild( (item.element ) );
        		break;
        }
    }

    return this;

};

window.Feedback.Form.prototype.end = function() {
    // form validation  
    var i = 0, len = this.elements.length, item;
    var valid = true;
    for (; i < len; i++) {
        item = this.elements[ i ];
        // make sure an already filled field has no class
        if (item.label_element) {
        	item.label_element.className = "";
        }
        // check that all required fields are entered
        if ( item.required === true ) {
        	if (item.element && item.element.value.length === 0) {
        		item.label_element.className = "feedback-error";
        		valid = false;
        	} else if (item.elements) {
        		var elements = item.elements;
        	    for (var x=0, xlen = elements.length; x<xlen; x++) {
        	        if (elements[x].checked) {
        	        	item.element = elements[x];
        	        	break;
        	        }        	    	
        	    }
        	    if (x===xlen) {
            		item.label_element.className = "feedback-error";
            		valid = false;
        	    }
        	} 
        }
    }

    return valid;

};

window.Feedback.Form.prototype.data = function() {
    
    if ( this._data !== undefined ) {
        // return cached value
        return this._data;
    }
    
    var i = 0, len = this.elements.length, item, data = {};
    
    for (; i < len; i++) {
        item = this.elements[ i ];
        data[ item.name ] = item.element.value;
    }
    
    // cache and return data
    return ( this._data = data );
};


window.Feedback.Form.prototype.review = function( dom ) {
  
    var i = 0, item, len = this.elements.length;
      
    for (; i < len; i++) {
        item = this.elements[ i ];
        
        if (item.hideOnReview !== true) { 
	        if (item.element.value.length > 0) {
	            dom.appendChild( element("label", item.label || item.name + ":") );
	            dom.appendChild( document.createTextNode( item.element.value) );
	            dom.appendChild( document.createElement( "hr" ) );
	        }
        }
        
    }
    
    return dom;
     
};