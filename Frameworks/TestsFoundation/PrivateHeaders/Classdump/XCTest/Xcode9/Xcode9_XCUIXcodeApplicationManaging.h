#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 120000

#import "Xcode9_XCTest_CDStructures.h"
#import "Xcode9_SharedHeader.h"
#import <Foundation/Foundation.h>

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@protocol XCUIXcodeApplicationManaging <NSObject>
- (void)terminateProcessWithToken:(id)arg1 completion:(void (^)(_Bool, NSError *))arg2;
- (void)requestLaunchProgressForProcessWithToken:(id)arg1 completion:(void (^)(_Bool, float, NSError *))arg2;
- (void)launchProcessWithPath:(NSString *)arg1 bundleID:(NSString *)arg2 arguments:(NSArray *)arg3 environmentVariables:(NSDictionary *)arg4 completion:(void (^)(id, NSError *))arg5;
@end

#endif