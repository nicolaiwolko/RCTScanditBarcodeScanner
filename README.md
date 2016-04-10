# RCTScanditBarcodeScanner
iOS React Native UI Component for SCANDIT Barcode Scanner SDK

Hey folks, i've writte a simple UI Component wrapper for SanditBarcodeScanner.
Feel free to use and contribute.



## Installation
1. Make sure you copied all *.m and *.h files in xcode into your Project.
Prefered way is to drag them into xcode: So xcode should automatically link them to build path.

2. Include ScanditBarcodeScanner from the provided JS File like this:

```import ScanditBarcodeScannerView from './ScanditBarcodeScanner';```


## How to use
````
import ScanditBarcodeScannerView from './ScanditBarcodeScanner';
ScanditBarcodeScannerView.setSettings({
  symbology: ['EAN13', 'QR']
});

class TestProject extends Component {
  render() {
  	var scan = function(data) {
  		console.log(data);
  	}
    return (
    	<View>
      	  <ScanditBarcodeScannerView onBarcodePickerDidScan={scan}/>
        </View>
    );
  }
}
```

