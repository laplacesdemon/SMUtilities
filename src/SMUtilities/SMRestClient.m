//
//  SMRestClient.m
//  SMUtilities
//
//  Created by Suleyman Melikoglu on 9/12/11.
//  Copyright 2011 Bogazici University. All rights reserved.
//

#import "SMRestClient.h"
#import "JSON.h"

@interface SMRestClient(PrivateMethods)
- (NSMutableData*)_generatePostBody;
- (id)formError:(NSInteger)code userInfo:(NSDictionary *) errorData;
- (id)parseJsonResponse:(NSData *)data error:(NSError **)error;
- (void)handleResponseData:(NSData *)data;
@end

@implementation SMRestClient
@synthesize delegate=_delegate, url=_url, httpMethod=_httpMethod, params=_params, methodName=_methodName, connection=_connection, idParam=_idParam;

#pragma mark - initializer

- (id)initWithMethodName:(NSString*)methodName andIdParam:(NSString*)idParam andParams:(NSMutableDictionary*)params andHttpMethod:(NSString*)httpMethod
{
    self = [super init];
    if (self) {
        self.params = params;
        self.httpMethod = httpMethod;
        self.methodName = methodName;
        self.idParam = idParam;
        self.url = nil;
    }
    return self;
}

+ (SMRestClient*)restClientWithMethodName:(NSString*)methodName andIdParam:(NSString*)idParam andParams:(NSMutableDictionary*)params andHttpMethod:(NSString*)httpMethod {
    SMRestClient* client = [[[SMRestClient alloc] initWithMethodName:methodName andIdParam:idParam andParams:params andHttpMethod:httpMethod] autorelease];
    return client;
}

+ (SMRestClient*)restClientWithUrl:(NSString*)theUrl andParams:(NSMutableDictionary*)params andHttpMethod:(NSString*)httpMethod {
    SMRestClient* client = [[[SMRestClient alloc] initWithMethodName:nil andIdParam:nil andParams:params andHttpMethod:httpMethod] autorelease];
    [client setUrl:theUrl];
    return client;
}


#pragma mark - memory management

- (void)dealloc {
    [_url release];
    [_httpMethod release];
    [_methodName release];
    [_params release];
    [super dealloc];
}

#pragma mark - private methods

- (NSMutableData*)_generatePostBody {
    return nil;
}

- (id)formError:(NSInteger)code userInfo:(NSDictionary *) errorData {
    return [NSError errorWithDomain:@"whastaErrDomain" code:code userInfo:errorData];
}

- (id)parseJsonResponse:(NSData *)data error:(NSError **)error {
    
    NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    SBJSON *jsonParser = [[SBJSON new] autorelease];
    if ([responseString isEqualToString:@"true"]) {
        return [NSDictionary dictionaryWithObject:@"true" forKey:@"result"];
    } else if ([responseString isEqualToString:@"false"]) {
        if (error != nil) {
            *error = [self formError:SMREST_ERROR_INTERNAL
                            userInfo:[NSDictionary
                                      dictionaryWithObject:@"This operation can not be completed"
                                      forKey:@"error_msg"]];
        }
        return nil;
    }
    
    
    id result = [jsonParser objectWithString:responseString];
    [responseString release];
    
    if (result == nil) {
        if (error != nil) {
            *error = [self formError:SMREST_ERROR_NOTFOUND
                            userInfo:nil];
        }
        return nil;
    }
    
    if (![result isKindOfClass:[NSArray class]]) {
        if ([result objectForKey:@"error"] != nil) {
            if (error != nil) {
                *error = [self formError:SMREST_ERROR_INTERNAL
                                userInfo:result];
            }
            return nil;
        }
        
        if ([result objectForKey:@"error_code"] != nil) {
            if (error != nil) {
                *error = [self formError:[[result objectForKey:@"error_code"] intValue] userInfo:result];
            }
            return nil;
        }
        
        if ([result objectForKey:@"error_msg"] != nil) {
            if (error != nil) {
                *error = [self formError:SMREST_ERROR_INTERNAL userInfo:result];
            }
        }
        
        if ([result objectForKey:@"error_reason"] != nil) {
            if (error != nil) {
                *error = [self formError:SMREST_ERROR_INTERNAL userInfo:result];
            }
        }
    }
    
    return result;
}

- (void)handleResponseData:(NSData *)data {
    [_delegate client:self didLoadRawResponse:data];
    
    NSError* error = nil;
    id result = [self parseJsonResponse:data error:&error];
    
    if (error)
        [_delegate client:self didFailWithError:error];
    else
        [_delegate client:self didLoad:(result == nil ? data : result)];
}

#pragma mark - methods

- (BOOL) loading {
    return _isLoading;
}

- (void) execute {
    if([_delegate respondsToSelector:@selector(clientWillStart:)])
        [_delegate clientWillStart:self];
    
    // create the request
    NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] initWithURL:[self generateURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:180.0] autorelease];
    //NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] initWithURL:[self generateURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:180.0] autorelease];
    [request setHTTPMethod:self.httpMethod];
    
    if ([self.httpMethod isEqualToString: @"POST"]) {
        [request setValue:@"multipart/form-data;" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:[self _generatePostBody]];
    }
    
    // create the connection with the request
    // and start loading the data
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (_connection) {
        _isLoading = YES;
    } else {
        // the connection failed
        _isLoading = NO;
        [_delegate client:self didFailWithError:nil];
    }
}

/**
 * generates the url using the baseUrl, methodName and additional params 
 */
- (NSURL*) generateURL {
    NSMutableString* str = [NSMutableString stringWithString:self.url];
    
    if (self.methodName) {
        [str appendString:self.methodName];        
    }

    if (self.idParam) {
        [str appendString:@"/"];
        [str appendString:self.idParam];
    }
    
    // add the params as query string
    if ([self.params count] > 0) {
        [str appendString:@"?"];
        for (NSString* key in self.params) {
            NSString* val = [self.params objectForKey:key];
            [str appendFormat:@"%@=%@&", key, val];
        }
    }
    
    return [NSURL URLWithString:str];
}

#pragma mark - NSURLConnection delegate methods

/**
 * Called when the server respond, It can be called multiple times, 
 * for example in the case of a redirect, so each time we reset the data.
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // create the received response data object
    _receivedData = [[NSMutableData alloc] init];
    [_receivedData setLength:0];
    [_delegate client:self didReceiveResponse:response];
}

/**
 * Called when new data is received, can be called several times. 
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data { 
    [_receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [_connection release];
    [_receivedData release];
    
    /*NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    */
    
    [_delegate client:self didFailWithError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Succeeded! Received %d bytes of data",[_receivedData length]);
    
    [self handleResponseData:_receivedData];
    _isLoading = NO;
    
    // memory management
    [_connection release];
    [_receivedData release];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    /*
    if (cachedResponse) {
        NSLog(@"the response is cached!");
        NSURLCacheStoragePolicy policy = [cachedResponse storagePolicy];
        if (policy == NSURLCacheStorageAllowed) {
            NSLog(@"NSURLCacheStorageAllowed");
        } else if (policy == NSURLCacheStorageAllowedInMemoryOnly) {
            NSLog(@"NSURLCacheStorageAllowedInMemoryOnly");
        } else if (policy == NSURLCacheStorageNotAllowed) {
            NSLog(@"NSURLCacheStorageNotAllowed");
        }
        NSLog(@"userInfo: %@", [cachedResponse userInfo]);
        
    } else {
        NSLog(@"the response is not cached");
    }*/
    return cachedResponse;
}

@end