//
//  EntryCell.h
//  ExpenseEditor
//
//  Created by Daniel Tse on 14.3.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntryCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* mainLabel;
@property (nonatomic, weak) IBOutlet UILabel* subtitleLabel;
@property (nonatomic, weak) IBOutlet UILabel* rightLabel;

@end
