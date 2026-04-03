#ifdef __MULLE_OBJC__
# import <MulleObjCTimeFoundation/MulleObjCTimeFoundation.h>
#else
# import <Foundation/Foundation.h>
#endif

//
// Tests for NSTimer(NSDate): calendar (absolute) timers
//   timerWithTimeInterval:invocation:repeats:        nil guard + real invocation
//   timerWithTimeInterval:target:selector:userInfo:repeats:
//   initWithFireDate:interval:target:selector:userInfo:repeats:
//   mulleInitWithFireTimeInterval:repeatInterval:invocation:
//   fireDate
//   mulleFireTimeInterval
//   timeInterval  (repeat interval)
//

@interface DateTimerTarget : NSObject
{
   int   _fireCount;
}

- (int) fireCount;
- (void) tick:(id) arg;

@end

@implementation DateTimerTarget

- (int) fireCount { return _fireCount; }

- (void) tick:(id) arg
{
   _fireCount++;
}

@end


int   main( void)
{
   @autoreleasepool
   {
      DateTimerTarget  *target;
      NSTimer          *t;

      target = [[[DateTimerTarget alloc] init] autorelease];

      // --- timerWithTimeInterval:invocation:repeats: nil invocation -> nil ---
      t = [NSTimer timerWithTimeInterval:1.0
                              invocation:nil
                                 repeats:NO];
      if( t != nil)
      {
         printf( "FAIL: nil invocation should return nil\n");
         return( 1);
      }
      printf( "timerWithTimeInterval:invocation:nil -> nil\n");

      // --- timerWithTimeInterval:target:selector:userInfo:repeats: nil target -> nil ---
      t = [NSTimer timerWithTimeInterval:1.0
                                  target:nil
                                selector:@selector( tick:)
                                userInfo:nil
                                 repeats:NO];
      if( t != nil)
      {
         printf( "FAIL: nil target should return nil\n");
         return( 1);
      }
      printf( "timerWithTimeInterval:target:nil -> nil\n");

      // --- nil selector -> nil ---
      t = [NSTimer timerWithTimeInterval:1.0
                                  target:target
                                selector:0
                                userInfo:nil
                                 repeats:NO];
      if( t != nil)
      {
         printf( "FAIL: nil selector should return nil\n");
         return( 1);
      }
      printf( "timerWithTimeInterval:selector:0 -> nil\n");

      // --- valid non-repeating calendar timer ---
      t = [NSTimer timerWithTimeInterval:1.0
                                  target:target
                                selector:@selector( tick:)
                                userInfo:nil
                                 repeats:NO];
      if( ! t)
      {
         printf( "FAIL: calendar timer creation returned nil\n");
         return( 1);
      }
      printf( "timerWithTimeInterval:target:selector: created\n");

      // fireDate must be non-nil for a calendar timer
      if( [t fireDate] == nil)
      {
         printf( "FAIL: fireDate should not be nil for calendar timer\n");
         return( 1);
      }
      printf( "fireDate != nil: OK\n");

      // mulleFireTimeInterval must be > 0 (absolute future time)
      if( [t mulleFireTimeInterval] <= 0.0)
      {
         printf( "FAIL: mulleFireTimeInterval should be > 0, got %.3f\n",
                 [t mulleFireTimeInterval]);
         return( 1);
      }
      printf( "mulleFireTimeInterval > 0: OK\n");

      // non-repeat: timeInterval returns 0
      if( [t timeInterval] != 0.0)
      {
         printf( "FAIL: non-repeat timeInterval should be 0.0, got %.3f\n",
                 [t timeInterval]);
         return( 1);
      }
      printf( "non-repeat timeInterval: 0.0\n");

      // fire: selector is called
      [t fire];
      if( [target fireCount] != 1)
      {
         printf( "FAIL: fire count should be 1, got %d\n", [target fireCount]);
         return( 1);
      }
      printf( "fire -> selector called\n");

      // --- repeating calendar timer: timeInterval == repeat interval ---
      t = [NSTimer timerWithTimeInterval:2.0
                                  target:target
                                selector:@selector( tick:)
                                userInfo:nil
                                 repeats:YES];
      if( [t timeInterval] != 2.0)
      {
         printf( "FAIL: repeat timeInterval should be 2.0, got %.3f\n",
                 [t timeInterval]);
         return( 1);
      }
      printf( "repeat timeInterval: 2.0\n");

      // --- zero interval clamped to minimum ---
      t = [NSTimer timerWithTimeInterval:0.0
                                  target:target
                                selector:@selector( tick:)
                                userInfo:nil
                                 repeats:NO];
      if( ! t || [t fireDate] == nil)
      {
         printf( "FAIL: zero-interval calendar timer should be created\n");
         return( 1);
      }
      printf( "zero interval calendar timer created: OK\n");

      // --- initWithFireDate:interval:target:selector:userInfo:repeats: repeating ---
      {
         NSDate           *fireDate;
         NSTimer          *t2;
         NSDate           *got;
         NSTimeInterval   delta;

         fireDate = [NSDate dateWithTimeIntervalSinceReferenceDate:
                        [NSDate timeIntervalSinceReferenceDate] + 5.0];
         t2 = [[[NSTimer alloc] initWithFireDate:fireDate
                                        interval:0.5
                                          target:target
                                        selector:@selector( tick:)
                                        userInfo:nil
                                         repeats:YES] autorelease];
         if( ! t2)
         {
            printf( "FAIL: initWithFireDate: returned nil\n");
            return( 1);
         }
         printf( "initWithFireDate:interval:target:selector: created\n");

         got   = [t2 fireDate];
         delta = [got timeIntervalSinceReferenceDate]
                 - [fireDate timeIntervalSinceReferenceDate];
         if( delta < -0.01 || delta > 0.01)
         {
            printf( "FAIL: fireDate mismatch, delta=%.6f\n", delta);
            return( 1);
         }
         printf( "fireDate matches initWithFireDate: OK\n");

         if( [t2 timeInterval] != 0.5)
         {
            printf( "FAIL: timeInterval should be 0.5, got %.3f\n", [t2 timeInterval]);
            return( 1);
         }
         printf( "initWithFireDate: timeInterval: 0.5\n");
      }

      // --- initWithFireDate: non-repeating: repeatInterval forced to 0 ---
      {
         NSDate   *fireDate;
         NSTimer  *t3;

         fireDate = [NSDate dateWithTimeIntervalSinceReferenceDate:
                        [NSDate timeIntervalSinceReferenceDate] + 1.0];
         t3 = [[[NSTimer alloc] initWithFireDate:fireDate
                                        interval:99.0
                                          target:target
                                        selector:@selector( tick:)
                                        userInfo:nil
                                         repeats:NO] autorelease];
         if( [t3 timeInterval] != 0.0)
         {
            printf( "FAIL: non-repeat initWithFireDate: timeInterval should be 0.0, got %.3f\n",
                    [t3 timeInterval]);
            return( 1);
         }
         printf( "initWithFireDate:repeats:NO -> timeInterval: 0.0\n");
      }

      // --- timerWithTimeInterval:invocation:repeats: with real NSInvocation ---
      {
         NSMethodSignature   *sig;
         NSInvocation        *inv;
         NSTimer             *t4;

         sig = [NSMethodSignature signatureWithObjCTypes:"v@:@"];
         inv = [NSInvocation invocationWithMethodSignature:sig];
         [inv setTarget:target];
         [inv setSelector:@selector( tick:)];

         t4 = [NSTimer timerWithTimeInterval:1.0
                                  invocation:inv
                                     repeats:NO];
         if( ! t4)
         {
            printf( "FAIL: timerWithTimeInterval:invocation: returned nil\n");
            return( 1);
         }
         printf( "timerWithTimeInterval:invocation: created\n");

         // fireDate non-nil for calendar timer
         if( [t4 fireDate] == nil)
         {
            printf( "FAIL: invocation timer fireDate should not be nil\n");
            return( 1);
         }
         printf( "invocation timer fireDate != nil: OK\n");

         // fire calls invocation
         int   before = [target fireCount];
         [t4 fire];
         if( [target fireCount] != before + 1)
         {
            printf( "FAIL: invocation timer fire did not call target\n");
            return( 1);
         }
         printf( "invocation timer fire called target: OK\n");
      }

      // --- timerWithTimeInterval:invocation:repeats:YES (repeat path) ---
      {
         NSMethodSignature   *sig;
         NSInvocation        *inv;
         NSTimer             *t5;

         sig = [NSMethodSignature signatureWithObjCTypes:"v@:@"];
         inv = [NSInvocation invocationWithMethodSignature:sig];
         [inv setTarget:target];
         [inv setSelector:@selector( tick:)];

         t5 = [NSTimer timerWithTimeInterval:2.0
                                  invocation:inv
                                     repeats:YES];
         if( ! t5)
         {
            printf( "FAIL: repeating invocation timer returned nil\n");
            return( 1);
         }
         if( [t5 timeInterval] != 2.0)
         {
            printf( "FAIL: repeating invocation timer timeInterval should be 2.0, got %.3f\n",
                    [t5 timeInterval]);
            return( 1);
         }
         printf( "repeating invocation timer timeInterval: 2.0\n");
      }
   }

   return( 0);
}
