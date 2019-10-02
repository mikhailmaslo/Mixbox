#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 140000

#import "Xcode_11_0_XCTAutomationSupport_CDStructures.h"
#import "Xcode_11_0_SharedHeader.h"
#import <Foundation/Foundation.h>

@class XCTCapabilities;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCTCapabilitiesBuilder : NSObject
{
    NSMutableDictionary *_capabilitiesDictionary;
}

@property(readonly, copy) NSMutableDictionary *capabilitiesDictionary; // @synthesize capabilitiesDictionary=_capabilitiesDictionary;
@property(readonly, copy) XCTCapabilities *capabilities;
- (void)upgradeCapability:(id)arg1 toVersion:(unsigned long long)arg2;
- (void)registerCapability:(id)arg1;
- (void)registerCapability:(id)arg1 version:(unsigned long long)arg2;
- (id)init;

@end

#endif