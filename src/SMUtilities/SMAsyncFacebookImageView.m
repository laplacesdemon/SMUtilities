//
//  SMAsyncFacebookImageView.m
//  SMUtilities
//
//  Created by Suleyman Melikoglu on 2/10/12.
//  Copyright (c) 2012 suleymanmelikoglu@gmail.com. All rights reserved.
//

#import "SMAsyncFacebookImageView.h"

@implementation SMAsyncFacebookImageView

- (void)_insertErrorMessage:(NSString*)message {
    UIButton* _errorButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    //[_errorButton setCenter:self.center];
    [_errorButton setTitle:message forState:UIControlStateNormal];
    [_errorButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_errorButton setBackgroundColor:[UIColor clearColor]];
    [[_errorButton titleLabel] setAdjustsFontSizeToFitWidth:YES];
    [[_errorButton titleLabel] setFont:[UIFont fontWithName:@"Arial" size:12]];
    [[_errorButton titleLabel] setNumberOfLines:2];
    [_errorButton addTarget:self action:@selector(onLoadAgain) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_errorButton];
    [_errorButton release];
}

- (void) connectionDidFinish:(SMConnection*)connection {
    // remove the indicator
    if ([[self subviews] count]>0) {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
    
    // get the image from data, if the image is nil then the data is not an image
    UIImage* img = [UIImage imageWithData:connection.receivedData];
    if (img == nil) {
        [self _insertErrorMessage:notFoundErrorMessage];
        return;
    }
    
    // Resize, crop the image to make sure it is square and renders
    // well on Retina display
    float ratio;
    float delta;
    float px = 100; // Double the pixels of the UIImageView (to render on Retina)
    CGPoint offset;
    CGSize size = img.size;
    if (size.width > size.height) {
        ratio = px / size.width;
        delta = (ratio*size.width - ratio*size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = px / size.height;
        delta = (ratio*size.height - ratio*size.width);
        offset = CGPointMake(0, delta/2);
    }
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * size.width) + delta,
                                 (ratio * size.height) + delta);
    UIGraphicsBeginImageContext(CGSizeMake(px, px));
    UIRectClip(clipRect);
    [img drawInRect:clipRect];
    UIImage *imgThumb =   UIGraphicsGetImageFromCurrentImageContext();
    
    // create the image view
    UIImageView* imageView = [[UIImageView alloc] initWithImage:imgThumb];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.tag = 31;
    
    [self addSubview:imageView];
    [imageView release];
    [_connection release];
}

@end
