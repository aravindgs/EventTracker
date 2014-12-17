//
//  ET_DetailEventViewController.m
//  EventTracker
//
//  Created by Aravind Nair on 18/12/14.
//  Copyright (c) 2014 KeepWorks. All rights reserved.
//

#import "ET_DetailEventViewController.h"
#import "AppDelegate.h"


@interface ET_DetailEventViewController ()

@property (nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) IBOutlet UIImageView *eventImage;
@property (strong, nonatomic) IBOutlet UILabel *eventName;
@property (strong, nonatomic) IBOutlet UILabel *entryType;
@property (strong, nonatomic) IBOutlet UILabel *entryAmount;
@property (strong, nonatomic) IBOutlet UILabel *location;

@end

@implementation ET_DetailEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _appDelegate = [[UIApplication sharedApplication] delegate];
    UIImage *image = [_appDelegate.imageCache objectForKey:_currentEvent.eventImageUrl];
    if(image){
        
        _eventImage.image = image;
    }
    
    else{
        
        _eventImage.image = nil;
        
        dispatch_queue_t downloadQueue = dispatch_queue_create("image downloader", NULL);
        dispatch_async(downloadQueue, ^{
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_currentEvent.eventImageUrl]];
            UIImage *image = [UIImage imageWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _eventImage.image = image;
                
            });
            
            [_appDelegate.imageCache setObject:image forKey:_currentEvent.eventImageUrl];
        });
    }
    _eventImage.clipsToBounds = YES;
    _eventName.text = _currentEvent.eventName;
    _location.text = [NSString stringWithFormat:@"Location : %@",_currentEvent.location];
    _entryType.text = (_currentEvent.isPaidEvent?@"Entry Type : Paid":@"Entry Type : Free");
    _entryType.textColor = (_currentEvent.isPaidEvent?[UIColor redColor]:[UIColor greenColor]);
    _entryAmount.text = [NSString stringWithFormat:@"Entry Fee : ₹ %.02f",_currentEvent.entryFee];
    
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
- (IBAction)trackEventClicked
{
    
}

@end
