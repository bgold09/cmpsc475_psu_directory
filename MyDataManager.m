//
//  MyDataManager.m
//  Penn State Search
//
//  Created by BRIAN J GOLDEN on 10/21/13.
//  Copyright (c) 2013 BRIAN J GOLDEN. All rights reserved.
//

#import "MyDataManager.h"
#import "DataManager.h"
#import "Building.h"

static NSString * const kBuildingNameKey = @"buildingName";
static NSString * const kImageKey = @"image";
static NSString * const kBuildingCodeKey = @"buildingCode";
static NSString * const kYearConstructedKey = @"yearConstructed";
static NSString * const kLatitudeKey = @"latitude";
static NSString * const kLongtitudeKey = @"longitide";

@implementation MyDataManager

- (NSString *)xcDataModelName {
    return @"Buildings";
}

- (void)createDatabaseFor:(DataManager *)dataManager {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"buildings" ofType:@"plist"];
    NSArray *buildingArray = [NSArray arrayWithContentsOfFile:plistPath];
    
    NSManagedObjectContext *managedObjectContext = dataManager.managedObjectContext;
    
    for (NSDictionary *dict in buildingArray) {
        Building *building = [NSEntityDescription insertNewObjectForEntityForName:@"Building" inManagedObjectContext:managedObjectContext];
        
        building.name = [dict objectForKey:kBuildingNameKey];
        building.buildingCode = [dict objectForKey:kBuildingCodeKey];
        building.yearConstructed = [dict objectForKey:kYearConstructedKey];
        building.latitude = [dict objectForKey:kLatitudeKey];
        building.longitude = [dict objectForKey:kLongtitudeKey];
        
        
        NSString *imageFilePath = [[NSBundle mainBundle] pathForResource:[dict objectForKey:@"photo"] ofType:@"jpg"];
        UIImage *buildingImage = [UIImage imageWithContentsOfFile:imageFilePath];
        building.image = UIImagePNGRepresentation(buildingImage);
    }
    
    [dataManager saveContext];
}

@end
