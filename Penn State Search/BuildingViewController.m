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

@interface BuildingViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) BuildingModel *model;
@property NSInteger buildingNumber;

@end

@implementation BuildingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _model = [BuildingModel sharedInstance];
        [_model sortByBuildingName];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.model count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    cell.textLabel.text = [self.model nameForIndex:indexPath.row];
    
    if ([self.model hasImageForIndex:indexPath.row]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
//        BuildingImageViewController *imageViewContoller =
//            [self.storyboard instantiateViewControllerWithIdentifier:@"BuildingImageView"];
//        imageViewContoller.buildingNumber = indexPath.row;
//        [self.navigationController pushViewController:imageViewContoller animated:YES];
        self.buildingNumber = indexPath.row;
        [self performSegueWithIdentifier:@"BuildingImageSegue" sender:self];
        
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"BuildingImageSegue"]) {
        BuildingImageViewController *imageViewController = segue.destinationViewController;
        imageViewController.buildingNumber = self.buildingNumber;
        imageViewController.buildingName = [self.model nameForIndex:self.buildingNumber];
    }
}

@end
