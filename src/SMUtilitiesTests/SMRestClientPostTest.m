//
//  SMRestClientPostTest.m
//  SMUtilities
//
//  Created by Suleyman Melikoglu on 10/25/11.
//  Copyright 2011 suleymanmelikoglu@gmail.com. All rights reserved.
//

#import "SMRestClientPostTest.h"

@implementation SMRestClientPostTest

- (void) setUp 
{
    url = @"http://localhost/sanalikaApp/en/api/";
}

- (void)testPostMethod
{
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"laplacesdemon", @"username",
                                   @"12345678", @"password",
                                   nil];
    SMRestClient* client = [SMRestClient restClientWithURL:url andMethodName:@"auth" andIdParam:nil andParams:params andHttpMethod:@"POST"];
    [client setDelegate:self];
    [client setAuthUsername:@"sanalikaApp"];
    [client setAuthPassword:@"12345678"];
    [client executeWithTag:@"testShouldAuthenticate"];
    
    // this is a workaround in order to test async requests
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop]; 
    while ([client loading] && [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

#pragma mark - rest client delegate

// called just before sending the request
- (void)clientWillStart:(SMRestClient *)client
{
    NSLog(@"request has started");
}

// called when the server responds
- (void)client:(SMRestClient *)client didReceiveResponse:(NSURLResponse *)response
{
    
}

// called when an error occurred
- (void)client:(SMRestClient *)client didFailWithError:(NSError *)error
{
    NSLog(@"request has failed with message:%@ code:%d desc: %@", [client tag], [error code], [error description]);    
    STFail(@"rest client should not fail");
}

// Called when a request returns and its response has been parsed into an object.
// The resulting object may be a dictionary or an array
- (void)client:(SMRestClient *)client didLoad:(id)result
{
    NSLog(@"did load message:%@ result:%@", [client tag], result);
    if ([[client tag] isEqualToString:@"testShouldAuthenticate"]) {
        STAssertTrue([result isKindOfClass:[NSDictionary class]], @"the result should be a dictionary");
        STAssertTrue([[result objectForKey:@"res"] isEqualToString:@"OK"] , @"result should return OK");
    }
}

// Called when a request returns a response.
// The result object is the raw response from the server of type NSData
- (void)client:(SMRestClient *)client didLoadRawResponse:(NSData *)data
{
    
}


@end
