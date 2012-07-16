//
//  ExpenseAppDelegate.m
//  ExpenseEditor
//
//  Created by Daniel Tse on 13.3.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExpenseAppDelegate.h"
#import "ExpenseMasterViewController.h"
#import "Entry.h"

@implementation ExpenseAppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (void) vacuumVenues: (NSNotification*) note {
    NSManagedObjectContext *moc = [note object];
    NSManagedObjectModel *mom = [[moc persistentStoreCoordinator] managedObjectModel];
    NSEntityDescription *venueEntity = [[mom entitiesByName] objectForKey:@"Venue"];
    for (NSManagedObject *venue in [moc updatedObjects]) {
        if ([venue entity] == venueEntity) {
            if (![venue hasFaultForRelationshipNamed:@"entries"] &&
                [[venue valueForKeyPath: @"entries"] count] == 0) {
                [moc deleteObject: venue];
            }
        }
    }
    
    NSFetchRequest* req = [NSFetchRequest fetchRequestWithEntityName: @"Entry"];
    NSUInteger entryCount = [__managedObjectContext countForFetchRequest: req error: nil];
    if (entryCount == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName: ExpenseClearedAll
                                                            object: nil];
    }
}

- (void) setModifiedTimestamps: (NSNotification*) note {
    NSManagedObjectContext* moc = note.object;
    
    NSDate* now = [NSDate date];
    for (id obj in [moc updatedObjects]) {
        if ([obj isKindOfClass: [Entry class]]) {
            Entry* entry = (Entry*)obj;
            entry.modifiedDate = now;
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    splitViewController.delegate = (id)navigationController.topViewController;
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(vacuumVenues:)
                                                 name: NSManagedObjectContextObjectsDidChangeNotification
                                               object: self.managedObjectContext];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(setModifiedTimestamps:)
                                                 name: NSManagedObjectContextWillSaveNotification
                                               object: self.managedObjectContext];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ExpenseEditor" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ExpenseEditor.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(void)deleteAll {
    NSFetchRequest* req = [[NSFetchRequest alloc] initWithEntityName: @"Entry"];
    req.includesPropertyValues = NO;
    
    NSArray* allObjects = [self.managedObjectContext executeFetchRequest: req
                                                                   error: nil];
    for (id object in allObjects) {
        [self.managedObjectContext deleteObject: object];
    }
    
    req = [[NSFetchRequest alloc] initWithEntityName: @"Card"];
    
    allObjects = [self.managedObjectContext executeFetchRequest: req
                                                                   error: nil];
    for (id object in allObjects) {
        [self.managedObjectContext deleteObject: object];
    }

    [self saveContext];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: ExpenseClearedAll
                                                        object: nil];
    [[NSNotificationCenter defaultCenter] postNotificationName: ExpenseAddedCard
                                                        object: nil];
}

@end
