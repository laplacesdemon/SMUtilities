//
//  SMSocketConnector.m
//  SMUtilities
//
//  Created by Suleyman Melikoglu on 11/28/11.
//  Copyright (c) 2011 suleymanmelikoglu@gmail.com. All rights reserved.
//

#import "SMSocketConnector.h"

@implementation SMSocketConnector
@synthesize delegate;
@synthesize ipAddress;
@synthesize port;

- (id)init
{
    self = [super init];
    if (self) {
        isConnectionOpened = NO;
        ipAddress = nil;
    }
    return self;
}

- (id)initWithIpAddress:(NSString*)address andPort:(NSInteger)thePort
{
    self = [super init];
    if (self) {
        isConnectionOpened = NO;
        ipAddress = address;
        port = thePort;
    }
    return self;
}

- (void)openNetworkCommunication 
{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)ipAddress, port, &readStream, &writeStream);
    inputStream = (NSInputStream *)readStream;
    outputStream = (NSOutputStream *)writeStream;
    
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream open];
    [outputStream open];
    isConnectionOpened = YES;
}

- (void)closeNetworkCommunication 
{
    [inputStream close];
    [outputStream close];
    isConnectionOpened = NO;
    [self.delegate connectorDidCloseCommunication:self];
}

- (void)dealloc {
    [self closeNetworkCommunication];
    [inputStream release];
    [outputStream release];
    [ipAddress release];
    [super dealloc];
}

- (void)callWithInput:(NSString*)xml 
{
    if (isConnectionOpened == NO) {
        [self openNetworkCommunication];
    }
	NSData *data = [[NSData alloc] initWithData:[xml dataUsingEncoding:NSASCIIStringEncoding]];
	[outputStream write:[data bytes] maxLength:[data length]];
}

#pragma mark - delegate

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
	switch (streamEvent) {
            
		case NSStreamEventOpenCompleted:
            [self.delegate connectorDidOpenCommunication:self];
			break;
            
		case NSStreamEventHasBytesAvailable:
            if (theStream == inputStream) {
                
                uint8_t buffer[1024];
                int len;
                
                while ([inputStream hasBytesAvailable]) {
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        
                        if (nil != output) {
                            NSLog(@"server said: %@", output);
                            [self.delegate connector:self didReceiveResponse:output];
                        }
                    }
                }
            }
			break;			
            
		case NSStreamEventErrorOccurred:
			//NSLog(@"Can not connect to the host!");
            [self.delegate connectorDidFail:self];
			break;
            
		case NSStreamEventEndEncountered:
			break;
            
		default:
			NSLog(@"Unknown event");
	}
}

@end
