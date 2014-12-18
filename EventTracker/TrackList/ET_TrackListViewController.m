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
#import "ET_DetailEventViewController.h"


@interface ET_TrackListViewController () <UITableViewDataSource,UITableViewDelegate>
{
    AppDelegate *appDelegate;
    ET_UserObject *user;
    UISwipeGestureRecognizer *leftEndSwipe;
}

@property (strong, nonatomic) IBOutlet UITableView *trackTable;

@end

@implementation ET_TrackListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    leftEndSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwiped:)];
    [leftEndSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:leftEndSwipe];
    appDelegate = [[UIApplication sharedApplication] delegate];
    user = [ET_UserObject getInstance];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [_trackTable addGestureRecognizer:longPress];
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

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"detailed" sender:[user.trackingEvents objectAtIndex:indexPath.row]];
}

- (void) untrackEvent : (UIButton *) deleteButton
{
    [user.trackingEvents removeObjectAtIndex:deleteButton.tag];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:user.trackingEvents] forKey:user.name];
    [_trackTable reloadData];
}

- (IBAction)longPressGestureRecognized:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.trackTable];
    NSIndexPath *indexPath = [self.trackTable indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self.trackTable cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshoFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.trackTable addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                    cell.hidden = YES;
                    
                }];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                // ... update data source.
                [user.trackingEvents exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:user.trackingEvents] forKey:user.name];
                
                // ... move the rows.
                [self.trackTable moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
            
        default: {
            // Clean up.
            UITableViewCell *cell = [self.trackTable cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            
            break;
        }
    }
}

- (UIView *)customSnapshoFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

- (void) rightSwiped : (UISwipeGestureRecognizer *) swipe
{
    CGPoint start = [swipe locationInView:self.view];
    if (start.x/self.view.frame.size.width < 0.1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailed"])
    {
        ET_DetailEventViewController *detail = [[ET_DetailEventViewController alloc] init];
        detail = [segue destinationViewController];
        detail.currentEvent = sender;
    }
}

@end
