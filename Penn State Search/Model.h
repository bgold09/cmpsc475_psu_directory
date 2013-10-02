//
//  Model.h
//  Penn State Search
//
//  Created by BRIAN J GOLDEN on 10/2/13.
//  Copyright (c) 2013 BRIAN J GOLDEN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject
- (NSArray *)searchForPeopleWithFirstName:(NSString *)firstName andLastName:(NSString *)lastName andAccessId:(NSString *)accessId;

@end
