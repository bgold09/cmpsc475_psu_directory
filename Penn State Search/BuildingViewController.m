//
//  BuildingViewController.m
//  Penn State Search
//
//  Created by BRIAN J GOLDEN on 10/10/13.
//  Copyright (c) 2013 BRIAN J GOLDEN. All rights reserved.
//

#import "BuildingViewController.h"
#import "BuildingImageViewController.h"
#import "BuildingTextViewController.h"
#import "AddBuildingViewController.h"
#import "MyDataManager.h"
#import "DataSource.h"
#import "DataManager.h"
#import "Building.h"
#import "Constants.h"

static NSString * const CellIdentifier = @"Cell";

@interface BuildingViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;
@property (strong, nonatomic) DataSource *dataSource;

@end

@implementation BuildingViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {        
        MyDataManager *myDataManager = [[MyDataManager alloc] init];
        _dataSource = [[DataSource alloc] initForEntity:@"Building" sortKeys:@[@"name"] predicate:nil sectionNameKeyPath:@"firstLetterOfName" dataManagerDelegate:myDataManager];
        _dataSource.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self.dataSource;
    self.dataSource.tableView = self.tableView;
    self.tableView.delegate = self;
    
    self.settingsButton.title = @"\u2699";
    UIFont *f1 = [UIFont fontWithName:@"Helvetica" size:24.0];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:f1, UITextAttributeFont, nil];
    [self.settingsButton setTitleTextAttributes:dict forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItems = @[self.settingsButton, self.editButtonItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadBuildingData:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadBuildingData:nil];
}

- (void)reloadBuildingData:(NSNotification *)notification {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSNumber *showAllBuildings = [preferences objectForKey:kShowAllBuildings];
    
    if (![showAllBuildings boolValue]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"image <> nil"];
        [self.dataSource updateWithPredicate:predicate];
    } else {
        [self.dataSource updateWithPredicate:nil];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Data Source Cell Configurer

- (NSString *)cellIdentifierForObject:(id)object {   
    return CellIdentifier;
}

- (void)configureCell:(UITableViewCell *)cell withObject:(id)object {
    Building *building = object;
    cell.textLabel.text = building.name;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - Editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

#pragma mark - Table View DataSource

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"BuildingTextSegue" sender:self];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"BuildingTextSegue"]) {
        BuildingTextViewController *infoViewController = segue.destinationViewController;
        __block Building *building = [self.dataSource objectAtIndexPath:self.tableView.indexPathForSelectedRow];
        infoViewController.building = building;
        infoViewController.completionBlock = ^(id obj) {
            NSString *newBuildingInfo = obj;
            building.info = newBuildingInfo;
            [[DataManager sharedInstance] saveContext];
        };
    } else if ([segue.identifier isEqualToString:@"AddBuildingSegue"]) {
        AddBuildingViewController *addBuildingViewController = segue.destinationViewController;
        addBuildingViewController.completionBlock = ^(id obj) {
            NSString *newBuildingName = obj;
            if (newBuildingName) {
                MyDataManager *myDataManager = [[MyDataManager alloc] init];
                [myDataManager addBuildingWithName:newBuildingName];
                [self reloadBuildingData:nil];
            }
        };
    }
}

@end
