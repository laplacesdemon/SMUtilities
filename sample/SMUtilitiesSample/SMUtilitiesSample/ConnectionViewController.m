//
//  ConnectionViewController.m
//  SMUtilitiesSample
//
//  Created by Suleyman Melikoglu on 10/2/11.
//  Copyright 2011 suleymanmelikoglu@gmail.com. All rights reserved.
//

#import "ConnectionViewController.h"

@implementation ConnectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL* url = [NSURL URLWithString:@"http://sleevage.com/wp-content/uploads/2008/04/circa_survive_onletting_go.jpg"];
    SMConnection* conn = [[[SMConnection alloc] initWithURL:url andDelegate:self] autorelease];
    [conn execute];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - connection delegate

- (void) connectionDidStart:(SMConnection*)connection {
    NSLog(@"connection has started");
}

- (void) connectionDidFinish:(SMConnection*)connection {
    NSLog(@"connection did finish");
}

- (void) connectionDidFail:(SMConnection*)connection {
    NSLog(@"connection did fail");
}

@end
