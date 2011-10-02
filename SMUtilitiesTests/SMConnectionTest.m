//
//  SMConnectionTest.m
//  SMRestClient
//
//  Created by Suleyman Melikoglu on 9/30/11.
//  Copyright 2011 suleymanmelikoglu@gmail.com. All rights reserved.
//

#import "SMConnectionTest.h"

@implementation SMConnectionTest

- (void)testDownloadingImage {
    method = testDownloadingImage;
    
    NSURL* url = [[NSURL alloc] initWithString:@"http://localhost/sample/sample.jpg"];
    SMConnection* conn = [[SMConnection alloc] initWithURL:url andDelegate:self];
    [url release];
    [conn execute];
    
    // this is a workaround in order to test async requests
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    while ([conn loading] && [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

- (void)testDownloadingText {
    method = testDownloadingText;
    
    NSURL* url = [[NSURL alloc] initWithString:@"http://localhost/sample/sample.php"];
    SMConnection* conn = [[SMConnection alloc] initWithURL:url andDelegate:self];
    [url release];
    [conn execute];
    
    // this is a workaround in order to test async requests
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    while ([conn loading] && [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

#pragma mark - smcacheconnection delegate

- (void) connectionDidStart:(SMConnection *)connection {
    
}

- (void) connectionDidFinish:(SMConnection*)connection {
    STAssertNotNil(connection.receivedData, @"received data shold not be nil");
    
    STAssertTrue([connection.receivedData isKindOfClass:[NSData class]], @"received data should be an NSData");
    STAssertFalse([connection isCached], @"connection should be cached");
    
    if (method == testDownloadingImage) {
        UIImage* img = [UIImage imageWithData:connection.receivedData];
        STAssertNotNil(img, @"image should not be nil");
        
        // check the file system
    } else if (method == testDownloadingText) {
        NSString* str = [[NSString alloc] initWithData:connection.receivedData encoding:NSUTF8StringEncoding];
        STAssertNotNil(str, @"data should not be nil");
    }
    
    
}

- (void) connectionDidFail:(SMConnection*)connection {
    STFail(@"connection should not be nil");
}

@end
