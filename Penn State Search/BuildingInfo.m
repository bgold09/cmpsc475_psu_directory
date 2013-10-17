//
//  Building.m
//  Penn State Search
//
//  Created by BRIAN J GOLDEN on 10/15/13.
//  Copyright (c) 2013 BRIAN J GOLDEN. All rights reserved.
//

#import "BuildingInfo.h"

static NSString * const kBuildingNameKey = @"buildingName";
static NSString * const kImageKey = @"image";
static NSString * const kBuildingCodeKey = @"buildingCode";
static NSString * const kYearConstructedKey = @"yearConstructed";
static NSString * const kLatitudeKey = @"latitude";
static NSString * const  kLongtitudeKey = @"longitide";

@interface BuildingInfo ()
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) UIImage *image;
@property NSInteger buildingCode;
@property NSInteger yearConstructed;
@property CGFloat latititude;
@property CGFloat longitude;

@end

@implementation BuildingInfo

- (id)initWithName:(NSString *)name buildingCode:(NSInteger)buildingCode yearConstructed:(NSInteger)yearConstructed latitude:(CGFloat)latitude longitude:(CGFloat)longitude photoNamed:(NSString *)photoFileName {
    self = [super init];
    if (self) {
        _name = name;
        _buildingCode = buildingCode;
        _yearConstructed = yearConstructed;
        _latititude = latitude;
        _longitude = longitude;
        
        if (photoFileName.length > 0) {
            NSString *imageFilePath = [[NSBundle mainBundle] pathForResource:photoFileName ofType:@"jpg"];
            _image = [UIImage imageWithContentsOfFile:imageFilePath];
        }
    }
    
    return self;
}

#pragma mark - NSCoding Protocol

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _name = [aDecoder decodeObjectForKey:kBuildingNameKey];
        _image = [aDecoder decodeObjectForKey:kImageKey];
        _buildingCode = [[aDecoder decodeObjectForKey:kBuildingCodeKey] integerValue];
        _yearConstructed = [[aDecoder decodeObjectForKey:kYearConstructedKey] integerValue];
        _latititude = [[aDecoder decodeObjectForKey:kLatitudeKey] floatValue];
        _longitude = [[aDecoder decodeObjectForKey:kLongtitudeKey] floatValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_name forKey:kBuildingNameKey];
    [aCoder encodeObject:_image forKey:kImageKey];
    
    NSNumber *buildingCode = [NSNumber numberWithInt:self.buildingCode];
    [aCoder encodeObject:buildingCode forKey:kBuildingCodeKey];
    
    NSNumber *yearConstructed = [NSNumber numberWithInt:self.yearConstructed];
    [aCoder encodeObject:yearConstructed forKey:kYearConstructedKey];
    
    NSNumber *latititude = [NSNumber numberWithFloat:self.latititude];
    [aCoder encodeObject:latititude forKey:kLatitudeKey];
    
    NSNumber *longitude = [NSNumber numberWithFloat:self.longitude];
    [aCoder encodeObject:longitude forKey:kLongtitudeKey];
}

@end
