//
//  ResultDetailViewController.m
//  Penn State Search
//
//  Created by BRIAN J GOLDEN on 10/7/13.
//  Copyright (c) 2013 BRIAN J GOLDEN. All rights reserved.
//

#import "ResultDetailViewController.h"
#import "Model.h"

@interface ResultDetailViewController ()
@property (nonatomic, strong) Model *model;
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
        _model = [Model sharedInstance];
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
    
    NSInteger correctedSectionIndex = [self.model fieldNumberWithValuesForIndex:self.resultNumber andFieldNumber:indexPath.section];
    switch (correctedSectionIndex) {
        case 0:
            CellIndentifier = @"TitleCell";
            cellTitle = [self.model titleForIndex:self.resultNumber];
            break;
        case 1:
            CellIndentifier = @"PrimaryAffiliationCell";
            cellTitle = [self.model personPrimaryAffiliationForIndex:self.resultNumber];
            break;
        case 2:
            CellIndentifier = @"EmailAddressCell";
            cellTitle = [self.model mailIdForIndex:self.resultNumber andMailIdNumber:indexPath.row];
            break;
        case 3:
            CellIndentifier = @"PostalAddressCell";
            cellTitle = [self.model postalAddressForIndex:self.resultNumber];
            break;
        default:
            CellIndentifier = @"TitleCell";
            cellTitle = [self.model titleForIndex:self.resultNumber];
            break;
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