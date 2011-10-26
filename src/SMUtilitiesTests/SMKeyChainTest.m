//
//  SMKeyChainTest.m
//  SMUtilities
//
//  Created by Suleyman Melikoglu on 10/26/11.
//  Copyright 2011 suleymanmelikoglu@gmail.com. All rights reserved.
//

#import "SMKeyChainTest.h"

@implementation SMKeyChainTest

- (void) testAddingAndReadingKey
{
    NSString* account = @"myAppName";
    NSString* password = @"myPassword";
    [SMKeyChain saveString:password forKey:account];
    
    NSString* passFromKeychain = [SMKeyChain stringForKey:account];
    STAssertTrue([password isEqualToString:passFromKeychain], @"pass should be the same");
}

- (void) testReset
{
    NSString* account = @"myAppName";
    NSString* password = @"myPassword";
    [SMKeyChain saveString:password forKey:account];
    
    [SMKeyChain removeStringForKey:account];
    NSString* passFromKeychain = [SMKeyChain stringForKey:account];
    STAssertNil(passFromKeychain, @"the password should have beeen deleted from the keychain storage");
}

@end
