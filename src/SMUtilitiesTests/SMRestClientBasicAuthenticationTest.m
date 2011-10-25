//
//  SMRestClientBasicAuthenticationTest.m
//  SMUtilities
//
//  Created by Suleyman Melikoglu on 10/25/11.
//  Copyright 2011 suleymanmelikoglu@gmail.com. All rights reserved.
//

#import "SMRestClientBasicAuthenticationTest.h"

@implementation SMRestClientBasicAuthenticationTest

- (void)testRestClientShouldDoBasicAuth 
{
    SMRestClient* client = [SMRestClient restClientWithURL:TEST_REST_URL andMethodName:@"auth" andIdParam:nil andParams:nil andHttpMethod:@"GET"];
    [client setDelegate:self];
    [client setAuthUsername:@"sanalikaApp"];
    [client setAuthPassword:@"12345678"];
    [client executeWithTag:@"authGet"];
    
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
    NSLog(@"request has failed with code:%d desc: %@", [error code], [error description]);    
}

// Called when a request returns and its response has been parsed into an object.
// The resulting object may be a dictionary or an array
- (void)client:(SMRestClient *)client didLoad:(id)result
{
    NSLog(@"returned parsed result %@", result);

    STAssertTrue([result isKindOfClass:[NSDictionary class]], @"the result should be a dictionary");
    STAssertEquals([[result objectForKey:@"code"] integerValue], 405, @"result should be 405");
    STAssertTrue([[result objectForKey:@"msg"] isEqualToString:@"405 Method Not Allowed"] , @"result should be 405 Method Not Allowed");
}

// Called when a request returns a response.
// The result object is the raw response from the server of type NSData
- (void)client:(SMRestClient *)client didLoadRawResponse:(NSData *)data
{
    
}

@end
