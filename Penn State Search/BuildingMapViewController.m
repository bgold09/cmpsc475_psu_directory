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
#import "BuildingImageViewController.h"

#define kMapZoomDistance           400.0
#define kDisclosureButtonDimension 23

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
    self.mapView.delegate = self;
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
    buildingAnnotation.coordinate = buildingCenter;
    buildingAnnotation.title = self.building.name;
    [self.mapView addAnnotation:buildingAnnotation];
}

#pragma mark - MapView Delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *annoView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:@"annoView"];
    
    if (!annoView) {
        annoView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annoView"];
    } else {
        annoView.annotation = annotation;
    }
    
    if (self.building.image) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        button.frame = CGRectMake(0, 0, kDisclosureButtonDimension, kDisclosureButtonDimension);
        annoView.rightCalloutAccessoryView = button;
    }

    annoView.pinColor = MKPinAnnotationColorRed;
    annoView.canShowCallout = YES;

    return annoView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    [self performSegueWithIdentifier:@"MapToImageSegue" sender:self];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MapToImageSegue"]) {
        BuildingImageViewController *imageViewController = segue.destinationViewController;
        imageViewController.building = self.building;
    }
}

@end
