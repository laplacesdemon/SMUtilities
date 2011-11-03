//
//  SMConnection.h
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