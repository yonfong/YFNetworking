//
//  UIDevice+YFNetworkingMethods.h
//  Pods
//
//  Created by sky on 2018/1/2.
//

#import <UIKit/UIKit.h>

@interface UIDevice (YFNetworkingMethods)

- (NSString *) yf_macaddress;
- (NSString *) yf_macaddressMD5;
- (NSString *) yf_machineType;
- (NSString *) yf_ostype;//显示“ios6，ios5”，只显示大版本号

@end
