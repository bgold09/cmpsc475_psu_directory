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
    [self bringUpContactView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bringUpContactView {
    
}

@end
