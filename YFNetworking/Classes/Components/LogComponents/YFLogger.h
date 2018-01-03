//
//  YFLogger.h
//  Pods
//
//  Created by sky on 2018/1/2.
//

#import <Foundation/Foundation.h>
#import "YFService.h"
#import "YFLoggerConfiguration.h"
#import "YFURLResponse.h"

@interface YFLogger : NSObject

@property (nonatomic, strong, readonly) YFLoggerConfiguration *configParams;

+ (void)logDebugInfoWithRequest:(NSURLRequest *)request apiName:(NSString *)apiName service:(YFService *)service requestParams:(id)requestParams httpMethod:(NSString *)httpMethod;
+ (void)logDebugInfoWithResponse:(NSHTTPURLResponse *)response responseString:(NSString *)responseString request:(NSURLRequest *)request error:(NSError *)error;
+ (void)logDebugInfoWithCachedResponse:(YFURLResponse *)response methodName:(NSString *)methodName serviceIdentifier:(YFService *)service;

+ (instancetype)sharedInstance;
- (void)logWithActionCode:(NSString *)actionCode params:(NSDictionary *)params;

@end
