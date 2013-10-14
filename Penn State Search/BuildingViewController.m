//
//  BuildingViewController.m
//  Penn State Search
//
//  Created by BRIAN J GOLDEN on 10/10/13.
//  Copyright (c) 2013 BRIAN J GOLDEN. All rights reserved.
//

#import "BuildingViewController.h"
#import "BuildingImageViewController.h"
#import "BuildingModel.h"

static NSString * const CellIndentifierWithImage = @"CellWithImage";
static NSString * const CellIdentifierWithoutImage = @"CellWithoutImage";

@interface BuildingViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) BuildingModel *model;

@end

@implementation BuildingViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _model = [BuildingModel sharedInstance];
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
    NSString *cellIdentifier;
    
    if ([self.model hasImageForIndex:indexPath.row]) {
        cellIdentifier = CellIndentifierWithImage;
    } else {
        cellIdentifier = CellIdentifierWithoutImage;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.textLabel.text = [self.model nameForIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.reuseIdentifier isEqualToString:CellIndentifierWithImage]) {
        [self performSegueWithIdentifier:@"BuildingImageSegue" sender:self];
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"BuildingImageSegue"]) {
        NSInteger buildingNumber = self.tableView.indexPathForSelectedRow.row;
        BuildingImageViewController *imageViewController = segue.destinationViewController;
        imageViewController.buildingNumber = buildingNumber;
        imageViewController.buildingName = [self.model nameForIndex:buildingNumber];
    }
}

@end
