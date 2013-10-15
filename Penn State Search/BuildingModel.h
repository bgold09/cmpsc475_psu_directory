//
//  BuildingModel.h
//  Penn State Search
//
//  Created by BRIAN J GOLDEN on 10/10/13.
//  Copyright (c) 2013 BRIAN J GOLDEN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuildingModel : NSObject
+ (id)sharedInstance;
- (NSInteger)count;
- (NSInteger)countWithImages;
- (NSInteger)indexForBuildingWithImageNumber:(NSInteger)index;
- (NSString *)nameForIndex:(NSInteger)index;
- (UIImage *)imageForIndex:(NSInteger)index;
- (BOOL)hasImageForIndex:(NSInteger)index;
@end
