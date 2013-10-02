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
static NSString *kBaseString = @"dc=psu,dc=edu";

- (id)init {
    self = [super init];
    if (self) {
        _connection = [[RHLDAPSearch alloc] initWithURL:kConnectionString];
    }
    return self;
}

- (NSArray *)searchForPeopleWithFirstName:(NSString *)firstName andLastName:(NSString *)lastName andAccessId:(NSString *)accessId {
    NSMutableString *query = [[NSMutableString alloc] initWithString:@"(&"];
    
    if ([firstName length] > 0) {
        [query appendFormat:@"(givenName=%@*)", firstName];
    }
    
    if ([lastName length] > 0) {
        [query appendFormat:@"(sn=%@)", lastName];
    }
    
    if ([accessId length] > 0) {
        [query appendFormat:@"(uid=%@)", accessId];
    }
    
    [query appendString:@")"];
    
    NSError *error;
    NSArray *results = [self.connection searchWithQuery:query withinBase:kBaseString usingScope:RH_LDAP_SCOPE_SUBTREE error:&error];
    
    return results;
}

@end
