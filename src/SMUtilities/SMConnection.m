//
//  SMConnection.m
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


#import "SMConnection.h"

@implementation SMConnection

@synthesize delegate=_delegate;
@synthesize connection=_connection;
@synthesize receivedData=_receivedData;
@synthesize url=_url;
@synthesize isCached=_isCached;
@synthesize loading=_loading;

- (id) initWithURL:(NSURL*)theUrl andDelegate:(id<SMConnectionDelegate>)theDelegate {
    self = [super init];
    if (self) {
        self.delegate = theDelegate;
        self.url = theUrl;
        self.receivedData = nil;
        self.isCached = NO;
        self.loading = NO;
    }
    return self;
}

#pragma mark - memory management

- (void) dealloc {
    [_connection cancel];
    [_connection release];
    [_receivedData release];
    [_url release];
    [super dealloc];
}

#pragma mark - class methods

- (void) execute {
    self.loading = YES;
    [self.delegate connectionDidStart:self];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:self.url
                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                            timeoutInterval:60];
    self.connection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
    if (self.connection == nil) {
        // @todo error handling
        self.loading = NO;
        [self.delegate connectionDidFail:self];
    }
}

#pragma mark - connection delegate

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    long long contentLength = [response expectedContentLength];
	if (contentLength == NSURLResponseUnknownLength) {
		contentLength = 500000;
	}
	self.receivedData = [NSMutableData dataWithCapacity:(NSUInteger)contentLength];
}


- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // append the data
    [self.receivedData appendData:data];
}


- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.loading = NO;
	//URLCacheAlertWithError(error);
	[self.delegate connectionDidFail:self];
}


- (NSCachedURLResponse *) connection:(NSURLConnection *)connection
				   willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
	// we do not use a NSURLCache disk or memory cache in the standard implementation
    return nil;
}


- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.loading = NO;
	[self.delegate connectionDidFinish:self];
}

@end
