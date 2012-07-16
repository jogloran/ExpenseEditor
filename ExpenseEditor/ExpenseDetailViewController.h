//
//  ExpenseDetailViewController.h
//  ExpenseEditor
//
//  Created by Daniel Tse on 13.3.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entry.h"
#import "Venue.h"
#import "ExpenseSuggestionsController.h"
#import "ExpenseWriter.h"

@interface ExpenseDetailViewController : UIViewController <UISplitViewControllerDelegate, UITextFieldDelegate, ExpenseCompletionDelegate> {
    CGPoint oldOffset;
    
    NSDate* lastEntered;
    
    ExpenseWriter* writer;
}

@property (strong, nonatomic) Entry* entry;
 
@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (weak, nonatomic) IBOutlet UITextField *placeField;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UITextField *costField;

@property (weak, nonatomic) NSManagedObjectContext* moc;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UIPopoverController* pc;
@property (strong, nonatomic) ExpenseSuggestionsController* sc;

- (IBAction) toggleSettingsInPopover: (id) sender;
@property (nonatomic, strong) UIStoryboardPopoverSegue* sendPopoverSegue;

@property (weak, nonatomic) IBOutlet UISegmentedControl *cardTypes;

- (IBAction)didEditCard:(UISegmentedControl *)sender;

- (IBAction)beganEditingVenue:(UITextField *)sender;
- (IBAction)beganEditingCost:(UITextField *)sender;
- (IBAction)didEditVenue:(UITextField *)sender;

- (IBAction)finishedEditingVenue:(id)sender;
- (IBAction)finishedEditingCost:(id)sender;

@end
