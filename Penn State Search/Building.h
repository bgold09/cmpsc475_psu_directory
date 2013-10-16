//
//  Building.h
//  Penn State Search
//
//  Created by BRIAN J GOLDEN on 10/15/13.
//  Copyright (c) 2013 BRIAN J GOLDEN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Building : NSObject <NSCoding>
@property (readonly, strong, nonatomic) NSString *name;
@property (readonly, strong, nonatomic) UIImage *image;
@property (readonly) NSInteger buildingCode;
@property (readonly) NSInteger yearConstructed;
@property (readonly) CGFloat latititude;
@property (readonly) CGFloat longitude;

@end
