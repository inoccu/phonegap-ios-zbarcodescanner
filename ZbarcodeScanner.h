//
//  ZbarcodeScanner.h
//
//  Created by Kenichi Inoue (Artisan Edge) on 2013/03/21.
//
//

#import <Cordova/CDV.h>

#import "ZBarSDK.h"

@interface ZbarcodeScanner : CDVPlugin <ZBarReaderViewDelegate, ZBarReaderDelegate>
{
    ZBarReaderViewController *_reader;
}

@property (nonatomic, copy) NSString *callbackId;
@property (nonatomic, retain) ZBarReaderViewController *reader;

- (void)scan:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
