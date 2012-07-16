//
//  Entry+Create.m
//  ExpenseEditor
//
//  Created by Daniel Tse on 13.3.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Entry+Create.h"

@implementation Entry (Create)

+ (Venue*) findVenueByName: (NSString*) venueName
                       moc: (NSManagedObjectContext*) moc {
    NSFetchRequest* req = [[NSFetchRequest alloc] initWithEntityName: @"Venue"];
    req.predicate = [NSPredicate predicateWithFormat: @"venue.name = %@", venueName];
    req.sortDescriptors = [NSArray arrayWithObject:
                           [NSSortDescriptor sortDescriptorWithKey: @"name" ascending: YES]];
    
    NSArray* results = [moc executeFetchRequest: req error: nil];
    if ([results count] > 0) return [results objectAtIndex: 0];
    return nil;
}

+ (Entry*) createWithMoc: (NSManagedObjectContext*) moc
              properties: (NSDictionary*) props {
    Entry* entry = [NSEntityDescription insertNewObjectForEntityForName: @"Entry"
                                             inManagedObjectContext: moc];
    
    entry.date = [props objectForKey: @"date"];
    entry.cost = [props objectForKey: @"cost"];
    entry.comment = [props objectForKey: @"comment"];
    
    entry.venue = [self findVenueByName: [props objectForKey: @"venueName"] moc: moc];
    
    return entry;
}

@end
