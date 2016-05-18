//
//  AppDelegate.h
//  ActivityDemo
//
//  Created by Кравченко Максим on 5/18/16.
//  Copyright © 2016 Кравченко Максим. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

typedef enum : NSInteger
{
	kActivityTypeCall = 0,
	kActivityTypeMeeting,
	kActivityTypeTask
} ActivityType;

typedef enum : NSInteger
{
	kActivityStatusOutdated = 0,
	kActivityStatusActual,
	kActivityStatusCompleted
} ActivityStatus;

extern NSString *kActivityKey;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

