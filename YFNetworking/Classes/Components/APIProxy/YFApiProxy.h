//
//  YFApiProxy.m
//  Pods
//
//  Created by sky on 2018/1/2.
//

#import "YFApiProxy.h"
#import "YFURLResponse.h"

typedef void(^YFCallback)(YFURLResponse *response);

@interface YFApiProxy: NSObject

+ (instancetype)sharedInstance;

- (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(YFCallback)success fail:(YFCallback)fail;

- (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(YFCallback)success fail:(YFCallback)fail;

- (NSInteger)callPUTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(YFCallback)success fail:(YFCallback)fail;

- (NSInteger)callDELETEWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(YFCallback)success fail:(YFCallback)fail;


- (NSNumber *)callApiWithRequest:(NSURLRequest *)request success:(YFCallback)success fail:(YFCallback)fail;

- (void)cancelRequestWithRequestID:(NSNumber *)requestID;

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;


@end

