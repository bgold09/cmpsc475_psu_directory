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
@property (strong, nonatomic) NSArray *requiredFieldKeys;
@property (strong, nonatomic) NSArray *requiredFieldNames;

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
        _requiredFieldNames = @[@"Title", @"Primary Affiliation", @"Email Address", @"Postal Address"];
        _requiredFieldKeys = @[@"title", @"eduPersonPrimaryAffiliation", @"psMailID", @"postalAddress"];
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

- (NSInteger)numberOfValuesForFieldForIndex:(NSInteger)resultIndex andFieldIndex:(NSInteger)fieldIndex {
    NSString *key = [self.requiredFieldKeys objectAtIndex:fieldIndex];
    NSDictionary *result = [self.directoryResults objectAtIndex:resultIndex];
    NSArray *fieldValues = [result objectForKey:key];
    return [fieldValues count];
}

- (NSInteger)numberOfFieldsWithValuesForIndex:(NSInteger)index {
    NSInteger numberOfFieldsPresent = 0;
    NSDictionary *result = [self.directoryResults objectAtIndex:index];
    
    for (NSString *requiredFieldKey in self.requiredFieldKeys) {
        NSArray *fieldValues = [result objectForKey:requiredFieldKey];
        
        if (fieldValues.count > 0) {
            numberOfFieldsPresent++;
        }
    }
    
    return numberOfFieldsPresent;
}

- (NSInteger)fieldNumberWithValuesForIndex:(NSInteger)index andFieldNumber:(NSInteger)fieldNumber {
    NSInteger count = 0;
    NSDictionary *result = [self.directoryResults objectAtIndex:index];
    
    for (NSInteger i = 0; i < self.requiredFieldKeys.count; i++) {
        NSString *fieldKey = [self.requiredFieldKeys objectAtIndex:i];
        NSArray *values = [result objectForKey:fieldKey];
        
        if (values.count > 0) {
            count++;
        }
        
        if (count - 1 == fieldNumber) {
            return i;
        }
    }
    
    return 0;
}

- (BOOL)allFieldsHaveValuesForIndex:(NSInteger)index {
    NSInteger numberOfFieldsPresent = [self numberOfFieldsWithValuesForIndex:index];
    return numberOfFieldsPresent == [self.requiredFieldKeys count];
}

- (NSString *)postalAddressForIndex:(NSInteger)index {
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

- (NSString *)personPrimaryAffiliationForIndex:(NSInteger)index {
    NSDictionary *result = [self.directoryResults objectAtIndex:index];
    NSArray *primaryAffiliations = [result objectForKey:@"eduPersonPrimaryAffiliation"];
    NSString *primaryAffiliation = [primaryAffiliations objectAtIndex:0];
    
    return primaryAffiliation;
}

- (NSString *)titleForIndex:(NSInteger)index {
    NSDictionary *result = [self.directoryResults objectAtIndex:index];
    NSArray *titles = [result objectForKey:@"title"];
    NSString *title = [titles objectAtIndex:0];
    
    if (!title) {
        title = @"No title available";
    }
    
    return title;
}

- (NSString *)mailIdForIndex:(NSInteger)index andMailIdNumber:(NSInteger)mailIdNumber {
    NSDictionary *result = [self.directoryResults objectAtIndex:index];
    NSArray *mailIds = [result objectForKey:@"psMailID"];
    NSString *mailId = [mailIds objectAtIndex:mailIdNumber];
    return mailId;
}

- (NSString *)fieldNameForIndex:(NSInteger)index {
    return [self.requiredFieldNames objectAtIndex:index];
}

@end
