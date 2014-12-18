//
//  ET_UserObject.m
//  EventTracker
//
//  Created by Aravind Nair on 18/12/14.
//  Copyright (c) 2014 KeepWorks. All rights reserved.
//

#import "ET_UserObject.h"

@implementation ET_UserObject

static ET_UserObject *user;

+ (ET_UserObject *) getInstance
{
    @synchronized ([ET_UserObject class])
    {
        if (user == nil)
        {
            user = [[ET_UserObject alloc] init];
            user.trackingEvents = [[NSMutableArray alloc] init];
        }
    }
    return user;
}

@end
