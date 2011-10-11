//
//  SMPersistencyManager.h
//  Whasta
//
//  Created by Suleyman Melikoglu on 9/15/11.
//  Copyright 2011 Bogazici University. All rights reserved.
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
