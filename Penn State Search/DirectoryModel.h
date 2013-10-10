//
//  Model.h
//  Penn State Search
//
//  Created by BRIAN J GOLDEN on 10/2/13.
//  Copyright (c) 2013 BRIAN J GOLDEN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DirectoryModel : NSObject
+ (id)sharedInstance;
- (void)searchForPeopleWithFirstName:(NSString *)firstName andLastName:(NSString *)lastName andAccessId:(NSString *)accessId;
- (NSInteger)count;
- (NSInteger)numberOfValuesForFieldForIndex:(NSInteger)resultIndex andFieldIndex:(NSInteger)fieldIndex;
- (NSInteger)numberOfFieldsWithValuesForIndex:(NSInteger)index;
- (NSInteger)fieldNumberWithValuesForIndex:(NSInteger)index andFieldNumber:(NSInteger)fieldNumber;
- (BOOL)allFieldsHaveValuesForIndex:(NSInteger)index;
- (NSString *)postalAddressForIndex:(NSInteger)index;
- (NSString *)displayNameForIndex:(NSInteger)index;
- (NSString *)personPrimaryAffiliationForIndex:(NSInteger)index;
- (NSString *)titleForIndex:(NSInteger)index;
- (NSString *)mailIdForIndex:(NSInteger)index andMailIdNumber:(NSInteger)mailIdNumber;
- (NSString *)fieldNameForIndex:(NSInteger)index;

@end
