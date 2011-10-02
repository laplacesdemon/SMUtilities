//
//  SMConnection.h
//  SMRestClient
//
//  Created by Suleyman Melikoglu on 9/30/11.
//  Copyright 2011 suleymanmelikoglu@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SMConnectionDelegate;

// base/abstract class of the connection implementations
@interface SMConnection : NSObject {
    id<SMConnectionDelegate> _delegate;
    NSURLConnection* _connection;
    NSMutableData* _receivedData;
    NSURL* _url;
    BOOL _isCached;
    BOOL _loading; // indicated that the connection is loading the data
}

@property (nonatomic, assign) id<SMConnectionDelegate> delegate;
@property (nonatomic, retain) NSURLConnection* connection;
@property (nonatomic, retain) NSMutableData* receivedData;
@property (nonatomic, retain) NSURL* url;
@property (nonatomic, assign) BOOL isCached;
@property (nonatomic, assign) BOOL loading;

- (id) initWithURL:(NSURL*)theUrl andDelegate:(id<SMConnectionDelegate>)theDelegate;
- (void) execute; // starts the process

@end

#pragma mark - delegate protocol

@protocol SMConnectionDelegate <NSObject>

- (void) connectionDidStart:(SMConnection*)connection;
- (void) connectionDidFinish:(SMConnection*)connection;
- (void) connectionDidFail:(SMConnection*)connection;

@end