//
//  Card+Create.m
//  ExpenseEditor
//
//  Created by Daniel Tse on 15.3.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Card+Create.h"

@implementation Card (Create)

+(Card *)findInMoc:(NSManagedObjectContext *)moc name:(NSString *)name {
    NSFetchRequest* req = [NSFetchRequest fetchRequestWithEntityName: @"Card"];
    req.predicate = [NSPredicate predicateWithFormat: @"name == %@", name];
    req.sortDescriptors = [NSArray arrayWithObject: 
                           [NSSortDescriptor sortDescriptorWithKey: @"name"
                                                         ascending: YES]];
    
    NSArray* results = [moc executeFetchRequest: req  error: nil];
    if ([results count] > 0) return [results objectAtIndex: 0];
    return nil;
}

+(Card *)createWithMoc:(NSManagedObjectContext *)moc name:(NSString *)name {
    Card* entry = [Card findInMoc: moc name: name];
    if (entry != nil) return entry;
    
    entry = [NSEntityDescription insertNewObjectForEntityForName: @"Card"
                                          inManagedObjectContext: moc];
    entry.name = name;
    
    return entry;
}
@end