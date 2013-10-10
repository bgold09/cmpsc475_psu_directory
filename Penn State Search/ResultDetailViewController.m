//
//  ResultDetailViewController.m
//  Penn State Search
//
//  Created by BRIAN J GOLDEN on 10/7/13.
//  Copyright (c) 2013 BRIAN J GOLDEN. All rights reserved.
//

#import "ResultDetailViewController.h"
#import "DirectoryModel.h"

@interface ResultDetailViewController ()
@property (nonatomic, strong) DirectoryModel *model;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ResultDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

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
    self.title = [self.model displayNameForIndex:self.resultNumber];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.model numberOfFieldsWithValuesForIndex:self.resultNumber];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger correctedSectionIndex = [self.model fieldNumberWithValuesForIndex:self.resultNumber andFieldNumber:section];
    return [self.model numberOfValuesForFieldForIndex:self.resultNumber andFieldIndex:correctedSectionIndex];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIndentifier;
    NSString *cellTitle;
    
    NSString *sectionHeader = [self tableView:self.tableView titleForHeaderInSection:indexPath.section];
    
    if ([sectionHeader isEqualToString:@"Title"]) {
        CellIndentifier = @"TitleCell";
        cellTitle = [self.model titleForIndex:self.resultNumber];
    } else if ([sectionHeader isEqualToString:@"Primary Affiliation"]) {
        CellIndentifier = @"PrimaryAffiliationCell";
        cellTitle = [self.model personPrimaryAffiliationForIndex:self.resultNumber];
    } else if ([sectionHeader isEqualToString:@"Email Address"]) {
        CellIndentifier = @"EmailAddressCell";
        cellTitle = [self.model mailIdForIndex:self.resultNumber andMailIdNumber:indexPath.row];
    } else if ([sectionHeader isEqualToString:@"Postal Address"]) {
        CellIndentifier = @"PostalAddressCell";
        cellTitle = [self.model postalAddressForIndex:self.resultNumber];
    } else {
        CellIndentifier = @"TitleCell";
        cellTitle = [self.model titleForIndex:self.resultNumber];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIndentifier];
    }

    cell.textLabel.text = cellTitle;
    
    return cell;
}

#pragma mark - TableView Delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSInteger correctedSectionIndex = [self.model fieldNumberWithValuesForIndex:self.resultNumber andFieldNumber:section];
    return [self.model fieldNameForIndex:correctedSectionIndex];
}

@end
