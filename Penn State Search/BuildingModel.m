//
//  BuildingModel.m
//  Penn State Search
//
//  Created by BRIAN J GOLDEN on 10/10/13.
//  Copyright (c) 2013 BRIAN J GOLDEN. All rights reserved.
//

#import "BuildingModel.h"

@interface BuildingModel ()
@property (strong, nonatomic) NSMutableArray *buildings;

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
        _buildings = [self allBuildingInfo];
    }
    return self;
}

- (NSInteger)count {
    return self.buildings.count;
}

- (NSString *)nameForIndex:(NSInteger)index {
    NSDictionary *buildingInfo = [self.buildings objectAtIndex:index];
    NSString *name = [buildingInfo objectForKey:@"name"];
    return name;
}

- (UIImage *)imageForIndex:(NSInteger)index {
    NSDictionary *buildingInfo = [self.buildings objectAtIndex:index];
    NSString *imageName = [buildingInfo objectForKey:@"photo"];
    NSString *imageFilePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];    
    UIImage *image = [UIImage imageWithContentsOfFile:imageFilePath];
    return image;
}

- (BOOL)hasImageForIndex:(NSInteger)index {
    NSDictionary *buildingInfo = [self.buildings objectAtIndex:index];
    NSString *imageName = [buildingInfo objectForKey:@"photo"];
    
    if (imageName.length == 0) {
        return NO;
    }
    
    return YES;
}

- (void)sortByBuildingName {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [self.buildings sortUsingDescriptors:@[sortDescriptor]];
}

- (NSMutableArray *)allBuildingInfo {
    NSString *buildingInfoFilePath = [[NSBundle mainBundle] pathForResource:@"buildings" ofType:@".plist"];
    NSMutableArray *buildingInfo = [[NSMutableArray alloc] initWithContentsOfFile:buildingInfoFilePath];
    return buildingInfo;
}

@end
