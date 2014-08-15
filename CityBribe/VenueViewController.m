//
//  FirstViewController.m
//  CityBribe
//
//  Created by Anthony Amoyal on 8/9/14.
//  Copyright (c) 2014 BattleHack. All rights reserved.
//

#import "VenueViewController.h"
#import "Offer.h"
#import "Foursquare2.h"
#import <CoreLocation/CoreLocation.h>
#import "Foursquare2.h"
#import "FSVenue.h"
#import "FSConverter.h"
#import "UIImage+Resize.h"
#import <Venmo-iOS-SDK/Venmo.h>
#import <Parse/Parse.h>
#import "FSPhoto.h"
#import "MBProgressHUD.h"

@interface VenueViewController ()
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) FSVenue *currentVenue;
@end

@implementation VenueViewController

MBProgressHUD *HUD;
int venmoAuthd;
@synthesize locationManager;
@synthesize currentLocation;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.currentVenue = nil;
    venmoAuthd = 0;
    [self.changeLocationButton setBackgroundImage:[UIImage imageNamed:@"Change Location-01.png"]
                                         forState:UIControlStateNormal];
    
    self.offersScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 120, 320, 300)];
    self.offersScrollView.clipsToBounds = YES;
    self.offersScrollView.scrollEnabled = YES;
    [self.offersScrollView setDelaysContentTouches:NO];
    self.offersScrollView.bounces = YES;
    self.offersScrollView.exclusiveTouch = NO;
    self.offersScrollView.userInteractionEnabled = YES;

    self.tabBarController.tabBar.hidden = YES;
    
    [self.view addSubview:self.offersScrollView];
    [self.view bringSubviewToFront:self.offersScrollView];
    
    CGRect newFrame = self.offersScrollView.frame;
    newFrame.size.height += (self.tabBarController.tabBar.frame.size.height + 100);
    self.offersScrollView.frame = newFrame;
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self.view bringSubviewToFront:self.changeLocationButton];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    if(self.currentVenue == nil){
        [self setCurrentVenueToClosestVenue:([[CLLocation alloc] initWithLatitude:42.351944 longitude:-71.055275])];
    }
}

- (void)setCurrentVenueToClosestVenue:(CLLocation *)location {
    location = [[CLLocation alloc] initWithLatitude:42.351944 longitude:-71.055275];
    [Foursquare2 venueSearchNearByLatitude:@(location.coordinate.latitude)
                                 longitude:@(location.coordinate.longitude)
                                     query:nil
                                     limit:nil
                                    intent:intentCheckin
                                    radius:@(500)
                                categoryId:nil
                                  callback:^(BOOL success, id result){
                                      if (success) {
                                          NSDictionary *dic = result;
                                          NSArray *venues = [dic valueForKeyPath:@"response.venues"];
                                          
                                          FSConverter *converter = [[FSConverter alloc]init];
                                          venues = [converter convertToObjects:venues];

                                          self.currentVenue = [venues objectAtIndex:0];
                                          [self getVenueDetails];
                                      }else{
                                          NSLog(@"FAIL");
                                      }
                                  }];
}

- (void)refreshVenueView
{
    [[self.currentVenue profilePhoto] downloadAndResize:CGSizeMake(320, 120)];
    
    self.profilePhoto.frame = CGRectMake(0, 0, 320, 120);
    self.profilePhoto.image = [self.currentVenue profilePhoto].image;
    
    self.headlineLabel.text = self.currentVenue.name;
    self.addressLabel.text = self.currentVenue.vanityAddress;
    
    [self.view  bringSubviewToFront:self.headlineLabel];
    [self.view  bringSubviewToFront:self.addressLabel];
}

- (void)getVenueDetails
{
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"Loading";
    HUD.delegate = self;
    [HUD show:YES];
    
    
    [Foursquare2 venueGetDetail:self.currentVenue.venueId callback:^(BOOL success, id result) {
        if (success) {
            NSDictionary *dic = result;
            NSDictionary *venueDict = [dic valueForKeyPath:@"response.venue"];
            FSConverter *converter = [[FSConverter alloc]init];
            self.currentVenue = [converter convertToObject:venueDict];
            
            PFQuery *query = [PFQuery queryWithClassName:@"Deals"];
            [query whereKey:@"foursquare_id" equalTo:self.currentVenue.venueId];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    [self.offersScrollView setContentSize:(CGSizeMake(320, [objects count]*229))];
                    [self showOffers:objects];
                    [HUD hide:YES];
                    NSLog(@"objects = %@", objects);
                }
            }];
            
            [self refreshVenueView];
            NSArray *viewsToRemove = [self.offersScrollView subviews];
            for (UIView *v in viewsToRemove) {
                [v removeFromSuperview];
            }
        }
    }];
}


- (void)getUsersLocation
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    currentLocation = newLocation;
}

- (IBAction)changeLocation
{
    UIStoryboard *sb = self.storyboard;
    NearbyVenuesViewController * nvvc = [sb instantiateViewControllerWithIdentifier:@"NearbyVenuesViewController"];

    nvvc.foursquareVenueDelegate = self;
    
    [self presentViewController:nvvc
                       animated:YES
                     completion:nil];
}

- (void)showOffers:(NSArray *)offers
{
    int i = 0;
    for (PFObject *o in offers) {
        if(self.currentVenue.photos && self.currentVenue.photos.count){
            FSPhoto *photo = [self.currentVenue.photos objectAtIndex:i+1];
            float yOffset = 0 + i*229;
            OfferView *ov = [[OfferView alloc] initWithFrame:CGRectMake(0, yOffset, 320, 223) andOffer:o andbackgroundPhoto:photo];
            ov.paydayDelegate = self;
            [self.offersScrollView addSubview:ov];
            i += 1;
        }
    }
}

#pragma mark FoursquareVenuesDelegate

- (void)venueChosen:(FSVenue *)venue
{
    self.currentVenue = venue;
    [self getVenueDetails];
}

#pragma PaydayDelegate

- (void)payTheMan:(PFObject *)offer
{
    float cents = 5.0;
    [[Venmo sharedInstance] sendPaymentTo:offer[@"venmo_id"]
                                   amount:cents
                                     note:offer[@"deal_name"]
                        completionHandler:^(VENTransaction *transaction, BOOL success, NSError *error) {
                            if (success) {
                                NSLog(@"Transaction succeeded!");
                                HUD = [[MBProgressHUD alloc] initWithView:self.view];
                                [self.view addSubview:HUD];
                                
                                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                                HUD.mode = MBProgressHUDModeCustomView;
                                
                                HUD.delegate = self;
                                HUD.labelText = @"Success";
                                
                                [HUD show:YES];
                                [HUD hide:YES afterDelay:2];
                            }
                            else {
                                NSLog(@"Transaction failed with error: %@", [error localizedDescription]);
                            }
                        }];
}

- (void) offerBought:(PFObject *)offer
{
    if (venmoAuthd) {
        [self payTheMan:offer];
    }else{
        NSLog(@"Offer bought: %@", offer);
        [[Venmo sharedInstance] requestPermissions:@[VENPermissionMakePayments,
                                                     VENPermissionAccessProfile]
                             withCompletionHandler:^(BOOL success, NSError *error) {
                                 if (success) {
                                     // :)
                                     NSLog(@":)");
                                     venmoAuthd = 1;
                                     
                                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                         [self payTheMan:offer];
                                     });
                                     
                                 }
                                 else {
                                     // :(
                                     NSLog(@":(");
                                 }
                             }];
    }
}

@end
