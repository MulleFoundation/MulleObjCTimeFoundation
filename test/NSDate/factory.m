#ifdef __MULLE_OBJC__
# import <MulleObjCTimeFoundation/MulleObjCTimeFoundation.h>
#else
# import <Foundation/Foundation.h>
#endif

// __isNSDate is a private runtime method declared in NSDate.m
@interface NSObject( _NSDate)
- (BOOL) __isNSDate;
@end

//
// Tests for NSDate factory methods and convenience constructors.
//

int   main( void)
{
   @autoreleasepool
   {
      NSDate         *d;
      NSTimeInterval  t;
      NSObject       *obj;

      // -[NSObject __isNSDate] must return NO
      obj = [[[NSObject alloc] init] autorelease];
      if( [obj __isNSDate])
      {
         printf( "FAIL: NSObject.__isNSDate returned YES\n");
         return( 1);
      }
      printf( "NSObject.__isNSDate: NO\n");

      // -[NSDate __isNSDate] must return YES
      d = [NSDate dateWithTimeIntervalSinceReferenceDate:0.0];
      if( ! [d __isNSDate])
      {
         printf( "FAIL: NSDate.__isNSDate returned NO\n");
         return( 1);
      }
      printf( "NSDate.__isNSDate: YES\n");

      // +date returns a non-nil date close to now
      d = [NSDate date];
      if( ! d)
      {
         printf( "FAIL: +date returned nil\n");
         return( 1);
      }
      printf( "+date: not nil\n");

      // +distantFuture
      d = [NSDate distantFuture];
      t = [d timeIntervalSinceReferenceDate];
      if( t != _NSDistantFuture)
      {
         printf( "FAIL: distantFuture interval %.1f != expected %.1f\n", t, _NSDistantFuture);
         return( 1);
      }
      printf( "+distantFuture: %.0f\n", t);

      // +distantPast
      d = [NSDate distantPast];
      t = [d timeIntervalSinceReferenceDate];
      if( t != _NSDistantPast)
      {
         printf( "FAIL: distantPast interval %.1f != expected %.1f\n", t, _NSDistantPast);
         return( 1);
      }
      printf( "+distantPast: %.0f\n", t);

      // +dateWithTimeIntervalSince1970: the 2001 epoch maps to reference 0.0
      d = [NSDate dateWithTimeIntervalSince1970:NSTimeIntervalSince1970];
      t = [d timeIntervalSinceReferenceDate];
      if( t != 0.0)
      {
         printf( "FAIL: dateWithTimeIntervalSince1970:978307200 -> %.1f (expected 0.0)\n", t);
         return( 1);
      }
      printf( "+dateWithTimeIntervalSince1970:978307200 -> reference 0.0\n");

      // -initWithTimeIntervalSince1970:
      d = [[[NSDate alloc] initWithTimeIntervalSince1970:NSTimeIntervalSince1970] autorelease];
      t = [d timeIntervalSinceReferenceDate];
      if( t != 0.0)
      {
         printf( "FAIL: initWithTimeIntervalSince1970:978307200 -> %.1f (expected 0.0)\n", t);
         return( 1);
      }
      printf( "-initWithTimeIntervalSince1970:978307200 -> reference 0.0\n");

      // -timeIntervalSince1970 round-trip
      d = [NSDate dateWithTimeIntervalSinceReferenceDate:0.0];
      if( [d timeIntervalSince1970] != NSTimeIntervalSince1970)
      {
         printf( "FAIL: timeIntervalSince1970 round-trip: %.1f (expected %.1f)\n",
                 [d timeIntervalSince1970], NSTimeIntervalSince1970);
         return( 1);
      }
      printf( "-timeIntervalSince1970 round-trip: %.0f\n", [d timeIntervalSince1970]);

      // +dateWithTimeIntervalSinceReferenceDate:
      d = [NSDate dateWithTimeIntervalSinceReferenceDate:42.0];
      t = [d timeIntervalSinceReferenceDate];
      if( t != 42.0)
      {
         printf( "FAIL: dateWithTimeIntervalSinceReferenceDate:42 -> %.1f\n", t);
         return( 1);
      }
      printf( "+dateWithTimeIntervalSinceReferenceDate:42.0 -> 42.0\n");

      // -initWithTimeInterval:sinceDate:
      // Expected: base(100.0) + 50.0 seconds = 150.0
      {
         NSDate   *base   = [NSDate dateWithTimeIntervalSinceReferenceDate:100.0];
         NSDate   *result = [[[NSDate alloc] initWithTimeInterval:50.0
                                                        sinceDate:base] autorelease];
         NSTimeInterval  expected = 150.0;

         t = [result timeIntervalSinceReferenceDate];
         if( t != expected)
         {
            printf( "FAIL: initWithTimeInterval:50 sinceDate:100 -> %.1f (expected %.1f)\n",
                    t, expected);
            return( 1);
         }
         printf( "-initWithTimeInterval:50 sinceDate:100 -> 150.0\n");
      }
   }

   return( 0);
}
