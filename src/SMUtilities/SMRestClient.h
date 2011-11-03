//
//  SMRestClient.h
//  SMUtilities
//
//  Rest Client is a wrapper around NSURLConnection class. Inspired by FBRequest class
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

#define SMREST_ERROR_INTERNAL 500
#define SMREST_ERROR_NOTFOUND 404

@protocol SMRestClientDelegate;

// communicates with a rest server, fetches data and parses them
// SMRestClient supports basic http authorization, authUsername and authPassword should be set in order to use basic authentication
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
    
    // authentication
    NSString* _authenticationMethod;
    NSString* _authUsername;
    NSString* _authPassword;
    
    // string boundary for post method
    NSString* stringBoundary;
    
    // useful to identify the request in the delegator if it is shared by 
    // different instances of the rest client
    NSString* _tag;
}

@property (nonatomic, assign) id<SMRestClientDelegate> delegate;
@property (nonatomic, copy) NSString* url;
@property (nonatomic, copy) NSString* httpMethod;
@property (nonatomic, copy) NSString* methodName;
@property (nonatomic, copy) NSString* idParam;
@property (nonatomic, retain) NSMutableDictionary* params;
@property (nonatomic, assign) NSURLConnection* connection;
@property (nonatomic, retain) NSString* authUsername;
@property (nonatomic, retain) NSString* authPassword;
@property (nonatomic, retain) NSString* tag;

// init methods
- (id)initWithURL:(NSString*)theUrl andMethodName:(NSString*)methodName andIdParam:(NSString*)idParam andParams:(NSMutableDictionary*)params andHttpMethod:(NSString*)httpMethod;
- (id)initWithMethodName:(NSString*)methodName andIdParam:(NSString*)idParam andParams:(NSMutableDictionary*)params andHttpMethod:(NSString*)httpMethod;
+ (SMRestClient*)restClientWithURL:(NSString*)theUrl andMethodName:(NSString*)methodName andIdParam:(NSString*)idParam andParams:(NSMutableDictionary*)params andHttpMethod:(NSString*)httpMethod;
+ (SMRestClient*)restClientWithMethodName:(NSString*)methodName andIdParam:(NSString*)idParam andParams:(NSMutableDictionary*)params andHttpMethod:(NSString*)httpMethod;
+ (SMRestClient*)restClientWithUrl:(NSString*)theUrl andParams:(NSMutableDictionary*)params andHttpMethod:(NSString*)httpMethod;

// class methods
- (BOOL) loading; // returns YES if the request is being sent
- (void) execute; // creates the connection and starts the operation
- (void) executeWithTag:(NSString*)theTag; // creates connection and sets the tag as an identifier

// generates the url using the baseUrl, methodName and additional params 
- (NSURL*) generateURL;

@end

#pragma mark - delegate protocol

@protocol SMRestClientDelegate <NSObject>

@optional
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
