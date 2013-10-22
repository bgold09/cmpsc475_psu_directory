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
- (BOOL)hasImageForName:(NSString *)name;
- (UIImage *)imageForName:(NSString *)name;
@end
