phonegap-ios-zbarcodescanner
============================

phonegap ios barcode scanner using ZBar.

1. config.xml  
`<plugin name="jp.artisanedge.cordova.ZbarcodeScanner" value="ZbarcodeScanner" />`
2. index.html  
`<script type="text/javascript" src="js/zbarcodescanner.js"></script>`
3. zbarcodescanner.js  

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
 
4. custom.js  

        window.plugins.ZbarcodeScanner.scan(function(result) {
            console.log("scan success " + result);
            if (result.cancelled) {
                // cancelled
            } else {
                console.log(result.text);
            }
        }, function(error) {
            console.log("scan error " + error);
        });
