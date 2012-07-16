//
//  ExpenseWriter.h
//  ExpenseEditor
//
//  Created by Daniel Tse on 14.3.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExpenseAppDelegate.h"

@interface ExpenseWriter : NSObject

@property (nonatomic, weak) ExpenseAppDelegate* app;

- (void) backup;
- (NSString*) dataToCSV;

@end
