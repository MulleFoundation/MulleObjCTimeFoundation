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

#include <stdlib.h>
#include <unistd.h>



@implementation NSConditionLock( Test)


- (void) runThread:(id) lock
{
   BOOL   haveLock;

   [lock lockWhenCondition:0];
   [lock unlockWithCondition:1];

   for(;;)
   {
      haveLock = [lock mulleLockWhenCondition:2
                                      timeout:0.25];

      if( [[NSThread currentThread] isCancelled])
      {
         if( haveLock)
         {
            [lock unlockWithCondition:1];
            return;
         }
      }

      if( haveLock)
         [lock unlockWithCondition:1];
   }
}

@end



int   main( int argc, const char * argv[])
{
   NSConditionLock   *lock;
   NSThread          *thread;

#ifdef __MULLE_OBJC__
   if( mulle_objc_global_check_universe( __MULLE_OBJC_UNIVERSENAME__) != mulle_objc_universe_is_ok)
      return( 1);
#endif

   lock   = [[[NSConditionLock alloc] initWithCondition:0] autorelease];
   thread = [[[NSThread alloc] initWithTarget:lock
                                     selector:@selector( runThread:)
                                       object:lock] autorelease];

   [thread start];

   mulle_fprintf( stderr, "*** RENDEZVOUS\n");
   // initial rendezvous
   if( ! [lock mulleLockWhenCondition:1
                               timeout:2.0])
      abort();
   [lock unlockWithCondition:2];

   sleep( 1);

   mulle_fprintf( stderr, "*** WAKE\n");
   // wake up once
   if( [lock tryLockWhenCondition:1])
      [lock unlockWithCondition:2];

   sleep( 1);

   mulle_fprintf( stderr, "*** SHUTDOWN\n");
   // let shut down
   if( ! [lock mulleLockWhenCondition:1
                            timeout:2.0])
      abort();
   [thread cancel];
   [lock unlockWithCondition:2];


   mulle_fprintf( stderr, "*** WAIT\n");
   // wait for it
   [lock mulleLockWhenCondition:1
                        timeout:2.0];
   [lock unlockWithCondition:0];

   return( 0);
}
