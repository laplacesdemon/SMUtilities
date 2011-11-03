//
//  SMCacheConnection.m
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


#import "SMCacheConnection.h"

@interface SMCacheConnection (PrivateMethods)

- (void) initCacheDirectory;
- (void) getFileModificationDate;

@end

@implementation SMCacheConnection
@synthesize lastModified=_lastModified;
@synthesize cacheDirectoryPath=_cacheDirectoryPath;
@synthesize filePath=_filePath;
@synthesize cacheInterval=_cacheInterval;

- (id) initWithURL:(NSURL *)theUrl andDelegate:(id<SMConnectionDelegate>)theDelegate 
{
    self = [super initWithURL:theUrl andDelegate:theDelegate];
    if (self) {
        self.lastModified = nil;
        self.cacheInterval = 86400.0;
        [self initCacheDirectory];
    }
    return self;
}

#pragma mark - memory management

- (void) dealloc 
{
    [_lastModified release];
    [_cacheDirectoryPath release];
    [_filePath release];
    [super dealloc];
}

#pragma mark - private methods

- (void) initCacheDirectory 
{
    // create path to cache directory inside the application's Documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.cacheDirectoryPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"SMCache"];
    
    NSLog(@"cache path: %@", self.cacheDirectoryPath);
    
	// check if the cache directory exists
	if ([[NSFileManager defaultManager] fileExistsAtPath:self.cacheDirectoryPath]) {
		return;
	}
    
    // create a new cache directory
    NSError* error = nil;
	if (![[NSFileManager defaultManager] createDirectoryAtPath:self.cacheDirectoryPath
								   withIntermediateDirectories:NO
													attributes:nil
														 error:&error]) {
		//URLCacheAlertWithError(error);
		return;
	}
}

- (void) getFileModificationDate
{
	// default date if file doesn't exist
	NSDate* fileDate = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
    
	if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath]) {
        // retrieve file attributes
        NSError* error = nil;
		NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:self.filePath error:&error];
		if (attributes != nil) {
            //NSLog(@"file atts: %@", attributes);
			fileDate = [attributes fileModificationDate];
		}
		else {
			//URLCacheAlertWithError(error);
		}
	}
    _fileDate = fileDate;
}

#pragma mark - class methods

- (void) execute
{
    self.isCached = YES;
    
    // get the file path
    [_filePath release]; // release previous instance if any
	NSString *fileName = [[self.url path] lastPathComponent];
	self.filePath = [[self.cacheDirectoryPath stringByAppendingPathComponent:fileName] retain];
    
    // check if the file exists in the cache
    // if the file is there, return it directly
    // otherwise, fetch the file from the server
    [self getFileModificationDate];
	/* get the elapsed time since last file update */
	NSTimeInterval time = fabs([_fileDate timeIntervalSinceNow]);
	if (time > _cacheInterval) {
        // file does not exist or it has not been updated since the interval time.
		[super execute];
	} else {
		// return the cached file
        self.loading = YES;
        [self.delegate connectionDidStart:self];
        NSLog(@"file path: %@", self.filePath);
        self.receivedData = [NSMutableData dataWithContentsOfFile:self.filePath];
        self.loading = NO;
        [self.delegate connectionDidFinish:self];
	}
}

- (void) clearCache
{
	// remove the cache directory and its contents 
    NSError* error = nil;
	if (![[NSFileManager defaultManager] removeItemAtPath:self.cacheDirectoryPath error:&error]) {
		//URLCacheAlertWithError(error);
		return;
	}
    
	// create a new cache directory
	if (![[NSFileManager defaultManager] createDirectoryAtPath:self.cacheDirectoryPath
								   withIntermediateDirectories:NO
													attributes:nil
														 error:&error]) {
		//URLCacheAlertWithError(error);
		return;
	}
}

#pragma mark - NSConnection delegate methods

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [super connection:connection didReceiveResponse:response];
    
    // try to get the last modified date from HTTP header, if no date found, set the last modified date the the current date
	if ([response isKindOfClass:[NSHTTPURLResponse self]]) {
		NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
		NSString *modified = [headers objectForKey:@"Last-Modified"];
		if (modified) {
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
			// avoid problem if the user's locale is incompatible with HTTP-style dates
			[dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
            
			[dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
			self.lastModified = [dateFormatter dateFromString:modified];
			[dateFormatter release];
		} else {
			// default if last modified date doesn't exist
			self.lastModified = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
		}
	}
}

- (NSCachedURLResponse *) connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
	// we use the custom caching
    return nil;
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    // save the file to the disk
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath] == YES) {
        
		/* apply the modified date policy */
        
		[self getFileModificationDate];
        NSComparisonResult result = [self.lastModified compare:_fileDate];

		if (result == NSOrderedDescending) {
			// file is outdated, so remove it 
            NSError* error = nil;
			if (![[NSFileManager defaultManager] removeItemAtPath:self.filePath error:&error]) {
				//URLCacheAlertWithError(error);
			}
            
		}
	}
    
	if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath] == NO) {
		// file doesn't exist, so create it 
		[[NSFileManager defaultManager] createFileAtPath:self.filePath
												contents:self.receivedData
											  attributes:nil];
	}
    
	// reset the file's modification date to indicate that the URL has been checked
    
    NSError* error = nil;
	NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSDate date], NSFileModificationDate, nil];
	if (![[NSFileManager defaultManager] setAttributes:dict ofItemAtPath:self.filePath error:&error]) {
		//URLCacheAlertWithError(error);
	}
	[dict release];
    
    [super connectionDidFinishLoading:connection];
}

@end
