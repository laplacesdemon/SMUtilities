//
//  SMIndicator.h
//  Whasta
//
//  Wrapper around ActivityIndicator
//
//  Created by Suleyman Melikoglu on 8/29/11.
//  Copyright 2011 Bogazici University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMIndicator : UIView {
    UIActivityIndicatorView* activityIndicator;
    UILabel* label;
    
@private
    BOOL isAnimating;
}

@property (nonatomic, retain) UILabel* label;
@property (nonatomic, retain) UIActivityIndicatorView* activityIndicator;

- (id)initWithLoadingText:(NSString*)theText;
- (void)startAnimating;
- (void)stopAnimating;
- (void)showMessage;
- (void)showMessage:(NSString*)message;
- (void)showMessage:(NSString*)message forSeconds:(NSTimeInterval)seconds;
- (void)remove;
- (BOOL)isAnimating;

@end
