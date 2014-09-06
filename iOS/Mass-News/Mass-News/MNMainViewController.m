//
//  MNMainViewController.m
//  Mass-News
//
//  Created by Thomas Clark on 9/6/14.
//  Copyright (c) 2014 Thomas Clark. All rights reserved.
//

#import "MNMainViewController.h"
#import "MNPopUpViewController.h"
#import "VCSimpleSession.h"
#import "UIViewController+ENPopUp.h"


@interface MNMainViewController () <VCSessionDelegate, CLLocationManagerDelegate>
@property (nonatomic, retain) VCSimpleSession* session;
@property (nonatomic, copy) NSString* url;
@property (nonatomic, copy) NSString* streamKey;
@property (nonatomic, copy) NSString* latitude;
@property (nonatomic, copy) NSString* longitude;
@property (nonatomic) CLLocationManager* locationManager;
@end

@implementation MNMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _session = [[VCSimpleSession alloc] initWithVideoSize:CGSizeMake(1280, 720) frameRate:30 bitrate:1000000 useInterfaceOrientation:YES];
    
    [self makeNewPopUpViewController];
    
    //Location data retrievel
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
    
    //_url = @"rtmp://live-ord.twitch.tv/app";
    _url = @"rtmp://162.243.105.23/live";
    //_streamKey = @"live_70680492_QzRH7KTYxFBRdMKSbt4uYjBWVPprrE";
    _streamKey = @"test2";
    
    self.view = _session.previewView;
    _session.previewView.frame = [[UIScreen mainScreen] bounds];
    
    [[NSBundle mainBundle] loadNibNamed: @"MNConnectButton" owner: self options: nil];
    self.connectButton.frame = CGRectMake(368, 70, 180, 180);
    [self.view addSubview:self.connectButton];
    
    _session.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makeNewPopUpViewController {
    self.popUpViewController = [[MNPopUpViewController alloc] initWithMasterVC:self];
    self.popUpViewController.view.frame = CGRectMake(0, 0, 290.0f, 280.0f);
}

#pragma mark - User Interface Outlets

- (IBAction)connectButtonTouch:(id)sender {
    
    if ([self.connectButton.titleLabel.text isEqualToString:@"START STREAM"]) {
        [self presentPopUpViewController:self.popUpViewController];
    } else if ([self.connectButton.titleLabel.text isEqualToString:@"STOP STREAM"]) {
        [_session endRtmpSession];
        [self makeNewPopUpViewController];
    }
}

- (void)finishButtonTouch {
    
    [self dismissPopUpViewController];
    
    switch(_session.rtmpSessionState) {
        case VCSessionStateNone:
        case VCSessionStatePreviewStarted:
        case VCSessionStateEnded:
        case VCSessionStateError:
            [_session startRtmpSessionWithURL:_url andStreamKey:_streamKey];
            break;
        default:
            [_session endRtmpSession];
            break;
    }
}

#pragma mark - VCSessionDelegate

- (void) connectionStatusChanged:(VCSessionState) state
{
    switch(state) {
        case VCSessionStateStarting:
            [self.connectButton setTitle:@"CONNECTING" forState:UIControlStateNormal];
            [self.connectButton setBackgroundColor:[UIColor colorWithRed:238.0/255 green:186.0/255 blue:76.0/255 alpha:.2]];
            break;
        case VCSessionStateStarted:
            [self.connectButton setTitle:@"STOP STREAM" forState:UIControlStateNormal];
            [self.connectButton setBackgroundColor:[UIColor colorWithRed:227.0/255 green:73.0/255 blue:59.0/255 alpha:.2]];
            break;
        case VCSessionStateError:
            [_session startRtmpSessionWithURL:_url andStreamKey:_streamKey];
            break;
        default:
            [self.connectButton setTitle:@"START STREAM" forState:UIControlStateNormal];
            [self.connectButton setBackgroundColor:[UIColor colorWithRed:35.0/255 green:181.0/255 blue:175.0/255 alpha:.6]];
            break;
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        _longitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        NSLog(_longitude);
        _latitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        NSLog(_latitude);
    }
}

@end
