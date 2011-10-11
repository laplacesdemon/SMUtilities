//
//  SMRestClientWithDefaultStrategyTest.m
//  Whasta
//
//  Created by Suleyman Melikoglu on 9/21/11.
//  Copyright 2011 Bogazici University. All rights reserved.
//

#import "SMRestClientIntegrationTest.h"

@implementation SMRestClientIntegrationTest

- (void)testItemsWithUrl {
    // full url contains the params
    NSString* url = @"http://api.twitter.com/1/statuses/public_timeline.json?count=3&include_entities=false&trim_user=false"; 
    SMRestClient* client = [SMRestClient restClientWithUrl:url andParams:nil andHttpMethod:@"GET"];
    [client setDelegate:self];
    [client execute];
    
    // this is a workaround in order to test async requests
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    
    while ([client loading] && [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

- (void)testItems {
    // you can also set only the base url
    NSString* url = @"http://api.twitter.com/1/"; 
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"3", @"count", @"false", @"include_entities", @"false", @"trim_user", nil];
    SMRestClient* client = [SMRestClient restClientWithMethodName:@"statuses/public_timeline.json" andIdParam:nil andParams:params andHttpMethod:@"GET"];
    [client setUrl:url];
    [client setDelegate:self];
    [client execute];
    
    // this is a workaround in order to test async requests
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    
    while ([client loading] && [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

/**
 * uses following url for testing: http://api.twitter.com/1/users/show.json?screen_name=laplaces_demon&include_entities=false
 */
- (void)testSingleItem {    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"laplaces_demon", @"screen_name", @"false", @"include_entities", nil];
    SMRestClient* client = [SMRestClient restClientWithMethodName:@"users/show.json" andIdParam:nil andParams:params andHttpMethod:@"GET"];
    [client setUrl:@"http://api.twitter.com/1/"];
    [client setDelegate:self];
    [client execute];
    
    // this is a workaround in order to test async requests
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    
    while ([client loading] && [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

- (void)testError {
    SMRestClient* client = [SMRestClient restClientWithMethodName:@"unknown" andIdParam:nil andParams:nil andHttpMethod:@"GET"];
    [client setUrl:@"http://theUrlThatDoesNotExists.com"];
    [client setDelegate:self];
    [client execute];
    
    // this is a workaround in order to test async requests
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    
    while ([client loading] && [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

#pragma mark - delegate methods

// called just before sending the request
- (void)clientWillStart:(SMRestClient *)client {
    
}

// called when the server responds
- (void)client:(SMRestClient *)client didReceiveResponse:(NSURLResponse *)response {
    STAssertNotNil(response, @"response should not be nil in any case");
}

// called when an error occurred
- (void)client:(SMRestClient *)client didFailWithError:(NSError *)error {
    if ([client.methodName isEqualToString:@"unknown"]) {
        STAssertTrue([error code] == SMREST_ERROR_NOTFOUND, @"error code should be 404");
    } else {
        NSString* str = [NSString stringWithFormat:@"request should not give any errors: %@", client.methodName];
        STFail(str);
    }
}

// Called when a request returns and its response has been parsed into an object.
// The resulting object may be a dictionary or an array
- (void)client:(SMRestClient *)client didLoad:(id)result {
    if ([client.methodName isEqualToString:@"statuses/public_timeline.json"] || nil == client.methodName) {
        STAssertNotNil(result, @"result should not be nil");
        STAssertTrue([result isKindOfClass:[NSArray class]], @"data structure fail");
        NSArray* statuses = (NSArray*)result;
        STAssertTrue([statuses count] > 0, @"there should be at least one item");
        
        // asserting the data structure of the response
        NSDictionary* res = [statuses objectAtIndex:0];
        STAssertNotNil([res objectForKey:@"retweet_count"], @"data structure failure");
        STAssertNotNil([res objectForKey:@"user"], @"data structure failure");   
        NSLog(@"res %@", res);
    } else if ([client.methodName isEqualToString:@"users/show.json"]) {
        STAssertNotNil(result, @"result should not be nil");
        STAssertTrue([result isKindOfClass:[NSDictionary class]], @"data structure fail");
        NSDictionary* res = (NSDictionary*)result;
        STAssertNotNil([res objectForKey:@"screen_name"], @"data structure failure");
        STAssertNotNil([res objectForKey:@"profile_text_color"], @"data structure failure");
    } else if ([client.methodName isEqualToString:@"unknown"]) {
        STFail(@"the fail url should not be catched in this method, it hsould be handled in fail with error method");
    } 
}

// Called when a request returns a response.
// The result object is the raw response from the server of type NSData
- (void)client:(SMRestClient *)client didLoadRawResponse:(NSData *)data {
    
}

@end
