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

@end
