//
//  YFAPIBaseManager.h
//  Pods
//
//  Created by sky on 2018/1/2.
//

#import <Foundation/Foundation.h>
#import "YFURLResponse.h"

@class YFAPIBaseManager;

// 在调用成功之后的params字典里面，用这个key可以取出requestID
static NSString * const kYFAPIBaseManagerRequestID = @"kYFAPIBaseManagerRequestID";

/*************************************************************************************************/
/*                               YFAPIManagerApiCallBackDelegate                                 */
/*************************************************************************************************/

//api回调
@protocol YFAPIManagerCallBackDelegate <NSObject>

@required
- (void)managerCallAPIDidSuccess:(YFAPIBaseManager *)manager;
- (void)managerCallAPIDidFailed:(YFAPIBaseManager *)manager;

@end

/*************************************************************************************************/
/*                               YFAPIManagerCallbackDataReformer                                */
/*************************************************************************************************/


@protocol YFAPIManagerDataReformer <NSObject>
@required

- (id)manager:(YFAPIBaseManager *)manager reformData:(NSDictionary *)data;
//用于获取服务器返回的错误信息

@optional
-(id)manager:(YFAPIBaseManager *)manager failedReform:(NSDictionary *)data;

@end

/*************************************************************************************************/
/*                                     YFAPIManagerValidator                                     */
/*************************************************************************************************/

@protocol YFAPIManagerValidator <NSObject>

@required

- (BOOL)manager:(YFAPIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data;

- (BOOL)manager:(YFAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data;

@end

/*************************************************************************************************/
/*                                YFAPIManagerParamSourceDelegate                                */
/*************************************************************************************************/

@protocol YFAPIManagerParamSource <NSObject>

@required
- (NSDictionary *)paramsForApi:(YFAPIBaseManager *)manager;

@end


typedef NS_ENUM (NSUInteger, YFAPIManagerErrorType) {
    YFAPIManagerErrorTypeDefault,       //没有产生过API请求，这个是manager的默认状态。
    YFAPIManagerErrorTypeSuccess,       //API请求成功且返回数据正确，此时manager的数据是可以直接拿来使用的。
    YFAPIManagerErrorTypeNoContent,     //API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。
    YFAPIManagerErrorTypeParamsError,   //参数错误，此时manager不会调用API，因为参数验证是在调用API之前做的。
    YFAPIManagerErrorTypeTimeout,       //请求超时。CTAPIProxy设置的是20秒超时，具体超时时间的设置请自己去看CTAPIProxy的相关代码。
    YFAPIManagerErrorTypeNoNetWork      //网络不通。在调用API之前会判断一下当前网络是否通畅，这个也是在调用API之前验证的，和上面超时的状态是有区别的。
};

typedef NS_ENUM (NSUInteger, YFAPIManagerRequestType){
    YFAPIManagerRequestTypeGet,
    YFAPIManagerRequestTypePost,
    YFAPIManagerRequestTypePut,
    YFAPIManagerRequestTypeDelete
};

/*************************************************************************************************/
/*                                         YFAPIManager                                          */
/*************************************************************************************************/
/*
 YFAPIBaseManager的派生类必须符合这些protocal
 */
@protocol YFAPIManager <NSObject>

@required
- (NSString *)methodName;
- (NSString *)serviceType;
- (YFAPIManagerRequestType)requestType;
- (BOOL)shouldCache;

// used for pagable API Managers mainly
@optional
- (void)cleanData;
- (NSDictionary *)reformParams:(NSDictionary *)params;
- (NSInteger)loadDataWithParams:(NSDictionary *)params;
- (BOOL)shouldLoadFromNative;

@end

/*************************************************************************************************/
/*                                    YFAPIManagerInterceptor                                    */
/*************************************************************************************************/
/*
 YFAPIBaseManager的派生类必须符合这些protocal
 */
@protocol YFAPIManagerInterceptor <NSObject>

@optional
- (BOOL)manager:(YFAPIBaseManager *)manager beforePerformSuccessWithResponse:(YFURLResponse *)response;
- (void)manager:(YFAPIBaseManager *)manager afterPerformSuccessWithResponse:(YFURLResponse *)response;

- (BOOL)manager:(YFAPIBaseManager *)manager beforePerformFailWithResponse:(YFURLResponse *)response;
- (void)manager:(YFAPIBaseManager *)manager afterPerformFailWithResponse:(YFURLResponse *)response;

- (BOOL)manager:(YFAPIBaseManager *)manager shouldCallAPIWithParams:(NSDictionary *)params;
- (void)manager:(YFAPIBaseManager *)manager afterCallingAPIWithParams:(NSDictionary *)params;

@end

/*************************************************************************************************/
/*                                       YFAPIBaseManager                                        */
/*************************************************************************************************/
@interface YFAPIBaseManager : NSObject

@property (nonatomic, weak) id<YFAPIManagerCallBackDelegate> delegate;
@property (nonatomic, weak) id<YFAPIManagerParamSource> paramSource;
@property (nonatomic, weak) id<YFAPIManagerValidator> validator;
@property (nonatomic, weak) NSObject<YFAPIManager> *child; //里面会调用到NSObject的方法，所以这里不用id
@property (nonatomic, weak) id<YFAPIManagerInterceptor> interceptor;


@property (nonatomic, copy, readonly) NSString *errorMessage;
@property (nonatomic, readonly) YFAPIManagerErrorType errorType;
@property (nonatomic, strong) YFURLResponse *response;

@property (nonatomic, assign, readonly) BOOL isReachable;
@property (nonatomic, assign, readonly) BOOL isLoading;

- (id)fetchDataWithReformer:(id<YFAPIManagerDataReformer>)reformer;

//来去从服务器获得的错误信息
- (id)fetchFailedRequstMsg:(id<YFAPIManagerDataReformer>)reformer;

//尽量使用loadData这个方法,这个方法会通过param source来获得参数，这使得参数的生成逻辑位于controller中的固定位置
- (NSInteger)loadData;

- (void)cancelAllRequests;
- (void)cancelRequestWithRequestId:(NSInteger)requestID;

// 拦截器方法，继承之后需要调用一下super
- (BOOL)beforePerformSuccessWithResponse:(YFURLResponse *)response;
- (void)afterPerformSuccessWithResponse:(YFURLResponse *)response;

- (BOOL)beforePerformFailWithResponse:(YFURLResponse *)response;
- (void)afterPerformFailWithResponse:(YFURLResponse *)response;

- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params;
- (void)afterCallingAPIWithParams:(NSDictionary *)params;

- (NSDictionary *)reformParams:(NSDictionary *)params;
- (void)cleanData;
- (BOOL)shouldCache;

- (void)successedOnCallingAPI:(YFURLResponse *)response;
- (void)failedOnCallingAPI:(YFURLResponse *)response withErrorType:(YFAPIManagerErrorType)errorType;

@end


