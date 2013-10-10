//
//  ViewController.m
//  Penn State Search
//
//  Created by BRIAN J GOLDEN on 10/1/13.
//  Copyright (c) 2013 BRIAN J GOLDEN. All rights reserved.
//

#import "SearchViewController.h"
#import "ResultsViewController.h"
#import "DirectoryModel.h"

#define kKeyboardHeight  216.0
#define kStatusBarHeight 20.0
#define kNavBarHeight    44.0

@interface SearchViewController () <UITextFieldDelegate>
@property (strong, nonatomic) DirectoryModel *model;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *accessIdField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)searchPressed:(id)sender;

@end

@implementation SearchViewController

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
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:self.view.frame.size];
}

- (void)viewDidAppear:(BOOL)animated {
    self.firstNameField.text = @"";
    self.lastNameField.text = @"";
    self.accessIdField.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kKeyboardHeight - kStatusBarHeight - kNavBarHeight, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    [self.scrollView setScrollEnabled:YES];
    
    CGRect frame = self.view.frame;
    frame.size.height -= kKeyboardHeight;
    if (!CGRectContainsPoint(frame, textField.frame.origin)) {
        CGPoint offset = self.scrollView.contentOffset;
        offset = CGPointMake(0.0, kKeyboardHeight - kStatusBarHeight - kNavBarHeight);
        [self.scrollView setContentOffset:offset animated:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.scrollView.contentInset = insets;
    }];
    
    self.scrollView.scrollIndicatorInsets = insets;
    [self.scrollView setScrollEnabled:YES];
}

#pragma mark - Segues

- (IBAction)searchPressed:(id)sender {
    [self.view endEditing:YES];
    
    if ([self.lastNameField.text length] == 0 && [self.accessIdField.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Input"
                                                        message:@"You must provide a last name and/or access ID for the search."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        [self.model searchForPeopleWithFirstName:self.firstNameField.text
                                                        andLastName:self.lastNameField.text
                                                        andAccessId:self.accessIdField.text];
        
        if ([self.model count] == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Results"
                                                            message:@"No results were found for your query."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            ResultsViewController *resultsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ResultsView"];
            [self.navigationController pushViewController:resultsViewController animated:YES];
        }
    }
}

@end
