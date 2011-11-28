//
//  SMSocketConnector.h
//  SMUtilities
//
//  Created by Suleyman Melikoglu on 11/28/11.
//  Copyright (c) 2011 suleymanmelikoglu@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SMSocketConnectorDelegate;

@interface SMSocketConnector : NSObject <NSStreamDelegate>
{
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    id<SMSocketConnectorDelegate> delegate;
    BOOL isConnectionOpened;
    NSString* ipAddress;
    NSInteger port;
}

@property (nonatomic, retain) NSString* ipAddress;
@property (nonatomic, assign) NSInteger port;
@property (nonatomic, assign) id<SMSocketConnectorDelegate> delegate;

- (id)initWithIpAddress:(NSString*)address andPort:(NSInteger)thePort;
- (void)openNetworkCommunication;
- (void)closeNetworkCommunication;
- (void)callWithInput:(NSString*)xml;

@end

#pragma mark - delegate protocol

@protocol SMSocketConnectorDelegate <NSObject>

- (void)connector:(SMSocketConnector*)connector didReceiveResponse:(NSString*)data;

@optional
- (void)connectorDidOpenCommunication:(SMSocketConnector*)connector; 
- (void)connectorDidCloseCommunication:(SMSocketConnector *)connector;
- (void)connectorDidFail:(SMSocketConnector*)connector;

@end
