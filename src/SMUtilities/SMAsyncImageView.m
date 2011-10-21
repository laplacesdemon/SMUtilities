//
//  AsyncImageView.m
//  Whasta
//
//  Created by Suleyman Melikoglu on 9/26/11.
//  Copyright 2011 Bogazici University. All rights reserved.
//

#import "SMAsyncImageView.h"

@implementation SMAsyncImageView

#pragma mark - class methods

- (void)loadImageFromUrl:(NSURL*)url {
    _url = url;
    _connection = [[SMCacheConnection alloc] initWithURL:url andDelegate:self];
    [_connection execute];
}

#pragma mark - connection delegate

- (void) connectionDidStart:(SMConnection*)connection {
    CGRect rect = CGRectMake(0, 0, 20, 20);
    UIActivityIndicatorView* _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:rect];
    [_indicatorView startAnimating];
    [_indicatorView setTag:99];
    [_indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [_indicatorView setCenter:self.center];
    [self addSubview:_indicatorView];
    [_indicatorView release];
}

- (void) connectionDidFinish:(SMConnection*)connection {
    // remove the indicator
    if ([[self subviews] count]>0) {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
    
    // create the image view
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:connection.receivedData]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addSubview:imageView];
    [imageView release];
    [_connection release];
}

- (void) connectionDidFail:(SMConnection*)connection {
    // remove the indicator
    if ([[self subviews] count]>0) {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
    
    UIButton* _errorButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    [_errorButton setCenter:self.center];
    [_errorButton setTitle:@"Failed, Tap to load" forState:UIControlStateNormal];
    [_errorButton setBackgroundColor:[UIColor clearColor]];
    [_errorButton addTarget:self action:@selector(onLoadAgain) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_errorButton];
    [_errorButton release];
    
    [_connection release];
}

- (void) onLoadAgain {
    // remove the error button
    if ([[self subviews] count]>0) {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
    
    [self loadImageFromUrl:_url];
}

@end
