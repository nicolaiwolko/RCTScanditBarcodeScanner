//
//  RCTScanditBarcodeScanner.m
//
//  Created by Nicolai Wolko on 04.04.16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "RCTScanditBarcodeScanner.h"

@implementation RCTScanditBarcodeScanner

@synthesize scanditBarcodePicker;

- (instancetype)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    SBSScanSettings* scanSettings = [SBSScanSettings defaultSettings];
    self.scanditBarcodePicker = [[SBSBarcodePicker alloc] initWithSettings:scanSettings];
    [self addSubview:self.scanditBarcodePicker.view];
  }
  return self;
}

- (void)didMoveToWindow
{
  [super didMoveToWindow];
  if (self.window) {
    [self.scanditBarcodePicker startScanning];
  } else {
    [self.scanditBarcodePicker stopScanning];
  }
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  self.scanditBarcodePicker.view.frame = self.bounds;
}


@end
