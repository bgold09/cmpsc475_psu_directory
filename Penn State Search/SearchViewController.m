//
//  SearchViewController.m
//  Penn State Search
//
//  Created by BRIAN J GOLDEN on 10/1/13.
//  Copyright (c) 2013 BRIAN J GOLDEN. All rights reserved.
//

#import "SearchViewController.h"
#import "Model.h"

@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backPressed:(UIBarButtonItem *)sender;

@end

@implementation SearchViewController

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
    
    NSString *firstName = [self.searchTerms objectForKey:@"first-name"];
    NSString *lastName = [self.searchTerms objectForKey:@"last-name"];
    NSString *accessId = [self.searchTerms objectForKey:@"access-id"];
    NSArray *results = [self.model searchForPeopleWithFirstName:firstName andLastName:lastName andAccessId:accessId];
    
    self.model.directoryResults = results;
    self.tableView.dataSource = self;
    
    if ([self.model count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Results"
                                                        message:@"No results were found for your query."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backPressed:(UIBarButtonItem *)sender {
    [self.delegate dismissMe];
}

#pragma mark - Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.model count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text = [self.model displayNameForIndex:indexPath.row];
    cell.detailTextLabel.text = [self.model addressForIndex:indexPath.row];
    
    return cell;
}

@end
