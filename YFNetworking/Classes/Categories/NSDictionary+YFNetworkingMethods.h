//
//  NSDictionary+YFNetworkingMethods.h
//  Pods
//
//  Created by sky on 2018/1/2.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (YFNetworkingMethods)

- (NSString *)yf_urlParamsStringSignature:(BOOL)isForSignature;
- (NSString *)yf_jsonString;
- (NSArray *)yf_transformedUrlParamsArraySignature:(BOOL)isForSignature;

@end
