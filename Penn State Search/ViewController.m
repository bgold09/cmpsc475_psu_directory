//
//  ViewController.m
//  Penn State Search
//
//  Created by BRIAN J GOLDEN on 10/1/13.
//  Copyright (c) 2013 BRIAN J GOLDEN. All rights reserved.
//

#import "ViewController.h"
#import "SearchViewController.h"

#define kKeyboardHeight 216

@interface ViewController () <UITextFieldDelegate, SearchDelegate>
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *accessIdField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
    
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SearchViewController *searchViewController = segue.destinationViewController;
    searchViewController.delegate = self;
}

- (IBAction)unwindSegue:(UIStoryboardSegue *)segue {
    
}

@end
