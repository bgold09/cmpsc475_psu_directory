//
//  BuildingImageViewController.m
//  Penn State Search
//
//  Created by BRIAN J GOLDEN on 10/10/13.
//  Copyright (c) 2013 BRIAN J GOLDEN. All rights reserved.
//

#import "BuildingImageViewController.h"
#import "Building.h"
#import "Constants.h"

@interface BuildingImageViewController ()
@property (strong, nonatomic) UIImageView *buildingImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation BuildingImageViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSData *imageData = self.building.image;
    UIImage *image = [UIImage imageWithData:imageData];
    _buildingImageView = [[UIImageView alloc] initWithImage:image];
    [self.scrollView addSubview:self.buildingImageView];
    
    self.scrollView.contentSize = image.size;
    self.scrollView.maximumZoomScale = 2.0;
    self.scrollView.frame = self.view.frame;
    self.scrollView.minimumZoomScale = self.scrollView.bounds.size.width / image.size.width;
    self.scrollView.bounces = YES;
    self.scrollView.bouncesZoom = NO;
    self.scrollView.delegate = self;
    
    [self.scrollView zoomToRect:self.buildingImageView.bounds animated:NO];
    self.title = self.building.name;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setZooming:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setZooming:nil];
}

- (void)setZooming:(NSNotification *)notification {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSNumber *boolAllowZooming = [preferences objectForKey:kAllowZooming];
    
    if (![boolAllowZooming boolValue]) {
        [self lockZoom];
    } else {
        [self unlockZoom];
    }
}

-(void)lockZoom {
    self.scrollView.maximumZoomScale = 1.0;
    self.scrollView.minimumZoomScale = 1.0;
}

- (void)unlockZoom {
    self.scrollView.contentSize = self.buildingImageView.image.size;
    self.scrollView.maximumZoomScale = 2.0;
    self.scrollView.frame = self.view.frame;
    self.scrollView.minimumZoomScale = self.scrollView.bounds.size.width / self.buildingImageView.image.size.width;
    self.scrollView.bounces = YES;
    self.scrollView.bouncesZoom = NO;
    [self.scrollView zoomToRect:self.buildingImageView.bounds animated:NO];
}

#pragma mark - ScrollView Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.buildingImageView;
}

@end
