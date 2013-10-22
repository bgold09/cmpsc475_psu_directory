//
//  Building+Name.m
//  Penn State Search
//
//  Created by BRIAN J GOLDEN on 10/21/13.
//  Copyright (c) 2013 BRIAN J GOLDEN. All rights reserved.
//

#import "Building+Name.h"

@implementation Building (Name)

- (NSString *)firstLetterOfName {
    NSString *letter = [self.name substringToIndex:1];
    NSScanner *scanner = [NSScanner scannerWithString:letter];
    BOOL isNumeric = [scanner scanInteger:NULL] && [scanner isAtEnd];
    
    return isNumeric ? @"#" : letter;
}

@end
