//
//  ET_LoginViewController.m
//  EventTracker
//
//  Created by Aravind Nair on 16/12/14.
//  Copyright (c) 2014 KeepWorks. All rights reserved.
//

#import "ET_LoginViewController.h"

@interface ET_LoginViewController () <UITextFieldDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UIButton *continueButton;

- (IBAction)continueClicked;

@end

@implementation ET_LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
#pragma mark BUTTON ACTIONS AND VALIDATIONS

- (IBAction)continueClicked
{
    [_nameField resignFirstResponder];
    //Check if name field is not filled
    
    if ([_nameField.text isEqualToString:@""])
    {
        UIAlertView *emptyNameFieldAlert = [[UIAlertView alloc] initWithTitle:@"NO NAME" message:@"Please enter your name before you continue" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [emptyNameFieldAlert setTag:101];
        [emptyNameFieldAlert show];
    }
    else
    {
        
        [self performSegueWithIdentifier:@"events" sender:_nameField.text];
    }
}

#pragma mark
#pragma mark ALERTVIEW DELEGATES

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101)
    {
        [_nameField becomeFirstResponder];
    }
}


#pragma mark
#pragma mark TEXTFIELD DELEGATES

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:textField action:@selector(resignFirstResponder)]];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
