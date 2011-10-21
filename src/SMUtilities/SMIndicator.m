//
//  SMIndicator.m
//  Whasta
//
//  Created by Suleyman Melikoglu on 8/29/11.
//  Copyright 2011 Bogazici University. All rights reserved.
//

#import "SMIndicator.h"
#import <QuartzCore/QuartzCore.h>

@implementation SMIndicator
@synthesize label;
@synthesize activityIndicator;

- (id)initWithLoadingText:(NSString*)theText 
{
    self = [super init];
    if (self) {
        isAnimating = NO;
        
        [self setFrame:CGRectMake(60, 100, 200, 100)];
        
        UIColor* background = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];;
        
        UILabel* backgroundLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
        [backgroundLabel setBackgroundColor:background];
        [backgroundLabel.layer setCornerRadius:10];
        [self addSubview:backgroundLabel];
        [backgroundLabel release];
        
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
    }
    return self;
}

- (id)init 
{
    return [self initWithLoadingText:@"Please Wait"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - animation methods

-(BOOL)isAnimating {
    return isAnimating;
}

-(void)startAnimating {
    //if (isAnimating) return;
    isAnimating = YES;
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
    [[self label] setText:message];
    [self performSelector:@selector(remove) withObject:self afterDelay:seconds];
}

- (void)remove {
    [UIView beginAnimations:@"SMIndicatorFadeOut" context:nil];
    [UIView setAnimationDuration:1];
    [self setAlpha:0];
    [UIView commitAnimations];
    [self performSelector:@selector(removeFromSuperview) withObject:self afterDelay:2];
}

#pragma mark - memory management

-(void) dealloc {
    [activityIndicator release];
    [label release];
    [super dealloc];
}

@end