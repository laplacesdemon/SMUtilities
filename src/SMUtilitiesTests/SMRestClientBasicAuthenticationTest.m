//
//  SMRestClientBasicAuthenticationTest.m
//  SMUtilities
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


#import "SMRestClientBasicAuthenticationTest.h"

@implementation SMRestClientBasicAuthenticationTest

- (void) setUp
{
    url = @"http://localhost/sanalikaApp/en/api/";
}

- (void)testRestClientShouldDoBasicAuth 
{
    SMRestClient* client = [SMRestClient restClientWithURL:url andMethodName:@"auth" andIdParam:nil andParams:nil andHttpMethod:@"GET"];
    [client setDelegate:self];
    [client setAuthUsername:@"sanalikaApp"];
    [client setAuthPassword:@"12345678"];
    // tests with internal dependencies are disabled.
    //[client executeWithTag:@"authGet"];
    
    // this is a workaround in order to test async requests
    //NSRunLoop* runLoop = [NSRunLoop currentRunLoop]; 
    //while ([client loading] && [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
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
