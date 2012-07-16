//
//  ExpenseMasterViewController.h
//  ExpenseEditor
//
//  Created by Daniel Tse on 13.3.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class ExpenseDetailViewController;

#import <CoreData/CoreData.h>

@interface ExpenseMasterViewController : BaseViewController

@property (strong, nonatomic) ExpenseDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
