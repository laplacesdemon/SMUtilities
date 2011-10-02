//
//  SMConnection.m
//  SMRestClient
//
//  Created by Suleyman Melikoglu on 9/30/11.
//  Copyright 2011 suleymanmelikoglu@gmail.com. All rights reserved.
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
