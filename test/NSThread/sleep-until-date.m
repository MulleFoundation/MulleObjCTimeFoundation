#ifdef __MULLE_OBJC__
# import <MulleObjCTimeFoundation/MulleObjCTimeFoundation.h>
#else
# import <Foundation/Foundation.h>
#endif

//
// Tests for NSThread(NSDate):
//   sleepUntilDate: with a past date  -> returns immediately
//   sleepUntilDate: with a near-future date -> sleeps briefly
//

int   main( void)
{
   @autoreleasepool
   {
      NSDate   *date;

      // past date: loop condition is false immediately
      date = [NSDate dateWithTimeIntervalSinceReferenceDate:[NSDate timeIntervalSinceReferenceDate] - 1.0];
      [NSThread sleepUntilDate:date];
      printf( "sleepUntilDate:past OK\n");

      // near-future date: actually sleeps ~20ms
      date = [NSDate dateWithTimeIntervalSinceReferenceDate:[NSDate timeIntervalSinceReferenceDate] + 0.02];
      [NSThread sleepUntilDate:date];
      printf( "sleepUntilDate:future OK\n");
   }

   return( 0);
}
