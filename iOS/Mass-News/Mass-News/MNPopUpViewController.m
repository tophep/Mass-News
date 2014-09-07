//
//  MNPopUpViewController.m
//  Mass-News
//
//  Created by Thomas Clark on 9/6/14.
//  Copyright (c) 2014 Thomas Clark. All rights reserved.
//

#import "MNPopUpViewController.h"
#import "MNMainViewController.h"
#import "UIViewController+ENPopUp.h"

@interface MNPopUpViewController () <UITextFieldDelegate>

@property (weak, nonatomic) MNMainViewController *masterVC;

@end

@implementation MNPopUpViewController

- (id)initWithMasterVC:(MNMainViewController *)viewController
{
    self = [super init];
    
    _masterVC = viewController;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tagField.delegate = self;
    self.descriptionField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - User Interface Outlets

- (IBAction)finishButtonTouch:(id)sender {
    
    self.tag = self.tagField.text;
    self.description = self.descriptionField.text;
    [_masterVC finishButtonTouch:self.tag];

}

@end
