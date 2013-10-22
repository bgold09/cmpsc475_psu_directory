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
#import "MyDataManager.h"
#import "DataSource.h"
#import "Building.h"
#import "Constants.h"

static NSString * const CellIndentifierWithImage = @"CellWithImage";
static NSString * const CellIdentifierWithoutImage = @"CellWithoutImage";

@interface BuildingViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;
@property (strong, nonatomic) BuildingModel *model;
@property (strong, nonatomic) DataSource *dataSource;

@end

@implementation BuildingViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _model = [BuildingModel sharedInstance];
        
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSNumber *showAllBuildings = [preferences objectForKey:kShowAllBuildings];
    NSPredicate *predicate;
    
    if (![showAllBuildings boolValue]) {
        predicate = [NSPredicate predicateWithFormat:@"image <> nil"];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"image <> nil OR image = nil"];
    }
    
    [self.dataSource updateWithPredicate:predicate];
    [self.tableView reloadData];
}

#pragma mark - Data Source Cell Configurer

- (NSString *)cellIdentifierForObject:(id)object {
    Building *building = object;
    NSString *cellIdentifier;
    
    if (building.image) {
        cellIdentifier = CellIndentifierWithImage;
    } else {
        cellIdentifier = CellIdentifierWithoutImage;
    }
    
    return cellIdentifier;
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.reuseIdentifier isEqualToString:CellIndentifierWithImage]) {
        [self performSegueWithIdentifier:@"BuildingImageSegue" sender:self];
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"BuildingImageSegue"]) {
        BuildingImageViewController *imageViewController = segue.destinationViewController;
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.tableView.indexPathForSelectedRow];
        NSString *buildingName = cell.textLabel.text;
        imageViewController.buildingName = buildingName;
    }
}

@end
