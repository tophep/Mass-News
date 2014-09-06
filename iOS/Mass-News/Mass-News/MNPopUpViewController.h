//
//  MNPopUpViewController.h
//  Mass-News
//
//  Created by Thomas Clark on 9/6/14.
//  Copyright (c) 2014 Thomas Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNPopUpViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITextField *descriptionField;
@property (retain, nonatomic) IBOutlet UITextField *tagField;
@property (retain, nonatomic) IBOutlet UIButton *finishButton;

@property (nonatomic, copy) NSString* tag;
@property (nonatomic, copy) NSString* description;

- (IBAction)finishButtonTouch:(id)sender;
- (id)initWithMasterVC:(UIViewController *)viewController;

@end
