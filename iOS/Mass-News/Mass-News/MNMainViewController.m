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


@interface MNMainViewController () <VCSessionDelegate, CLLocationManagerDelegate, NSURLConnectionDataDelegate>
@property (nonatomic, retain) VCSimpleSession* session;
@property (nonatomic, copy) NSString* url;
@property (nonatomic, copy) NSString* streamKey;
@property (nonatomic, copy) NSString* tag;
@property (nonatomic, copy) NSString* latitude;
@property (nonatomic, copy) NSString* longitude;
@property (nonatomic) CLLocationManager* locationManager;
@property (nonatomic) BOOL isDoingTagRequest;
@end

@implementation MNMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _session = [[VCSimpleSession alloc] initWithVideoSize:CGSizeMake(1280, 720) frameRate:30 bitrate:1000000 useInterfaceOrientation:YES];
    
    [self makeNewPopUpViewController];
    
    self.receivedData = [[NSMutableData alloc] init];
    
    //Location data retrievel
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
    
    //_url = @"rtmp://live-ord.twitch.tv/app";
    _url = @"rtmp://massne.ws/live";
    //_streamKey = @"live_70680492_QzRH7KTYxFBRdMKSbt4uYjBWVPprrE";
    _streamKey = @"";
    
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

- (void)finishButtonTouch:(NSString *)tag {
    self.tag = tag;
    self.isDoingTagRequest = true;
    
    NSMutableDictionary *jsonTagDictionary = [[NSMutableDictionary alloc] init];
    [jsonTagDictionary setObject:tag forKey:@"name"];
    
    NSError *error;
    NSData *jsonTagData = [NSJSONSerialization dataWithJSONObject:jsonTagDictionary options:0 error:&error];

    NSURL *url1 = [[NSURL alloc] initWithString:@"http://massne.ws:8080/api/tags"];
    NSMutableURLRequest *request1 = [NSMutableURLRequest requestWithURL:url1];
    [request1 setHTTPMethod:@"POST"];
    [request1 setValue:[NSString stringWithFormat:@"%d", jsonTagData.length] forHTTPHeaderField:@"Content-Length"];
    [request1 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request1 setHTTPBody:jsonTagData];
    
    NSURLConnection *connection1 = [[NSURLConnection alloc] initWithRequest:request1
                                                                  delegate:self];
    
    [connection1 start];
    
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
        NSLog(self.longitude);
        _latitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        NSLog(self.latitude);
    }
}

#pragma mark - NSURLConnectionDataDelegate

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.receivedData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"%@" , error);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    if (self.isDoingTagRequest) {
        NSMutableDictionary *jsonSessionDictionary = [[NSMutableDictionary alloc] init];
        [jsonSessionDictionary setObject:self.tag forKey:@"name"];
        [jsonSessionDictionary setObject:[NSNumber numberWithDouble:[self.latitude doubleValue]] forKey:@"latitude"];
        [jsonSessionDictionary setObject:[NSNumber numberWithDouble:[self.longitude doubleValue]] forKey:@"longitude"];
        
        NSData* jsonSessionData = [NSJSONSerialization dataWithJSONObject:jsonSessionDictionary
                                                                  options:0 error:nil];
        
        NSURL *url2 = [[NSURL alloc] initWithString:@"http://massne.ws:8080/api/sessions"];
        NSMutableURLRequest *request2 = [NSMutableURLRequest requestWithURL:url2];
        [request2 setHTTPMethod:@"POST"];
        [request2 setValue:[NSString stringWithFormat:@"%d", jsonSessionData.length] forHTTPHeaderField:@"Content-Length"];
        [request2 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request2 setHTTPBody:jsonSessionData];
        
        NSURLConnection *connection2 = [[NSURLConnection alloc] initWithRequest:request2
                                                                       delegate:self];
        
        [connection2 start];
        self.receivedData = [[NSMutableData alloc] init];
        self.isDoingTagRequest = FALSE;
    } else {
        NSError *jsonError;
        NSDictionary *jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:self.receivedData options:NSJSONWritingPrettyPrinted error:&jsonError];
        if(jsonError) {
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            self.streamKey = [jsonDictionaryOrArray objectForKey:@"uniqueId"];
            NSLog(self.streamKey);
        }
    }
    
}

@end
