//
//  ExpenseSendPopoverViewController.m
//  ExpenseEditor
//
//  Created by Daniel Tse on 14.3.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExpenseSendPopoverViewController.h"
#import "ExpenseWriter.h"

#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ExpenseSendPopoverViewController ()

@end

@implementation ExpenseSendPopoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)didTapDeleteAll:(id)sender {
    ExpenseAppDelegate* app = (ExpenseAppDelegate*)[UIApplication sharedApplication].delegate;
    [app deleteAll];
}

- (IBAction)didTapSend:(id)sender {
    ExpenseWriter* writer = [[ExpenseWriter alloc] init];
    NSString* result = [writer dataToCSV];
    
    MFMailComposeViewController* cvc = [[MFMailComposeViewController alloc] init];
    cvc.mailComposeDelegate = self;
    
    [cvc setModalPresentationStyle: UIModalPresentationPageSheet];
    [cvc setSubject: @"Expense file attached"];
    [cvc setMessageBody: @"The Expense file is attached to this e-mail." isHTML: NO];
    [cvc addAttachmentData: [result dataUsingEncoding: NSUTF8StringEncoding]
                  mimeType: @"text/plain"
                  fileName: @"Expense.csv"];
    
    [self presentViewController: cvc animated: YES completion: ^{}];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated: YES completion: ^{}];
}
@end
