//
//  BuildingSettingsViewController.m
//  Penn State Search
//
//  Created by BRIAN J GOLDEN on 10/14/13.
//  Copyright (c) 2013 BRIAN J GOLDEN. All rights reserved.
//

#import "PreferencesViewController.h"
#import "Constants.h"

@interface PreferencesViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *zoomSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *showImagesSwitch;
- (IBAction)dismissPressed:(id)sender;

@end

@implementation PreferencesViewController

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
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSNumber *boolZoom = [preferences objectForKey:kAllowZooming];
    NSNumber *boolShowAll = [preferences objectForKey:kShowAllBuildings];
    self.zoomSwitch.on = [boolZoom boolValue];
    self.showImagesSwitch.on = [boolShowAll boolValue];
}

- (IBAction)dismissPressed:(id)sender {
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setBool:self.zoomSwitch.on forKey:kAllowZooming];
    [preferences setBool:self.showImagesSwitch.on forKey:kShowAllBuildings];
    [preferences synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
