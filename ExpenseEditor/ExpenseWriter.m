//
//  ExpenseWriter.m
//  ExpenseEditor
//
//  Created by Daniel Tse on 14.3.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExpenseWriter.h"
#import "CHCSV.h"
#import "Entry.h"
#import "Venue.h"
#import "Card.h"

@implementation ExpenseWriter

@synthesize app;

- (id)init
{
    self = [super init];
    if (self) {
        self.app = (ExpenseAppDelegate*)[UIApplication sharedApplication].delegate;
    }
    return self;
}

- (void) backup {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:@"backup.csv"];
    
    NSManagedObjectContext* moc = self.app.managedObjectContext;
    
    CHCSVWriter* writer = [[CHCSVWriter alloc] initWithCSVFile: folderPath
                                                        atomic: YES];
    
    NSFetchRequest* req = [[NSFetchRequest alloc] initWithEntityName: @"Entry"];
    req.predicate = nil;
    req.sortDescriptors = [NSArray arrayWithObject:
                           [NSSortDescriptor sortDescriptorWithKey: @"modifiedDate"
                                                         ascending: YES]];
    NSArray* results = [moc executeFetchRequest: req error: nil];
    
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"dd/MM/yyyy";
    
    for (Entry* result in results) {
        [writer writeLineOfFields:
         [fmt stringFromDate: result.date], 
         result.venue.name, 
         result.venue.location,
         [NSString stringWithFormat: @"%.2f", [result.cost floatValue]],
         result.card.name,
         nil];
    }
}

- (NSString*) dataToCSV {
    NSManagedObjectContext* moc = self.app.managedObjectContext;
    
    CHCSVWriter* writer = [[CHCSVWriter alloc] initForWritingToString];
    
    NSFetchRequest* req = [[NSFetchRequest alloc] initWithEntityName: @"Entry"];
    req.predicate = nil;
    req.sortDescriptors = [NSArray arrayWithObject:
                           [NSSortDescriptor sortDescriptorWithKey: @"modifiedDate"
                                                         ascending: YES]];
    NSArray* results = [moc executeFetchRequest: req error: nil];
    
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"dd/MM/yyyy";
    
    for (Entry* result in results) {
        [writer writeLineOfFields:
         [fmt stringFromDate: result.date], 
         result.venue.name, 
         result.venue.location,
         [NSString stringWithFormat: @"%.2f", [result.cost floatValue]],
         result.card.name,
         nil];
    }
    
    return [writer stringValue];
}

@end
