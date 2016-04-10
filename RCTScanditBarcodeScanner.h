//
//  RCTScanditBarcodeScanner.h
//
//  Created by Nicolai Wolko on 04.04.16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ScanditBarcodeScanner/ScanditBarcodeScanner.h>

@interface RCTScanditBarcodeScanner : UIView

@property (nonatomic, strong) SBSBarcodePicker *scanditBarcodePicker;

@end
