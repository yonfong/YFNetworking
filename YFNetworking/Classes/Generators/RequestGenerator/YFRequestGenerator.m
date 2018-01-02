//
//  YFRequestGenerator.m
//  Pods
//
//  Created by sky on 2018/1/2.
//

#import <AFNetworking/AFNetworking.h>
#import "YFRequestGenerator.h"
#import "YFSignatureGenerator.h"
#import "YFServiceFactory.h"
#import "YFCommonParamsGenerator.h"
#import "NSDictionary+YFNetworkingMethods.h"
#import "NSObject+YFNetworkingMethods.h"
#import <AFNetworking/AFNetworking.h>
#import "YFService.h"
#import "YFLogger.h"
#import "NSURLRequest+YFNetworkingMethods.h"
#import "YFNetworkingConfigurationManager.h"

@interface YFRequestGenerator ()

@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;

@end

@implementation YFRequestGenerator

#pragma mark - public methods
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static YFRequestGenerator *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[YFRequestGenerator alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    
    self = [super init];
    [self initialRequestGenerator];
    return self;
}

- (void)initialRequestGenerator {
    
    _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
    _httpRequestSerializer.timeoutInterval = [YFNetworkingConfigurationManager sharedInstance].apiNetworkingTimeoutSeconds;
    _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    
}

- (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    return [self generateRequestWithServiceIdentifier:serviceIdentifier requestParams:requestParams methodName:methodName requestWithMethod:@"GET"];
}

- (NSURLRequest *)generatePOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    return [self generateRequestWithServiceIdentifier:serviceIdentifier requestParams:requestParams methodName:methodName requestWithMethod:@"POST"];
}

- (NSURLRequest *)generatePutRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    return [self generateRequestWithServiceIdentifier:serviceIdentifier requestParams:requestParams methodName:methodName requestWithMethod:@"PUT"];
}

- (NSURLRequest *)generateDeleteRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    return [self generateRequestWithServiceIdentifier:serviceIdentifier requestParams:requestParams methodName:methodName requestWithMethod:@"DELETE"];
}

- (NSURLRequest *)generateRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName requestWithMethod:(NSString *)method {
    YFService *service = [[YFServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSString *urlString = [service urlGeneratingRuleByMethodName:methodName];
    
    NSDictionary *totalRequestParams = [self totalRequestParamsByService:service requestParams:requestParams];
    
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:method URLString:urlString parameters:totalRequestParams error:NULL];
    
    if (![method isEqualToString:@"GET"] && [YFNetworkingConfigurationManager sharedInstance].shouldSetParamsInHTTPBodyButGET) {
        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:requestParams options:0 error:NULL];
    }
    
    if ([service.child respondsToSelector:@selector(extraHttpHeadParmasWithMethodName:)]) {
        NSDictionary *dict = [service.child extraHttpHeadParmasWithMethodName:methodName];
        if (dict) {
            [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [request setValue:obj forHTTPHeaderField:key];
            }];
        }
    }
    
    request.requestParams = totalRequestParams;
    return request;
}


#pragma mark - private method
//根据Service拼接额外参数
- (NSDictionary *)totalRequestParamsByService:(YFService *)service requestParams:(NSDictionary *)requestParams {
    NSMutableDictionary *totalRequestParams = [NSMutableDictionary dictionaryWithDictionary:requestParams];
    
    if ([service.child respondsToSelector:@selector(extraParmas)]) {
        if ([service.child extraParmas]) {
            [[service.child extraParmas] enumerateKeysAndObjeYFsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [totalRequestParams setObjeYF:obj forKey:key];
            }];
        }
    }
    return [totalRequestParams copy];
}

#pragma mark test

- (void)rest {
    
    //self.httpRequestSerializer = nil;
}

@end
