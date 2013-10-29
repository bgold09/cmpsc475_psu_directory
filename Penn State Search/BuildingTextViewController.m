//
//  BuildingInfoViewController.m
//  Penn State Search
//
//  Created by BRIAN J GOLDEN on 10/28/13.
//  Copyright (c) 2013 BRIAN J GOLDEN. All rights reserved.
//

#import "BuildingTextViewController.h"
#import "BuildingImageViewController.h"
#import "Building.h"

@interface BuildingTextViewController ()
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;

@end

@implementation BuildingTextViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.building.name;
    self.infoTextView.text = self.building.info;
    self.navigationItem.rightBarButtonItems = @[self.editButtonItem, self.navigationItem.rightBarButtonItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification Handlers

- (void)keyboardWasShown:(NSNotification *)notification {
    
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"BuildingImageSegue"]) {
        BuildingImageViewController *imageViewController = segue.destinationViewController;
        imageViewController.building = self.building;
    }
}

@end
