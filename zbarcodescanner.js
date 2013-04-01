;(function(){

//-------------------------------------------------------------------
var ZbarcodeScanner = function() {
}

//-------------------------------------------------------------------
ZbarcodeScanner.prototype.scan = function(success, fail, options) {
    console.log("start scan");
    function successWrapper(result) {
        result.cancelled = (result.cancelled == 1)
        success.call(null, result)
    }

    if (!fail) { fail = function() {}}

    if (typeof fail != "function")  {
        console.log("ZbarcodeScanner.scan failure: failure parameter not a function")
        return
    }

    if (typeof success != "function") {
        fail("success callback parameter must be a function")
        return
    }
  
    if ( null == options ) 
      options = []

    return Cordova.exec(successWrapper, fail, "jp.artisanedge.cordova.ZbarcodeScanner", "scan", options)
}

//-------------------------------------------------------------------

// remove Cordova.addConstructor since it was not supported on PhoneGap 2.0
if (!window.plugins) window.plugins = {}

if (!window.plugins.ZbarcodeScanner) {
    window.plugins.ZbarcodeScanner = new ZbarcodeScanner()
}

})();
