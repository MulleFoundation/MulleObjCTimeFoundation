//
//  NSDate.m
//  MulleObjCValueFoundation
//
//  Copyright (c) 2011 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011 Codeon GmbH.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//
#import "NSDate.h"

// other files in this library

// other libraries of MulleObjCValueFoundation
#import "_MulleObjCDateSubclasses.h"

// std-c and dependencies


@implementation NSObject( _NSDate)

- (BOOL) __isNSDate
{
   return( NO);
}

@end


@implementation NSDate

- (BOOL) __isNSDate
{
   return( YES);
}


+ (NSTimeInterval) timeIntervalSinceReferenceDate
{
   return( _NSTimeIntervalNow());
}


- (instancetype) init
{
   return( [self initWithTimeIntervalSinceReferenceDate:_NSTimeIntervalNow()]);
}


- (instancetype) initWithTimeIntervalSinceReferenceDate:(NSTimeInterval) interval
{
   return( [_MulleObjCConcreteDate newWithTimeIntervalSinceReferenceDate:interval]);
}


# pragma mark - convenience constructors

+ (NSDate *) date
{
   return( [[[self alloc] init] autorelease]);
}


+ (instancetype) dateWithTimeIntervalSince1970:(NSTimeInterval) seconds
{
   seconds -= NSTimeIntervalSince1970;
   return( [[[self alloc] initWithTimeIntervalSinceReferenceDate:seconds] autorelease]);
}


+ (instancetype) dateWithTimeIntervalSinceReferenceDate:(NSTimeInterval) seconds
{
   return( [[[self alloc] initWithTimeIntervalSinceReferenceDate:seconds] autorelease]);
}


// make these class clusters
+ (instancetype) distantFuture
{
   return( [[[self alloc] initWithTimeIntervalSinceReferenceDate:_NSDistantFuture] autorelease]);
}


+ (instancetype) distantPast
{
   return( [[[self alloc] initWithTimeIntervalSinceReferenceDate:_NSDistantPast] autorelease]);
}


# pragma mark - Various inits

- (instancetype) initWithTimeInterval:(NSTimeInterval) seconds
                            sinceDate:(NSDate *) refDate
{
   return( [self initWithTimeIntervalSinceReferenceDate:seconds - [refDate timeIntervalSinceReferenceDate]]);
}


- (instancetype) initWithTimeIntervalSince1970:(NSTimeInterval) seconds
{
   return( [self initWithTimeIntervalSinceReferenceDate:seconds - NSTimeIntervalSince1970]);
}


- (NSComparisonResult) compare:(id) other
{
   NSTimeInterval  diff;

   if( ! other)               // (stabilize sort)
      return( NSOrderedSame); // this is compatible with Apple Foundation

   diff = [self timeIntervalSinceReferenceDate] - [other timeIntervalSinceReferenceDate];
   if( diff < 0)
      return( NSOrderedAscending);
   if( diff > 0)
      return( NSOrderedDescending);
   return( NSOrderedSame);
}


- (instancetype) dateByAddingTimeInterval:(NSTimeInterval) seconds
{
   seconds += [self timeIntervalSinceReferenceDate];
   return( [[self class] dateWithTimeIntervalSinceReferenceDate:seconds]);
}


- (NSDate *) earlierDate:(NSDate *) other
{
   NSTimeInterval   diff;

   if( ! other)
      return( self); // weird but compatible

   diff = [self timeIntervalSinceDate:other];  // according to dox
   if( diff <= 0.0)
      return( self);
   return( other);
}


- (NSDate *) laterDate:(NSDate *) other
{
   NSTimeInterval   diff;

   if( ! other)
      return( self); // weird but compatible

   diff = [self timeIntervalSinceDate:other];  // according to dox
   if( diff >= 0.0)
      return( self);
   return( other);
}


- (NSTimeInterval) timeIntervalSinceDate:(NSDate *) other
{
   // compatible would be NAN, but that's just weird IMO
   // if( ! other)
   //   return( NaN);

   return( [self timeIntervalSinceReferenceDate] -
           [other timeIntervalSinceReferenceDate]);
}


- (NSTimeInterval) timeIntervalSince1970
{
   return( _NSTimeIntervalSinceReferenceDateAsSince1970( [self timeIntervalSinceReferenceDate]));
}


#pragma mark - hash and equality

- (NSUInteger) hash
{
   return( mulle_double_hash( [self timeIntervalSinceReferenceDate]));
}

- (BOOL) isEqualToDate:(NSDate *) other
{
   if( ! other)
      return( NO);

   return( [self timeIntervalSinceReferenceDate] == [other timeIntervalSinceReferenceDate]);
}


- (BOOL) isEqual:(id) other
{
   if( ! [other __isNSDate])
      return( NO);

   // dunno yet
   //   if( ! [other __isNSCalendarDate])
   //      return( NO);
   return( [self isEqualToDate:other]);
}

@end
