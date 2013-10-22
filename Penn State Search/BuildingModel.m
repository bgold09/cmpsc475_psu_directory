//
//  BuildingModel.m
//  Penn State Search
//
//  Created by BRIAN J GOLDEN on 10/10/13.
//  Copyright (c) 2013 BRIAN J GOLDEN. All rights reserved.
//

#import "BuildingModel.h"
#import "DataManager.h"
#import "MyDataManager.h"
#import "Building.h"

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
        DataManager *dataManager = [DataManager sharedInstance];
        MyDataManager *myDataManager = [[MyDataManager alloc] init];
        dataManager.delegate = myDataManager;
        
        NSArray *results = [dataManager fetchManagedObjectsForEntity:@"Building" sortKeys:@[@"name"] predicate:nil];
        self.buildingInfoArray = [results mutableCopy];
    }
    return self;
}

#pragma mark - Public Methods

- (NSInteger)count {
    return self.buildingInfoArray.count;
}

- (NSInteger)countWithImages {
    NSInteger count = 0;
    
    for (Building *building in self.buildingInfoArray) {
        
        if (building.image) {
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
    Building *building = [self.buildingInfoArray objectAtIndex:index];
    NSString *name = building.name;
    return name;
}

- (UIImage *)imageForIndex:(NSInteger)index {
    Building *building = [self.buildingInfoArray objectAtIndex:index];
    UIImage *image = [[UIImage alloc] initWithData:building.image];
    return image;
}

- (BOOL)hasImageForIndex:(NSInteger)index {
    Building *building = [self.buildingInfoArray objectAtIndex:index];
    UIImage *image = [[UIImage alloc] initWithData:building.image];
    
    if (image) {
        return YES;
    }
    
    return NO;
}

- (BOOL)hasImageForName:(NSString *)name {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", name];
    NSArray *result = [self.buildingInfoArray filteredArrayUsingPredicate:predicate];
    Building *building = [result objectAtIndex:0];
    
    if (building.image) {
        return YES;
    }
    
    return NO;
}

- (UIImage *)imageForName:(NSString *)name {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", name];
    NSArray *result = [self.buildingInfoArray filteredArrayUsingPredicate:predicate];
    Building *building = [result objectAtIndex:0];
    UIImage *image = [[UIImage alloc] initWithData:building.image];
    return image;
}

@end
