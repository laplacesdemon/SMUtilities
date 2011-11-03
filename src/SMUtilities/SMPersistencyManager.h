//
//  SMPersistencyManager.h
//  Whasta
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


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SMPersistencyManager : NSObject {

}

@property (nonatomic, retain, readonly) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel* managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator* persistentStoreCoordinator;

- (BOOL)hasChanges;

// class methods
- (BOOL)saveContext;
- (BOOL)deleteObject:(NSManagedObject*)managedObject;
- (NSArray*)fetchWithEntityName:(NSString*)name;
- (NSArray*)fetchWithEntityName:(NSString*)name andSortKey:(NSString*)sortKey ascending:(BOOL)ascending;
- (NSArray*)fetchWithEntityName:(NSString*)name andPredicate:(NSString*)predicateString andArguments:(NSString*)predicateArguments;
- (id)createModelWithName:(NSString*)name;
- (NSDate*)lastUpdateDateForEntity:(NSString*)entity;
- (void)saveLastUpdateDateForEntity:(NSString*)entity;

// helper methods
- (NSURL*)applicationDocumentsDirectory;

@end
