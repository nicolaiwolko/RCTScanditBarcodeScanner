// ScanditBarcodeScanner.js
'use strict';

import React, { requireNativeComponent, NativeAppEventEmitter, NativeModules } from 'react-native';


class ScanditBarcodeScannerView extends React.Component {
	constructor() {
		super();
		let that = this;
		this.barcodePickerDidScan = NativeAppEventEmitter.addListener(
  			'RCTScanditBarcodeScanner_barcodePickerDidScan', function(data) {
				if (!that.props.onBarcodePickerDidScan) {
				  return;
				}
				that.props.onBarcodePickerDidScan(data);
  			}
		);
	}

	static setSettings(settings) {
		NativeModules.ScanditBarcodeScannerManager.setSettings(settings);
	}

	componentWillUnmount() {
		this.barcodePickerDidScan.remove();
	}

	render() {
		return <ScanditBarcodeScanner {...this.props}/>;
	}
}

ScanditBarcodeScannerView.propTypes = {
	// You need to specify a callback function, which is called
	// after successfull scan process
	onBarcodePickerDidScan: React.PropTypes.func.isRequired,
};

var ScanditBarcodeScanner = requireNativeComponent('RCTScanditBarcodeScanner', ScanditBarcodeScannerView);

module.exports = ScanditBarcodeScannerView;
