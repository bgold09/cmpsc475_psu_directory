//
//  Model.m
//  Penn State Search
//
//  Created by BRIAN J GOLDEN on 10/2/13.
//  Copyright (c) 2013 BRIAN J GOLDEN. All rights reserved.
//

#import "Model.h"
#import "RHLDAPSearch.h"

static NSString * const kConnectionString = @"ldap://ldap.psu.edu:389";
static NSString * const kBaseString = @"dc=psu,dc=edu";

@interface Model ()
@property (strong, nonatomic) RHLDAPSearch *connection;
@property (strong, nonatomic) NSArray *directoryResults;

@end

@implementation Model

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
        _connection = [[RHLDAPSearch alloc] initWithURL:kConnectionString];
    }
    return self;
}

- (void)searchForPeopleWithFirstName:(NSString *)firstName andLastName:(NSString *)lastName andAccessId:(NSString *)accessId {
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
    
    _directoryResults = results;
}

- (NSInteger)count {
    return [self.directoryResults count];
}

- (NSString *)addressForIndex:(NSInteger)index {
    NSDictionary *result = [self.directoryResults objectAtIndex:index];
    NSArray *addresses = [result objectForKey:@"postalAddress"];
    NSString *resultAddress = [addresses objectAtIndex:0];
    
    if (!resultAddress) {
        return @"No Address Available";
    }
    
    NSString *address = [resultAddress stringByReplacingOccurrencesOfString:@"$" withString:@"\n"];
    return address;
}

- (NSString *)displayNameForIndex:(NSInteger)index {
    NSDictionary *result = [self.directoryResults objectAtIndex:index];
    NSArray *displayNames = [result objectForKey:@"displayName"];
    NSString *displayName = [displayNames objectAtIndex:0];
    return displayName;
}

@end
