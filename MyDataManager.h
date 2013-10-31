//
//  MyDataManager.h
//  Penn State Search
//
//  Created by BRIAN J GOLDEN on 10/21/13.
//  Copyright (c) 2013 BRIAN J GOLDEN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManagerDelegate.h"

@interface MyDataManager : NSObject <DataManagerDelegate>
- (void)addBuildingWithName:(NSString *)name;

@end
