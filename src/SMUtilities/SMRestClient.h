//
//  SMRestClient.h
//  SMUtilities
//
//  Rest Client is a wrapper around NSURLConnection class. Inspired by FBRequest class
//
//  Created by Suleyman Melikoglu on 9/12/11.
//  Copyright 2011 Bogazici University. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SMREST_ERROR_INTERNAL 500
#define SMREST_ERROR_NOTFOUND 404

@protocol SMRestClientDelegate;

/**
 * communicates with Whasta server
 */
@interface SMRestClient : NSObject {
    id<SMRestClientDelegate> _delegate;
    
    NSString* _url;
    NSString* _methodName;
    NSString* _idParam;
    NSString* _httpMethod;
    NSMutableDictionary* _params;
    NSURLConnection* _connection;
    NSMutableData* _receivedData;
    BOOL _isLoading;
}

@property (nonatomic, assign) id<SMRestClientDelegate> delegate;
@property (nonatomic, copy) NSString* url;
@property (nonatomic, copy) NSString* httpMethod;
@property (nonatomic, copy) NSString* methodName;
@property (nonatomic, copy) NSString* idParam;
@property (nonatomic, retain) NSMutableDictionary* params;
@property (nonatomic, assign) NSURLConnection* connection;

// init methods
- (id)initWithMethodName:(NSString*)methodName andIdParam:(NSString*)idParam andParams:(NSMutableDictionary*)params andHttpMethod:(NSString*)httpMethod;
+ (SMRestClient*)restClientWithMethodName:(NSString*)methodName andIdParam:(NSString*)idParam andParams:(NSMutableDictionary*)params andHttpMethod:(NSString*)httpMethod;
+ (SMRestClient*)restClientWithUrl:(NSString*)theUrl andParams:(NSMutableDictionary*)params andHttpMethod:(NSString*)httpMethod;

// class methods
- (BOOL) loading; // returns YES if the request is being sent
- (void) execute; // creates the connection and starts the operation

// generates the url using the baseUrl, methodName and additional params 
- (NSURL*) generateURL;

@end

#pragma mark - delegate protocol

@protocol SMRestClientDelegate <NSObject>

// called just before sending the request
- (void)clientWillStart:(SMRestClient *)client;

// called when the server responds
- (void)client:(SMRestClient *)client didReceiveResponse:(NSURLResponse *)response;

// called when an error occurred
- (void)client:(SMRestClient *)client didFailWithError:(NSError *)error;

// Called when a request returns and its response has been parsed into an object.
// The resulting object may be a dictionary or an array
- (void)client:(SMRestClient *)client didLoad:(id)result;

// Called when a request returns a response.
// The result object is the raw response from the server of type NSData
- (void)client:(SMRestClient *)client didLoadRawResponse:(NSData *)data;

@end
