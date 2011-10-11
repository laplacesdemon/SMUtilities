//
//  SMAlert.h
//  SMUtilities
//
//  Created by Suleyman Melikoglu on 10/11/11.
//  Copyright 2011 suleymanmelikoglu@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

void SMAlertWithError(NSError* error, NSString* title);
void SMAlertWithMessage(NSString* message, NSString* title);
void SMAlertWithMessageAndDelegate(NSString* message, NSString* title, id delegate);
