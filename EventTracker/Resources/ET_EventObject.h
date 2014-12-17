//
//  ET_EventObject.h
//  EventTracker
//
//  Created by Aravind Nair on 18/12/14.
//  Copyright (c) 2014 KeepWorks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ET_EventObject : NSObject

@property (nonatomic) int eventId;
@property (nonatomic) NSString *eventName;
@property (nonatomic) NSString *eventImageUrl;
@property (nonatomic) NSString *location;
@property (nonatomic) BOOL isPaidEvent;
@property (nonatomic) float entryFee;

- (ET_EventObject *) createEventFromInfo: (NSDictionary *) eventInfo;

@end
