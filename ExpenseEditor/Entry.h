//
//  Entry.h
//  ExpenseEditor
//
//  Created by Daniel Tse on 15.3.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Card, Venue;

@interface Entry : NSManagedObject

@property (nonatomic, retain) NSDate * comment;
@property (nonatomic, retain) NSNumber * cost;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSDate * modifiedDate;
@property (nonatomic, retain) Venue *venue;
@property (nonatomic, retain) Card *card;

@end
