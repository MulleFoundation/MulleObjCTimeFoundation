#ifdef __MULLE_OBJC__
# import <MulleObjCTimeFoundation/MulleObjCTimeFoundation.h>
#else
# import <Foundation/Foundation.h>
#endif

@interface NSDate (Forward)
- (BOOL) isEqualToDate:(NSDate *) other;
@end

//
// Tests for NSDate equality, hash, dateByAddingTimeInterval,
// earlierDate, laterDate.
//

int   main( void)
{
   @autoreleasepool
   {
      NSDate   *d1 = [NSDate dateWithTimeIntervalSinceReferenceDate:100.0];
      NSDate   *d2 = [NSDate dateWithTimeIntervalSinceReferenceDate:100.0];
      NSDate   *d3 = [NSDate dateWithTimeIntervalSinceReferenceDate:200.0];
      NSDate   *d4 = [NSDate dateWithTimeIntervalSinceReferenceDate:-50.0];

      // -isEqualToDate: same interval => YES
      if( ! [d1 isEqualToDate:d2])
      {
         printf( "FAIL: isEqualToDate: equal dates returned NO\n");
         return( 1);
      }
      printf( "isEqualToDate: equal: YES\n");

      // -isEqualToDate: different interval => NO
      if( [d1 isEqualToDate:d3])
      {
         printf( "FAIL: isEqualToDate: different dates returned YES\n");
         return( 1);
      }
      printf( "isEqualToDate: different: NO\n");

      // -isEqualToDate:nil => NO
      if( [d1 isEqualToDate:nil])
      {
         printf( "FAIL: isEqualToDate:nil returned YES\n");
         return( 1);
      }
      printf( "isEqualToDate:nil: NO\n");

      // -isEqual: same date => YES
      if( ! [d1 isEqual:d2])
      {
         printf( "FAIL: isEqual: equal dates returned NO\n");
         return( 1);
      }
      printf( "isEqual: equal: YES\n");

      // -isEqual: non-NSDate object => NO
      NSObject   *obj = [[[NSObject alloc] init] autorelease];
      if( [d1 isEqual:obj])
      {
         printf( "FAIL: isEqual: non-date returned YES\n");
         return( 1);
      }
      printf( "isEqual: non-date: NO\n");

      // -hash: equal dates must have equal hashes
      if( [d1 hash] != [d2 hash])
      {
         printf( "FAIL: hash: equal dates have different hashes\n");
         return( 1);
      }
      printf( "hash: equal dates have equal hashes\n");

      // -dateByAddingTimeInterval:
      {
         NSDate         *added    = [d1 dateByAddingTimeInterval:50.0];
         NSTimeInterval  expected = 150.0;

         if( [added timeIntervalSinceReferenceDate] != expected)
         {
            printf( "FAIL: dateByAddingTimeInterval:50 from 100 -> %.1f (expected %.1f)\n",
                    [added timeIntervalSinceReferenceDate], expected);
            return( 1);
         }
         printf( "dateByAddingTimeInterval:50 from 100 -> 150.0\n");
      }

      // -timeIntervalSinceDate:
      {
         NSTimeInterval  diff = [d3 timeIntervalSinceDate:d1];   // 200 - 100 = 100

         if( diff != 100.0)
         {
            printf( "FAIL: timeIntervalSinceDate: %.1f (expected 100.0)\n", diff);
            return( 1);
         }
         printf( "timeIntervalSinceDate: 200 - 100 = 100.0\n");
      }

      // -earlierDate: returns the date with smaller interval
      if( [d1 earlierDate:d3] != d1)
      {
         printf( "FAIL: earlierDate: did not return earlier date\n");
         return( 1);
      }
      printf( "earlierDate: returns earlier\n");

      if( [d3 earlierDate:d1] != d1)
      {
         printf( "FAIL: earlierDate: reversed args did not return earlier date\n");
         return( 1);
      }
      printf( "earlierDate: reversed args: returns earlier\n");

      // -earlierDate:nil => self (Apple compatible)
      if( [d1 earlierDate:nil] != d1)
      {
         printf( "FAIL: earlierDate:nil did not return self\n");
         return( 1);
      }
      printf( "earlierDate:nil -> self\n");

      // -earlierDate: equal dates => returns self (diff == 0 => self path)
      if( [d1 earlierDate:d2] != d1)
      {
         printf( "FAIL: earlierDate: equal dates did not return self\n");
         return( 1);
      }
      printf( "earlierDate: equal dates -> self\n");

      // -laterDate: returns the date with larger interval
      if( [d1 laterDate:d3] != d3)
      {
         printf( "FAIL: laterDate: did not return later date\n");
         return( 1);
      }
      printf( "laterDate: returns later\n");

      if( [d3 laterDate:d1] != d3)
      {
         printf( "FAIL: laterDate: reversed args did not return later date\n");
         return( 1);
      }
      printf( "laterDate: reversed args: returns later\n");

      // -laterDate:nil => self (Apple compatible)
      if( [d1 laterDate:nil] != d1)
      {
         printf( "FAIL: laterDate:nil did not return self\n");
         return( 1);
      }
      printf( "laterDate:nil -> self\n");

      // -laterDate: equal dates => returns self (diff == 0 => self path)
      if( [d1 laterDate:d2] != d1)
      {
         printf( "FAIL: laterDate: equal dates did not return self\n");
         return( 1);
      }
      printf( "laterDate: equal dates -> self\n");

      // negative interval date
      if( [d4 timeIntervalSinceReferenceDate] != -50.0)
      {
         printf( "FAIL: negative interval date wrong\n");
         return( 1);
      }
      printf( "negative interval date: -50.0\n");
   }

   return( 0);
}
