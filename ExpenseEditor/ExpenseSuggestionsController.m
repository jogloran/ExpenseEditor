//
//  ExpenseSuggestionsController.m
//  ExpenseEditor
//
//  Created by Daniel Tse on 14.3.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExpenseSuggestionsController.h"
#import "Venue.h"

@interface ExpenseSuggestionsController ()

@end

@implementation ExpenseSuggestionsController
@synthesize tableView;
@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) reloadData {
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* ident = @"SuggestionCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: ident];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle
                                      reuseIdentifier: ident];
    }
    
    Venue* venue = [self.fetchedResultsController objectAtIndexPath: indexPath];
    cell.textLabel.text = venue.name;
    cell.detailTextLabel.text = venue.location;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate) {
        Venue* value = (Venue*)[self.fetchedResultsController objectAtIndexPath: indexPath];
        [self.delegate didCompleteWith: value];
    }
}

@end
