//
//  ExpenseSendPopoverViewController.h
//  ExpenseEditor
//
//  Created by Daniel Tse on 14.3.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MessageUI/MessageUI.h>

@interface ExpenseSendPopoverViewController : UIViewController <MFMailComposeViewControllerDelegate>

- (IBAction)didTapDeleteAll:(id)sender;
- (IBAction)didTapSend:(id)sender;
@end
