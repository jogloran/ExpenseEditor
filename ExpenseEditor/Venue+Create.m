//
//  Venue+Create.m
//  ExpenseEditor
//
//  Created by Daniel Tse on 13.3.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Venue.h"
#import "Venue+Create.h"

@implementation Venue (Create)

+ (Venue*) findInMoc: (NSManagedObjectContext*) moc
                name: (NSString*) name
            location: (NSString*) location {
    NSFetchRequest* req = [NSFetchRequest fetchRequestWithEntityName: @"Venue"];
    req.predicate = [NSPredicate predicateWithFormat: @"name == %@ AND location == %@", name, location];
    req.sortDescriptors = [NSArray arrayWithObject: 
                           [NSSortDescriptor sortDescriptorWithKey: @"name"
                                                         ascending: YES]];
    
    NSArray* results = [moc executeFetchRequest: req  error: nil];
    if ([results count] > 0) return [results objectAtIndex: 0];
    return nil;
}

+ (Venue*) createWithMoc: (NSManagedObjectContext*) moc
                    name: (NSString*) name 
                location: (NSString*) location {
    Venue* entry = [Venue findInMoc: moc name: name location: location];
    if (entry != nil) return entry;
    
    entry = [NSEntityDescription insertNewObjectForEntityForName: @"Venue"
                                                 inManagedObjectContext: moc];
    entry.name = name;
    entry.location = location;
    
    return entry;
}

@end
