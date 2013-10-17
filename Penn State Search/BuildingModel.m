//
//  BuildingModel.m
//  Penn State Search
//
//  Created by BRIAN J GOLDEN on 10/10/13.
//  Copyright (c) 2013 BRIAN J GOLDEN. All rights reserved.
//

#import "BuildingModel.h"
#import "BuildingInfo.h"

static NSString * const archiveFilename = @"buildings.archive";

@interface BuildingModel ()
@property (strong, nonatomic) NSMutableArray *buildingInfoArray;

@end

@implementation BuildingModel

+ (id)sharedInstance {
	static id singleton = nil;
	if (!singleton) {
		singleton = [[self alloc] init];
	}
	return singleton;
}

- (id)init {
    self = [super init];
    if (self) {
        
        if ([self fileExists]) {
            NSString *archiveFilePath = [self archiveFilePath];
            _buildingInfoArray = [NSKeyedUnarchiver unarchiveObjectWithFile:archiveFilePath];
        } else {
            NSMutableArray *buildings = [self allBuildingInfo];
            
            _buildingInfoArray = [NSMutableArray array];
            for (NSDictionary *dict in buildings) {
                NSNumber *buildingCode = dict[@"opp_bldg_code"];
                NSNumber *year = dict[@"year_constructed"];
                NSNumber *latitude = dict[@"latitude"];
                NSNumber *longitude = dict[@"longitude"];
                
                BuildingInfo *building = [[BuildingInfo alloc] initWithName:dict[@"name"]
                                                       buildingCode:[buildingCode integerValue]
                                                    yearConstructed:[year integerValue]
                                                           latitude:[latitude floatValue]
                                                          longitude:[longitude floatValue]
                                                         photoNamed:dict[@"photo"]];
                
                [_buildingInfoArray addObject:building];
            }
            
            [NSKeyedArchiver archiveRootObject:_buildingInfoArray toFile:[self archiveFilePath]];
        }
        
        [self sortByBuildingName];
    }
    return self;
}

#pragma mark - File System

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSString *)archiveFilePath {
    return [[self applicationDocumentsDirectory] stringByAppendingPathComponent:archiveFilename];
}

- (BOOL)fileExists {
    NSString *archiveFilePath = [self archiveFilePath];
    return [[NSFileManager defaultManager] fileExistsAtPath:archiveFilePath];
}

#pragma mark - Public Methods

- (NSInteger)count {
    return self.buildingInfoArray.count;
}

- (NSInteger)countWithImages {
    NSInteger count = 0;
    
    for (BuildingInfo *buildingInfo in self.buildingInfoArray) {
        
        if (buildingInfo.image) {
            count++;
        }
    }
    
    return count;
}

- (NSInteger)indexForBuildingWithImageNumber:(NSInteger)index {
    NSInteger count = 0;
        
    for (NSInteger buildingIndex = 0; buildingIndex < [self.buildingInfoArray count]; buildingIndex++) {
        if ([self hasImageForIndex:buildingIndex]) {
            count++;
        }
        
        if (count - 1 == index) {
            return buildingIndex;
        }
    }
    
    return 0;
}

- (NSString *)nameForIndex:(NSInteger)index {
    BuildingInfo *buildingInfo = [self.buildingInfoArray objectAtIndex:index];
    NSString *name = buildingInfo.name;
    return name;
}

- (UIImage *)imageForIndex:(NSInteger)index {
    BuildingInfo *buildingInfo = [self.buildingInfoArray objectAtIndex:index];
    UIImage *image = buildingInfo.image;    
    return image;
}

- (BOOL)hasImageForIndex:(NSInteger)index {
    BuildingInfo *buildingInfo = [self.buildingInfoArray objectAtIndex:index];
    UIImage *image = buildingInfo.image;
    
    if (image) {
        return YES;
    }
    
    return NO;
}

#pragma mark - Private Methods

- (void)sortByBuildingName {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [self.buildingInfoArray sortUsingDescriptors:@[sortDescriptor]];
    
}

- (NSMutableArray *)allBuildingInfo {
    NSString *buildingInfoFilePath = [[NSBundle mainBundle] pathForResource:@"buildings" ofType:@".plist"];
    NSMutableArray *buildingInfo = [[NSMutableArray alloc] initWithContentsOfFile:buildingInfoFilePath];
    return buildingInfo;
}

@end
