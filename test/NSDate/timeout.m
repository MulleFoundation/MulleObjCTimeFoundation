//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#ifdef __MULLE_OBJC__
# import <MulleObjCTimeFoundation/MulleObjCTimeFoundation.h>
#else
# import <Foundation/Foundation.h>
# pragma message( "Apple Foundation")
#endif


static void   print_fail_if( int state)
{
   if( state)
      printf( "FAIL\n");
}


int   main( int argc, const char * argv[])
{
   NSConditionLock   *lock;
   NSTimeInterval    before;
   NSTimeInterval    after;

#ifdef __MULLE_OBJC__
   if( mulle_objc_global_check_universe( __MULLE_OBJC_UNIVERSENAME__) != mulle_objc_universe_is_ok)
      return( 1);
#endif

   lock = [[[NSConditionLock alloc] initWithCondition:1848] autorelease];

   // exercise NSLocking protocol, which is done by NSCondition
   // really

   before = _NSTimeIntervalNow();
   if( [lock mulleLockWhenCondition:1849
                            timeout:0.75])
   {
      fprintf( stderr, "succeeded with wrong condition\n");
      return( 1);
   }

   after = _NSTimeIntervalNow();
   if( before + 0.75 > after)
   {
      fprintf( stderr, "timeout 1 too early (%.5f, %.5f)\n", before + 0.75, after);
      return( 1);
   }

   before = _NSTimeIntervalNow();
   if( [lock mulleLockWhenCondition:1849
                 beforeTimeInterval:before + 0.75])
   {
      fprintf( stderr, "succeeded with wrong condition\n");
      return( 1);
   }

   after = _NSTimeIntervalNow();
   if( before + 0.75 > after)
   {
      fprintf( stderr, "timeout 2 too early (%.5f, %.5f)\n", before + 0.75, after);
      return( 1);
   }

   return( 0);
}
