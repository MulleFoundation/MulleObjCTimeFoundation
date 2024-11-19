//
//  NSConditionLock+NSDate.m
//  MulleObjCLockFoundation
//
//  Copyright (c) 2021 Nat! - Mulle kybernetiK.
//  Copyright (c) 2021 Codeon GmbH.
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
// prefer a local NSConditionLock over one in import.h
//

#ifdef __has_include
# if __has_include( "NSConditionLock.h")
#  import "NSConditionLock.h"
# endif
#endif

#import "import.h"

#import "NSTimeInterval.h"

@class NSDate;


@interface NSConditionLock( NSDate)

// this does the more common idiom
// of pthread_mutex_lock  pthread_cond_waittimed
// this may deadlock though, the time out is for sending the condition
// not the holding of the lock
- (BOOL) mulleLockWhenCondition:(NSInteger) value
                  waitUntilDate:(NSDate *) date;

// this will not deadlock
- (BOOL) lockWhenCondition:(NSInteger) condition
                beforeDate:(NSDate *) limit;

- (BOOL) lockBeforeDate:(NSDate *) limit;


// this will not deadlock
- (BOOL) mulleLockWhenCondition:(NSInteger) condition
                        timeout:(mulle_relativetime_t) seconds;

- (BOOL) mulleLockWhenCondition:(NSInteger) condition
             beforeTimeInterval:(NSTimeInterval) timeInterval;

// this can deadlock
- (BOOL) mulleLockWhenCondition:(NSInteger) value
          waitUntilTimeInterval:(NSTimeInterval) timeInterval;

//// this does the more common idiom
//// of pthread_mutex_lock  pthread_cond_waittimed
//// this may deadlock though, the time out is for sending the condition
//// not the holding of the lock
//- (BOOL) mulleLockWhenCondition:(NSInteger) value
//             beforeTimeInterval:(mulle_timeinterval_t) timeInterval;

//
- (BOOL) mulleLockWithTimeout:(mulle_relativetime_t) seconds;

- (BOOL) mulleLockBeforeTimeInterval:(NSTimeInterval) timeInterval;

@end
