//
//  BuildingImageViewController.h
//  Penn State Search
//
//  Created by BRIAN J GOLDEN on 10/10/13.
//  Copyright (c) 2013 BRIAN J GOLDEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Building.h"

@interface BuildingImageViewController : UIViewController <UIScrollViewDelegate>
@property (strong, nonatomic) Building *building;

@end
