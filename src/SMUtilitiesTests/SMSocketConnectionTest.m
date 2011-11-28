//
//  SMSocketConnectionTest.m
//  SMUtilities
//
//  Created by Suleyman Melikoglu on 11/28/11.
//  Copyright (c) 2011 suleymanmelikoglu@gmail.com. All rights reserved.
//

#import "SMSocketConnectionTest.h"

@implementation SMSocketConnectionTest

- (void)setUp {
    isLoading = NO;
    conn = [[SMSocketConnector alloc] initWithIpAddress:@"212.68.49.60" andPort:2013];
    [conn setDelegate:self];
}

- (void)tearDown {
    [conn release];
}

- (void)testSendEnvelope
{
    isLoading = YES;
    [conn callWithInput:@"<?xml version=\"1.0\"?><envelopes><envelope type='userSession' user='laplacesdemon'/></envelopes>"];
    
    // this is a workaround in order to test async requests
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    while (isLoading && [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

#pragma mark - delegator

- (void)connector:(SMSocketConnector *)connector didReceiveResponse:(NSString *)data
{
    NSString* expectedOffline = @"<?xml version=\"1.0\"?><envelopes><envelope type='userSession'></envelope></envelopes>";
    
    STAssertTrue([data isEqualToString:expectedOffline], @"unexpected result", nil);
    [conn closeNetworkCommunication];
}

- (void)connectorDidOpenCommunication:(SMSocketConnector *)connector
{
    
}

- (void)connectorDidCloseCommunication:(SMSocketConnector *)connector
{
    isLoading = NO;
}

@end
