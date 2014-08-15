//
//  FirstViewController.h
//  CityBribe
//
//  Created by Anthony Amoyal on 8/9/14.
//  Copyright (c) 2014 BattleHack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "NearbyVenuesViewController.h"
#import "OfferView.h"
#import "MBProgressHUD.h"

@interface VenueViewController : UIViewController <CLLocationManagerDelegate, FoursquareVenuesDelegate, PaydayDelegate, MBProgressHUDDelegate>

@property (nonatomic, retain) IBOutlet UILabel *headlineLabel;
@property (nonatomic, retain) IBOutlet UILabel *addressLabel;
@property (nonatomic, retain) IBOutlet UIImageView *profilePhoto;
@property (nonatomic, retain) IBOutlet UIButton *changeLocationButton;
@property (nonatomic, retain) UIScrollView *offersScrollView;

- (IBAction)changeLocation;

@end
