#ifdef __MULLE_OBJC__
# import <MulleObjCTimeFoundation/MulleObjCTimeFoundation.h>
#else
# import <Foundation/Foundation.h>
#endif

//
// Tests for NSLock(NSDate): lockBeforeDate:
//

int   main( void)
{
   @autoreleasepool
   {
      NSLock   *lock;
      NSDate   *soon;

      lock = [[[NSLock alloc] init] autorelease];
      soon = [NSDate dateWithTimeIntervalSinceReferenceDate:[NSDate timeIntervalSinceReferenceDate] + 0.5];

      // free lock should be acquired before a date half a second away
      if( ! [lock lockBeforeDate:soon])
      {
         printf( "FAIL: lockBeforeDate:+0.5 should succeed on free lock\n");
         return( 1);
      }
      printf( "lockBeforeDate:+0.5 on free lock -> YES\n");
      [lock unlock];
   }

   return( 0);
}
