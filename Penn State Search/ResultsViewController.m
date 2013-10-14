//
//  SearchViewController.m
//  Penn State Search
//
//  Created by BRIAN J GOLDEN on 10/1/13.
//  Copyright (c) 2013 BRIAN J GOLDEN. All rights reserved.
//

#import "ResultsViewController.h"
#import "ResultDetailViewController.h"
#import "DirectoryModel.h"

@interface ResultsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) DirectoryModel *model;

@end

@implementation ResultsViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _model = [DirectoryModel sharedInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
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
    cell.detailTextLabel.text = [self.model postalAddressForIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"DetailSegue" sender:self];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DetailSegue"]) {
        ResultDetailViewController *detailViewController = segue.destinationViewController;
        detailViewController.resultNumber = self.tableView.indexPathForSelectedRow.row;
    }
}

@end
