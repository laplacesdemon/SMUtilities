//
//  AsyncImageView.h
//  Whasta
//
//  Created by Suleyman Melikoglu on 9/26/11.
//  Copyright 2011 Bogazici University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCacheConnection.h"

@interface SMAsyncImageView : UIView <SMConnectionDelegate> {
    SMCacheConnection* _connection;
    NSURL* _url;
}

- (void) loadImageFromUrl:(NSURL*)url;
- (void) onLoadAgain;

@end
