//
//  YFServiceFactory.h
//  Pods
//
//  Created by sky on 2018/1/2.
//

#import <Foundation/Foundation.h>
#import "YFService.h"

@protocol YFServiceFactoryDataSource <NSObject>

/*
 * key为service的Identifier
 * value为service的Class的字符串
 */
- (NSDictionary<NSString *,NSString *> *)servicesKindsOfServiceFactory;

@end

@interface YFServiceFactory : NSObject

@property (nonatomic, weak) id<YFServiceFactoryDataSource> dataSource;

+ (instancetype)sharedInstance;
- (YFService<YFServiceProtocol> *)serviceWithIdentifier:(NSString *)identifier;

@end

