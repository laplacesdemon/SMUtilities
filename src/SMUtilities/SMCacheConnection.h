//
//  SMCacheConnection.h
//  SMRestClient
//
//  Created by Suleyman Melikoglu on 9/30/11.
//  Copyright 2011 suleymanmelikoglu@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMConnection.h"

// cache update interval in seconds
//const double SMCacheInterval = 86400.0; // 24hr
//const double SMCacheInterval = 6060243012.0; // 1 year

@interface SMCacheConnection : SMConnection {
    // the file's last modification date
    NSDate* _lastModified;
    
    // file path that the data is stored
    NSString* _cacheDirectoryPath;
    
    // actual file path
    NSString* _filePath;
    
    // the files last modified date
    NSDate* _fileDate;
    
    double _cacheInterval;
}

@property (nonatomic, retain) NSDate* lastModified;
@property (nonatomic, copy) NSString* cacheDirectoryPath;
@property (nonatomic, copy) NSString* filePath;
@property (nonatomic, assign) double cacheInterval;

- (void) clearCache;

@end
