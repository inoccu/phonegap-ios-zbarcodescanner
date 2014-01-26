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
@synthesize reader = _reader;

- (void)scan:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    self.callbackId = [arguments pop];
    NSLog(@"callbackId:%@", self.callbackId);
    
    self.reader = [[ZBarReaderViewController alloc] init];
    self.reader.readerDelegate = self;
    
    ZBarImageScanner *scanner = self.reader.scanner;
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    
    [self.viewController presentModalViewController:self.reader animated:YES];
    [self.reader release];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"start imagePickerController:picker");
    if (self.reader.readerView.session.running) {
        for (AVCaptureInput *input in self.reader.readerView.session.inputs) {
            [self.reader.readerView.session removeInput:input];
        }
        for (AVCaptureOutput *output in self.reader.readerView.session.outputs) {
            [self.reader.readerView.session removeOutput:output];
        }
        [self.reader.readerView.session stopRunning];
        if (!self.reader.readerView.session.running) {
            NSLog(@"AVCaptureSession stopped.");
        }
    }
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
    if (self.reader.readerView.session.running) {
        for (AVCaptureInput *input in self.reader.readerView.session.inputs) {
            [self.reader.readerView.session removeInput:input];
        }
        for (AVCaptureOutput *output in self.reader.readerView.session.outputs) {
            [self.reader.readerView.session removeOutput:output];
        }
        [self.reader.readerView.session stopRunning];
        if (!self.reader.readerView.session.running) {
            NSLog(@"AVCaptureSession stopped.");
        }
    }
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
