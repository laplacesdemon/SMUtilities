//
//  WSRestClientWithDefaultStrategyTest.h
//  Whasta
//
//  Created by Suleyman Melikoglu on 9/21/11.
//  Copyright 2011 Bogazici University. All rights reserved.
//  https://github.com/laplacesdemon/SMUtilities
//
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html
//  SMUtilities is a compilation of useful utilities for iOS
//  Copyright (C) 2011 Suleyman Melikoglu suleyman@melikoglu.info
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

//  Application unit tests contain unit test code that must be injected into an application to run correctly.
//  Define USE_APPLICATION_UNIT_TEST to 0 if the unit test code is designed to be linked into an independent test executable.

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "SMRestClient.h"

/**
 * The integration tests for the rest client, 
 * The tests communicate with the twitter api as the source
 */
@interface SMRestClientIntegrationTest : SenTestCase <SMRestClientDelegate> 

- (void)testItems;   
- (void)testSingleItem;   
- (void)testError;   

@end
