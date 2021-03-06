#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 140000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 150000

#import "Xcode_12_0_XCTest_CDStructures.h"
#import "Xcode_12_0_SharedHeader.h"
#import <XCTest/XCTNSPredicateExpectation.h>
#import <XCTest/XCTestExpectation.h>

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCTNSPredicateExpectation ()
{
    _Bool _hasCleanedUp;
    _Bool _isEvaluating;
    _Bool _shouldEvaluate;
    CDUnknownBlockType _handler;
    NSString *_debugDescription;
    NSPredicate *_predicate;
    id _object;
    NSObject *_queue;
    NSRunLoop *_timerRunLoop;
    NSTimer *_timer;
    double _pollingInterval;
}

@property double pollingInterval; // @synthesize pollingInterval=_pollingInterval;
@property _Bool shouldEvaluate; // @synthesize shouldEvaluate=_shouldEvaluate;
@property _Bool isEvaluating; // @synthesize isEvaluating=_isEvaluating;
@property _Bool hasCleanedUp; // @synthesize hasCleanedUp=_hasCleanedUp;
@property(retain) NSTimer *timer; // @synthesize timer=_timer;
@property(retain) NSRunLoop *timerRunLoop; // @synthesize timerRunLoop=_timerRunLoop;
@property(readonly) NSObject *queue; // @synthesize queue=_queue;
@property(copy) NSString *debugDescription; // @synthesize debugDescription=_debugDescription;
- (void)cleanup;
- (void)fulfill;
- (_Bool)_shouldFulfillForObject:(id)arg1 handler:(CDUnknownBlockType)arg2;
- (void)_considerFulfilling;
- (void)_scheduleTimer;
- (void)startPolling;
- (void)on_queue_setHasBeenWaitedOn:(_Bool)arg1;

- (void)dealloc;

// Remaining properties

@end

#endif