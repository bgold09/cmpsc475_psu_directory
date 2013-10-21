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
#import "Constants.h"

static NSString * const CellIndentifierWithImage = @"CellWithImage";
static NSString * const CellIdentifierWithoutImage = @"CellWithoutImage";

@interface BuildingViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;
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
    
    self.settingsButton.title = @"\u2699";
    UIFont *f1 = [UIFont fontWithName:@"Helvetica" size:24.0];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:f1, UITextAttributeFont, nil];
    [self.settingsButton setTitleTextAttributes:dict forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

#pragma mark - Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSNumber *showAllBuildings = [preferences objectForKey:kShowAllBuildings];
    return [showAllBuildings boolValue] ? [self.model count] : [self.model countWithImages];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier;
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSNumber *showAllBuildings = [preferences objectForKey:kShowAllBuildings];
    
    NSInteger index;
    
    if ([showAllBuildings boolValue]) {
        index = indexPath.row;
    } else {
        index = [self.model indexForBuildingWithImageNumber:indexPath.row];
    }
    
    if (![showAllBuildings boolValue] || [self.model hasImageForIndex:index]) {
        cellIdentifier = CellIndentifierWithImage;
    } else {
        cellIdentifier = CellIdentifierWithoutImage;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.textLabel.text = [self.model nameForIndex:index];
    
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
        NSInteger buildingNumber;
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        NSNumber *showAllBuildings = [preferences objectForKey:kShowAllBuildings];
        
        if ([showAllBuildings boolValue]) {
            buildingNumber = self.tableView.indexPathForSelectedRow.row;
        } else {
            buildingNumber =
                [self.model indexForBuildingWithImageNumber:self.tableView.indexPathForSelectedRow.row];
        }
        
        BuildingImageViewController *imageViewController = segue.destinationViewController;
        imageViewController.buildingNumber = buildingNumber;
        imageViewController.buildingName = [self.model nameForIndex:buildingNumber];
    }
}

@end
