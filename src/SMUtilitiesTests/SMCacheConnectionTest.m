//
//  SMCacheConnectionTest.m
//  SMUtilities
//
//  Created by Suleyman Melikoglu on 10/2/11.
//  Copyright 2011 suleymanmelikoglu@gmail.com. All rights reserved.
//

#import "SMCacheConnectionTest.h"

@implementation SMCacheConnectionTest

- (void) testDownloadingImage 
{
    method = testDownloadingImage;
    
    NSURL* url = [[NSURL alloc] initWithString:@"http://localhost/sample/sample.jpg"];
    SMCacheConnection* conn = [[[SMCacheConnection alloc] initWithURL:url andDelegate:self] autorelease];
    [url release];
    [conn execute];
    
    // this is a workaround in order to test async requests
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    while ([conn loading] && [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

#pragma mark - smcacheconnection delegate

- (void)connectionDidStart:(SMConnection *)connection {
    
}

- (void)connectionDidFinish:(SMCacheConnection*)connection {
    STAssertNotNil(connection.receivedData, @"received data shold not be nil");
    STAssertTrue([connection.receivedData isKindOfClass:[NSData class]], @"received data should be an NSData");
    STAssertTrue([connection isCached], @"connection should be cached");
    
    if (method == testDownloadingImage) {
        UIImage* img = [UIImage imageWithData:connection.receivedData];
        STAssertNotNil(img, @"image should not be nil");
        
        // check the file system
    } else if (method == testDownloadingText) {
        NSString* str = [[NSString alloc] initWithData:connection.receivedData encoding:NSUTF8StringEncoding];
        STAssertNotNil(str, @"data should not be nil");
    }
}

- (void)connectionDidFail:(SMCacheConnection*)connection {
    STFail(@"connection should not be nil");
}


@end
