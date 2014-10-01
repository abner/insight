window.Feedback.XHR = function( url ) {

    this.url = url;

    this.createCORSRequest = function(method, url){
        var xhr = new XMLHttpRequest();
        if ("withCredentials" in xhr){
            // XHR has 'withCredentials' property only if it supports CORS
            xhr.open(method, url, true);
        } else if (typeof XDomainRequest != "undefined"){ // if IE use XDR
            xhr = new XDomainRequest();
            xhr.open(method, url);
        } else {
            xhr = null;
        }
        return xhr;
    };

};

window.Feedback.XHR.prototype = new window.Feedback.Send();

window.Feedback.XHR.prototype.send = function( data, callback ) {

    var xhr = this.createCORSRequest("POST", this.url);

    if(xhr == null){
      throw new Error('Navegador não suporta requisição cross-domain.')
    }

    xhr.onreadystatechange = function() {
        if( xhr.readyState == 4 ){ // any successful REST result - 2xx
        	callback( (xhr.status >= 200 && xhr.status < 300) );
        }
    };
    
    xhr.setRequestHeader("Accept", "application/json");
    xhr.setRequestHeader("Content-Type", "application/json; charset=UTF-8");
    xhr.send(  window.JSON.stringify( data ) );    
};
