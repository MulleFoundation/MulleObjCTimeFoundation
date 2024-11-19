//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#ifdef __MULLE_OBJC__
# import <MulleObjCTimeFoundation/MulleObjCTimeFoundation.h>
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#else
# import <Foundation/Foundation.h>
# pragma message( "Apple Foundation")
#endif


static struct
{
   NSInteger          *sequence;
   NSInteger          storage[ 3];
   NSUInteger         i_storage;
   NSConditionLock    *lock;
} Self;



@interface Foo : NSObject
@end


@implementation Foo

+ (void) run:(NSNumber *) nr
{
   NSInteger   i;

   i = [nr unsignedIntegerValue];
   for(;;)
   {
      [Self.lock lockWhenCondition:i];

      if( i != *Self.sequence)
         abort();

      Self.i_storage = (Self.i_storage + 1) % 3;
      Self.sequence  = &Self.storage[ Self.i_storage];
      *Self.sequence = ++i;

      [Self.lock unlockWithCondition:i];
      ++i;
      if( i >= 10)
         break;
   }
}

@end


int   main( int argc, const char * argv[])
{
   Self.sequence = &Self.storage[ 0];
   Self.lock     = [[[NSConditionLock alloc] initWithCondition:0] autorelease];
   [NSThread detachNewThreadSelector:@selector( run:)
                            toTarget:[Foo class]
                          withObject:@(0)];

   [[Foo class] run:@(1)];

   return( 0);
}
