#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 140000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 150000

#import "Xcode_12_0_XCTAutomationSupport_CDStructures.h"
#import "Xcode_12_0_SharedHeader.h"
#import <Foundation/Foundation.h>

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface NSPredicate (XCTAutomationSupport)
- (id)xct_matchedValuesOfClass:(Class)arg1 forKeyPath:(id)arg2;
- (id)_xct_requiredKeyPathsOrError:(id *)arg1;
@property(readonly, copy) NSSet *_xct_allExpressions;
@property(readonly) _Bool _xct_containsBlockOrFunctionPredicatesOrExpressions;
@property(readonly) _Bool _xct_supportsSecureCoding;
@end

#endif