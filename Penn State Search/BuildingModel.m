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
@property (strong, nonatomic) NSMutableArray *buildingArray;

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
        _buildingArray = [results mutableCopy];
    }
    return self;
}

#pragma mark - Public Methods

- (NSInteger)count {
    return self.buildingArray.count;
}

- (NSInteger)countWithImages {
    NSInteger count = 0;
    
    for (Building *building in self.buildingArray) {
        
        if (building.image) {
            count++;
        }
    }
    
    return count;
}


- (BOOL)hasImageForName:(NSString *)name {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", name];
    NSArray *result = [self.buildingArray filteredArrayUsingPredicate:predicate];
    Building *building = [result objectAtIndex:0];
    
    if (building.image) {
        return YES;
    }
    
    return NO;
}

- (UIImage *)imageForName:(NSString *)name {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", name];
    NSArray *result = [self.buildingArray filteredArrayUsingPredicate:predicate];
    Building *building = [result objectAtIndex:0];
    UIImage *image = [[UIImage alloc] initWithData:building.image];
    return image;
}

@end
