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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backPressed:(UIBarButtonItem *)sender {
    [self.delegate dismissMe];
}

@end
