//
//  SearchViewController.h
//  Penn State Search
//
//  Created by BRIAN J GOLDEN on 10/1/13.
//  Copyright (c) 2013 BRIAN J GOLDEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@protocol SearchDelegate <NSObject>

@end

@interface ResultsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) Model *model;
@property (weak, nonatomic) id<SearchDelegate> delegate;

@end
