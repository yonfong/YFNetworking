//
//  NSURLRequest+YFNetworkingMethods.m
//  Pods
//
//  Created by sky on 2018/1/2.
//

#import <objc/runtime.h>
#import "NSURLRequest+YFNetworkingMethods.h"

static void *YFNetworkingRequestParams;

@implementation NSURLRequest (YFNetworkingMethods)

- (void)setRequestParams:(NSDictionary *)requestParams {
    objc_setAssociatedObject(self, &YFNetworkingRequestParams, requestParams, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)requestParams {
    return objc_getAssociatedObject(self, &YFNetworkingRequestParams);
}


@end
