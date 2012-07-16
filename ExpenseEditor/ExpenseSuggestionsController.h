//
//  ExpenseSuggestionsController.h
//  ExpenseEditor
//
//  Created by Daniel Tse on 14.3.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol ExpenseCompletionDelegate <NSObject>
- (void) didCompleteWith: (id) value;
@end

@interface ExpenseSuggestionsController : BaseViewController <UIPopoverControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) id<ExpenseCompletionDelegate> delegate;

- (void) reloadData;

@end
