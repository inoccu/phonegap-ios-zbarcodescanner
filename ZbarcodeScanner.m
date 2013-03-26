//
//  ZbarcodeScanner.m
//  CatchAction
//
//  Created by Kenichi Inoue (Artisan Edge) on 2013/03/21.
//
//

#import "ZbarcodeScanner.h"

@implementation ZbarcodeScanner

@synthesize callbackId;

- (void)scan:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    self.callbackId = [arguments pop];
    NSLog(@"callbackId:%@", self.callbackId);
    
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    
    ZBarImageScanner *scanner = reader.scanner;
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    
    [self.viewController presentModalViewController:reader animated:YES];
    [reader release];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"start imagePickerController:picker");
    [self.viewController dismissModalViewControllerAnimated:YES];

    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    
    for (symbol in results)
        break;
    
    NSMutableDictionary *retVal = [NSMutableDictionary dictionary];
    [retVal setObject:[NSNumber numberWithBool:NO] forKey:@"cancelled"];
    [retVal setObject:symbol.data forKey:@"text"];
    
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:retVal];
    [self writeJavascript:[result toSuccessCallbackString:callbackId]];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"start imagePickerControllerDidCancel");
    [self.viewController dismissModalViewControllerAnimated:YES];

    NSMutableDictionary *retVal = [NSMutableDictionary dictionary];
    [retVal setObject:[NSNumber numberWithBool:YES] forKey:@"cancelled"];
    
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:retVal];
    [self writeJavascript:[result toSuccessCallbackString:callbackId]];
}

- (void)readerControllerDidFailToRead:(ZBarReaderController *)reader withRetry:(BOOL)retry
{
    NSLog(@"start readerControllerDidFailToRead");
}

- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    NSLog(@"start readerView:didReadSymbols");
}

@end
