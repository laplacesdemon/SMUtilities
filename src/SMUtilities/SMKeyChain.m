//
//  SMKeyChainWrapper.m
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


#import "SMKeyChain.h"
#import <Security/Security.h>

@implementation SMKeyChain

+ (void)saveString:(NSString *)inputString forKey:(NSString	*)account {
	NSAssert(account != nil, @"Invalid account");
	NSAssert(inputString != nil, @"Invalid string");
	
	NSMutableDictionary *query = [NSMutableDictionary dictionary];
	
	[query setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
	[query setObject:account forKey:(id)kSecAttrAccount];
	[query setObject:(id)kSecAttrAccessibleWhenUnlocked forKey:(id)kSecAttrAccessible];
	
	OSStatus error = SecItemCopyMatching((CFDictionaryRef)query, NULL);
	if (error == errSecSuccess) {
		// do update
		NSDictionary *attributesToUpdate = [NSDictionary dictionaryWithObject:[inputString dataUsingEncoding:NSUTF8StringEncoding] 
                                                                       forKey:(id)kSecValueData];
		
		error = SecItemUpdate((CFDictionaryRef)query, (CFDictionaryRef)attributesToUpdate);
		NSAssert1(error == errSecSuccess, @"SecItemUpdate failed: %d", error);
	} else if (error == errSecItemNotFound) {
		// do add
		[query setObject:[inputString dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecValueData];
		
		error = SecItemAdd((CFDictionaryRef)query, NULL);
		NSAssert1(error == errSecSuccess, @"SecItemAdd failed: %d", error);
	} else {
		NSAssert1(NO, @"SecItemCopyMatching failed: %d", error);
	}
}

+ (NSString *)stringForKey:(NSString *)account {
	NSAssert(account != nil, @"Invalid account");
	
	NSMutableDictionary *query = [NSMutableDictionary dictionary];
    
	[query setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
	[query setObject:account forKey:(id)kSecAttrAccount];
	[query setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    
	NSData *dataFromKeychain = nil;
    
	OSStatus error = SecItemCopyMatching((CFDictionaryRef)query, (CFTypeRef *)&dataFromKeychain);
	
	NSString *stringToReturn = nil;
	if (error == errSecSuccess) {
		stringToReturn = [[[NSString alloc] initWithData:dataFromKeychain encoding:NSUTF8StringEncoding] autorelease];
	}
	
	[dataFromKeychain release];
	
	return stringToReturn;
}

+ (void)removeStringForKey:(NSString *)account {
	NSAssert(account != nil, @"Invalid account");
    
	NSMutableDictionary *query = [NSMutableDictionary dictionary];
	
	[query setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
	[query setObject:account forKey:(id)kSecAttrAccount];
    
	OSStatus status = SecItemDelete((CFDictionaryRef)query);
	if (status != errSecSuccess) {
		NSLog(@"SecItemDelete failed: %ld", status);
	}
}

@end
