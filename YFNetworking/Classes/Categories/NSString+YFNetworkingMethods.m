//
//  NSString+YFNetworkingMethods.m
//  Pods
//
//  Created by sky on 2018/1/2.
//

#include <CommonCrypto/CommonDigest.h>
#import "NSString+YFNetworkingMethods.h"
#import "NSObject+YFNetworkingMethods.h"

@implementation NSString (YFNetworkingMethods)

- (NSString *)yf_md5 {
    NSData* inputData = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char outputData[CC_MD5_DIGEST_LENGTH];
    CC_MD5([inputData bytes], (unsigned int)[inputData length], outputData);
    
    NSMutableString* hashStr = [NSMutableString string];
    int i = 0;
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; ++i)
        [hashStr appendFormat:@"%02x", outputData[i]];
    
    return hashStr;
}


@end
