//
//  AddBuildingViewController.m
//  Penn State Search
//
//  Created by BRIAN J GOLDEN on 10/30/13.
//  Copyright (c) 2013 BRIAN J GOLDEN. All rights reserved.
//

#import "AddBuildingViewController.h"

@interface AddBuildingViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
- (IBAction)okPressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;

@end

@implementation AddBuildingViewController

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
    self.nameField.delegate = self;
}

- (IBAction)okPressed:(id)sender {
    if (!self.nameField.text) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Name Provided"
                                                        message:@"You must enter a name for the new building."
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    } else {
        self.completionBlock(self.nameField.text);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)cancelPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Cancel" message:@"Are you sure you want to cancel? All changes will be lost." delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    [alert show];
}

#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
