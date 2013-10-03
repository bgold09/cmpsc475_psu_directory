//
//  ViewController.m
//  Penn State Search
//
//  Created by BRIAN J GOLDEN on 10/1/13.
//  Copyright (c) 2013 BRIAN J GOLDEN. All rights reserved.
//

#import "ViewController.h"
#import "SearchViewController.h"
#import "Model.h"

#define kKeyboardHeight 216

@interface ViewController () <UITextFieldDelegate, SearchDelegate>
@property (strong, nonatomic) Model *model;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *accessIdField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)searchPressed:(id)sender;

@end

@implementation ViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _model = [[Model alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
//    CGSize contentSize =
    [self.scrollView setScrollEnabled:NO];
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
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kKeyboardHeight, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    [self.scrollView setScrollEnabled:YES];
    
    CGRect frame = self.view.frame;
    frame.size.height -= kKeyboardHeight;
    if (!CGRectContainsPoint(frame, textField.frame.origin)) {
        CGPoint offset = self.scrollView.contentOffset;
        offset = CGPointMake(0.0, kKeyboardHeight);
        [self.scrollView setContentOffset:offset animated:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.scrollView.contentInset = insets;
    }];
    
    self.scrollView.scrollIndicatorInsets = insets;
    [self.scrollView setScrollEnabled:NO];
}

#pragma mark - Search Delegate

- (void)dismissMe {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SearchViewController *searchViewController = segue.destinationViewController;
    searchViewController.delegate = self;
    searchViewController.model = self.model;
}

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
        NSArray *results = [self.model searchForPeopleWithFirstName:self.firstNameField.text
                                                        andLastName:self.lastNameField.text
                                                        andAccessId:self.accessIdField.text];
        
        self.model.directoryResults = results;
        
        if ([self.model count] == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Results"
                                                            message:@"No results were found for your query."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            [self performSegueWithIdentifier:@"SearchSegue" sender:Nil];
        }
    }
}

@end
