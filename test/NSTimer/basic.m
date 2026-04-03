#ifdef __MULLE_OBJC__
# import <MulleObjCTimeFoundation/MulleObjCTimeFoundation.h>
#else
# import <Foundation/Foundation.h>
#endif

//
// Tests for NSTimer: construction, fire, isValid, invalidate,
// nil guards, userInfo, and accessor methods.
//

static int   gCallbackCount;
static id    gCallbackUserInfo;

static void   timerCallback( NSTimer *t, id userInfo)
{
   gCallbackCount++;
   gCallbackUserInfo = userInfo;
}


@interface TimerTarget : NSObject
{
   int   _fireCount;
   id    _lastArg;
}

- (int) fireCount;
- (id) lastArg;
- (void) fired:(id) arg;
- (void) firedWithTimer:(NSTimer *) t;

@end

@implementation TimerTarget

- (int) fireCount  { return _fireCount; }
- (id) lastArg     { return _lastArg; }

- (void) fired:(id) arg
{
   _fireCount++;
   [_lastArg autorelease];
   _lastArg = [arg retain];
}

- (void) firedWithTimer:(NSTimer *) t
{
   _fireCount++;
}

- (void) dealloc
{
   [_lastArg release];
   [super dealloc];
}

@end


int   main( void)
{
   @autoreleasepool
   {
      NSTimer      *t;
      TimerTarget  *target;

      // --- nil guards ---

      // nil target → returns nil
      t = [NSTimer mulleTimerWithRelativeTimeInterval:1.0
                                       repeatInterval:0.0
                                               target:nil
                                             selector:@selector( fired:)
                                             userInfo:nil
                           fireUsesUserInfoAsArgument:NO];
      if( t != nil)
      {
         printf( "FAIL: nil target should return nil timer\n");
         return( 1);
      }
      printf( "nil target -> nil timer\n");

      // nil selector (0) → returns nil
      t = [NSTimer mulleTimerWithRelativeTimeInterval:1.0
                                       repeatInterval:0.0
                                               target:[[[NSObject alloc] init] autorelease]
                                             selector:0
                                             userInfo:nil
                           fireUsesUserInfoAsArgument:NO];
      if( t != nil)
      {
         printf( "FAIL: nil selector should return nil timer\n");
         return( 1);
      }
      printf( "nil selector -> nil timer\n");

      // nil callback → returns nil
      t = [NSTimer mulleTimerWithRelativeTimeInterval:1.0
                                       repeatInterval:0.0
                                             callback:NULL
                                             userInfo:nil];
      if( t != nil)
      {
         printf( "FAIL: nil callback should return nil timer\n");
         return( 1);
      }
      printf( "nil callback -> nil timer\n");

      // nil invocation → returns nil
      t = [NSTimer mulleTimerWithRelativeTimeInterval:1.0
                                       repeatInterval:0.0
                                           invocation:nil];
      if( t != nil)
      {
         printf( "FAIL: nil invocation should return nil timer\n");
         return( 1);
      }
      printf( "nil invocation -> nil timer\n");

      // --- selector-based timer, no repeat, passes self as arg ---
      target = [[[TimerTarget alloc] init] autorelease];

      t = [NSTimer mulleTimerWithRelativeTimeInterval:1.0
                                       repeatInterval:0.0
                                               target:target
                                             selector:@selector( fired:)
                                             userInfo:nil
                           fireUsesUserInfoAsArgument:NO];
      if( ! t)
      {
         printf( "FAIL: selector timer creation returned nil\n");
         return( 1);
      }
      printf( "selector timer created\n");

      if( ! [t isValid])
      {
         printf( "FAIL: new timer should be valid\n");
         return( 1);
      }
      printf( "isValid before fire: YES\n");

      // fire: target receives self (the timer) as argument
      [t fire];
      if( [target fireCount] != 1)
      {
         printf( "FAIL: fire did not call selector (count=%d)\n", [target fireCount]);
         return( 1);
      }
      printf( "fire called selector: OK\n");

      // non-repeat timer invalidates itself on fire
      if( [t isValid])
      {
         printf( "FAIL: non-repeat timer should be invalid after fire\n");
         return( 1);
      }
      printf( "non-repeat timer invalid after fire: OK\n");

      // fired arg is the timer itself (fireUsesUserInfoAsArgument=NO)
      if( [target lastArg] != t)
      {
         printf( "FAIL: fired arg should be timer itself, got something else\n");
         return( 1);
      }
      printf( "fired arg is timer (passUserInfo=NO): OK\n");

      // --- selector-based timer, passes userInfo as arg ---
      {
         id           info    = [NSDate dateWithTimeIntervalSinceReferenceDate:1.0];
         TimerTarget  *tgt2   = [[[TimerTarget alloc] init] autorelease];
         NSTimer      *t2     = [NSTimer mulleTimerWithRelativeTimeInterval:1.0
                                                             repeatInterval:0.0
                                                                     target:tgt2
                                                                   selector:@selector( fired:)
                                                                   userInfo:info
                                                 fireUsesUserInfoAsArgument:YES];
         [t2 fire];
         if( [tgt2 lastArg] != info)
         {
            printf( "FAIL: fired arg should be userInfo, got something else\n");
            return( 1);
         }
         printf( "fired arg is userInfo (passUserInfo=YES): OK\n");
      }

      // --- repeat timer stays valid after fire ---
      {
         TimerTarget  *tgt3 = [[[TimerTarget alloc] init] autorelease];
         NSTimer      *t3   = [NSTimer mulleTimerWithRelativeTimeInterval:1.0
                                                           repeatInterval:1.0
                                                                   target:tgt3
                                                                 selector:@selector( firedWithTimer:)
                                                                 userInfo:nil
                                               fireUsesUserInfoAsArgument:NO];
         [t3 fire];
         if( ! [t3 isValid])
         {
            printf( "FAIL: repeat timer should still be valid after fire\n");
            return( 1);
         }
         printf( "repeat timer valid after fire: OK\n");

         [t3 fire];
         if( [tgt3 fireCount] != 2)
         {
            printf( "FAIL: repeat timer should fire multiple times (count=%d)\n",
                    [tgt3 fireCount]);
            return( 1);
         }
         printf( "repeat timer fires multiple times: OK\n");

         [t3 invalidate];
         if( [t3 isValid])
         {
            printf( "FAIL: invalidated timer should not be valid\n");
            return( 1);
         }
         printf( "invalidate -> isValid: NO\n");
      }

      // --- callback-based timer ---
      {
         id          info = [NSDate dateWithTimeIntervalSinceReferenceDate:2.0];
         NSTimer    *t4   = [NSTimer mulleTimerWithRelativeTimeInterval:1.0
                                                         repeatInterval:0.0
                                                               callback:timerCallback
                                                               userInfo:info];
         if( ! t4)
         {
            printf( "FAIL: callback timer creation returned nil\n");
            return( 1);
         }
         printf( "callback timer created\n");

         gCallbackCount    = 0;
         gCallbackUserInfo = nil;
         [t4 fire];
         if( gCallbackCount != 1)
         {
            printf( "FAIL: callback not called on fire (count=%d)\n", gCallbackCount);
            return( 1);
         }
         printf( "callback called on fire: OK\n");

         if( gCallbackUserInfo != info)
         {
            printf( "FAIL: callback userInfo mismatch\n");
            return( 1);
         }
         printf( "callback userInfo: OK\n");

         // non-repeat callback timer also invalidates on fire
         if( [t4 isValid])
         {
            printf( "FAIL: non-repeat callback timer should be invalid after fire\n");
            return( 1);
         }
         printf( "non-repeat callback timer invalid after fire: OK\n");
      }

      // --- accessors ---
      {
         id           info   = [NSDate dateWithTimeIntervalSinceReferenceDate:3.0];
         TimerTarget  *tgt5   = [[[TimerTarget alloc] init] autorelease];
         NSTimer      *t5     = [NSTimer mulleTimerWithRelativeTimeInterval:2.0
                                                             repeatInterval:3.0
                                                                     target:tgt5
                                                                   selector:@selector( firedWithTimer:)
                                                                   userInfo:info
                                                 fireUsesUserInfoAsArgument:NO];

         if( [t5 userInfo] != info)
         {
            printf( "FAIL: userInfo accessor wrong\n");
            return( 1);
         }
         printf( "userInfo accessor: OK\n");

         if( [t5 mulleRepeatTimeInterval] != 3.0)
         {
            printf( "FAIL: mulleRepeatTimeInterval wrong: %.1f\n",
                    [t5 mulleRepeatTimeInterval]);
            return( 1);
         }
         printf( "mulleRepeatTimeInterval: 3.0\n");

         if( ! [t5 mulleIsRelativeTimer])
         {
            printf( "FAIL: mulleIsRelativeTimer should be YES for relative timer\n");
            return( 1);
         }
         printf( "mulleIsRelativeTimer: YES\n");

         // relative timer: mulleRelativeTimeInterval returns the relative interval
         if( [t5 mulleRelativeTimeInterval] != 2.0)
         {
            printf( "FAIL: mulleRelativeTimeInterval wrong: %.1f\n",
                    [t5 mulleRelativeTimeInterval]);
            return( 1);
         }
         printf( "mulleRelativeTimeInterval: 2.0\n");

         if( [t5 mulleTarget] != tgt5)
         {
            printf( "FAIL: mulleTarget wrong\n");
            return( 1);
         }
         printf( "mulleTarget: OK\n");

         if( [t5 mulleSelector] != @selector( firedWithTimer:))
         {
            printf( "FAIL: mulleSelector wrong\n");
            return( 1);
         }
         printf( "mulleSelector: OK\n");

         if( [t5 mulleFiresWithUserInfoAsArgument])
         {
            printf( "FAIL: mulleFiresWithUserInfoAsArgument should be NO\n");
            return( 1);
         }
         printf( "mulleFiresWithUserInfoAsArgument: NO\n");
      }

      // --- zero/negative interval clamped to _NSTIMER_MIN_TIMEINTERVAL ---
      {
         TimerTarget  *tgt6 = [[[TimerTarget alloc] init] autorelease];
         NSTimer      *t6   = [NSTimer mulleTimerWithRelativeTimeInterval:0.0
                                                           repeatInterval:0.0
                                                                   target:tgt6
                                                                 selector:@selector( firedWithTimer:)
                                                                 userInfo:nil
                                               fireUsesUserInfoAsArgument:NO];
         if( [t6 mulleRelativeTimeInterval] <= 0.0)
         {
            printf( "FAIL: zero interval should be clamped to min, got %.6f\n",
                    [t6 mulleRelativeTimeInterval]);
            return( 1);
         }
         printf( "zero interval clamped to _NSTIMER_MIN_TIMEINTERVAL: OK\n");

         // negative repeat clamped to 0.0 (non-repeating)
         NSTimer   *t7 = [NSTimer mulleTimerWithRelativeTimeInterval:1.0
                                                      repeatInterval:-1.0
                                                              target:tgt6
                                                            selector:@selector( firedWithTimer:)
                                                            userInfo:nil
                                          fireUsesUserInfoAsArgument:NO];
         if( [t7 mulleRepeatTimeInterval] != 0.0)
         {
            printf( "FAIL: negative repeatInterval should clamp to 0.0, got %.1f\n",
                    [t7 mulleRepeatTimeInterval]);
            return( 1);
         }
         printf( "negative repeatInterval clamped to 0.0: OK\n");
      }
   }

   return( 0);
}
