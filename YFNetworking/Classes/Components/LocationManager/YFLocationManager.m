//
//  YFLocationManager.m
//  Pods
//
//  Created by sky on 2018/1/2.
//

#import "YFLocationManager.h"

@interface YFLocationManager () <CLLocationManagerDelegate>

@property (nonatomic, assign, readwrite) YFLocationManagerLocationResult locationResult;
@property (nonatomic, assign, readwrite) YFLocationManagerLocationServiceStatus locationStatus;
@property (nonatomic, copy, readwrite) CLLocation *currentLocation;

@property (nonatomic, strong) CLLocationManager *locationManager;

@end


@implementation YFLocationManager

+ (instancetype)sharedInstance {
    static YFLocationManager *locationManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locationManager = [[YFLocationManager alloc] init];
    });
    return locationManager;
}

- (void)startLocation {
    if ([self checkLocationStatus]) {
        self.locationResult = YFLocationManagerLocationResultLocating;
        [self.locationManager startUpdatingLocation];
    } else {
        [self failedLocationWithResultType:YFLocationManagerLocationResultFail statusType:self.locationStatus];
    }
}

- (void)stopLocation {
    if ([self checkLocationStatus]) {
        [self.locationManager stopUpdatingLocation];
    }
}

- (void)restartLocation {
    [self stopLocation];
    [self startLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.currentLocation = [manager.location copy];
    NSLog(@"Current location is %@", self.currentLocation);
    [self stopLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    //如果用户还没选择是否允许定位，则不认为是定位失败
    if (self.locationStatus == YFLocationManagerLocationServiceStatusNotDetermined) {
        return;
    }
    
    //如果正在定位中，那么也不会通知到外面
    if (self.locationResult == YFLocationManagerLocationResultLocating) {
        return;
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.locationStatus = YFLocationManagerLocationServiceStatusOK;
        [self restartLocation];
    } else {
        if (self.locationStatus != YFLocationManagerLocationServiceStatusNotDetermined) {
            [self failedLocationWithResultType:YFLocationManagerLocationResultDefault statusType:YFLocationManagerLocationServiceStatusNoAuthorization];
        } else {
            [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager startUpdatingLocation];
        }
    }
}

#pragma mark - private methods
- (void)failedLocationWithResultType:(YFLocationManagerLocationResult)result statusType:(YFLocationManagerLocationServiceStatus)status {
    self.locationResult = result;
    self.locationStatus = status;
}

- (BOOL)checkLocationStatus; {
    BOOL result = NO;
    BOOL serviceEnable = [self locationServiceEnabled];
    YFLocationManagerLocationServiceStatus authorizationStatus = [self locationServiceStatus];
    if (authorizationStatus == YFLocationManagerLocationServiceStatusOK && serviceEnable) {
        result = YES;
    } else if (authorizationStatus == YFLocationManagerLocationServiceStatusNotDetermined) {
        result = YES;
    } else {
        result = NO;
    }
    
    if (serviceEnable && result) {
        result = YES;
    } else {
        result = NO;
    }
    
    if (result == NO) {
        [self failedLocationWithResultType:YFLocationManagerLocationResultFail statusType:self.locationStatus];
    }
    
    return result;
}

- (BOOL)locationServiceEnabled {
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationStatus = YFLocationManagerLocationServiceStatusOK;
        return YES;
    } else {
        self.locationStatus = YFLocationManagerLocationServiceStatusUnknownError;
        return NO;
    }
}

- (YFLocationManagerLocationServiceStatus)locationServiceStatus {
    self.locationStatus = YFLocationManagerLocationServiceStatusUnknownError;
    BOOL serviceEnable = [CLLocationManager locationServicesEnabled];
    if (serviceEnable) {
        CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
        switch (authorizationStatus) {
            case kCLAuthorizationStatusNotDetermined:
                self.locationStatus = YFLocationManagerLocationServiceStatusNotDetermined;
                break;
                
            case kCLAuthorizationStatusAuthorizedAlways :
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                self.locationStatus = YFLocationManagerLocationServiceStatusOK;
                break;
                
            case kCLAuthorizationStatusDenied:
                self.locationStatus = YFLocationManagerLocationServiceStatusNoAuthorization;
                break;
                
            default:
                break;
        }
    } else {
        self.locationStatus = YFLocationManagerLocationServiceStatusUnAvailable;
    }
    return self.locationStatus;
}

#pragma mark - getters and setters
- (CLLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _locationManager;
}


@end
