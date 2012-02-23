//
//  SMIndicator.m
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


#import "SMIndicator.h"
#import <QuartzCore/QuartzCore.h>

@implementation SMIndicator
@synthesize label;
@synthesize backgroundLabel;
@synthesize msg;
@synthesize activityIndicator;

- (id)initWithLoadingText:(NSString*)theText 
{
    self = [super init];
    if (self) {
        isAnimating = NO;
        
        [self setFrame:CGRectMake(60, 100, 200, 100)];
        
        UIColor* background = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
        
        backgroundLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
        [backgroundLabel setBackgroundColor:background];
        [backgroundLabel.layer setCornerRadius:10];
        [self addSubview:backgroundLabel];
        
        activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(50, 40, 20, 20)];
        [activityIndicator setHidesWhenStopped:YES];
        //[activityIndicator setBackgroundColor:background];
        [self addSubview:activityIndicator];
        
        CGRect rectLabel = CGRectMake(80, 40, 110, 20);
        label = [[UILabel alloc] initWithFrame:rectLabel];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:[UIFont fontWithName:@"Arial" size:12]];
        [label setText:theText];
        [self addSubview:label];
        
        CGRect rectMsg = CGRectMake(10, 10, 180, 80);
        msg = [[UILabel alloc] initWithFrame:rectMsg];
        [msg setBackgroundColor:[UIColor clearColor]];
        [msg setTextColor:[UIColor whiteColor]];
        [msg setFont:[UIFont fontWithName:@"Arial" size:12]];
        [msg setHidden:YES];
        [msg setAdjustsFontSizeToFitWidth:YES];
        [msg setNumberOfLines:4];
        [msg setTextAlignment:UITextAlignmentCenter];
        [self addSubview:msg];
    }
    return self;
}

- (id)init 
{
    return [self initWithLoadingText:@"Please Wait"];
}

#pragma mark - animation methods

-(BOOL)isAnimating {
    return isAnimating;
}

-(void)startAnimating {
    //if (isAnimating) return;
    isAnimating = YES;
    [label setHidden:NO];
    [msg setHidden:YES];
    [activityIndicator startAnimating];
}

-(void)stopAnimating {
    //if (!isAnimating) return;
    isAnimating = NO;
    [activityIndicator stopAnimating];
    [self remove];
}

- (void)showMessage {
    [self showMessage:[[self label] text] forSeconds:2];
}

/**
 * displays the message for 2 seconds
 */
- (void)showMessage:(NSString *)message {
    [self showMessage:message forSeconds:2];
}

- (void)showMessage:(NSString*)message forSeconds:(NSTimeInterval)seconds {
    [msg setText:message];
    [msg setHidden:NO];
    [label setHidden:YES];
    [self performSelector:@selector(remove) withObject:self afterDelay:seconds];
}

- (void)remove {
    [UIView beginAnimations:@"SMIndicatorFadeOut" context:nil];
    [UIView setAnimationDuration:1];
    [self setAlpha:0];
    [UIView commitAnimations];
    [self performSelector:@selector(removeFromSuperview) withObject:self afterDelay:1];
}

#pragma mark - memory management

-(void) dealloc {
    [activityIndicator release];
    [label release];
    [msg release];
    [backgroundLabel release];
    [super dealloc];
}

@end
