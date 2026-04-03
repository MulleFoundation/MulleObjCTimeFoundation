#ifdef __MULLE_OBJC__
# import <MulleObjCTimeFoundation/MulleObjCTimeFoundation.h>
#else
# import <Foundation/Foundation.h>
#endif

//
// Regression test: mulleLockWhenCondition:timeout:0.0 must NOT leave lock
// locked when the condition is not met.
//
// Bug scenario (observed in UIWindowThread log):
//   - Lock is at condition 1, currently UNLOCKED
//   - Thread calls mulleLockWhenCondition:2 timeout:0.0
//   - timeout=0.0 => tryLockUntilTimeout succeeds immediately (lock is free),
//     returning diff=0.0 (not -1.0, so lock is acquired)
//   - Condition check: condition=1 != 2
//   - deadline - now() <= 0.0 => returns NO ... but never unlocks!
//   - Result: method returns NO but lock is left LOCKED
//
// This test verifies the fix: after a failed mulleLockWhenCondition:timeout:0.0
// call the lock must be free and acquirable.
//

int   main( void)
{
   NSConditionLock   *lock;
   BOOL               result;

   @autoreleasepool
   {
      // Lock starts free at condition 1; we want condition 2 with zero timeout.
      lock = [[[NSConditionLock alloc] initWithCondition:1] autorelease];

      result = [lock mulleLockWhenCondition:2
                                    timeout:0.0];
      if( result)
      {
         printf( "FAIL: mulleLockWhenCondition:2 timeout:0.0 returned YES unexpectedly\n");
         [lock unlockWithCondition:1];
         return( 1);
      }
      printf( "mulleLockWhenCondition:2 timeout:0.0 returned NO: OK\n");

      // The lock must be free now.  If the bug is present, this will fail.
      result = [lock mulleLockWhenCondition:1
                                    timeout:0.1];
      if( ! result)
      {
         printf( "FAIL: lock is stuck locked after zero-timeout miss\n");
         return( 1);
      }
      printf( "lock is free after zero-timeout miss: OK\n");
      [lock unlockWithCondition:1];
   }

   return( 0);
}
