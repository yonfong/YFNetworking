//
//  NSMutableString+YFNetworkingMethods.m
//  Pods
//
//  Created by sky on 2018/1/2.
//

#import "NSMutableString+YFNetworkingMethods.h"
#import "NSObject+YFNetworkingMethods.h"

@implementation NSMutableString (YFNetworkingMethods)

- (void)yf_appendURLRequest:(NSURLRequest *)request
{
    [self appendFormat:@"\n\nHTTP URL:\n\t%@", request.URL];
    [self appendFormat:@"\n\nHTTP Header:\n%@", request.allHTTPHeaderFields ? request.allHTTPHeaderFields : @"\t\t\t\t\tN/A"];
    [self appendFormat:@"\n\nHTTP Body:\n\t%@", [[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding] yf_defaultValue:@"\t\t\t\tN/A"]];
}

@end
