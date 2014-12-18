//
//  ET_EventObject.m
//  EventTracker
//
//  Created by Aravind Nair on 18/12/14.
//  Copyright (c) 2014 KeepWorks. All rights reserved.
//

#import "ET_EventObject.h"

@implementation ET_EventObject


- (ET_EventObject *) createEventFromInfo: (NSDictionary *) eventInfo
{
    ET_EventObject *currentEvent = [[ET_EventObject alloc] init];
    currentEvent.eventId = [[eventInfo valueForKey:@"event_id"] intValue];
    currentEvent.eventName = [eventInfo valueForKey:@"name"];
    currentEvent.eventImageUrl = [eventInfo valueForKey:@"image"];
    currentEvent.location = [eventInfo valueForKey:@"location"];
    currentEvent.isPaidEvent = (([[eventInfo valueForKey:@"paid"] intValue] == 0)?NO:YES);
    currentEvent.entryFee = [[eventInfo valueForKey:@"amount"] floatValue];
    return currentEvent;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInt:_eventId forKey:@"event_id"];
    [coder encodeObject:_eventImageUrl forKey:@"image"];
    [coder encodeObject:_eventName forKey:@"name"];
    [coder encodeObject:_location forKey:@"location"];
    [coder encodeBool:_isPaidEvent forKey:@"is_paid"];
    [coder encodeFloat:_entryFee forKey:@"fee"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [[ET_EventObject alloc] init];
    if (self != nil)
    {
        _eventId = [coder decodeIntForKey:@"event_id"];
        _eventImageUrl = [coder decodeObjectForKey:@"image"];
        _eventName = [coder decodeObjectForKey:@"name"];
        _location = [coder decodeObjectForKey:@"location"];
        _isPaidEvent = [coder decodeBoolForKey:@"is_paid"];
        _entryFee = [coder decodeFloatForKey:@"fee"];
    }
    return self;
}

@end
