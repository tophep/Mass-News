//
//  MNMainViewController.m
//  Mass-News
//
//  Created by Thomas Clark on 9/6/14.
//  Copyright (c) 2014 Thomas Clark. All rights reserved.
//

#import "MNMainViewController.h"
#import "VCSimpleSession.h"


@interface MNMainViewController () <VCSessionDelegate>
@property (nonatomic, retain) VCSimpleSession* session;
@end

@implementation MNMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _session = [[VCSimpleSession alloc] initWithVideoSize:CGSizeMake(1280, 720) frameRate:30 bitrate:1000000];
    
    self.view = _session.previewView;
    _session.previewView.frame = [[UIScreen mainScreen] bounds];
    _session.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) connectionStatusChanged:(VCSessionState) state
{
    switch(state) {
        case VCSessionStateStarting:
            //[self.btnConnect setTitle:@"Connecting" forState:UIControlStateNormal];
            break;
        case VCSessionStateStarted:
            //[self.btnConnect setTitle:@"Disconnect" forState:UIControlStateNormal];
            break;
        default:
            //[self.btnConnect setTitle:@"Connect" forState:UIControlStateNormal];
            break;
    }
}

@end

