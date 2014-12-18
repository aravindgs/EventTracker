//
//  ET_DetailEventViewController.h
//  EventTracker
//
//  Created by Aravind Nair on 18/12/14.
//  Copyright (c) 2014 KeepWorks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ET_EventObject.h"

@class ET_TrackListViewController;

@interface ET_DetailEventViewController : UIViewController

@property (nonatomic) ET_EventObject *currentEvent;

@end
