//
//  SMRestClient.m
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


#import "SMRestClient.h"
#import "JSON.h"
#import <UIKit/UIKit.h>

@interface SMRestClient(PrivateMethods)
- (void)utfAppendBody:(NSMutableData *)body data:(NSString *)data;
- (NSMutableData*)_generatePostBody;
- (id)formError:(NSInteger)code userInfo:(NSDictionary *) errorData;
- (id)parseJsonResponse:(NSData *)data error:(NSError **)error;
- (void)handleResponseData:(NSData *)data;
@end

@implementation SMRestClient
@synthesize 
delegate=_delegate, 
url=_url, 
httpMethod=_httpMethod, 
params=_params, 
methodName=_methodName, 
connection=_connection, 
idParam=_idParam, 
authUsername=_authUsername,
authPassword=_authPassword,
tag=_tag;

#pragma mark - initializer

- (id)initWithMethodName:(NSString*)methodName andIdParam:(NSString*)idParam andParams:(NSMutableDictionary*)params andHttpMethod:(NSString*)httpMethod
{
    return [self initWithURL:nil andMethodName:methodName andIdParam:idParam andParams:params andHttpMethod:httpMethod];
}

- (id)initWithURL:(NSString*)theUrl andMethodName:(NSString*)methodName andIdParam:(NSString*)idParam andParams:(NSMutableDictionary*)params andHttpMethod:(NSString*)httpMethod
{
    self = [super init];
    if (self) {
        self.params = params;
        self.httpMethod = httpMethod;
        self.methodName = methodName;
        self.idParam = idParam;
        self.url = theUrl;
        _authenticationMethod = nil;
        stringBoundary = @"3i2ndDfv2rTHiSisAbouNdArYfORhtTPEefj3q2f";
    }
    return self;    
}

+ (SMRestClient*)restClientWithURL:(NSString*)theUrl andMethodName:(NSString*)methodName andIdParam:(NSString*)idParam andParams:(NSMutableDictionary*)params andHttpMethod:(NSString*)httpMethod
{
    SMRestClient* client = [[[SMRestClient alloc] initWithURL:theUrl andMethodName:methodName andIdParam:idParam andParams:params andHttpMethod:httpMethod] autorelease];
    return client;
}

+ (SMRestClient*)restClientWithMethodName:(NSString*)methodName andIdParam:(NSString*)idParam andParams:(NSMutableDictionary*)params andHttpMethod:(NSString*)httpMethod 
{
    SMRestClient* client = [[[SMRestClient alloc] initWithMethodName:methodName andIdParam:idParam andParams:params andHttpMethod:httpMethod] autorelease];
    return client;
}

+ (SMRestClient*)restClientWithUrl:(NSString*)theUrl andParams:(NSMutableDictionary*)params andHttpMethod:(NSString*)httpMethod 
{
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
    [_tag release];
    [super dealloc];
}

#pragma mark - private methods

- (void)_utfAppendBody:(NSMutableData *)body data:(NSString *)data {
    [body appendData:[data dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSMutableData*)_generatePostBody {
    NSMutableData *body = [NSMutableData data];
    NSString *endLine = [NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary];
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    
    [self _utfAppendBody:body data:[NSString stringWithFormat:@"--%@\r\n", stringBoundary]];
    
    for (id key in [_params keyEnumerator]) {
        
        if (([[_params valueForKey:key] isKindOfClass:[UIImage class]])
            || ([[_params valueForKey:key] isKindOfClass:[NSData class]])) 
        {    
            [dataDictionary setObject:[_params valueForKey:key] forKey:key];
            continue;   
        }
        
        [self _utfAppendBody:body
                       data:[NSString
                             stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",
                             key]];
        [self _utfAppendBody:body data:[_params valueForKey:key]];
        [self _utfAppendBody:body data:endLine];
    }
    
    if ([dataDictionary count] > 0) {
        for (id key in dataDictionary) {
            NSObject *dataParam = [dataDictionary valueForKey:key];
            if ([dataParam isKindOfClass:[UIImage class]]) {
                NSData* imageData = UIImagePNGRepresentation((UIImage*)dataParam);
                [self _utfAppendBody:body
                               data:[NSString stringWithFormat:
                                     @"Content-Disposition: form-data; filename=\"%@\"\r\n", key]];
                [self _utfAppendBody:body
                               data:[NSString stringWithString:@"Content-Type: image/png\r\n\r\n"]];
                [body appendData:imageData];
            } else {
                NSAssert([dataParam isKindOfClass:[NSData class]],
                         @"dataParam must be a UIImage or NSData");
                [self _utfAppendBody:body
                               data:[NSString stringWithFormat:
                                     @"Content-Disposition: form-data; filename=\"%@\"\r\n", key]];
                [self _utfAppendBody:body
                               data:[NSString stringWithString:@"Content-Type: content/unknown\r\n\r\n"]];
                [body appendData:(NSData*)dataParam];
            }
            [self _utfAppendBody:body data:endLine];
            
        }
    }
    
    return body;
}

- (id)formError:(NSInteger)code userInfo:(NSDictionary *) errorData {
    return [NSError errorWithDomain:@"SMUtilities" code:code userInfo:errorData];
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
    
    if (error) {
        if ([_delegate respondsToSelector:@selector(client:didFailWithError:)]) {
            [_delegate client:self didFailWithError:error];
        }
    } else {
        if ([_delegate respondsToSelector:@selector(client:didLoad:)]) {
            [_delegate client:self didLoad:(result == nil ? data : result)];                        
        }
    }
}

#pragma mark - methods

- (BOOL) loading {
    return _isLoading;
}

- (void) execute {
    if([_delegate respondsToSelector:@selector(clientWillStart:)]) {
        [_delegate clientWillStart:self];
    }
    
    // create the request
    NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] initWithURL:[self generateURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:180.0] autorelease];
    //NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] initWithURL:[self generateURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:180.0] autorelease];
    [request setHTTPMethod:self.httpMethod];
    
    if ([self.httpMethod isEqualToString: @"POST"]) {
        NSString* contentType = [NSString
                                 stringWithFormat:@"multipart/form-data; boundary=%@", stringBoundary];
        [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
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
        if ([_delegate respondsToSelector:@selector(client:didFailWithError:)]) {
            [_delegate client:self didFailWithError:nil];
        }
    }
}

- (void) executeWithTag:(NSString*)theTag {
    [self setTag:theTag];
    [self execute];
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
    if (![[self httpMethod] isEqualToString:@"POST"]) {
        if ([self.params count] > 0) {
            [str appendString:@"?"];
            for (NSString* key in self.params) {
                NSString* val = [self.params objectForKey:key];
                [str appendFormat:@"%@=%@&", key, val];
            }
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
    
    if(!response) {
        return;
    }
    
    if ([_delegate respondsToSelector:@selector(client:didReceiveResponse:)]) {
        [_delegate client:self didReceiveResponse:response];
    }
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
       
    if ([_delegate respondsToSelector:@selector(client:didFailWithError:)]) {
        [_delegate client:self didFailWithError:error];        
    }

}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
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

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if (_authenticationMethod == nil) 
        return;
    
    // for this version, only the basic and digest authentication are supportted
    if (!(_authenticationMethod == NSURLAuthenticationMethodHTTPBasic 
        || _authenticationMethod == NSURLAuthenticationMethodHTTPDigest
        || _authenticationMethod == NSURLAuthenticationMethodDefault))
        return;
    
    if (_authUsername == nil || _authPassword == nil)
        return;
    
    if ([challenge previousFailureCount] == 0) {
        NSURLCredential* credential = [NSURLCredential credentialWithUser:_authUsername password:_authPassword persistence:NSURLCredentialPersistenceNone];
        [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        NSError* error = [NSError errorWithDomain:@"SMUtilities" code:500 userInfo:nil];
        if ([[self delegate] respondsToSelector:@selector(client:didFailWithError:)]) {
            [[self delegate] client:self didFailWithError:error];            
        }
    }

}

- (void) connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
}

- (BOOL) connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    _authenticationMethod = [protectionSpace authenticationMethod];
    return YES;
}

@end
