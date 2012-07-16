//
//  Card+Create.h
//  ExpenseEditor
//
//  Created by Daniel Tse on 15.3.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Card.h"

@interface Card (Create)

+ (Card*) findInMoc: (NSManagedObjectContext*) moc
               name: (NSString*) name;

+ (Card*) createWithMoc: (NSManagedObjectContext*) moc
                   name: (NSString*) name;

@end
