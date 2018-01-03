//
//  YFLocationManager.h
//  Pods
//
//  Created by sky on 2018/1/2.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSUInteger, YFLocationManagerLocationServiceStatus) {
    YFLocationManagerLocationServiceStatusDefault,               //默认状态
    YFLocationManagerLocationServiceStatusOK,                    //定位功能正常
    YFLocationManagerLocationServiceStatusUnknownError,          //未知错误
    YFLocationManagerLocationServiceStatusUnAvailable,           //定位功能关掉了
    YFLocationManagerLocationServiceStatusNoAuthorization,       //定位功能打开，但是用户不允许使用定位
    YFLocationManagerLocationServiceStatusNoNetwork,             //没有网络
    YFLocationManagerLocationServiceStatusNotDetermined          //用户还没做出是否要允许应用使用定位功能的决定，第一次安装应用的时候会提示用户做出是否允许使用定位功能的决定
};

typedef NS_ENUM(NSUInteger, YFLocationManagerLocationResult) {
    YFLocationManagerLocationResultDefault,              //默认状态
    YFLocationManagerLocationResultLocating,             //定位中
    YFLocationManagerLocationResultSuccess,              //定位成功
    YFLocationManagerLocationResultFail,                 //定位失败
    YFLocationManagerLocationResultParamsError,          //调用API的参数错了
    YFLocationManagerLocationResultTimeout,              //超时
    YFLocationManagerLocationResultNoNetwork,            //没有网络
    YFLocationManagerLocationResultNoContent             //API没返回数据或返回数据是错的
};

@interface YFLocationManager : NSObject

@property (nonatomic, assign, readonly) YFLocationManagerLocationResult locationResult;
@property (nonatomic, assign,readonly) YFLocationManagerLocationServiceStatus locationStatus;
@property (nonatomic, copy, readonly) CLLocation *currentLocation;

+ (instancetype)sharedInstance;

- (void)startLocation;
- (void)stopLocation;
- (void)restartLocation;

@end

