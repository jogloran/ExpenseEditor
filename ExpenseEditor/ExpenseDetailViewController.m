//
//  ExpenseDetailViewController.m
//  ExpenseEditor
//
//  Created by Daniel Tse on 13.3.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExpenseAppDelegate.h"
#import "ExpenseDetailViewController.h"
#import "Venue+Create.h"
#import "DateInputView.h"
#import "Card+Create.h"

@interface ExpenseDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation ExpenseDetailViewController

@synthesize entry = _entry;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize placeField = _placeField;
@synthesize dateField = _dateField;
@synthesize locationField = _locationField;
@synthesize costField = _costField;
@synthesize masterPopoverController = _masterPopoverController;

@synthesize moc;
@synthesize scrollView = _scrollView;

@synthesize pc;
@synthesize sc;

@synthesize sendPopoverSegue;
@synthesize cardTypes = _cardTypes;

#pragma mark - Managing the detail item

- (void) selectSegmentWithTitle: (NSString*) title {
    self.cardTypes.selectedSegmentIndex = -1;
    for (NSUInteger i = 0; i < self.cardTypes.numberOfSegments; ++i) {
        if ([[self.cardTypes titleForSegmentAtIndex: i] isEqualToString: title]) {
            self.cardTypes.selectedSegmentIndex = i;
            break;
        }
    }    
}

- (void) didChangeCardTypes {
    [self.cardTypes removeAllSegments];
    
    NSFetchRequest* req = [NSFetchRequest fetchRequestWithEntityName: @"Card"];
    req.predicate = nil;
    req.sortDescriptors = [NSArray arrayWithObject: [NSSortDescriptor sortDescriptorWithKey: @"name"
                                                                                  ascending: NO]]; // ascending: NO to get the right order in segments
    NSArray* types = [self.moc executeFetchRequest: req error: nil];
    for (Card* type in types) {
        [self.cardTypes insertSegmentWithTitle: type.name atIndex: 0 animated: YES];
    }
    
    [self selectSegmentWithTitle: self.entry.card.name];
}

- (void) setLastEnteredDate: (NSDate*) date {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: date forKey: @"lastEnteredDate"];
    [defaults synchronize];    
}

- (NSDate*) lastEnteredDate {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    id date = [defaults objectForKey: @"lastEnteredDate"];
    if (date == nil) {
        date = [NSDate date];
        [defaults setObject: date forKey: @"lastEnteredDate"];
        [defaults synchronize];
    }
    
    return date;
}

- (void) setLastSelectedCard: (NSString*) card {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: card forKey: @"lastSelectedCard"];
    [defaults synchronize];    
}

- (NSString*) lastSelectedCard {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    id card = [defaults objectForKey: @"lastSelectedCard"];
    
    return card;
}

- (void)setEntry:(id)newEntry
{
    if (_entry != newEntry) {
        _entry = newEntry;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.entry) {
        [self updateVenue];
        
        [self updateCost];

        [self updateDate];
    }
}

- (void) save {
    [writer backup];
    
    [self.moc save: nil];
}

- (void) updateCost {
    if (self.entry.card.name != nil) {
        [self selectSegmentWithTitle: self.entry.card.name];
    } else {
        [self selectSegmentWithTitle: [self lastSelectedCard]];
        self.entry.card = [Card findInMoc: moc name: [self lastSelectedCard]];
    }
    
    self.costField.text = [NSString stringWithFormat: @"%.2f", 
                           [self.entry.cost floatValue]];
}

- (void) updateVenue {
    self.placeField.text = self.entry.venue.name;
    self.locationField.text = self.entry.venue.location;
}

- (void) updateDate {
    // change the currently selected date in the date picker
    if (_entry.date == nil) {
        _entry.date = [self lastEnteredDate];
    }
    ((DateInputView*)self.dateField.inputView).datePicker.date = _entry.date;
    
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"dd/MM/yyyy";
    
    self.dateField.text = [fmt stringFromDate: self.entry.date];
}

- (void) didChangeDateValue: (id) sender {
    self.entry.date = ((UIDatePicker*)sender).date;
    
    [self setLastEnteredDate: self.entry.date];
    
    [self updateDate];
    [self save];
}

- (void) didTapNext: (id) sender {
    [self.costField becomeFirstResponder];
}

- (void) enableEditing: (id) sender {
    self.locationField.enabled = YES;
    self.placeField.enabled = YES;
    self.costField.enabled = YES;
    self.dateField.enabled = YES;
}

- (void) disableEditing: (id) sender {
    self.locationField.enabled = NO;
    self.placeField.enabled = NO;
    self.costField.enabled = NO;
    self.dateField.enabled = NO;
    
    self.locationField.text = self.placeField.text = self.costField.text = self.dateField.text = @"";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    writer = [[ExpenseWriter alloc] init];

    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(didChangeCardTypes)
                                                 name: ExpenseAddedCard
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(enableEditing:)
                                                 name: ExpenseAddedEntry
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(disableEditing:)
                                                 name: ExpenseClearedAll
                                               object: nil];
    
    self.moc = ((ExpenseAppDelegate*)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    [self didChangeCardTypes];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    NSArray* views = [[NSBundle mainBundle] loadNibNamed: @"DateInputView"
                                                   owner: self options: nil];
    DateInputView* div = [views objectAtIndex: 0];
    div.autoresizingMask = UIViewAutoresizingNone;
    
    div.datePicker.datePickerMode = UIDatePickerModeDate;
    [div.datePicker addTarget: self action: @selector(didChangeDateValue:)
             forControlEvents: UIControlEventValueChanged];
    
    div.nextButton.target = self;
    div.nextButton.action = @selector(didTapNext:);
    
    self.dateField.inputView = div;
    
    lastEntered = [self lastEnteredDate];
    
    [self configureView];
}

- (void)viewDidUnload
{
    [self setPlaceField:nil];
    [self setDateField:nil];
    [self setCostField:nil];
    [self setScrollView:nil];
    [self setCardTypes:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.detailDescriptionLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (void) initiateSuggestionsWithString: (NSString*) partial {
    NSFetchRequest* req = [NSFetchRequest fetchRequestWithEntityName: @"Venue"];
    
    if ([partial length] == 0) {
        req.predicate = nil;
    } else {
        req.predicate = [NSPredicate predicateWithFormat: @"name beginswith[cd] %@", partial];
    }
    
    req.sortDescriptors = [NSArray arrayWithObject: [NSSortDescriptor sortDescriptorWithKey: @"name" ascending: YES]];
    
    NSFetchedResultsController* frc = [[NSFetchedResultsController alloc] initWithFetchRequest: req
                                                                          managedObjectContext: moc
                                                                            sectionNameKeyPath: nil cacheName: @"Suggestions"];
    self.sc.fetchedResultsController = frc;
    [self.sc.fetchedResultsController performFetch: nil];

    [self.sc reloadData]; // why is this necessary?
}

- (void)didCompleteWith:(Venue*) venue {
    self.entry.venue = venue;
    [self save];

    [self updateVenue];
    [self.pc dismissPopoverAnimated: YES];
}

- (IBAction)didEditCard:(UISegmentedControl *)sender {
    NSString* name = [sender titleForSegmentAtIndex: sender.selectedSegmentIndex];
    self.entry.card = [Card findInMoc: moc name: name];
    
    [self setLastSelectedCard: name];
    
    [self save];
}

- (IBAction)beganEditingVenue:(UITextField *)sender {
    oldOffset = self.scrollView.contentOffset;
    
    CGRect bounds = [self.placeField convertRect: self.placeField.bounds toView: self.scrollView];
    bounds.origin.x = 0;
    bounds.origin.y -= 60;
    [self.scrollView setContentOffset: bounds.origin animated: YES];
    
    if (self.sc == nil) {
        self.sc = [[ExpenseSuggestionsController alloc] initWithNibName: @"ExpenseSuggestionsView" bundle: [NSBundle mainBundle]];
        
        self.pc = [[UIPopoverController alloc] initWithContentViewController: self.sc];
        
        self.pc.delegate = self.sc;
        self.pc.passthroughViews = [NSArray arrayWithObjects: self.view, nil];
        
        self.sc.delegate = self;
    }
    
    [self.pc presentPopoverFromRect: self.placeField.bounds
                             inView: self.placeField
           permittedArrowDirections: UIPopoverArrowDirectionAny
                           animated: YES];
     
    [self initiateSuggestionsWithString: sender.text];
}

- (IBAction)didEditVenue:(UITextField *)sender {
    if (![self.pc isPopoverVisible]) {
        [self.pc presentPopoverFromRect: self.placeField.bounds
                                 inView: self.placeField
               permittedArrowDirections: UIPopoverArrowDirectionAny
                               animated: YES];
    }
    
    [self initiateSuggestionsWithString: sender.text];
}

- (IBAction)finishedEditingVenue:(UITextField*)sender {
    [self.scrollView setContentOffset: oldOffset animated: YES];
    oldOffset = CGPointZero;
    
    self.entry.venue = [Venue createWithMoc: self.moc 
                                       name: sender.text
                                   location: self.locationField.text];
    [self save];
    
    [self.pc dismissPopoverAnimated: YES];
}

- (IBAction)finishedEditingLocation:(UITextField *)sender {
    self.entry.venue.location = sender.text;
    [self save];
}

- (IBAction)beganEditingDate:(UITextField *)sender {    
    [self updateDate];
}

- (IBAction)beganEditingCost:(UITextField *)sender {
    oldOffset = self.scrollView.contentOffset;
    
    CGRect bounds = [self.costField convertRect: self.costField.bounds toView: self.scrollView];
    bounds.origin.x = 0;
    bounds.origin.y -= 60;
    [self.scrollView setContentOffset: bounds.origin animated: YES];
}

- (IBAction)finishedEditingCost:(UITextField*)sender {
    [self.scrollView setContentOffset: oldOffset animated: YES];
    oldOffset = CGPointZero;
    
    self.entry.cost = [NSNumber numberWithFloat: [sender.text floatValue]];
    self.costField.text = [NSString stringWithFormat: @"%.2f", [self.entry.cost floatValue]];
    
    [self save];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    UIView* view = [self.scrollView viewWithTag: textField.tag+1];
    if (view == nil) {
        [textField resignFirstResponder];
        return YES;
    } else {
        [view becomeFirstResponder];
        return NO;
    }
}

- (IBAction) toggleSettingsInPopover: (id) sender {
    if (self.sendPopoverSegue.popoverController.isPopoverVisible) {
        [self.sendPopoverSegue.popoverController dismissPopoverAnimated: YES];
        self.sendPopoverSegue = nil;
    } else {
        [self performSegueWithIdentifier: @"SendPopoverSegue" sender: sender];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: @"SendPopoverSegue"]) {
        self.sendPopoverSegue = (UIStoryboardPopoverSegue*)segue;
    }
}

@end
