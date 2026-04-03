#ifdef __MULLE_OBJC__
# import <MulleObjCTimeFoundation/MulleObjCTimeFoundation.h>
#else
# import <Foundation/Foundation.h>
#endif

//
// Tests for NSConditionLock NSDate-based API:
//   lockWhenCondition:beforeDate:
//   lockBeforeDate:
//   mulleLockWhenCondition:waitUntilTimeInterval:
//   mulleLockWhenCondition:waitUntilDate:
//   mulleLockWithTimeout:
//   mulleLockBeforeTimeInterval:
//

int   main( void)
{
   @autoreleasepool
   {
      NSConditionLock   *lock;
      NSDate            *soon;
      NSDate            *past;

      lock = [[[NSConditionLock alloc] initWithCondition:7] autorelease];
      soon = [NSDate dateWithTimeIntervalSinceReferenceDate:[NSDate timeIntervalSinceReferenceDate] + 0.5];
      past = [NSDate dateWithTimeIntervalSinceReferenceDate:[NSDate timeIntervalSinceReferenceDate] - 1.0];

      // --- lockWhenCondition:beforeDate: success (condition already met) ---
      if( ! [lock lockWhenCondition:7 beforeDate:soon])
      {
         printf( "FAIL: lockWhenCondition:7 beforeDate:+0.5 should succeed\n");
         return( 1);
      }
      printf( "lockWhenCondition:7 beforeDate:+0.5 -> YES\n");
      [lock unlockWithCondition:7];

      // --- lockWhenCondition:beforeDate: timeout (condition not met) ---
      if( [lock lockWhenCondition:99 beforeDate:past])
      {
         printf( "FAIL: lockWhenCondition:99 beforeDate:past should time out\n");
         [lock unlockWithCondition:7];
         return( 1);
      }
      printf( "lockWhenCondition:99 beforeDate:past -> NO (timeout)\n");

      // verify lock is free after timeout
      if( ! [lock tryLock])
      {
         printf( "FAIL: lock stuck after lockWhenCondition:beforeDate: timeout\n");
         return( 1);
      }
      printf( "lock free after lockWhenCondition:beforeDate: timeout\n");
      [lock unlock];

      // --- lockBeforeDate: success ---
      if( ! [lock lockBeforeDate:soon])
      {
         printf( "FAIL: lockBeforeDate:+0.5 should succeed\n");
         return( 1);
      }
      printf( "lockBeforeDate:+0.5 -> YES\n");
      [lock unlock];

      // --- mulleLockWhenCondition:waitUntilTimeInterval: success ---
      {
         NSTimeInterval   deadline = [NSDate timeIntervalSinceReferenceDate] + 0.5;

         if( ! [lock mulleLockWhenCondition:7
                       waitUntilTimeInterval:deadline])
         {
            printf( "FAIL: mulleLockWhenCondition:7 waitUntilTimeInterval:+0.5 should succeed\n");
            return( 1);
         }
         printf( "mulleLockWhenCondition:7 waitUntilTimeInterval:+0.5 -> YES\n");
         [lock unlockWithCondition:7];
      }

      // --- mulleLockWhenCondition:waitUntilTimeInterval: timeout ---
      {
         NSTimeInterval   past_ti = [NSDate timeIntervalSinceReferenceDate] - 1.0;

         if( [lock mulleLockWhenCondition:99
                     waitUntilTimeInterval:past_ti])
         {
            printf( "FAIL: mulleLockWhenCondition:99 waitUntilTimeInterval:past should fail\n");
            [lock unlockWithCondition:7];
            return( 1);
         }
         printf( "mulleLockWhenCondition:99 waitUntilTimeInterval:past -> NO\n");

         // lock must be free
         if( ! [lock tryLock])
         {
            printf( "FAIL: lock stuck after mulleLockWhenCondition:waitUntilTimeInterval: timeout\n");
            return( 1);
         }
         printf( "lock free after mulleLockWhenCondition:waitUntilTimeInterval: timeout\n");
         [lock unlock];
      }

      // --- mulleLockWhenCondition:waitUntilDate: success ---
      if( ! [lock mulleLockWhenCondition:7 waitUntilDate:soon])
      {
         printf( "FAIL: mulleLockWhenCondition:7 waitUntilDate:+0.5 should succeed\n");
         return( 1);
      }
      printf( "mulleLockWhenCondition:7 waitUntilDate:+0.5 -> YES\n");
      [lock unlockWithCondition:7];

      // --- mulleLockWithTimeout: success ---
      if( ! [lock mulleLockWithTimeout:0.5])
      {
         printf( "FAIL: mulleLockWithTimeout:0.5 should succeed\n");
         return( 1);
      }
      printf( "mulleLockWithTimeout:0.5 -> YES\n");
      [lock unlock];

      // --- mulleLockBeforeTimeInterval: success ---
      {
         NSTimeInterval   deadline = [NSDate timeIntervalSinceReferenceDate] + 0.5;

         if( ! [lock mulleLockBeforeTimeInterval:deadline])
         {
            printf( "FAIL: mulleLockBeforeTimeInterval:+0.5 should succeed\n");
            return( 1);
         }
         printf( "mulleLockBeforeTimeInterval:+0.5 -> YES\n");
         [lock unlock];
      }
   }

   return( 0);
}
