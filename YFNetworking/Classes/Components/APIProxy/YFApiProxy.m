//
//  YFApiProxy.m
//  Pods
//
//  Created by sky on 2018/1/2.
//

#import <AFNetworking/AFNetworking.h>
#import "YFApiProxy.h"
#import "YFServiceFactory.h"
#import "YFRequestGenerator.h"
#import "YFLogger.h"
#import "NSURLRequest+YFNetworkingMethods.h"

static NSString * const kYFApiProxyDispatchItemKeyCallbackSuccess = @"kYFApiProxyDispatchItemKeyCallbackSuccess";
static NSString * const kYFApiProxyDispatchItemCallbackFail = @"kYFApiProxyDispatchItemCallbackFail";

@interface YFApiProxy ()

@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (nonatomic, strong) NSNumber *recordedRequestId;

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation YFApiProxy
#pragma mark - getters and setters
- (NSMutableDictionary *)dispatchTable {
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

- (AFHTTPSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sessionManager.securityPolicy.allowInvalidCertificates = YES;
        _sessionManager.securityPolicy.validatesDomainName = NO;
    }
    return _sessionManager;
}

#pragma mark - life cycle
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static YFApiProxy *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[YFApiProxy alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public methods
- (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(YFCallback)success fail:(YFCallback)fail {
    NSURLRequest *request = [[YFRequestGenerator sharedInstance] generateGETRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(YFCallback)success fail:(YFCallback)fail {
    NSURLRequest *request = [[YFRequestGenerator sharedInstance] generatePOSTRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (NSInteger)callPUTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(YFCallback)success fail:(YFCallback)fail {
    NSURLRequest *request = [[YFRequestGenerator sharedInstance] generatePutRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (NSInteger)callDELETEWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(YFCallback)success fail:(YFCallback)fail {
    NSURLRequest *request = [[YFRequestGenerator sharedInstance] generateDeleteRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (void)cancelRequestWithRequestID:(NSNumber *)requestID {
    NSURLSessionDataTask *requestOperation = self.dispatchTable[requestID];
    [requestOperation cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList {
    for (NSNumber *requestId in requestIDList) {
        [self cancelRequestWithRequestID:requestId];
    }
}

/** 这个函数存在的意义在于，如果将来要把AFNetworking换掉，只要修改这个函数的实现即可。 */
- (NSNumber *)callApiWithRequest:(NSURLRequest *)request success:(YFCallback)success fail:(YFCallback)fail {
    
    NSLog(@"\n==================================\n\nRequest Start: \n\n %@\n\n==================================", request.URL);
    
    // 跑到这里的block的时候，就已经是主线程了。
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSNumber *requestID = @([dataTask taskIdentifier]);
        [self.dispatchTable removeObjectForKey:requestID];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSData *responseData = responseObject;
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        if (error) {
            [YFLogger logDebugInfoWithResponse:httpResponse
                                responseString:responseString
                                       request:request
                                         error:error];
            YFURLResponse *CTResponse = [[YFURLResponse alloc] initWithResponseString:responseString requestId:requestID request:request responseData:responseData error:error];
            fail?fail(CTResponse):nil;
        } else {
            // 检查http response是否成立。
            [YFLogger logDebugInfoWithResponse:httpResponse
                                responseString:responseString
                                       request:request
                                         error:NULL];
            YFURLResponse *CTResponse = [[YFURLResponse alloc] initWithResponseString:responseString requestId:requestID request:request responseData:responseData status:YFURLResponseStatusSuccess];
            success?success(CTResponse):nil;
        }
    }];
    
    NSNumber *requestId = @([dataTask taskIdentifier]);
    
    self.dispatchTable[requestId] = dataTask;
    [dataTask resume];
    
    return requestId;
}

@end

