//
//  SMDeviceTest.m
//  SMUtilities
//
//  Created by Suleyman Melikoglu on 11/22/11.
//  Copyright (c) 2011 suleymanmelikoglu@gmail.com. All rights reserved.
//

#import "SMDeviceTest.h"
#import "SMDevice.h"

@implementation SMDeviceTest

// All code under test must be linked into the Unit Test bundle
- (void)testUuid
{
    NSString* theUuid = [SMDevice uuid];
    STAssertNotNil(theUuid, @"the uuid should not be nil");
    NSLog(@"the uuid: %@", theUuid);
}

@end
