//
//  SMKeyChainWrapper.h
//  SMUtilities
//
//  Created by Suleyman Melikoglu on 10/26/11.
//  Copyright 2011 suleymanmelikoglu@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

// Keychain wrapper for storing sensitive data in the keychain
@interface SMKeyChain : NSObject

// saves the given input string (password) to the keychain
// account is the identifier of the password
+ (void)saveString:(NSString *)inputString forKey:(NSString	*)account;

// reads the sensitive string from the keychain storage
+ (NSString *)stringForKey:(NSString *)account;

// removes the data stored in the keychain
+ (void)removeStringForKey:(NSString *)account;

@end
