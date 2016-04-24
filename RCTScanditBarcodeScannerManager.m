//
//  RCTScanditBarcodeScannerManager.m
//
//  Created by Nicolai Wolko on 03.04.16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "RCTScanditBarcodeScannerManager.h"
#import "RCTBridge.h"
#import "RCTEventDispatcher.h"

@implementation RCTScanditBarcodeScannerManager

{
  RCTScanditBarcodeScanner *scanditBarcodeScanner;
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(startScanning)
{
  [scanditBarcodeScanner.scanditBarcodePicker startScanning];
}

RCT_EXPORT_METHOD(stopScanning)
{
  [scanditBarcodeScanner.scanditBarcodePicker stopScanning];
}

RCT_EXPORT_METHOD(pauseScanning)
{
  [scanditBarcodeScanner.scanditBarcodePicker pauseScanning];
}

RCT_EXPORT_METHOD(resumeScanning)
{
  [scanditBarcodeScanner.scanditBarcodePicker resumeScanning];
}

RCT_EXPORT_METHOD(setSettings:(NSDictionary *)settings)
{
  SBSScanSettings *scanditBarcodeSettings = [SBSScanSettings defaultSettings];
  
  unsigned count;
  objc_property_t *properties = class_copyPropertyList([scanditBarcodeSettings class], &count);
  
  for (int i = 0; i < count; i++) {
    
    NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
    
    if ([settings objectForKey:key]) {
      [scanditBarcodeSettings setValue:[settings objectForKey:key] forKey:key];
    }
    
  }
  
  if ([settings objectForKey:@"symbology"]) {
    NSArray *symbologies = [settings objectForKey:@"symbology"];
    for (int i = 0; i < symbologies.count; i++) {
      
      NSString *code = symbologies[i];
      
      void (^selectedCase)() = @{
                                 @"EAN13" : ^{
                                   [scanditBarcodeSettings setSymbology:SBSSymbologyEAN13 enabled:YES];
                                 },
                                 @"UPC12" : ^{
                                   [scanditBarcodeSettings setSymbology:SBSSymbologyUPC12 enabled:YES];
                                 },
                                 @"QR" : ^{
                                   [scanditBarcodeSettings setSymbology:SBSSymbologyQR enabled:YES];
                                 },
                                 @"Code39" : ^{
                                   [scanditBarcodeSettings setSymbology:SBSSymbologyCode39 enabled:YES];
                                 },
                                 @"EAN8" : ^{
                                   [scanditBarcodeSettings setSymbology:SBSSymbologyEAN8 enabled:YES];
                                 },
                                 @"UPCE" : ^{
                                   [scanditBarcodeSettings setSymbology:SBSSymbologyUPCE enabled:YES];
                                 },
                                 @"Code128" : ^{
                                   [scanditBarcodeSettings setSymbology:SBSSymbologyCode128 enabled:YES];
                                 },
                                 @"Code11" : ^{
                                   [scanditBarcodeSettings setSymbology:SBSSymbologyCode11 enabled:YES];
                                 },
                                 @"Code93" : ^{
                                   [scanditBarcodeSettings setSymbology:SBSSymbologyCode93 enabled:YES];
                                 },
                                 @"PDF417" : ^{
                                   [scanditBarcodeSettings setSymbology:SBSSymbologyPDF417 enabled:YES];
                                 },
                                 @"Aztec" : ^{
                                   [scanditBarcodeSettings setSymbology:SBSSymbologyAztec enabled:YES];
                                 },
                                 }[code];
      
      if (selectedCase != nil)
        selectedCase();
    }
  }
  
  free(properties);
  [scanditBarcodeScanner.scanditBarcodePicker applyScanSettings:scanditBarcodeSettings completionHandler:nil];
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    scanditBarcodeScanner = [[RCTScanditBarcodeScanner alloc] init];
    scanditBarcodeScanner.scanditBarcodePicker.scanDelegate = self;
  }
  return self;
}

- (NSDictionary *) dictionaryWithPropertiesOfObject:(id)obj
{
  NSMutableDictionary *dict = [NSMutableDictionary dictionary];
  
  unsigned count;
  objc_property_t *properties = class_copyPropertyList([obj class], &count);
  
  
  for (int i = 0; i < count; i++) {
    
    NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
    
    if ([[obj valueForKey:key] isKindOfClass:[NSArray class]]) {
     
      NSArray *orig_list = [obj valueForKey:key];
      NSMutableArray *new_list = [[NSMutableArray alloc] init];
      
      for (int ii = 0; ii < orig_list.count; ii++) {
        [new_list addObject:[self dictionaryWithPropertiesOfObject:orig_list[ii]]];
      }
      
      [dict setObject:[[NSArray alloc] initWithArray:new_list] forKey:key];
      
    } else {
      
      if ([[obj valueForKey:key] isKindOfClass:[NSValue class]] || [[obj valueForKey:key] isKindOfClass:[NSData class]]) {
        [dict setObject:[NSString stringWithFormat:@"%p", [obj valueForKey:key]] forKey:key];
      } else if ([obj valueForKey:key] != nil) {
        [dict setObject:[obj valueForKey:key] forKey:key];
      } else {
        [dict setObject:@"" forKey:key];
      }
      
    }
  }
  
  free(properties);
  return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)barcodePicker:(SBSBarcodePicker *)picker didScan:(SBSScanSession *)session
{
  NSDictionary *body = [self dictionaryWithPropertiesOfObject: session];
  [self.bridge.eventDispatcher sendAppEventWithName:@"RCTScanditBarcodeScanner_barcodePickerDidScan" body:body];
}

- (UIView *)view
{
  return scanditBarcodeScanner;
}

@end
