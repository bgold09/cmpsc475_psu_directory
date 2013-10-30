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
    self.infoTextView.delegate = self;
    self.title = self.building.name;
    self.infoTextView.text = self.building.info;
    self.navigationItem.rightBarButtonItems = @[self.editButtonItem, self.navigationItem.rightBarButtonItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (!self.editing) {
        [self.infoTextView resignFirstResponder];
    } else {
        [self.infoTextView becomeFirstResponder];
    }
}

#pragma mark - Notification Handlers

- (void)keyboardWasShown:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    CGRect frame = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGSize keyboardSize = frame.size;
    self.infoTextView.frame = CGRectMake(0.0, 0.0, keyboardSize.width, keyboardSize.height);
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    self.infoTextView.frame = CGRectMake(0.0, 0.0, self.infoTextView.bounds.size.width, self.view.bounds.size.height);
}

#pragma mark - TextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (!self.editing) {
        [self setEditing:YES animated:YES];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.completionBlock(self.infoTextView.text);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"BuildingImageSegue"]) {
        BuildingImageViewController *imageViewController = segue.destinationViewController;
        imageViewController.building = self.building;
    }
}

@end
