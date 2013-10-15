//
//  BuildingImageViewController.m
//  Penn State Search
//
//  Created by BRIAN J GOLDEN on 10/10/13.
//  Copyright (c) 2013 BRIAN J GOLDEN. All rights reserved.
//

#import "BuildingImageViewController.h"
#import "BuildingModel.h"
#import "Constants.h"

@interface BuildingImageViewController ()
@property (strong, nonatomic) BuildingModel *model;
@property (strong, nonatomic) UIImageView *buildingImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation BuildingImageViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _model = [BuildingModel sharedInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *image = [self.model imageForIndex:self.buildingNumber];
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
    self.title = self.buildingName;
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSNumber *boolAllowZooming = [preferences objectForKey:kAllowZooming];
    
    if (![boolAllowZooming boolValue]) {
        [self lockZoom];
    }
}

-(void)lockZoom {
    self.scrollView.maximumZoomScale = 1.0;
    self.scrollView.minimumZoomScale = 1.0;
}

#pragma mark - ScrollView Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.buildingImageView;
}

@end
