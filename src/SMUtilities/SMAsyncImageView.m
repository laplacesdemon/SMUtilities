//
//  AsyncImageView.m
//  Whasta
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
