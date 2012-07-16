//
//  Venue+Create.h
//  ExpenseEditor
//
//  Created by Daniel Tse on 13.3.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Venue.h"

@interface Venue (Create)

+ (Venue*) findInMoc: (NSManagedObjectContext*) moc
                name: (NSString*) name
            location: (NSString*) location;

+ (Venue*) createWithMoc: (NSManagedObjectContext*) moc
                    name: (NSString*) name 
                location: (NSString*) location;

@end
