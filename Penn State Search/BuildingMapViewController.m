//
//  BuildingMapViewController.m
//  Penn State Search
//
//  Created by BRIAN J GOLDEN on 11/6/13.
//  Copyright (c) 2013 BRIAN J GOLDEN. All rights reserved.
//

#import "BuildingMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>

#define kMapZoomDistance 400.0

@interface BuildingMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation BuildingMapViewController

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
    self.title = self.building.name;
    [self updateMapView];
}

- (void)updateMapView {
    CLLocationCoordinate2D buildingCenter = CLLocationCoordinate2DMake([self.building.latitude floatValue], [self.building.longitude floatValue]);
    CLLocationCoordinate2D mapCenter = buildingCenter;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(mapCenter, kMapZoomDistance, kMapZoomDistance);
    [self.mapView setRegion:region];
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    MKPointAnnotation *buildingAnnotation = [[MKPointAnnotation alloc] init];
    [buildingAnnotation setCoordinate:buildingCenter];
    [buildingAnnotation setTitle:self.building.name];
    [self.mapView addAnnotation:buildingAnnotation];
}

@end
