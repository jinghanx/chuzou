//
//  ViewController.m
//  chuzou
//
//  Created by Jinghan Xu on 8/24/18.
//  Copyright © 2018 Jinghan Xu. All rights reserved.
//

#import "ViewController.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>


@interface ViewController ()

@end

@implementation ViewController

CLLocationManager *locationManager;
AVAudioPlayer *player;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    locationManager = [[CLLocationManager alloc] init]; // initializing locationManager
    [locationManager requestAlwaysAuthorization];
    locationManager.delegate = self; // we set the delegate of locationManager to self.
    locationManager.desiredAccuracy = kCLLocationAccuracyBest; // setting the accuracy
    
    CLCircularRegion *region =  [[CLCircularRegion alloc] initWithCenter:CLLocationCoordinate2DMake(55.75578600, 37.61763300)
                                                                  radius:locationManager.maximumRegionMonitoringDistance
                                                              identifier:@"Moscow"];
    region.notifyOnEntry = YES;
    region.notifyOnExit = NO;
    
    [locationManager startMonitoringForRegion:region];
}

-(void)printAddressFromLocation:(CLLocation *)location {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if(placemarks && placemarks.count > 0)
         {
             CLPlacemark *placemark= [placemarks objectAtIndex:0];
             
             NSString *address = [NSString stringWithFormat:@"Address: %@ %@,%@ %@", [placemark subThoroughfare],[placemark thoroughfare],[placemark locality], [placemark administrativeArea]];
             
             NSLog(@"%@",address);
             self.addressLabel.text = address;
             self.titleLabel.text = [NSString stringWithFormat:@"Hello %@.", [placemark administrativeArea]];
         }
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma core location delegate
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Error: %@", error.description);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *crnLoc = [locations lastObject];
    NSLog(@"%@", [NSString stringWithFormat:@"%.8f", crnLoc.coordinate.latitude]);
    NSLog(@"%@", [NSString stringWithFormat:@"%.8f", crnLoc.coordinate.longitude]);
    NSLog(@"%@", [NSString stringWithFormat:@"%.0f", crnLoc.altitude]);
    NSLog(@"%@", [NSString stringWithFormat:@"%.0f", crnLoc.speed]);
    [self printAddressFromLocation:crnLoc];
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(nonnull CLRegion *)region{
    NSLog(@"Enter %@", region.identifier);
    
    NSString *soundFilePath = [NSString stringWithFormat:@"%@/test.mp3",[[NSBundle mainBundle] resourcePath]];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    player.numberOfLoops = 1;
    [player play];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(nonnull CLRegion *)region {
    NSLog(@"Exit %@", region.identifier);
}

# pragma IBAction
- (IBAction)goButton:(id)sender {
    [locationManager startUpdatingLocation];  //requesting location updates
}
@end
