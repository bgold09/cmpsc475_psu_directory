//
//  BuildingInfoViewController.h
//  Penn State Search
//
//  Created by BRIAN J GOLDEN on 10/28/13.
//  Copyright (c) 2013 BRIAN J GOLDEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Building.h"

@interface BuildingTextViewController : UIViewController <UITextViewDelegate>
@property (strong, nonatomic) Building *building;
@property (copy, nonatomic) CompletionBlock completionBlock;

@end
