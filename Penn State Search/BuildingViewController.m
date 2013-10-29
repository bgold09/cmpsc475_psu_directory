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
#import "MyDataManager.h"
#import "DataSource.h"
#import "Building.h"
#import "Constants.h"

static NSString * const CellIndentifierWithImage = @"CellWithImage";
static NSString * const CellIdentifierWithoutImage = @"CellWithoutImage";

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
    self.tableView.delegate = self;
    
    self.settingsButton.title = @"\u2699";
    UIFont *f1 = [UIFont fontWithName:@"Helvetica" size:24.0];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:f1, UITextAttributeFont, nil];
    [self.settingsButton setTitleTextAttributes:dict forState:UIControlStateNormal];
    
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
    Building *building = object;
    
    if (building.image) {
        return CellIndentifierWithImage;
    }
    
    return CellIdentifierWithoutImage;
}

- (void)configureCell:(UITableViewCell *)cell withObject:(id)object {
    Building *building = object;
    cell.textLabel.text = building.name;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"BuildingTextSegue" sender:self];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"BuildingImageSegue"]) {
        BuildingImageViewController *imageViewController = segue.destinationViewController;
        Building *building = [self.dataSource objectAtIndexPath:self.tableView.indexPathForSelectedRow];
        imageViewController.building = building;
    } else if ([segue.identifier isEqualToString:@"BuildingTextSegue"]) {
        BuildingTextViewController *infoViewController = segue.destinationViewController;
        Building *building = [self.dataSource objectAtIndexPath:self.tableView.indexPathForSelectedRow];
        infoViewController.building = building;
    }
}

@end
