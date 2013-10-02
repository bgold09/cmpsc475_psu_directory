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
    CGRect frame = textField.frame;    
    if (frame.origin.y + frame.size.height >
            self.scrollView.frame.origin.y + self.scrollView.frame.size.height - kKeyboardHeight) {
        CGPoint offset = self.scrollView.contentOffset;
        offset = CGPointMake(offset.x, offset.y + kKeyboardHeight);
        [self.scrollView setContentOffset:offset animated:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    CGPoint offset = CGPointMake(0.0, 0.0);
    [self.scrollView setContentOffset:offset animated:YES];
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
    
    NSDictionary *searchTerms = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    self.firstNameField.text, @"first-name",
                                    self.lastNameField.text, @"last-name",
                                    self.accessIdField.text, @"access-id",
                                    nil];
    
    searchViewController.searchTerms = searchTerms;
}

- (IBAction)searchPressed:(id)sender {   
    if ([self.lastNameField.text length] == 0 && [self.accessIdField.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Input"
                                                        message:@"You must input a last name and/or access ID for the search."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        [self performSegueWithIdentifier:@"SearchSegue" sender:Nil];
    }
}

@end
