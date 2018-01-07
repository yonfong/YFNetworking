//
//  YFService.m
//  Pods
//
//  Created by sky on 2018/1/2.
//

#import "YFService.h"
#import "NSObject+YFNetworkingMethods.h"

@interface YFService()

@property (nonatomic, weak, readwrite) id<YFServiceProtocol> child;

@end


@implementation YFService

- (instancetype)init {
    self = [super init];
    if (self) {
        if ([self conformsToProtocol:@protocol(YFServiceProtocol)]) {
            self.child = (id<YFServiceProtocol>)self;
        }
    }
    return self;
}

- (NSString *)urlGeneratingRuleByMethodName:(NSString *)methodName {
    NSString *urlString = nil;
    if (self.apiVersion.length != 0) {
        urlString = [NSString stringWithFormat:@"%@/%@/%@", self.apiBaseUrl, self.apiVersion, methodName];
    } else {
        urlString = [NSString stringWithFormat:@"%@/%@", self.apiBaseUrl, methodName];
    }
    return urlString;
}


#pragma mark - getters and setters
- (NSString *)privateKey {
    return self.child.isOnline ? self.child.onlinePrivateKey : self.child.offlinePrivateKey;
}

- (NSString *)publicKey {
    return self.child.isOnline ? self.child.onlinePublicKey : self.child.offlinePublicKey;
}

- (NSString *)apiBaseUrl {
    return self.child.isOnline ? self.child.onlineApiBaseUrl : self.child.offlineApiBaseUrl;
}

- (NSString *)apiVersion {
    return self.child.isOnline ? self.child.onlineApiVersion : self.child.offlineApiVersion;
}

@end
