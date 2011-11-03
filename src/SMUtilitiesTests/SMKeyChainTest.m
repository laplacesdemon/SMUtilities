//
//  SMKeyChainTest.m
//  SMUtilities
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


#import "SMKeyChainTest.h"

@implementation SMKeyChainTest

- (void) tearDown
{
    NSString* account = @"myAppName";
    [SMKeyChain removeStringForKey:account];
}

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
