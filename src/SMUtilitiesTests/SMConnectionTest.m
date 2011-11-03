//
//  SMConnectionTest.m
//  SMRestClient
//
//  SMUtilities is a compilation of useful utilities for iOS
//  Copyright (C) 2011 Suleyman Melikoglu suleyman@melikoglu.info
//  https://github.com/laplacesdemon/SMUtilities
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
// 
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
// 
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
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
