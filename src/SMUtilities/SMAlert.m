//
//  SMAlert.m
//  SMUtilities
//
//  Created by Suleyman Melikoglu on 10/11/11.
//  Copyright 2011 suleymanmelikoglu@gmail.com. All rights reserved.
//

#import "SMAlert.h"

void SMAlertWithError(NSError* error, NSString* title) {
    NSString *message = [NSString stringWithFormat:@"Error! %@ %@",
						 [error localizedDescription],
						 [error localizedFailureReason]];
	
	SMAlertWithMessage (message, title);
}

void SMAlertWithMessage(NSString* message, NSString* title) {
    /* open an alert with an OK button */
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title 
													message:message
												   delegate:nil 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles: nil];
	[alert show];
	[alert release];
}

void SMAlertWithMessageAndDelegate(NSString* message, NSString* title, id delegate) {
    /* open an alert with OK and Cancel buttons */
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title 
													message:message
												   delegate:delegate 
										  cancelButtonTitle:@"Cancel" 
										  otherButtonTitles: @"OK", nil];
	[alert show];
	[alert release];
}
