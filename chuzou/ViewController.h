//
//  ViewController.h
//  chuzou
//
//  Created by Jinghan Xu on 8/24/18.
//  Copyright © 2018 Jinghan Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLGeocoder.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController : UIViewController<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
- (IBAction)goButton:(id)sender;

@end

