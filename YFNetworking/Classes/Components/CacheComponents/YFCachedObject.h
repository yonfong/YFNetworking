//
//  YFCacheObject.h
//  Pods
//
//  Created by sky on 2018/1/2.
//

#import <Foundation/Foundation.h>

@interface YFCachedObject : NSObject

@property (nonatomic, copy, readonly) NSData *content;
@property (nonatomic, copy, readonly) NSDate *lastUpdateTime;

@property (nonatomic, assign, readonly) BOOL isOutdated;
@property (nonatomic, assign, readonly) BOOL isEmpty;

- (instancetype)initWithContent:(NSData *)content;
- (void)updateContent:(NSData *)content;

@end
