//
//  DateInputView.h
//  ExpenseEditor
//
//  Created by Daniel Tse on 14.3.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateInputView : UIView

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;

@end
