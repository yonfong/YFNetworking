//
//  NSObject+YFNetworkingMethods.m
//  Pods
//
//  Created by sky on 2018/1/2.
//

#import "NSObject+YFNetworkingMethods.h"

@implementation NSObject (YFNetworkingMethods)

- (id)yf_defaultValue:(id)defaultData
{
    if (![defaultData isKindOfClass:[self class]]) {
        return defaultData;
    }
    
    if ([self yf_isEmptyObject]) {
        return defaultData;
    }
    
    return self;
}

- (BOOL)yf_isEmptyObject
{
    if ([self isEqual:[NSNull null]]) {
        return YES;
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        if ([(NSString *)self length] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSArray class]]) {
        if ([(NSArray *)self count] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSDictionary class]]) {
        if ([(NSDictionary *)self count] == 0) {
            return YES;
        }
    }
    
    return NO;
}

@end
