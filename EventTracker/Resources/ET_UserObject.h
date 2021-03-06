//
//  ET_UserObject.h
//  EventTracker
//
//  Created by Aravind Nair on 18/12/14.
//  Copyright (c) 2014 KeepWorks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ET_UserObject : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSMutableArray *trackingEvents;

+ (ET_UserObject *) getInstance;

@end
