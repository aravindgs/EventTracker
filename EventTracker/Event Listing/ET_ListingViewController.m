//
//  ET_ListingViewController.m
//  EventTracker
//
//  Created by Aravind Nair on 17/12/14.
//  Copyright (c) 2014 KeepWorks. All rights reserved.
//

#import "ET_ListingViewController.h"
#import "ET_EventsCollectionViewCell.h"
#import "ET_EventsTableViewCell.h"
#import "ET_EventObject.h"
#import "AppDelegate.h"
#import "ET_DetailEventViewController.h"
#import "ET_UserObject.h"

@interface ET_ListingViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate>
{
    ET_UserObject *user;
}

@property (nonatomic) NSMutableArray *eventObjectsArray;
@property (strong, nonatomic) IBOutlet UICollectionView *eventGrid;
@property (strong, nonatomic) IBOutlet UITableView *eventList;
@property (nonatomic) AppDelegate *appDelegate;
@end

@implementation ET_ListingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    _appDelegate = [[UIApplication sharedApplication] delegate];
    user = [ET_UserObject getInstance];
    NSDictionary *eventsDataDictionary = [NSDictionary dictionaryWithDictionary:[self getEventListDictionary]];
    NSArray *eventDictionariesArray = [NSArray arrayWithArray:[eventsDataDictionary valueForKey:@"events"]];
    _eventObjectsArray = [[NSMutableArray alloc] init];
    for (int i=0; i<eventDictionariesArray.count; i++)
    {
        ET_EventObject *event = [[ET_EventObject alloc] init];
        event = [event createEventFromInfo:[eventDictionariesArray objectAtIndex:i]];
        [_eventObjectsArray addObject:event];
        
    }
    _eventGrid.hidden = YES;
    _eventList.hidden = NO;
    
    
}

- (void) viewWillAppear:(BOOL)animated
{
    self.title = @"EVENTS";
}

- (void) viewWillDisappear:(BOOL)animated
{
    self.title = @"";
}

- (void)didReceiveMemoryWarning
{
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
#pragma mark COLLECTION VIEW DATA SOURCE AND DELEGATE


-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"event";
    ET_EventsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[ET_EventsCollectionViewCell alloc] init];
    }
    ET_EventObject *currentEvent = [[ET_EventObject alloc] init];
    currentEvent = [_eventObjectsArray objectAtIndex:indexPath.row];
    cell.eventName.text =currentEvent.eventName;
    UIImage *image = [_appDelegate.imageCache objectForKey:currentEvent.eventImageUrl];
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
            
            [_appDelegate.imageCache setObject:image forKey:currentEvent.eventImageUrl];
        });
    }
    cell.eventImage.clipsToBounds = YES;
    return cell;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _eventObjectsArray.count;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float cellWidth = (collectionView.frame.size.width-30)/2;
    return CGSizeMake(cellWidth, cellWidth);
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"detail" sender:[_eventObjectsArray objectAtIndex:indexPath.row]];
}


#pragma mark
#pragma mark TABLE VIEW DATA SOURCE AND DELEGATE

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"event";
    ET_EventsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[ET_EventsTableViewCell alloc] init];
    }
    ET_EventObject *currentEvent = [[ET_EventObject alloc] init];
    currentEvent = [_eventObjectsArray objectAtIndex:indexPath.row];
    UIImage *image = [_appDelegate.imageCache objectForKey:currentEvent.eventImageUrl];
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
            
            [_appDelegate.imageCache setObject:image forKey:currentEvent.eventImageUrl];
        });
    }
    cell.eventName.text = currentEvent.eventName;
    cell.eventLocation.text = currentEvent.location;
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
    return _eventObjectsArray.count;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"detail" sender:[_eventObjectsArray objectAtIndex:indexPath.row]];
}

#pragma mark
#pragma mark OTHER CONTROLLER LOGICS AND FUNCTIONS

- (NSDictionary *) getEventListDictionary
{
    
    //Getting json string from file stroing data
    NSString *eventsDataFilePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"EventsData.json"];
    NSString *eventsJsonString = [NSString stringWithContentsOfFile:eventsDataFilePath
                                                           encoding:NSUTF8StringEncoding
                                                              error:nil];
    
    //Converting json string to nsdictionary
    
    NSData *eventsData = [eventsJsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *eventsDataDictionary = [NSJSONSerialization JSONObjectWithData: eventsData
                                                                         options: kNilOptions
                                                                           error: nil];
    return eventsDataDictionary;
}

- (IBAction)listOrGridSelected:(UISegmentedControl *)sender
{
    //Logic to switch between grid and list view
    if (sender.selectedSegmentIndex == 0)
    {
        _eventGrid.hidden = YES;
        _eventList.hidden = NO;
    }
    else
    {
        _eventGrid.hidden = NO;
        _eventList.hidden = YES;
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detail"])
    {
        ET_DetailEventViewController *detail = [[ET_DetailEventViewController alloc] init];
        detail = [segue destinationViewController];
        detail.currentEvent = sender;
    }
}

@end
