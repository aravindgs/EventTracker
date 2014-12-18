//
//  ET_TrackListViewController.m
//  EventTracker
//
//  Created by Aravind Nair on 18/12/14.
//  Copyright (c) 2014 KeepWorks. All rights reserved.
//

#import "ET_TrackListViewController.h"
#import "ET_UserObject.h"
#import "ET_EventObject.h"
#import "ET_EventsTableViewCell.h"
#import "AppDelegate.h"


@interface ET_TrackListViewController () <UITableViewDataSource,UITableViewDelegate>
{
    AppDelegate *appDelegate;
    ET_UserObject *user;
}

@property (strong, nonatomic) IBOutlet UITableView *trackTable;

@end

@implementation ET_TrackListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate = [[UIApplication sharedApplication] delegate];
    user = [ET_UserObject getInstance];
}

- (void) viewWillAppear:(BOOL)animated
{
    self.title = @"TRACKED EVENTS";
}

- (void) viewWillDisappear:(BOOL)animated
{
    self.title = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark
#pragma mark TABLE VIEW DATA SOURCE AND DELEGATE

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"tracked";
    ET_EventsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[ET_EventsTableViewCell alloc] init];
    }
    ET_EventObject *currentEvent = [[ET_EventObject alloc] init];
    currentEvent = [user.trackingEvents objectAtIndex:indexPath.row];
    UIImage *image = [appDelegate.imageCache objectForKey:currentEvent.eventImageUrl];
    if(image){
        
        cell.eventImage.image = image;
    }
    
    else{
        
        cell.eventImage.image = nil;
        
        dispatch_queue_t downloadQueue = dispatch_queue_create("image downloader", NULL);
        dispatch_async(downloadQueue, ^{
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:currentEvent.eventImageUrl]];
            UIImage *image = [UIImage imageWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                cell.eventImage.image = image;
                
            });
            
            [appDelegate.imageCache setObject:image forKey:currentEvent.eventImageUrl];
        });
    }
    cell.eventName.text = currentEvent.eventName;
    cell.eventLocation.text = currentEvent.location;
    [cell.deleteButton.layer setCornerRadius:(cell.deleteButton.frame.size.height/2)];
    [cell.deleteButton clipsToBounds];
    cell.deleteButton.tag = indexPath.row;
    [cell.deleteButton addTarget:self action:@selector(untrackEvent:) forControlEvents:UIControlEventTouchUpInside];
    if (currentEvent.isPaidEvent)
    {
        cell.entryStatus.textColor = [UIColor redColor];
        cell.entryStatus.text = @"Paid";
    }
    else
    {
        cell.entryStatus.textColor = [UIColor greenColor];
        cell.entryStatus.text = @"Free";
    }
    cell.eventImage.clipsToBounds = YES;
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return user.trackingEvents.count;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void) untrackEvent : (UIButton *) deleteButton
{
    [user.trackingEvents removeObjectAtIndex:deleteButton.tag];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:user.trackingEvents] forKey:user.name];
    [_trackTable reloadData];
}

@end
