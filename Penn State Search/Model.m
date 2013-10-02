//
//  Model.m
//  Penn State Search
//
//  Created by BRIAN J GOLDEN on 10/2/13.
//  Copyright (c) 2013 BRIAN J GOLDEN. All rights reserved.
//

#import "Model.h"
#import "RHLDAPSearch.h"

@interface Model ()
@property (strong, nonatomic) RHLDAPSearch *connection;

@end

@implementation Model

static NSString *kConnectionString = @"ldap://ldap.psu.edu:389";

- (id)init {
    self = [super init];
    if (self) {
        _connection = [[RHLDAPSearch alloc] initWithURL:kConnectionString];
    }
    return self;
}

@end
