//
//  MNMainViewController.h
//  Mass-News
//
//  Created by Thomas Clark on 9/6/14.
//  Copyright (c) 2014 Thomas Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <CoreLocation/CoreLocation.h>


@interface MNMainViewController : UIViewController

@property (retain, nonatomic) IBOutlet UIButton *connectButton;
@property (retain, nonatomic) UIViewController *popUpViewController;
@property (retain, nonatomic) NSMutableData *receivedData;

- (IBAction)connectButtonTouch:(id)sender;
- (void)finishButtonTouch:(NSString *)tag;

@end
