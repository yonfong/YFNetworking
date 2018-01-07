//
//  YFCacheObject.m
//  Pods
//
//  Created by sky on 2018/1/2.
//

#import "YFCachedObject.h"
#import "YFNetworkingConfigurationManager.h"

@interface YFCachedObject ()

@property (nonatomic, copy, readwrite) NSData *content;
@property (nonatomic, copy, readwrite) NSDate *lastUpdateTime;

@end


@implementation YFCachedObject

#pragma mark - getters and setters
- (BOOL)isEmpty {
    return self.content == nil;
}

- (BOOL)isOutdated {
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastUpdateTime];
    return timeInterval > [YFNetworkingConfigurationManager sharedInstance].cacheOutdateTimeSeconds ;
}

- (void)setContent:(NSData *)content {
    _content = [content copy];
    self.lastUpdateTime = [NSDate dateWithTimeIntervalSinceNow:0];
}

#pragma mark - life cycle
- (instancetype)initWithContent:(NSData *)content {
    self = [super init];
    if (self) {
        self.content = content;
    }
    return self;
}

#pragma mark - public method
- (void)updateContent:(NSData *)content {
    self.content = content;
}

@end
