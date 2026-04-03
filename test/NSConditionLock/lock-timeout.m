#ifdef __MULLE_OBJC__
# import <MulleObjCTimeFoundation/MulleObjCTimeFoundation.h>
#else
# import <Foundation/Foundation.h>
#endif

//
// Test: mulleLockWhenCondition:timeout: must unlock on timeout
// when it acquired the lock but the condition never matched.
//
// Setup: lock starts at condition 1, nobody else holds it.
// Thread B calls mulleLockWhenCondition:2 timeout:0.1
//   → acquires lock (condition=1, not 2)
//   → waits for condition to become 2
//   → times out → should return NO AND release the lock
//
// If it doesn't release, main can never acquire → deadlock.
//

static NSConditionLock   *gLock;
static BOOL               gThreadDone;
static BOOL               gThreadFailed;


// Standalone helper — avoids a category on NSConditionLock which conflicts
// with static libgcov when the test binary uses -Wl,--export-dynamic.
@interface LockTimeoutWorker : NSObject
- (void) runWorker:(id) argument;
@end

@implementation LockTimeoutWorker

- (void) runWorker:(id) argument
{
   BOOL   result;

   @autoreleasepool
   {
      // Lock is free at condition 1. We want condition 2 — should time out.
      result = [gLock mulleLockWhenCondition:2
                                     timeout:0.1];
      if( result)
      {
         gThreadFailed = YES;
         [gLock unlockWithCondition:1];
      }
      gThreadDone = YES;
   }
}

@end


int   main( void)
{
   LockTimeoutWorker   *worker;
   int                  i;

   // Lock starts free at condition 1
   gLock = [[[NSConditionLock alloc] initWithCondition:1] autorelease];

   worker = [[[LockTimeoutWorker alloc] init] autorelease];

   // Start worker: acquires lock, waits for condition 2, should time out
   [NSThread detachNewThreadSelector:@selector( runWorker:)
                            toTarget:worker
                          withObject:nil];

   // Wait up to 1s for worker to finish
   for( i = 0; i < 20; i++)
   {
      mulle_relativetime_sleep( 0.05);
      if( gThreadDone)
         break;
   }

   if( ! gThreadDone)
   {
      printf( "FAIL: worker stuck (lock not released after timeout)\n");
      return( 1);
   }

   if( gThreadFailed)
   {
      printf( "FAIL: worker acquired lock with wrong condition\n");
      return( 1);
   }

   printf( "worker timed out: OK\n");

   // Now main should be able to acquire the lock
   if( ! [gLock mulleLockWhenCondition:1
                                timeout:0.1])
   {
      printf( "FAIL: lock still held after worker timeout\n");
      return( 1);
   }

   printf( "main acquired lock after worker timeout: OK\n");
   [gLock unlockWithCondition:1];

   return( 0);
}
