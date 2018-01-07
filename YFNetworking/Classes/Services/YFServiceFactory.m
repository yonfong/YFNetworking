//
//  YFServiceFactory.m
//  Pods
//
//  Created by sky on 2018/1/2.
//

#import "YFServiceFactory.h"
#import "YFService.h"


@interface YFServiceFactory ()

@property (nonatomic, strong) NSMutableDictionary *serviceStorage;

@end

@implementation YFServiceFactory

#pragma mark - getters and setters
- (NSMutableDictionary *)serviceStorage {
    if (_serviceStorage == nil) {
        _serviceStorage = [[NSMutableDictionary alloc] init];
    }
    return _serviceStorage;
}

#pragma mark - life cycle
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static YFServiceFactory *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[YFServiceFactory alloc] init];
    });
    return sharedInstance;
}
//多线程环境可能会引起崩溃，对dataSource加个同步锁
#pragma mark - public methods
- (YFService<YFServiceProtocol> *)serviceWithIdentifier:(NSString *)identifier {
    @synchronized (self.dataSource) {
        
        NSAssert(self.dataSource, @"必须提供dataSource绑定并实现servicesKindsOfServiceFactory方法，否则无法正常使用Service模块");
        
        if (self.serviceStorage[identifier] == nil) {
            self.serviceStorage[identifier] = [self newServiceWithIdentifier:identifier];
        }
        return self.serviceStorage[identifier];
        
    }
}

#pragma mark - private methods
- (YFService<YFServiceProtocol> *)newServiceWithIdentifier:(NSString *)identifier {
    NSAssert([self.dataSource respondsToSelector:@selector(servicesKindsOfServiceFactory)], @"请实现YFServiceFactoryDataSource的servicesKindsOfServiceFactory方法");
    
    if ([[self.dataSource servicesKindsOfServiceFactory]valueForKey:identifier]) {
        NSString *classStr = [[self.dataSource servicesKindsOfServiceFactory]valueForKey:identifier];
        id service = [[NSClassFromString(classStr) alloc]init];
        NSAssert(service, [NSString stringWithFormat:@"无法创建service，请检查servicesKindsOfServiceFactory提供的数据是否正确"],service);
        NSAssert([service conformsToProtocol:@protocol(YFServiceProtocol)], @"你提供的Service没有遵循YFServiceProtocol");
        return service;
    }else {
        NSAssert(NO, @"servicesKindsOfServiceFactory中无法找不到相匹配identifier");
    }
    
    return nil;
}

@end
