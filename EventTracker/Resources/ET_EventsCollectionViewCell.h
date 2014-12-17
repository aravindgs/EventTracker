//
//  ET_EventsCollectionViewCell.h
//  EventTracker
//
//  Created by Aravind Nair on 18/12/14.
//  Copyright (c) 2014 KeepWorks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ET_EventsCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *eventImage;
@property (strong, nonatomic) IBOutlet UILabel *eventName;

@end
