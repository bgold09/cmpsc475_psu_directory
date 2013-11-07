//
//  BuildingMapViewController.h
//  Penn State Search
//
//  Created by BRIAN J GOLDEN on 11/6/13.
//  Copyright (c) 2013 BRIAN J GOLDEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Building.h"

@interface BuildingMapViewController : UIViewController <MKMapViewDelegate>
@property (strong, nonatomic) Building *building;

@end
